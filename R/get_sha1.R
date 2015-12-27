sha1_digits <- function(which = c("base", "zapsmall", "coef")){
  which <- match.arg(which)
  switch(which,
    base = 14L,
    zapsmall = 7L,
    coef = 4L # coef = 5L yields differences for some lmer models
  )
}

setGeneric(
  name = "get_sha1",
  def = function(x){
    standard.generic("get_sha1")
  }
)

setMethod(
  f = "get_sha1",
  signature = "ANY",
  definition = function(x){
    digest(x, algo = "sha1")
  }
)

setMethod(
  f = "get_sha1",
  signature = "integer",
  definition = function(x){
    digest(x, algo = "sha1")
  }
)

setMethod(
  f = "get_sha1",
  signature = "anova",
  definition = function(x){
    get_sha1(
      apply(
        x,
        1,
        num_32_64,
        digits = sha1_digits("coef"),
        zapsmall = sha1_digits("zapsmall")
      )
    )
  }
)

setMethod(
  f = "get_sha1",
  signature = "factor",
  definition = function(x){
    digest(x, algo = "sha1")
  }
)

setMethod(
  f = "get_sha1",
  signature = "list",
  definition = function(x){
    digest(
      sapply(x, get_sha1),
      algo = "sha1"
    )
  }
)

setMethod(
  f = "get_sha1",
  signature = "numeric",
  definition = function(x){
    get_sha1(
      num_32_64(
        x,
        digits = sha1_digits("base"),
        zapsmall = sha1_digits("zapsmall")
      )
    )
  }
)

setMethod(
  f = "get_sha1",
  signature = "matrix",
  definition = function(x){
    # needed to make results comparable between 32-bit and 64-bit
    if (class(x[1, 1]) == "numeric") {
      get_sha1(as.vector(x))
    } else {
      digest(x, algo = "sha1")
    }
  }
)

setMethod(
  f = "get_sha1",
  signature = "data.frame",
  definition = function(x){
    # needed to make results comparable between 32-bit and 64-bit
    digest(sapply(x, get_sha1), algo = "sha1")
  }
)

num_32_64 <- function(x, digits = 6, zapsmall = 7){
  if (!is.numeric(x)) {
    stop("x is not numeric")
  }
  if (!is.integer(digits)) {
    if (!all.equal(as.integer(digits), digits)) {
      stop("digits is not integer")
    }
    digits <- as.integer(digits)
  }
  if (length(digits) != 1) {
    stop("digits must contain exactly one integer")
  }
  if (digits < 1) {
    stop("digits must be positive")
  }
  if (!is.integer(zapsmall)) {
    if (!all.equal(as.integer(zapsmall), zapsmall)) {
      stop("zapsmall is not integer")
    }
    zapsmall <- as.integer(zapsmall)
  }
  if (length(zapsmall) != 1) {
    stop("zapsmall must contain exactly one integer")
  }
  if (zapsmall < 1) {
    stop("zapsmall must be positive")
  }

  if (length(x) == 0) {
    return(character(0))
  }
  x.na <- is.na(x)
  if (all(x.na)) {
    return(x)
  }
  output <- rep(NA, length(x))

  x.hex <- sprintf("%a", x[!x.na])
  exponent <- as.integer(gsub("^.*p", "", x.hex))

  # detect "small" numbers
  zapsmall.hex <- floor(log2(10 ^ -zapsmall))
  zero <- x.hex == sprintf("%a", 0) | exponent <= zapsmall.hex
  if (any(zero)) {
    output[!x.na][zero] <- "0"
    if (all(zero)) {
      return(output)
    }
  }

  digits.hex <- ceiling(log(10 ^ digits, base = 16))
  mantissa <- x.hex[!zero] # select "large" numbers
  # select mantissa
  mantissa <- gsub(mantissa, pattern = ".*x1\\.{0,1}", replacement = "")
  # select mantissa
  mantissa <- gsub(mantissa, pattern = "p.*$", replacement = "")
  mantissa <- substring(mantissa, 1, digits.hex) # select required precision
  # remove potential trailing zero's
  mantissa <- gsub(mantissa, pattern = "0$", replacement = "")
  negative <- ifelse(grepl(x.hex[!zero], pattern = "^-"), "-", "")
  output[!x.na][!zero] <- paste0(negative, mantissa, " ", exponent[!zero])
  return(output)
}
