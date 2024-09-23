
## tests for raw output

suppressMessages(library(digest))

for (algo in c("md5", "xxhash32")) {
    jennys <- as.raw(as.integer(c(8,6,7,5,3,0,9)))
    direct <- list(md5 = md5, xxhash32 = xxh32)[[algo]]
    print(microbenchmark::microbenchmark(
      digest = digest(jennys, serialize = FALSE, raw = TRUE, algo = algo),
      direct = direct(jennys),
      check = "equal", times = 1e3
    ))
}
