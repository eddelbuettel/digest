
## tests for digest, taken from the examples in the manual page
##
## $Id: digestTest.R,v 1.1 2006/07/29 01:56:01 edd Exp $

stopifnot(require(digest))

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
  cat(md5, "\n")
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
  cat(sha1, "\n")
}

crc32Input <-
  c("abc",
    "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
    NULL)
crc32Output <- 
  c("352441c2",
    "171a3f5f",
    "2ef80172")

for (i in seq(along=crc32Input)) {
  crc32 <- digest(crc32Input[i], algo="crc32", serialize=FALSE)
  stopifnot(identical(crc32, crc32Output[i]))
  cat(crc32, "\n")
}

# one of the FIPS-
sha1 <- digest("abc", algo="sha1", serialize=FALSE)
stopifnot(identical(sha1, "a9993e364706816aba3e25717850c26c9cd0d89d"))

# example of a digest of a standard R list structure
cat(digest(list(LETTERS, data.frame(a=letters[1:5],
                           b=matrix(1:10,
                             ncol=2)))), "\n")

# test 'length' parameter and file input
fname = file.path(R.home(),"COPYING")
x = readChar(fname, file.info(fname)$size) # read file
for (alg in c("sha1", "md5", "crc32")) {
  # partial file
  h1 = digest(x    , length=18000, algo=alg, serialize=FALSE)
  h2 = digest(fname, length=18000, algo=alg, serialize=FALSE, file=TRUE)
  h3 = digest( substr(x,1,18000) , algo=alg, serialize=FALSE)
  stopifnot( identical(h1,h2), identical(h1,h3) )
  cat(h1, "\n", h2, "\n", h3, "\n")
  # whole file
  h1 = digest(x    , algo=alg, serialize=FALSE)
  h2 = digest(fname, algo=alg, serialize=FALSE, file=TRUE)
  stopifnot( identical(h1,h2) )
}

# compare md5 algorithm to other tools
library(tools)
fname = file.path(R.home(),"COPYING")
h1 = as.character(md5sum(fname))
h2 = digest(fname, algo="md5", file=TRUE)
stopifnot( identical(h1,h2) )
