# $Id$

makeRaw <- function(object)
  ## generic function, converts an object to a raw
  UseMethod('makeRaw')

makeRaw.raw <- function(object) object

makeRaw.character <- function(object) charToRaw(object)

# splits a hex-string into the values it contains.
makeRaw.digest <- function(x) {
  parts <- sapply(seq(1, nchar(x), 2),
                  function(i) { substr(x, i, i + 1) })
  as.raw(as.hexmode(parts))
}

makeRaw.default <- function(object) as.raw(object)

padWithZeros <- function(k) {
  k <- makeRaw(k)
  while(length(k) > 64)
    k <- makeRaw.digest(digest(k, algo="sha1", serialize=FALSE))
  makeRaw(c(k, rep(0, 64 - length(k))))
}

hmac <- function(key, object, algo=c("md5", "sha1", "crc32", "sha256", "sha512"), serialize=FALSE, raw=FALSE, ...) {
  padded.key <- padWithZeros(key)
  i.xored.key <- xor(padded.key, makeRaw(0x36))
  character.digest <- digest(c(i.xored.key, makeRaw(object)), algo=algo, serialize=serialize, ...)
  raw.digest <- makeRaw.digest(character.digest)
  o.xored.key <- xor(padded.key, makeRaw(0x5c))
  result <- digest(c(o.xored.key, raw.digest), algo=algo, serialize=serialize, ...)
  if(raw)
    result <- makeRaw.digest(result)
  return(result)
}
