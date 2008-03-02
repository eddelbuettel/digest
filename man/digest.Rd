% $Id: digest.Rd,v 1.1 2003/11/29 01:47:55 edd Exp $
\name{digest}
\alias{digest}
\title{Create hash function digests for arbitrary R objects}
\description{
  The \code{digest} function applies a cryptographical hash function to
  arbitrary R objects. By default, the objects are internally
  serialized, and either one of the currently implemented MD5 and SHA-1
  hash functions algorithms can be used to compute a compact digest of
  the serialized object.

  In order to compare this implementation with others, serialization of
  the input argument can also be turned off in which the input argument
  must be a character string for which its digest is returned.
}
\usage{
digest(object, algo="md5", serialize=TRUE)
}
\arguments{
  \item{object}{An arbitrary R object which will then be passed to the
    \code{\link{serialize}} function, unless the \code{serialize}
    argument is set to \code{FALSE}}
  \item{algo}{The algorithms to be used; currently available choices are
    \code{md5}, which is also the default, and \code{sha-1}}
  \item{serialize}{A logical variable indicating whether the object
    should be serialized using \code{serialize}. Setting this to
    \code{FALSE} allows to compares the digest output of given character
    strings to known control output.}
}
\value{
  The \code{digest} function returns a character string of a fixed
  length containing the requested digest of the supplied R object. For
  MD5, a string of length 32 is returned; for SHA-1, a string of length
  40 is returned.

  NULL is returned if an bad argument for \code{algo} had been supplied.
}
\details{
  Cryptographic hash functions are well researched and documented. The
  MD5 algorithm by Ron Rivest is specified in RFC 1321. The SHA-1
  algorithm is specified in FIPS-180-1.

  This R implementation relies on two standalone implementations in C
  by Christophe Devine.}
}
\references{
  MD5 is described in \cite{MD5 Message-Digest Algorithm}
  at \url{http://www.ietf.org/rfc/rfc1321.txt}.

  SHA-1 is described in \cite{Secure Hash Standard} at
  \url{http://www.itl.nist.gov/fipspubs/fip180-1.htm}.

  \url{http://www.cr0.net:8040/code/crypto} for the underlying
  C functions used here, and further references.
}
\author{Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
  Christophe Devine for the hash function implementations.}
\seealso{\code{\link{serialize}}, \code{\link{md5sum}}}

\examples{

## Standard RFC 1321 test vectors
md5Input <-
  c("",
    "a",
    "abc",
    "message digest",
    "abcdefghijklmnopqrstuvwxyz",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    paste("12345678901234567890123456789012345678901234567890123456789012",
          "345678901234567890", sep=""))
md5Output <-
  c("d41d8cd98f00b204e9800998ecf8427e",
    "0cc175b9c0f1b6a831c399e269772661",
    "900150983cd24fb0d6963f7d28e17f72",
    "f96b697d7cb7938d525a2f31aaf161d0",
    "c3fcd3d76192e4007dfb496cca67e13b",
    "d174ab98d277d9f5a5611c2c9f419d9f",
    "57edf4a22be3c955ac49da2e2107b67a")

for (i in seq(along=md5Input)) {
  md5 <- digest(md5Input[i], serialize=FALSE)
  stopifnot(identical(md5, md5Output[i]))
}

sha1Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
    NULL)
sha1Output <- 
  c("a9993e364706816aba3e25717850c26c9cd0d89d",
    "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
    "34aa973cd4c4daa4f61eeb2bdbad27316534016f")

for (i in seq(along=sha1Input)) {
  sha1 <- digest(sha1Input[i], algo="sha1", serialize=FALSE)
  stopifnot(identical(sha1, sha1Output[i]))
}

# one of the FIPS-
sha1 <- digest("abc", algo="sha1", serialize=FALSE)
stopifnot(identical(sha1, "a9993e364706816aba3e25717850c26c9cd0d89d"))

# example of a digest of a standard R list structure
digest(list(LETTERS, data.frame(a=letters[1:5], b=matrix(1:10,ncol=2))))
}
\keyword{misc}

