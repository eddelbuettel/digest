
## tests for the fletcher (Fletcher-32) algorithm

suppressMessages(library(digest))

## check vectors from the Fletcher's checksum reference (16-bit word blocks)
input  <- c("abcde", "abcdef", "abcdefgh")
output <- c("f04fc729", "56502d2a", "ebe19591")

expect_identical(sapply(input, digest, algo="fletcher", serialize=FALSE,
                        USE.NAMES=FALSE),
                 output)

## empty input reduces to zero
expect_identical(digest("", algo="fletcher", serialize=FALSE), "00000000")

## raw input matches the equivalent character input
expect_identical(digest(charToRaw("abcde"), algo="fletcher", serialize=FALSE),
                 digest("abcde", algo="fletcher", serialize=FALSE))

## file interface agrees with the in-memory result
tf <- tempfile()
writeBin(charToRaw("abcdefgh"), tf)
expect_identical(digest(tf, algo="fletcher", file=TRUE),
                 digest("abcdefgh", algo="fletcher", serialize=FALSE))
unlink(tf)

## vectorised interface agrees with digest()
vd <- getVDigest(algo="fletcher")
expect_identical(vd(input, serialize=FALSE), output)
