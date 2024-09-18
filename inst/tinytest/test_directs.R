
## tests for raw output

suppressMessages(library(digest))

for (algo in c("md5")) {
               #"sha1", "crc32", "sha256", "sha512", "xxhash32", "xxhash64", "murmur32",
               # "spookyhash", "blake3", "crc32c",
               #"xxh3_64", "xxh3_128")) {

    tarfun <- get(algo)
    raw_jenny <- as.raw(as.integer(c(8, 6, 7, 5, 3, 0, 9)))
    # integers are 8 bytes; raws are 2 hexes = 1 bytes
    ext_jenny <- c()
    for (i in seq_along(raw_jenny)) {
      ext_jenny <- c(ext_jenny, c(raw_jenny[i], raw(7)))
    }
    tarfun(ext_jenny, leaveRaw = TRUE)
    tarfun(as.integer(c(8, 6, 7, 5, 3, 0, 9)), leaveRaw = TRUE)
    digest(raw_jenny, algo = "md5", serialize = FALSE, raw = TRUE)
    
}
