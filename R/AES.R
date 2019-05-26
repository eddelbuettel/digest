# This is loosely modelled on the AES code from the Python Crypto package.

# Currently only ECB, CBC and CTR modes are supported...

modes <- c("ECB", "CBC", "CFB", "PGP", "OFB", "CTR", "OPENPGP")

AES <- function(key, mode=c("ECB", "CBC", "CTR"), IV=NULL) {
    mode <- match(match.arg(mode), modes)
    if (!(mode %in% c(1:2, 6)))
        stop("Only ECB, CBC and CTR mode encryption are supported.")	# #nocov

    key <- as.raw(key)
    IV <- as.raw(IV)

    context <- .Call(AESinit, key)
    block_size <- 16
    key_size <- length(key)
    rm(key)

    encrypt <- function(text) {
        if (typeof(text) == "character")
            text <- charToRaw(text)					# #nocov
        if (mode == 1)
            .Call(AESencryptECB, context, text)
        else if (mode == 2) {
            len <- length(text)
            if (len %% 16 != 0)
                stop("Text length must be a multiple of 16 bytes")	# #nocov
            result <- raw(length(text))
            for (i in seq_len(len/16)) {
                ind <- (i-1)*16 + 1:16
                IV <<- .Call(AESencryptECB, context, xor(text[ind], IV))
                result[ind] <- IV
            }
            result
        } else if (mode == 6) {
            len <- length(text)
            blocks <- (len + 15) %/% 16
            result <- raw(16*blocks)
            zero <- as.raw(0)
            for (i in 1:blocks) {
                result[16*(i-1)+1:16] <- IV
                byte <- 16
                repeat {
                    IV[byte] <<- as.raw((as.integer(IV[byte]) + 1) %% 256)
                    if (IV[byte] != zero || byte == 1) break
                    byte <- byte - 1
                }
            }
            result <- .Call(AESencryptECB, context, result)
            length(result) <- len
            xor(text, result)
        }
    }

    decrypt <- function(ciphertext, raw = FALSE) {
        if (mode == 1)
            result <- .Call(AESdecryptECB, context, ciphertext)
        else if (mode == 2) {
            len <- length(ciphertext)
            if (len %% 16 != 0)
                stop("Ciphertext length must be a multiple of 16 bytes")	# #nocov
            result <- raw(length(ciphertext))
            for (i in seq_len(len/16)) {
                ind <- (i-1)*16 + 1:16
                res <- .Call(AESdecryptECB, context, ciphertext[ind])
                result[ind] <- xor(res, IV)
                IV <<- ciphertext[ind]
            }
        } else if (mode == 6)
              result <- encrypt(ciphertext)

        if (!raw)
            result <- rawToChar(result)						# #nocov
        result
    }

    structure(list(encrypt=encrypt,
                   decrypt=decrypt,
                   block_size=function() block_size,
                   IV=function() IV,
                   key_size=function() key_size,
                   mode=function() modes[mode]),
              class = "AES")
}

print.AES <- function(x, ...)							# #nocov
    cat("AES cipher object; mode", x$mode(), "key size", x$key_size(), "\n")	# #nocov
