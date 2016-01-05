# functions written by Thierry Onkelinx
sha1 <- function(x, digits = 14, zapsmall = 7){
    UseMethod("sha1")
}

sha1.default <- function(x, digits = 14, zapsmall = 7) {
    stop("sha1() has not method for the '", class(x), "' class")
}

sha1.integer <- function(x, digits = 14, zapsmall = 7) {
    digest(x, algo = "sha1")
}

sha1.character <- function(x, digits = 14, zapsmall = 7) {
    digest(x, algo = "sha1")
}

sha1.factor <- function(x, digits = 14, zapsmall = 7) {
    digest(x, algo = "sha1")
}

sha1.NULL <- function(x, digits = 14, zapsmall = 7) {
    digest(x, algo = "sha1")
}

sha1.logical <- function(x, digits = 14, zapsmall = 7) {
    digest(x, algo = "sha1")
}

sha1.numeric <- function(x, digits = 14, zapsmall = 7){
    digest(
        num2hex(
            x,
            digits = digits,
            zapsmall = zapsmall
        ),
        algo = "sha1"
    )
}

sha1.matrix <- function(x, digits = 14, zapsmall = 7){
    # needed to make results comparable between 32-bit and 64-bit
    if (class(x[1, 1]) == "numeric") {
        digest(
            matrix( #return a matrix with the same dimensions as x
                apply(
                    x,
                    2,
                    num2hex,
                    digits = digits,
                    zapsmall = zapsmall
                ),
                ncol = ncol(x)
            ),
            algo = "sha1"
        )
    } else {
        digest(x, algo = "sha1")
    }
}

sha1.data.frame <- function(x, digits = 14, zapsmall = 7){
    # needed to make results comparable between 32-bit and 64-bit
    sha1(
        sapply(x, sha1, digits = digits, zapsmall = zapsmall)
    )
}

sha1.list <- function(x, digits = 14, zapsmall = 7){
    sha1(
        sapply(x, sha1, digits = digits, zapsmall = zapsmall)
    )
}

sha1.POSIXlt <- function(x, digits = 14, zapsmall = 7) {
    sha1(
        do.call(
            data.frame,
            lapply(as.POSIXlt(x), unlist)
        ),
        digits = digits,
        zapsmall = zapsmall
    )
}

sha1.POSIXct <- function(x, digits = 14, zapsmall = 7) {
    sha1(
        list(
            x = as.POSIXlt(x),
            class = "POSIXct"
        ),
        digits = digits,
        zapsmall = zapsmall
    )
}

sha1.anova <- function(x, digits = 4, zapsmall = 7){
    if (digits > 4) {
        warning(
            "Hash on 32 bit might be different from hash on 64 bit with digits > 4"
        )
    }
    sha1(
        apply(
            x,
            1,
            sha1,
            digits = digits,
            zapsmall = zapsmall
        )
    )
}

num2hex <- function(x, digits = 14, zapsmall = 7){
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
  mantissa <- gsub(mantissa, pattern = "0*$", replacement = "")
  negative <- ifelse(grepl(x.hex[!zero], pattern = "^-"), "-", "")
  output[!x.na][!zero] <- paste0(negative, mantissa, " ", exponent[!zero])
  return(output)
}
