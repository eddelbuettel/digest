
md5 <- function(x, leaveRaw = TRUE, ...) {
  UseMethod("md5")
}

md5.default <- function(x, leaveRaw, ...) {
  digest(x, algo = "md5", ...)
}

md5.raw <- function(x, leaveRaw) .Call(md5_impl, x, leaveRaw)

md5.integer <- function(x, leaveRaw) .Call(md5_impl, x, leaveRaw)