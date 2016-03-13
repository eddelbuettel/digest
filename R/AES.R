# This is loosely modelled on the AES code from the Python Crypto package.
# Currently only ECB, CBC and CTR modes are supported...
modes <- c("ECB", "CBC", "CFB", "PGP", "OFB", "CTR", "OPENPGP")

#' Create AES block cipher object.
#'
#' This creates an object that can perform the Advanced Encryption Standard
#' (AES) block cipher.
#'
#' @param key The key as a 16, 24 or 32 byte raw vector for AES-128, AES-192 or
#'   AES-256 respectively.
#' @param mode The encryption mode to use.  Currently only \dQuote{electronic codebook} (ECB), \dQuote{cipher-block chaining} (CBC) and \dQuote{counter} (CTR) modes are supported.
#' @param IV The initial vector for CBC mode or initial counter for CTR mode.
#'
#' @return An object of class \code{"AES"}.  This is a list containing the
#'   following component functions:
#'   \item{encrypt(text)}{A function to encrypt a text vector. The text may be a
#'   single element character vector or a raw vector. It returns the ciphertext
#'   as a raw vector.}
#'   \item{decrypt(ciphertext, raw = FALSE)}{A function to decrypt the
#'   ciphertext. In ECB mode, the same AES object can be used for both
#'   encryption and decryption, but in CBC and CTR modes a new object needs to
#'   be created, using the same initial \code{key} and \code{IV} values.}
#'   \item{IV()}{Report on the current state of the initialization vector. As
#'   blocks are encrypted or decrypted in CBC or CTR mode, the initialization
#'   vector is updated, so both operations can be performed sequentially on
#'   subsets of the text or ciphertext.}
#'   \item{block_size(), key_size(), mode()}{Report on these aspects of the AES
#'   object.}
#'
#' @details The standard NIST definition of CTR mode doesn't define how the
#'   counter is updated, it just requires that it be updated with each block and
#'   not repeat itself for a long time.  This implementation treats it as a 128
#'   bit integer and adds 1 with each successive block.
#'
#' @author The R interface was written by Duncan Murdoch. The design is loosely
#'   based on the Python Crypto implementation.  The underlying AES
#'   implementation is by Christophe Devine.
#'
#' @references
#'   United States National Institute of Standards and Technology (2001).
#'   "Announcing the ADVANCED ENCRYPTION STANDARD (AES)". Federal Information
#'   Processing Standards Publication 197.
#'   \url{http://csrc.nist.gov/publications/fips/fips197/fips-197.pdf}.
#'
#'   Morris Dworkin (2001). "Recommendation for Block Cipher Modes of
#'   Operation". NIST Special Publication 800-38A 2001 Edition.
#'   \url{http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf}.
#'
#' @example vignettes/example-AES.R
#' @export
#' @useDynLib digest AESinit AESencryptECB AESdecryptECB
AES <- function(key, mode=c("ECB", "CBC", "CTR"), IV=NULL) {
    mode <- match(match.arg(mode), modes)
    if (!(mode %in% c(1:2, 6)))
        stop("Only ECB, CBC and CTR mode encryption are supported.")

    key <- as.raw(key)
    IV <- as.raw(IV)

    context <- .Call(AESinit, key) #TODO:defined but not used? (by Viliam Simko)
    block_size <- 16
    key_size <- length(key)
    rm(key)

    encrypt <- function(text) {
        if (typeof(text) == "character")
            text <- charToRaw(text)
        if (mode == 1)
            .Call(AESencryptECB, context, text)
        else if (mode == 2) {
            len <- length(text)
            if (len %% 16 != 0)
                stop("Text length must be a multiple of 16 bytes")
            result <- raw(length(text))
            for (i in seq_len(len/16)) {
                ind <- (i - 1)*16 + 1:16
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
                result[16*(i - 1) + 1:16] <- IV
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
                stop("Ciphertext length must be a multiple of 16 bytes")
            result <- raw(length(ciphertext))
            for (i in seq_len(len/16)) {
                ind <- (i - 1)*16 + 1:16
                res <- .Call(AESdecryptECB, context, ciphertext[ind])
                result[ind] <- xor(res, IV)
                IV <<- ciphertext[ind]
            }
        } else if (mode == 6)
              result <- encrypt(ciphertext)

        if (!raw)
            result <- rawToChar(result)
        result
    }

    structure(list(encrypt = encrypt,
                   decrypt = decrypt,
                   block_size = function() block_size,
                   IV = function() IV,
                   key_size = function() key_size,
                   mode = function() modes[mode]),
              class = "AES")
}

#' @export
print.AES <- function(x, ...)
    cat("AES cipher object; mode", x$mode(), "key size", x$key_size(), "\n")
