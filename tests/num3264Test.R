## tests for digest, taken from the examples in the manual page

stopifnot(require(digest))

# zap small numbers to zero
zapsmall <- 1:10
border <- 2 ^ floor(log2(10 ^ -zapsmall))
sapply(
  seq_along(zapsmall),
  function(i) {
    num_32_64(border[i] * -1:1, digits = 6, zapsmall = zapsmall[i])
  }
)
# handle 0 correct
num_32_64(0)

# digits are consistent
x <- pi
x.hex <- sapply(1:16, num_32_64, x = x)
x.hex <- x.hex[c(TRUE, diff(nchar(x.hex)) > 0)]
exponent <-  unique(gsub("^[0-9a-f]* ", "", x.hex))
length(exponent) == 1
mantissa <- gsub(" [0-9]*$", "", x.hex)
sapply(
  head(seq_along(mantissa), -1),
  function(i){
    all(grepl(paste0("^", mantissa[i], ".*"), tail(mantissa, -i)))
  }
)

#it keeps NA values
x <- c(pi, NA, 0)
is.na(num_32_64(x))
x <- c(pi, NA, pi)
is.na(num_32_64(x))
x <- as.numeric(c(NA, NA, NA))
is.na(num_32_64(x))

# handles empty vectors
num_32_64(numeric(0))
