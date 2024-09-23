
md5 <- function(x, raw = TRUE, seed = 0L, ...) {
  UseMethod("md5")
}

md5.default <- function(x, raw = TRUE, seed = 0L, ...) {
  digest(x, algo = "md5", raw = raw, seed = seed, ...)
}

md5.raw <- function(x, raw = TRUE, seed = 0L, ...) .Call(md5_impl, x, raw, seed)

md5.integer <- function(x, raw = TRUE, seed = 0L, ...) .Call(md5_impl, x, raw, seed)

md5.numeric <- function(x, raw = TRUE, seed = 0L, ...) .Call(md5_impl, x, raw, seed)