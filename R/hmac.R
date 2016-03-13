
makeRaw <- function(object)
    ## generic function, converts an object to a raw
    UseMethod("makeRaw")

makeRaw.raw <- function(object) object

makeRaw.character <- function(object) charToRaw(object)

# splits a hex-string into the values it contains.
makeRaw.digest <- function(x) {
    parts <- sapply(seq(1, nchar(x), 2),
                    function(i) { substr(x, i, i + 1) })
    as.raw(as.hexmode(parts))
}

makeRaw.default <- function(object) as.raw(object)

# key shall be padded if its length is smaller than the block size of the
# respective algorithm, hashed if longer. block sizes are as follows:
#
# md5		64
# sha1		64
# crc32	 	4
# sha256 	64
# sha512	128 (doh!)

padWithZeros <- function(k,algo) {
    blocksize <- 64
    if (algo == "crc32") blocksize <- 4
    if (algo == "sha512") blocksize <- 128
    k <- makeRaw(k)
    if(length(k) > blocksize) {# not while()
        k <-digest(k, algo=algo, serialize=FALSE,raw=TRUE)
        if (algo == "crc32") {
            k <- substring(k, seq(1,7,2), seq(2,8,2))
            k <- makeRaw(strtoi(k,16))
        }
    }
    makeRaw(c(k, rep(0, blocksize - length(k))))
}

#' Compute a hash-based message authentication code.
#'
#' The \code{hmac} function calculates a message authentication code (MAC)
#' involving the specified cryptographic hash function in combination with a
#' given secret key.
#'
#' @param key An arbitrary character or numeric vector, to use as pre-shared
#'   secret key.
#' @param  object An arbitrary R object which will then be passed to the
#'   \code{\link{serialize}} function, unless the \code{serialize} argument is
#'   set to \code{FALSE}.
#' @param algo The algorithms to be used; currently available choices are
#'   \code{md5}, which is also the default, \code{sha1}, \code{crc32} and
#'   \code{sha256}.
#' @param serialize default value of \code{serialize} is here FALSE, not TRUE as
#'   it is in \code{digest}.
#' @param raw This flag alters the type of the output.  Setting this to
#'   \code{TRUE} causes the function to return an object of type \code{"raw"}
#'   instead of \code{"character"}.
#' @param ... All remaining arguments are passed to \code{digest}.
#'
#' @return The \code{hmac} function uses the \code{digest} to return a hash
#'   digest as specified in the RFC 2104.
#'
#' @references
#'   MD5: \url{http://www.ietf.org/rfc/rfc1321.txt}.
#'
#'   SHA-1: \url{http://www.itl.nist.gov/fipspubs/fip180-1.htm}. SHA-256:
#'   \url{http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf}.
#'
#'   CRC32:  The original reference webpage at \code{rocksoft.com} has vanished
#'   from the web; see
#'   \url{https://en.wikipedia.org/wiki/Cyclic_redundancy_check} for general
#'   information on CRC algorithms.
#'
#'   \url{http://www.aarongifford.com/computers/sha.html} for the integrated C
#'   implementation of sha-512.
#'
#'   The page for the code underlying the C functions used here for sha-1 and
#'   md5, and further references, is no longer accessible.  Please see
#'   \url{https://en.wikipedia.org/wiki/SHA-1} and
#'   \url{https://en.wikipedia.org/wiki/MD5}.
#'
#'   \url{http://zlib.net} for documentation on the zlib library which supplied
#'   the code for crc32.
#'
#'   \url{http://en.wikipedia.org/wiki/SHA_hash_functions} for documentation on
#'   the sha functions.
#'
#' @author Mario Frasca \email{mfrasca@zonnet.nl}
#' @example vignettes/example-hmac.R
#' @seealso \code{\link{digest}}
#' @keywords misc
#' @export
hmac <- function(key, object,
                 algo = c("md5", "sha1", "crc32", "sha256", "sha512"),
                 serialize = FALSE, raw = FALSE, ...) {
    padded.key <- padWithZeros(key,algo)
    i.xored.key <- xor(padded.key, makeRaw(0x36))
    character.digest <- digest(c(i.xored.key, makeRaw(object)),
                               algo = algo, serialize = serialize, ...)
    raw.digest <- makeRaw.digest(character.digest)
    o.xored.key <- xor(padded.key, makeRaw(0x5c))
    result <- digest(c(o.xored.key, raw.digest), algo = algo,
                     serialize = serialize, ...)
    if (raw) {
        result <- makeRaw.digest(result)
    }
    return(result)
}
