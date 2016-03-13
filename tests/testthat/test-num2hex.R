## tests for digest, taken from the examples in the manual page
context("num2hex")

# Tests ==============
test_that("zap small numbers to zero", {
    zapsmall <- 1:10
    border <- 2 ^ floor(log2(10 ^ -zapsmall))
    expect_identical(
        sapply(
            seq_along(zapsmall),
            function(i) {
                digest:::num2hex(border[i] * -1:1, digits = 6, zapsmall = zapsmall[i])
            }
        ),
        matrix(
            "0",
            ncol = length(zapsmall),
            nrow = 3
        )
    )
})

test_that("handle 0 correct", {
    expect_identical(digest:::num2hex(0), "0")
})

test_that("digits are consistent", {
    x <- pi
    x.hex <- sapply(1:16, digest:::num2hex, x = x)
    x.hex <- x.hex[c(TRUE, diff(nchar(x.hex)) > 0)]
    exponent <-  unique(gsub("^[0-9a-f]* ", "", x.hex))

    expect_identical(length(exponent), 1L)

    mantissa <- gsub(" [0-9]*$", "", x.hex)
    fun <- function(i) {
        all(
            grepl(
                paste0("^", mantissa[i], ".*"),
                tail(mantissa, -i)
            )
        )
    }

    for (m in head(seq_along(mantissa), -1)) {
        expect_true(fun(m))
    }
})

test_that("it keeps NA values", {
    x <- c(pi, NA, 0)
    expect_identical(
        is.na(digest:::num2hex(x)),
        is.na(x)
    )
    x <- c(pi, NA, pi)
    expect_identical(
        is.na(digest:::num2hex(x)),
        is.na(x)
    )
    x <- as.numeric(c(NA, NA, NA))
    expect_identical(
        is.na(digest:::num2hex(x)),
        is.na(x)
    )
})

test_that("handles empty vectors", {
    expect_identical(
        digest:::num2hex(numeric(0)),
        character(0)
    )
})

test_that("example from FAQ 7.31: tests if all trailing zero's are removed", {
    expect_identical(
        digest:::num2hex(2, digits = 14),
        digest:::num2hex(sqrt(2) ^ 2, digits = 14)
    )
    expect_false(
        identical(
            digest:::num2hex(2, digits = 15),
            digest:::num2hex(sqrt(2) ^ 2, digits = 15)
        )
    )
})
