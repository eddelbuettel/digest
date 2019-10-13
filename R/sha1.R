
##  sha1 -- SHA1 hash generation for R
##
##  Copyright (C) 2015 - 2019  Thierry Onkelinx and Dirk Eddelbuettel
##  Copyright (C) 2016 - 2019  Viliam Simko
##
##  This file is part of digest.
##
##  digest is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  digest is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with digest.  If not, see <http://www.gnu.org/licenses/>.


# functions written by Thierry Onkelinx
sha1 <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    UseMethod("sha1")
}

sha1.default <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    stop(  							# #nocov start
        "sha1() has no method for the '",
        paste(class(x), collapse = "', '"),
        "' class",
        call. = FALSE
    )								# #nocov end
}

sha1.integer <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    attr(x, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(x, algo = algo)
}

sha1.character <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    attr(x, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(x, algo = algo)
}

sha1.factor <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    attr(x, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(x, algo = algo)
}

sha1.NULL <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    # attributes cannot be set on a NULL object
    digest(x, algo = algo)
}

sha1.logical <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    attr(x, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(x, algo = algo)
}

sha1.numeric <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    y <- num2hex(
        x,
        digits = digits,
        zapsmall = zapsmall
    )
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}

sha1.matrix <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    # needed to make results comparable between 32-bit and 64-bit
    if (storage.mode(x) == "double") {
        y <- matrix( #return a matrix with the same dimensions as x
            apply(
                x,
                2,
                num2hex,
                digits = digits,
                zapsmall = zapsmall
            ),
            ncol = ncol(x)
        )
        attr(y, "digest::sha1") <- attr_sha1(
            x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
        )
        digest(y, algo = algo)
    } else {
        attr(x, "digest::sha1") <- attr_sha1(
            x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
        )
        digest(x, algo = algo)
    }
}

sha1.complex <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    # a vector of complex numbers is converted into 2-column matrix (Re,Im)
    y <- cbind(Re(x), Im(x))
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    sha1(y, digits = digits, zapsmall = zapsmall, ..., algo = algo)
}

sha1.Date <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    y <- as.numeric(x)
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    sha1(y, digits = digits, zapsmall = zapsmall, ..., algo = algo)
}

sha1.array <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    # Array x encoded as list of two elements:
    # 1. lengths of all dimensions of x
    # 2. all cells of x as a single vector
    y <- list(
        dimension = dim(x),
        value = as.numeric(x))
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    sha1(y, digits = digits, zapsmall = zapsmall, ..., algo = algo)
}

sha1.data.frame <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    if (length(x)) {
        # needed to make results comparable between 32-bit and 64-bit
        y <- vapply(
            x,
            sha1,
            digits = digits,
            zapsmall = zapsmall,
            ...,
            algo = algo,
            FUN.VALUE = NA_character_
        )
    } else {
        y <- x
    }
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}

sha1.list <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    if (length(x)) {
        # needed to make results comparable between 32-bit and 64-bit
        y <- vapply(
            x,
            sha1,
            digits = digits,
            zapsmall = zapsmall,
            ...,
            algo = algo,
            FUN.VALUE = NA_character_
        )
    } else {
        y <- x
    }
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(y, algo = algo)
}

sha1.POSIXlt <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    y <- do.call(
        data.frame,
        lapply(unclass(as.POSIXlt(x)), unlist)
    )
    y$sec <- num2hex(y$sec, digits = digits, zapsmall = zapsmall)
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}

sha1.POSIXct <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    y <- sha1(
        as.POSIXlt(x),
        digits = digits,
        zapsmall = zapsmall,
        ...,
        algo = algo
    )
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}

sha1.anova <- function(x, digits = 4L, zapsmall = 7L, ..., algo = "sha1"){
    if (digits > 4) {
        warning("Hash on 32 bit might be different from hash on 64 bit with digits > 4") # #nocov
    }
    y <- apply(
        x,
        1,
        num2hex,
        digits = digits,
        zapsmall = zapsmall
    )
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}

