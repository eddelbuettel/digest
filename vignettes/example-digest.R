## Standard RFC 1321 test vectors
md5Input <-
    c("",
      "a",
      "abc",
      "message digest",
      "abcdefghijklmnopqrstuvwxyz",
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
      paste0("12345678901234567890123456789012345678901234567890123456789012",
             "345678901234567890"))
md5Output <-
    c("d41d8cd98f00b204e9800998ecf8427e",
      "0cc175b9c0f1b6a831c399e269772661",
      "900150983cd24fb0d6963f7d28e17f72",
      "f96b697d7cb7938d525a2f31aaf161d0",
      "c3fcd3d76192e4007dfb496cca67e13b",
      "d174ab98d277d9f5a5611c2c9f419d9f",
      "57edf4a22be3c955ac49da2e2107b67a")

for (i in seq(along = md5Input)) {
    md5 <- digest(md5Input[i], serialize = FALSE)
    stopifnot(identical(md5, md5Output[i]))
}

sha1Input <-
    c("abc", "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")

sha1Output <-
    c("a9993e364706816aba3e25717850c26c9cd0d89d",
      "84983e441c3bd26ebaae4aa1f95129e5e54670f1")

for (i in seq(along = sha1Input)) {
    sha1 <- digest(sha1Input[i], algo = "sha1", serialize = FALSE)
    stopifnot(identical(sha1, sha1Output[i]))
}

crc32Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
crc32Output <-
    c("352441c2",
      "171a3f5f")

for (i in seq(along = crc32Input)) {
    crc32 <- digest(crc32Input[i], algo = "crc32", serialize = FALSE)
    stopifnot(identical(crc32, crc32Output[i]))
}


sha256Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha256Output <-
    c("ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
      "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")

for (i in seq(along = sha256Input)) {
    sha256 <- digest(sha256Input[i], algo = "sha256", serialize = FALSE)
    stopifnot(identical(sha256, sha256Output[i]))
}

# SHA 512 example
sha512Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq")
sha512Output <-
    c(paste0("ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a",
            "2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f"),
      paste0("204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c335",
            "96fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445"))

for (i in seq(along = sha512Input)) {
    sha512 <- digest(sha512Input[i], algo = "sha512", serialize = FALSE)
    stopifnot(identical(sha512, sha512Output[i]))
}

## xxhash32 example
xxhash32Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
xxhash32Output <-
    c("32d153ff",
      "89ea60c3",
      "02cc5d05")

for (i in seq(along = xxhash32Input)) {
    xxhash32 <- digest(xxhash32Input[i], algo = "xxhash32", serialize = FALSE)
    cat(xxhash32, "\n")
    stopifnot(identical(xxhash32, xxhash32Output[i]))
}

## xxhash64 example
xxhash64Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
xxhash64Output <-
    c("44bc2cf5ad770999",
      "f06103773e8585df",
      "ef46db3751d8e999")

for (i in seq(along = xxhash64Input)) {
    xxhash64 <- digest(xxhash64Input[i], algo = "xxhash64", serialize = FALSE)
    cat(xxhash64, "\n")
    stopifnot(identical(xxhash64, xxhash64Output[i]))
}

## these outputs were calculated using mmh3 python package
murmur32Input <-
    c("abc",
      "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
      "")
murmur32Output <-
    c("b3dd93fa",
      "ee925b90",
      "00000000")

for (i in seq(along = murmur32Input)) {
    murmur32 <- digest(murmur32Input[i], algo = "murmur32", serialize = FALSE)
    cat(murmur32, "\n")
    stopifnot(identical(murmur32, murmur32Output[i]))
}

# example of a digest of a standard R list structure
digest(list(LETTERS, data.frame(a = letters[1:5], b = matrix(1:10, ncol = 2))))

# test 'length' parameter and file input
fname <- file.path(R.home(),"COPYING")
x <- readChar(fname, file.info(fname)$size) # read file
for (alg in c("sha1", "md5", "crc32")) {
    # partial file
    h1 <- digest(x,     length = 18000, algo = alg, serialize = FALSE)
    h2 <- digest(fname, length = 18000, algo = alg, serialize = FALSE,
                 file = TRUE)
    h3 <- digest(substr(x,1,18000), algo = alg, serialize = FALSE)
    stopifnot( identical(h1,h2), identical(h1,h3) )
    # whole file
    h1 <- digest(x,     algo = alg, serialize = FALSE)
    h2 <- digest(fname, algo = alg, serialize = FALSE, file = TRUE)
    stopifnot( identical(h1,h2) )
}

# compare md5 algorithm to other tools
library(tools)
fname <- file.path(R.home(),"COPYING")
h1 <- as.character(md5sum(fname))
h2 <- digest(fname, algo = "md5", file = TRUE)
stopifnot( identical(h1,h2) )
