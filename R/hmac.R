
makeRaw <- function(object)
    ## generic function, converts an object to a raw
    UseMethod('makeRaw')

makeRaw.raw <- function(object) object

makeRaw.character <- function(object) charToRaw(object)

# splits a hex-string into the values it contains.
makeRaw.digest <- function(object) {
    parts <- sapply(seq(1, nchar(object), 2),
                    function(i) { substr(object, i, i + 1) })
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

hmac <- function(key, object,
                 algo=c("md5", "sha1", "crc32", "sha256", "sha512"),
                 serialize=FALSE, raw=FALSE, ...) {
    padded.key <- padWithZeros(key,algo)
    i.xored.key <- xor(padded.key, makeRaw(0x36))
    character.digest <- digest(c(i.xored.key, makeRaw(object)),
                               algo=algo, serialize=serialize, ...)
    raw.digest <- makeRaw.digest(character.digest)
    o.xored.key <- xor(padded.key, makeRaw(0x5c))
    result <- digest(c(o.xored.key, raw.digest), algo=algo, serialize=serialize, ...)
    if(raw)
        result <- makeRaw.digest(result)
    return(result)
}