attr_sha1 <- function(x, digits, zapsmall, algo, ...) {
    if (algo == "sha1") {
        return(
            list(
                class = class(x),
                digits = as.integer(digits),
                zapsmall = as.integer(zapsmall),
                ...
            )
        )
    }
    list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        algo = algo,
        ...
    )
}

num2hex <- function(x, digits = 14L, zapsmall = 7L){
    if (!is.numeric(x)) {
        stop("x is not numeric")				# #nocov
    }
    if (!is.integer(digits)) {
        if (!all.equal(as.integer(digits), digits)) {
            stop("digits is not integer")			# #nocov
        }
        digits <- as.integer(digits)
    }
    if (length(digits) != 1) {
        stop("digits must contain exactly one integer")		# #nocov
    }
    if (digits < 1) {
        stop("digits must be positive")				# #nocov
    }
    if (!is.integer(zapsmall)) {
        if (!all.equal(as.integer(zapsmall), zapsmall)) {
            stop("zapsmall is not integer")			# #nocov
        }
        zapsmall <- as.integer(zapsmall)
    }
    if (length(zapsmall) != 1) {
        stop("zapsmall must contain exactly one integer")	# #nocov
    }
    if (zapsmall < 1) {
        stop("zapsmall must be positive")			# #nocov
    }

    if (length(x) == 0) {
        return(character(0))
    }
    x.na <- is.na(x)
    if (all(x.na)) {
        return(x)
    }
    x.inf <- is.infinite(x)
    output <- rep(NA_character_, length(x))
    output[x.inf & x > 0] <- "Inf"
    output[x.inf & x < 0] <- "-Inf"
    x.finite <- !x.na & !x.inf

    x.hex <- sprintf("%a", x[x.finite])
    exponent <- as.integer(gsub("^.*p", "", x.hex))

    # detect "small" numbers
    zapsmall.hex <- floor(log2(10 ^ -zapsmall))
    zero <- x.hex == sprintf("%a", 0) | exponent <= zapsmall.hex
    if (any(zero)) {
        output[x.finite][zero] <- "0"
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
    output[x.finite][!zero] <- paste0(negative, mantissa, " ", exponent[!zero])
    return(output)
}

sha1.pairlist <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    # needed to make results comparable between 32-bit and 64-bit
    y <- vapply(
        x,
        sha1,
        digits = digits,
        zapsmall = zapsmall,
        ...,
        algo = algo,
        FUN.VALUE = NA_character_
    )
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}

sha1.name <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    # attribute cannot be set on a name object
    digest(x, algo = algo)
}

sha1.function <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    dots <- list(...)
    if (is.null(dots$environment)) {
        dots$environment <- TRUE
    }
    if (isTRUE(dots$environment)) {
        y <- list(
            formals = formals(x),
            body = as.character(body(x)),
            environment = digest(environment(x), algo = algo)
        )
    } else {
        y <- list(
            formals = formals(x),
            body = as.character(body(x))
        )
    }
    y <- vapply(
        y,
        sha1,
        digits = digits,
        zapsmall = zapsmall,
        environment = dots$environment,
        ... = dots,
        algo = algo,
        FUN.VALUE = NA_character_
    )
    attr(y, "digest::sha1") <- attr_sha1(
        x = y, digits = digits, zapsmall = zapsmall, algo = algo, dots
    )
    digest(y, algo = algo)
}

sha1.call <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    attr(x, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(x, algo = algo)
}

sha1.raw <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1") {
    attr(x, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(x, algo = algo)
}

sha1.formula <- function(x, digits = 14L, zapsmall = 7L, ..., algo = "sha1"){
    dots <- list(...)
    if (is.null(dots$environment)) {
        dots$environment <- TRUE
    }
    y <- vapply(
        x,
        sha1,
        digits = digits,
        zapsmall = zapsmall,
        ... = dots,
        algo = algo,
        FUN.VALUE = NA_character_
    )
    if (isTRUE(dots$environment)) {
        y <- c(
            y,
            digest(environment(x), algo = algo)
        )
    }
    attr(y, "digest::sha1") <- attr_sha1(
        x = x, digits = digits, zapsmall = zapsmall, algo = algo, ...
    )
    digest(y, algo = algo)
}
