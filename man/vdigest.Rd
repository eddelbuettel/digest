\name{getVDigest}
\alias{getVDigest}
\title{Set a vectorised function for creating hash function digests}
\description{
The \code{getVDigest} function extends \code{digest} by allowing one to
set a function that returns hash summaries as a character vector of the same length as the input. It also provides a performance advantage
when repeated calls are necessary (e.g. applying a hash function repeatedly to an object). The returned function contains the same arguments as \code{digest} with the exception of the \code{raw} argument (see \code{\link{digest}} for more details).
}
\usage{
getVDigest(algo=c("md5", "sha1", "crc32", "sha256", "sha512", "xxhash32",
            "xxhash64", "murmur32", "spookyhash"),
             errormode=c("stop","warn","silent"))
}
\arguments{
  \item{algo}{The algorithms to be used; currently available choices are
    \code{md5}, which is also the default, \code{sha1}, \code{crc32},
    \code{sha256}, \code{sha512}, \code{xxhash32}, \code{xxhash64},
    \code{murmur32} and \code{spookyhash}.}
  \item{errormode}{A character value denoting a choice for the behaviour in
    the case of error: \sQuote{stop} aborts (and is the default value),
    \sQuote{warn} emits a warning and returns \code{NULL} and
    \sQuote{silent} suppresses the error and returns an empty string.}
}
\value{
  The \code{getVDigest} function returns a function for a given
  algorithm and error-mode.
}
\details{
 Note that since one hash summary will be returned for each element passed as input,  care must be taken when determining whether or not to include the data structure as  part of the object. For instance, to return the equivalent output of
 \code{digest(list("a"))} it would be necessary to wrap the list object itself
 \code{getVDigest()(list(list("a")))}
}
\seealso{\code{\link{digest}}, \code{\link{serialize}}, \code{\link{md5sum}}}
\examples{
stretch_key <- function(d, n) {
    md5 <- getVDigest()
    for (i in seq_len(n))
        d <- md5(d, serialize = FALSE)
    d
}
stretch_key('abc123', 65e3)
sha1 <- getVDigest(algo = 'sha1')
sha1(letters)

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

md5 <- getVDigest()
stopifnot(identical(md5(md5Input, serialize = FALSE), md5Output))
stopifnot(identical(digest(list("abc")),
                 md5(list(list("abc")))))

sha512Input <-c(
    "",
    "The quick brown fox jumps over the lazy dog."
    )
sha512Output <- c(
    paste0("cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce",
           "47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"),
    paste0("91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bb",
           "c6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed")
    )

sha512 <- getVDigest(algo = 'sha512')
stopifnot(identical(sha512(sha512Input, serialize = FALSE), sha512Output))

}
\keyword{misc}
