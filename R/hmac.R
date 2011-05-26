# $Id$

make.raw <- function(object)
  ## generic function, converts an object to a raw
  UseMethod('make.raw')

make.raw.raw <- function(object) object

make.raw.character <- function(object) charToRaw(object)

# splits a hex-string into the values it contains.
make.raw.digest <- function(x) {
  parts <- sapply(seq(1, nchar(x), 2),
                  function(i) { substr(x, i, i + 1) })
  as.raw(as.hexmode(parts))
}

make.raw.default <- function(object) as.raw(object)

pad.with.zeros <- function(k) {
  k <- make.raw(k)
  while(length(k) > 64)
    k <- make.raw.digest(digest(k, algo="sha1", serialize=FALSE))
  make.raw(c(k, rep(0, 64 - length(k))))
}

hmac <- function(key, object, algo=c("md5", "sha1", "crc32", "sha256"), serialize=FALSE, raw=FALSE, ...) {
  padded.key <- pad.with.zeros(key)
  i.xored.key <- xor(padded.key, make.raw(0x36))
  character.digest <- digest(c(i.xored.key, make.raw(object)), algo=algo, serialize=serialize, ...)
  raw.digest <- make.raw.digest(character.digest)
  o.xored.key <- xor(padded.key, make.raw(0x5c))
  result <- digest(c(o.xored.key, raw.digest), algo=algo, serialize=serialize, ...)
  if(raw)
    result <- make.raw.digest(result)
  return(result)
}
