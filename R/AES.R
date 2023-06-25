##  AES -- Advanced Encryption Standard (AES) block cipher for R
##
##  Copyright (C) 2013 - 2019  Duncan Murdoch and Dirk Eddelbuettel
##  Copyright (C) 2019         Ion Suruceanu
##
##  This file is part of digest.
##
##  digest is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  digest is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with digest.  If not, see <http://www.gnu.org/licenses/>.

## This is loosely modelled on the AES code from the Python Crypto package.
## Currently only ECB, CBC, CFB and CTR modes are supported...

modes <- c("ECB", "CBC", "CFB", "PGP", "OFB", "CTR", "OPENPGP")

AES <- function(key, mode=c("ECB", "CBC", "CFB", "CTR"), IV=NULL, padding=FALSE) {
    mode <- match(match.arg(mode), modes)
    if (!(mode %in% c(1:3, 6)))
        stop("Only ECB, CBC, CFB and CTR mode encryption are supported.")	# #nocov
    if (padding && mode != 2)
        stop("Only CBC mode supports padding") # #nocov

    key <- as.raw(key)
    IV <- as.raw(IV)

    context <- .Call(AESinit, key)
    block_size <- 16
    key_size <- length(key)
    rm(key)

    encrypt <- function(text) {
        if (typeof(text) == "character")
            text <- charToRaw(text)
        if (mode == 1)
            .Call(AESencryptECB, context, text)
        else if (mode == 2) {
            if (padding) {
              bytes <- block_size - (length(text) %% block_size)
              text <- c(text, rep(as.raw(bytes), times = bytes))
            }

            len <- length(text)
            if (len %% block_size != 0)
                stop("Text length must be a multiple of ", block_size, " bytes, or use `padding=TRUE`")
            result <- raw(length(text))
            for (i in seq_len(len/block_size)) {
                ind <- (i-1)*block_size + seq(block_size)
                IV <<- .Call(AESencryptECB, context, xor(text[ind], IV))
                result[ind] <- IV
            }
            result
        } else if (mode == 3) {
            if (length(IV) != block_size) {
                stop("IV length must equal block size")
            }
            result <- raw(length(text))
            blocks <- split(text, ceiling(seq_along(text)/block_size))
            i <- 0
            for (b in blocks) {
                if (block_size == length(IV)) {
                    out <- .Call(AESencryptECB, context, IV)
                }
                len <- length(b)
                ind <- i*length(IV)+1:len
                i <- i + 1
                result[ind] <- xor(b, out[0:len])
                IV <<- result[ind]
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
            if (padding) {
              bytes_to_remove <- as.integer(utils::tail(result, 1))
              result <- utils::head(result, -bytes_to_remove)
            }
        } else if (mode == 3) {
            if (length(IV) != block_size) {
                stop("IV length must equal block size")
            }
            result <- raw(length(ciphertext))
            blocks <- split(ciphertext, ceiling(seq_along(ciphertext)/block_size))
            i <- 0
            for (b in blocks) {
                if (block_size == length(IV)) {
                    out <- .Call(AESencryptECB, context, IV)
                }
                len <- length(b)
                ind <- i*length(IV)+1:len
                i <- i + 1
                result[ind] <- xor(b, out[0:len])
                IV <<- b
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
