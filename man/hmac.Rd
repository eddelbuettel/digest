\name{hmac}
\alias{hmac}
\title{compute a hash-based message authentication code}
\description{
  The \code{hmac} function calculates a message authentication code
  (MAC) involving the specified cryptographic hash function in
  combination with a given secret key.
}
\usage{
hmac(key, object,
     algo = c("md5", "sha1", "crc32", "sha256", "sha512"),
     serialize = FALSE, raw = FALSE, ...)
}
\arguments{
  \item{key}{An arbitrary character or numeric vector, to use as
    pre-shared secret key.}
  \item{object}{An arbitrary R object which will then be passed to the
    \code{\link{serialize}} function, unless the \code{serialize}
    argument is set to \code{FALSE}.}
  \item{algo}{The algorithms to be used; currently available choices are
    \code{md5}, which is also the default, \code{sha1}, \code{crc32} and
    \code{sha256}.}
  \item{serialize}{default value of \code{serialize} is here FALSE, not
    TRUE as it is in \code{digest}.}
  \item{raw}{This flag alters the type of the output.  Setting this to
    \code{TRUE} causes the function to return an object of type
    \code{"raw"} instead of \code{"character"}.} 
  \item{...}{All remaining arguments are passed to \code{digest}.  }
}
\value{
  The \code{hmac} function uses the \code{digest} to return a hash
  digest as specified in the RFC 2104.
}
\references{
  MD5: \url{http://www.ietf.org/rfc/rfc1321.txt}. 

  SHA-1: \url{https://en.wikipedia.org/wiki/SHA-1}.
  SHA-256: \url{https://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf}.
  CRC32:  The original reference webpage at \code{rocksoft.com} has
  vanished from the web; see
  \url{https://en.wikipedia.org/wiki/Cyclic_redundancy_check} for
  general information on CRC algorithms.

  \url{http://www.aarongifford.com/computers/sha.html} for the 
  integrated C implementation of sha-512.

  The page for the code underlying the C functions used here for sha-1
  and md5, and further references, is no longer accessible.  Please see
  \url{https://en.wikipedia.org/wiki/SHA-1} and
  \url{https://en.wikipedia.org/wiki/MD5}.  

  \url{http://zlib.net} for documentation on the zlib library which
  supplied the code for crc32.

  \url{http://en.wikipedia.org/wiki/SHA_hash_functions} for
  documentation on the sha functions.
}
\author{Mario Frasca \email{mfrasca@zonnet.nl}.} 
\seealso{\code{\link{digest}}}

\examples{



## Standard RFC 2104 test vectors
current <- hmac('Jefe', 'what do ya want for nothing?', "md5")
target <- '750c783e6ab0b503eaa86e310a5db738'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0x0b, 16), 'Hi There', "md5")
target <- '9294727a3638bb1c13f48ef8158bfc9d'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0xaa, 16), rep(0xdd, 50), "md5")
target <- '56be34521d144c88dbb8c733f0e8b3f6'
stopifnot(identical(target, as.character(current)))

## SHA1 tests inspired to the RFC 2104 and checked against the python
## hmac implementation.
current <- hmac('Jefe', 'what do ya want for nothing?', "sha1")
target <- 'effcdf6ae5eb2fa2d27416d5f184df9c259a7c79'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0x0b, 16), 'Hi There', "sha1")
target <- '675b0b3a1b4ddf4e124872da6c2f632bfed957e9'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0xaa, 16), rep(0xdd, 50), "sha1")
target <- 'd730594d167e35d5956fd8003d0db3d3f46dc7bb'
stopifnot(identical(target, as.character(current)))

}
\keyword{misc}

