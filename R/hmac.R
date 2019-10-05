
##  hmac -- Hash-based message authentication code for R
##
##  Copyright (C) 2011 - 2019  Mario Frasca and Dirk Eddelbuettel
##  Copyright (C) 2012 - 2019  Hannes Muehleisen and Dirk Eddelbuettel
##
##  This file is part of digest.
##
##  digest is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  digest is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with digest.  If not, see <http://www.gnu.org/licenses/>.

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
    if (algo == "crc32") blocksize <- 4			  # #nocov
    if (algo == "sha512") blocksize <- 128
    k <- makeRaw(k)
    if(length(k) > blocksize) {# not while()
        k <-digest(k, algo=algo, serialize=FALSE,raw=TRUE)
        if (algo == "crc32") {
            k <- substring(k, seq(1,7,2), seq(2,8,2))  	  # #nocov
            k <- makeRaw(strtoi(k,16))                    # #nocov
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
    if (raw) result <- makeRaw.digest(result)
    return(result)
}
