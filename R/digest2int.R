digest2int <- function(x, seed = 0L) {
    .Call(digest2int_impl, x, as.integer(seed))
}
