\name{AES}
\alias{AES}

\title{
Create AES block cipher object
}
\description{
This creates an object that can perform the Advanced Encryption
Standard (AES) block cipher.
}
\usage{
AES(key, mode=c("ECB", "CBC", "CFB", "CTR"), IV=NULL, padding=FALSE)
}
\arguments{
  \item{key}{
The key as a 16, 24 or 32 byte raw vector for AES-128, AES-192 or
AES-256 respectively.
}
  \item{mode}{
The encryption mode to use.  Currently only \dQuote{electronic
codebook} (ECB), \dQuote{cipher-block chaining} (CBC), \dQuote{cipher feedback} (CFB) and
\dQuote{counter} (CTR) modes are supported.
}
  \item{IV}{
The initial vector for CBC and CFB mode or initial counter for CTR mode.
}
  \item{padding}{
Whether or not PKCS#7 padding is used during encryption and decryption in CBC mode.
}
}
\value{
An object of class \code{"AES"}.  This is a list containing the
following component functions:

\item{encrypt(text)}{A function to encrypt a text vector.  The text
may be a single element character vector or a raw vector.  It returns
the ciphertext as a raw vector.}

\item{decrypt(ciphertext, raw = FALSE)}{A function to decrypt the
ciphertext. In ECB mode, the same AES
object can be used for both encryption and decryption, but in
CBC, CFB and CTR modes a new object needs to be
created, using the same initial \code{key} and \code{IV} values.
Returns a single element character vector, or a raw vector if \code{raw = TRUE}.}

\item{IV()}{Report on the current state of the initialization vector.
As blocks are encrypted or decrypted in CBC, CFB or CTR mode, the initialization
vector is updated, so both operations can be performed sequentially on
subsets of the text or ciphertext.}

\item{block_size(), key_size(), mode()}{Report on these aspects of
the AES object.}

}
\details{
The standard NIST definition of CTR mode doesn't define how the counter
is updated, it just requires that it be updated with each block
and not repeat itself for a long time.  This implementation treats it as a
128 bit integer and adds 1 with each successive block.
}
\author{
The R interface was written by Duncan Murdoch. The design is loosely
based on the Python Crypto implementation.  The underlying AES
implementation is by Christophe Devine.
}
\references{
United States National Institute of Standards and Technology (2001).
"Announcing the ADVANCED ENCRYPTION STANDARD (AES)".
Federal Information Processing Standards Publication 197.
\url{https://csrc.nist.gov/publications/fips/fips197/fips-197.pdf}.

Morris Dworkin (2001).
"Recommendation for Block Cipher Modes of Operation".
NIST Special Publication 800-38A 2001 Edition.
}
\examples{
# First in ECB mode: the repeated block is coded the same way each time
msg <- as.raw(c(1:16, 1:16))
key <- as.raw(1:16)
aes <- AES(key, mode="ECB")
aes$encrypt(msg)
aes$decrypt(aes$encrypt(msg), raw=TRUE)

# Now in CBC mode:  each encoding is different
iv <- sample(0:255, 16, replace=TRUE)
aes <- AES(key, mode="CBC", iv)
code <- aes$encrypt(msg)
code

# Need a new object for decryption in CBC mode
aes <- AES(key, mode="CBC", iv)
aes$decrypt(code, raw=TRUE)

# In CBC mode, the input length must be a multiple of 16 bytes.
# You can use `padding = TRUE` to ensure the input length is always valid.
AES(key, mode="CBC", iv, padding = TRUE)$encrypt(as.raw(1:15))

# CFB mode: IV must be the same length as the Block's block size
# Two different instances of AES are required for encryption and decryption
iv <- sample(0:255, 16, replace=TRUE)
aes <- AES(key, mode="CFB", iv)
code <- aes$encrypt(msg)
code
#decrypt
aes <-  AES(key, mode="CFB", iv)
aes$decrypt(code)


# FIPS-197 examples

hextextToRaw <- function(text) {
  vals <- matrix(as.integer(as.hexmode(strsplit(text, "")[[1]])), ncol=2, byrow=TRUE)
  vals <- vals \%*\% c(16, 1)
  as.raw(vals)
}

plaintext       <- hextextToRaw("00112233445566778899aabbccddeeff")

aes128key       <- hextextToRaw("000102030405060708090a0b0c0d0e0f")
aes128output    <- hextextToRaw("69c4e0d86a7b0430d8cdb78070b4c55a")
aes <- AES(aes128key)
aes128 <- aes$encrypt(plaintext)
stopifnot(identical(aes128, aes128output))
stopifnot(identical(plaintext, aes$decrypt(aes128, raw=TRUE)))

aes192key       <- hextextToRaw("000102030405060708090a0b0c0d0e0f1011121314151617")
aes192output    <- hextextToRaw("dda97ca4864cdfe06eaf70a0ec0d7191")
aes <- AES(aes192key)
aes192 <- aes$encrypt(plaintext)
stopifnot(identical(aes192, aes192output))
stopifnot(identical(plaintext, aes$decrypt(aes192, raw=TRUE)))

aes256key       <- hextextToRaw("000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f")
aes256output     <- hextextToRaw("8ea2b7ca516745bfeafc49904b496089")
aes <- AES(aes256key)
aes256 <- aes$encrypt(plaintext)
stopifnot(identical(aes256, aes256output))
stopifnot(identical(plaintext, aes$decrypt(aes256, raw=TRUE)))

# SP800-38a examples

plaintext <- hextextToRaw(paste("6bc1bee22e409f96e93d7e117393172a",
                                "ae2d8a571e03ac9c9eb76fac45af8e51",
                                "30c81c46a35ce411e5fbc1191a0a52ef",
                                "f69f2445df4f9b17ad2b417be66c3710",sep=""))
key <- hextextToRaw("2b7e151628aed2a6abf7158809cf4f3c")

ecb128output <- hextextToRaw(paste("3ad77bb40d7a3660a89ecaf32466ef97",
                                   "f5d3d58503b9699de785895a96fdbaaf",
                                   "43b1cd7f598ece23881b00e3ed030688",
                                   "7b0c785e27e8ad3f8223207104725dd4",sep=""))
aes <- AES(key)
ecb128 <- aes$encrypt(plaintext)
stopifnot(identical(ecb128, ecb128output))
stopifnot(identical(plaintext, aes$decrypt(ecb128, raw=TRUE)))

cbc128output <- hextextToRaw(paste("7649abac8119b246cee98e9b12e9197d",
                                   "5086cb9b507219ee95db113a917678b2",
                                   "73bed6b8e3c1743b7116e69e22229516",
                                   "3ff1caa1681fac09120eca307586e1a7",sep=""))
iv <- hextextToRaw("000102030405060708090a0b0c0d0e0f")
aes <- AES(key, mode="CBC", IV=iv)
cbc128 <- aes$encrypt(plaintext)
stopifnot(identical(cbc128, cbc128output))
aes <- AES(key, mode="CBC", IV=iv)
stopifnot(identical(plaintext, aes$decrypt(cbc128, raw=TRUE)))


cfb128output <- hextextToRaw(paste("3b3fd92eb72dad20333449f8e83cfb4a",
                                   "c8a64537a0b3a93fcde3cdad9f1ce58b",
                                   "26751f67a3cbb140b1808cf187a4f4df",
                                   "c04b05357c5d1c0eeac4c66f9ff7f2e6",sep=""))
aes <- AES(key, mode="CFB", IV=iv)
cfb128 <- aes$encrypt(plaintext)
stopifnot(identical(cfb128, cfb128output))
aes <- AES(key, mode="CFB", IV=iv)
stopifnot(identical(plaintext, aes$decrypt(cfb128, raw=TRUE)))


ctr128output <- hextextToRaw(paste("874d6191b620e3261bef6864990db6ce",
                                   "9806f66b7970fdff8617187bb9fffdff",
                                   "5ae4df3edbd5d35e5b4f09020db03eab",
                                   "1e031dda2fbe03d1792170a0f3009cee",sep=""))
iv <- hextextToRaw("f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff")
aes <- AES(key, mode="CTR", IV=iv)
ctr128 <- aes$encrypt(plaintext)
stopifnot(identical(ctr128, ctr128output))
aes <- AES(key, mode="CTR", IV=iv)
stopifnot(identical(plaintext, aes$decrypt(ctr128, raw=TRUE)))

}
