# This is loosely modelled on the AES code from the Python Crypto package. 

# Currently only ECB and CBC modes are supported...

modes <- c("ECB", "CBC", "CFB", "PGP", "OFB", "CTR", "OPENPGP")

AES <- function(key, mode=c("ECB", "CBC"), IV=NULL) {
  mode <- match(match.arg(mode), modes)
  if (!(mode %in% 1:2))
    stop("Only ECB and CBC mode encryption are supported.")

  key <- as.raw(key)
  IV <- as.raw(IV)
  
  context <- .Call("AESinit", key)
  block_size <- 16
  key_size <- length(key)
  rm(key)
  
  encrypt <- function(text) {
    if (typeof(text) == "character")
      text <- charToRaw(text)
    if (mode == 1)
      .Call("AESencryptECB", context, text)
    else if (mode == 2) {
      len <- length(text)
      if (len %% 16 != 0)
      	stop("Text length must be a multiple of 16 bytes")
      result <- raw(length(text))
      for (i in seq_len(len/16)) {
        ind <- (i-1)*16 + 1:16
        IV <<- .Call("AESencryptECB", context, xor(text[ind], IV))
        result[ind] <- IV
      }
      result
    }  
  }
  
  decrypt <- function(ciphertext, raw = FALSE) {
    if (mode == 1) 
      result <- .Call("AESdecryptECB", context, ciphertext)
    else if (mode == 2) {
      len <- length(ciphertext)
      if (len %% 16 != 0)
        stop("Ciphertext length must be a multiple of 16 bytes")
      result <- raw(length(ciphertext))
      for (i in seq_len(len/16)) {
        ind <- (i-1)*16 + 1:16
        res <- .Call("AESdecryptECB", context, ciphertext[ind])
        result[ind] <- xor(res, IV)
        IV <<- ciphertext[ind]
      }
    }
    if (!raw)
      result <- rawToChar(result)
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
  
print.AES <- function(x, ...) 
  cat("AES cipher object; mode", x$mode(), "key size", x$key_size(), "\n")
  