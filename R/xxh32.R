xxh32 <- function(x, raw = TRUE, seed = 0L, ...) {
  UseMethod("xxh32")
}

xxh32.default <- function(x, raw = TRUE, seed = 0L, ...) {
  digest(x, algo = "xxhash32", raw = raw, seed = seed, ...)
}

xxh32.raw <- function(x, raw = TRUE, seed = 0L, ...) .Call(xxh32_impl, x, raw, seed)

xxh32.integer <- function(x, raw = TRUE, seed = 0L, ...) .Call(xxh32_impl, x, raw, seed)

xxh32.numeric <- function(x, raw = TRUE, seed = 0L, ...) .Call(xxh32_impl, x, raw, seed)