# functions written by Thierry Onkelinx
sha1 <- function(x, digits = 14L, zapsmall = 7L, ...){
    UseMethod("sha1")
}

sha1.default <- function(x, digits = 14L, zapsmall = 7L, ...) {
    stop(
        "sha1() has not method for the '",
        paste(class(x), collapse = "', '"),
        "' class",
        call. = FALSE
    )
}

sha1.integer <- function(x, digits = 14L, zapsmall = 7L, ...) {
    attr(x, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(x, algo = "sha1")
}

sha1.character <- function(x, digits = 14L, zapsmall = 7L, ...) {
    attr(x, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(x, algo = "sha1")
}

sha1.factor <- function(x, digits = 14L, zapsmall = 7L, ...) {
    attr(x, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(x, algo = "sha1")
}

sha1.NULL <- function(x, digits = 14L, zapsmall = 7L, ...) {
    # attributes cannot be set on a NULL object
    digest(x, algo = "sha1")
}

sha1.logical <- function(x, digits = 14L, zapsmall = 7L, ...) {
    attr(x, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(x, algo = "sha1")
}

sha1.numeric <- function(x, digits = 14L, zapsmall = 7L, ...){
    y <- num2hex(
        x,
        digits = digits,
        zapsmall = zapsmall
    )
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(y, algo = "sha1")
}

sha1.matrix <- function(x, digits = 14L, zapsmall = 7L, ...){
    # needed to make results comparable between 32-bit and 64-bit
    if (class(x[1, 1]) == "numeric") {
        y <- matrix( #return a matrix with the same dimensions as x
            apply(
                x,
                2,
                num2hex,
                digits = digits,
                zapsmall = zapsmall,
                ... = ...
            ),
            ncol = ncol(x)
        )
        attr(y, "digest::sha1") <- list(
            class = class(x),
            digits = as.integer(digits),
            zapsmall = as.integer(zapsmall),
            ... = ...
        )
        digest(y, algo = "sha1")
    } else {
        attr(x, "digest::sha1") <- list(
            class = class(x),
            digits = as.integer(digits),
            zapsmall = as.integer(zapsmall),
            ... = ...
        )
        digest(x, algo = "sha1")
    }
}

sha1.complex <- function(x, digits = 14L, zapsmall = 7L, ...) {
    # a vector of complex numbers is converted into 2-column matrix (Re,Im)
    y <- cbind(Re(x), Im(x))
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    sha1(y, digits = digits, zapsmall = zapsmall, ...)
}

sha1.Date <- function(x, digits = 14L, zapsmall = 7L, ...) {
    y <- as.numeric(x)
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    sha1(y, digits = digits, zapsmall = zapsmall, ...)
}

sha1.array <- function(x, digits = 14L, zapsmall = 7L, ...) {
    # Array x encoded as list of two elements:
    # 1. lengths of all dimensions of x
    # 2. all cells of x as a single vector
    y <- list(
        dimension = dim(x),
        value = as.numeric(x))
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    sha1(y, digits = digits, zapsmall = zapsmall, ...)
}

sha1.data.frame <- function(x, digits = 14L, zapsmall = 7L, ...){
    if (length(x)) {
        # needed to make results comparable between 32-bit and 64-bit
        y <- vapply(
            x,
            sha1,
            digits = digits,
            zapsmall = zapsmall,
            ... = ...,
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
    digest(y, algo = "sha1")
}

sha1.list <- function(x, digits = 14L, zapsmall = 7L, ...){
    if (length(x)) {
        # needed to make results comparable between 32-bit and 64-bit
        y <- vapply(
            x,
            sha1,
            digits = digits,
            zapsmall = zapsmall,
            ... = ...,
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
    digest(y, algo = "sha1")
}

sha1.POSIXlt <- function(x, digits = 14L, zapsmall = 7L, ...) {
    y <- do.call(
        data.frame,
        lapply(as.POSIXlt(x), unlist)
    )
    y$sec <- num2hex(y$sec, digits = digits, zapsmall = zapsmall)
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(y, algo = "sha1")
}

sha1.POSIXct <- function(x, digits = 14L, zapsmall = 7L, ...) {
    y <- sha1(as.POSIXlt(x), digits = digits, zapsmall = zapsmall, ... = ...)
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(y, algo = "sha1")
}

sha1.anova <- function(x, digits = 4L, zapsmall = 7L, ...){
    if (digits > 4) {
        warning("Hash on 32 bit might be different from hash on 64 bit with digits > 4") # #nocov
    }
    y <- apply(
        x,
        1,
        num2hex,
        digits = digits,
        zapsmall = zapsmall,
        ... = ...
    )
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(y, algo = "sha1")
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

sha1.pairlist <- function(x, digits = 14L, zapsmall = 7L, ...) {
    # needed to make results comparable between 32-bit and 64-bit
    y <- vapply(
        x,
        sha1,
        digits = digits,
        zapsmall = zapsmall,
        ... = ...,
        FUN.VALUE = NA_character_
    )
    attr(y, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(y, algo = "sha1")
}

sha1.name <- function(x, digits = 14L, zapsmall = 7L, ...) {
    # attribute cannot be set on a name object
    digest(x, algo = "sha1")
}

sha1.function <- function(x, digits = 14L, zapsmall = 7L, ...){
    dots <- list(...)
    if (is.null(dots$environment)) {
        dots$environment <- TRUE
    }
    if (isTRUE(dots$environment)) {
        y <- list(
            formals = formals(x),
            body = as.character(body(x)),
            environment = digest(environment(x), algo = "sha1")
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
        FUN.VALUE = NA_character_
    )
    attr(y, "digest::sha1") <- list(
        class = class(y),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        dots
    )
    digest(y, algo = "sha1")
}

sha1.call <- function(x, digits = 14L, zapsmall = 7L, ...){
    attr(x, "digest::sha1") <- list(
        class = class(x),
        digits = as.integer(digits),
        zapsmall = as.integer(zapsmall),
        ... = ...
    )
    digest(x, algo = "sha1")
}
