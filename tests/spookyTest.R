
## tests for digest spooky

stopifnot(require(digest))
# Not sure if this is really bad practice. what's the best way to include a package that's just for testing?
if (!require("fastdigest")) install.packages("fastdigest", repos = "https://cran.rstudio.com")

## test vectors (originally for md5)
spookyInput <-
    c("",
      "a",
      "abc",
      "message digest",
      "abcdefghijklmnopqrstuvwxyz",
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
      paste("12345678901234567890123456789012345678901234567890123456789012",
            "345678901234567890", sep=""))

spookyOutputSkip30 <-
  c(
    '1909f56bfc062723c751e8b465ee728b',
    'bdc9bba09181101a922a4161f0584275',
    '67c93775f715ab8ab01178caf86713c6',
    '9630c2a55c0987a0db44434f9d67a192',
    '5172de938ce149a98f4d06d3c3168ffe',
    'b5b3b2d0f08b58aa07f551895f929f81',
    '3621ec01112dafa1610a4bd23041966b'
  )

## spooky raw output test
for (i in seq(along.with=spookyInput)) {
    # skip = 30 skips the entire serialization header for a length 1 character vector
    # this is equivalent to raw = TRUE and matches the python spooky implementation for those vectors
    spooky <- digest(spookyInput[i], algo = "spookyhash", skip = 30)
    stopifnot(identical(spooky, spookyOutputSkip30[i]))
    cat(spooky, "\n")
}

## compare spooky algorithm to fastdigest
for (i in seq(along.with=spookyInput)) {
    # skip = 0 includes the entire serialization header for a length 1 character vector (this is a bug in fastdigest, I believe)
    # A failing test here might be due to a fix of this in fastdigest
    # fastdigest also currently uses the system default serialization version which is
    if(as.double(R.Version()$major) > 3 | as.double(R.Version()$major) == 3 & as.double(R.Version()$minor) >= 6){
      spooky <- paste(.Call(digest:::spookydigest_impl, spookyInput[i], 0, 100000.0, 9872143234.0, 3, NULL), collapse = "")
    } else {
      spooky <- paste(.Call(digest:::spookydigest_impl, spookyInput[i], 0, 100000.0, 9872143234.0, 2, NULL), collapse = "")
    }
    stopifnot(identical(spooky, fastdigest::fastdigest(spookyInput[i])))
    cat(spooky, "\n")
}
