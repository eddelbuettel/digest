## tests for digest, taken from the examples in the manual page
context("sha1")

# Setup ==============

# calculate sha1 fingerprints
x.numeric <- seq(0, 1, length = 4 ^ 3)
x.list <- list(letters, x.numeric)
x.dataframe <- data.frame(
    X = letters,
    Y = x.numeric[2],
    Z = factor(letters),
    stringsAsFactors = FALSE
)
x.matrix.num <- as.matrix(x.numeric)
x.matrix.letter <- as.matrix(letters)
x.dataframe.round <- x.dataframe
x.dataframe.round$Y <- signif(x.dataframe.round$Y, 14)
x.factor <- factor(letters)
x.array.num <- as.array(x.numeric)

lm.model.0 <- lm(weight ~ Time, data = ChickWeight)
lm.model.1 <- lm(weight ~ 1, data = ChickWeight)
glm.model.0 <- glm(weight ~ Time, data = ChickWeight, family = poisson)
glm.model.1 <- glm(weight ~ 1, data = ChickWeight, family = poisson)

anova.list <- list(
    lm = anova(lm.model.0, lm.model.1),
    glm = anova(glm.model.0, glm.model.1),
    glm.test = anova(glm.model.0, glm.model.1, test = "Chisq")
)

test.element <- list(
    # NULL
    NULL,
    # empty classes
    logical(0), integer(0), numeric(0), character(0), list(), data.frame(),
    # scalar
    TRUE, FALSE, 1L, 1, "a",
    # date. Make sure to add the time zone. Otherwise the test might fail
    as.POSIXct("2015-01-02 03:04:06.07", tz = "UTC"),
    # vector
    c(TRUE, FALSE), 1:3, seq(0, 10, length = 4), letters[1:3],
    factor(letters[4:6]),
    as.POSIXct(c("2015-01-02 03:04:06.07", "1960-12-31 23:59:59"), tz = "UTC")
)
select.vector <- which(sapply(test.element, length) > 1)
test.element <- c(
    test.element,
    # add a data.frame
    list(expand.grid(test.element[select.vector])),
    # add a list
    list(test.element[select.vector]),
    # add matrices
    list(matrix(1:10)),
    list(matrix(seq(0, 10, length = 4))),
    list(matrix(letters))
)

# Tests ==============

test_that("tests using detailed numbers", {
    expect_equal(x.numeric, signif(x.numeric, 14))
    expect_false(identical(x.numeric, signif(x.numeric, 14)))
    expect_false(identical(x.matrix.num, signif(x.matrix.num, 14)))
})

test_that("returns the correct SHA1",{
    expect_identical(
        sha1(x.numeric),
        {
            z <- digest:::num2hex(x.numeric)
            attr(z, "digest::sha1") <- list(
                class = class(x.numeric),
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )

    expect_identical(
        sha1(letters),
        {
            z <- letters
            attr(z, "digest::sha1") <- list(
                class = "character",
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )

    expect_identical(
        sha1(x.list),
        {
            z <- sapply(x.list, sha1)
            attr(z, "digest::sha1") <- list(
                class = "list",
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )
    expect_identical(
        sha1(x.dataframe),
        {
            z <- sapply(x.dataframe, sha1)
            attr(z, "digest::sha1") <- list(
                class = "data.frame",
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )
    expect_identical(
        sha1(x.matrix.num),
        {
            z <- matrix(
                apply(x.matrix.num, 2, digest:::num2hex),
                ncol = ncol(x.matrix.num)
            )
            attr(z, "digest::sha1") <- list(
                class = "matrix",
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )
    expect_identical(
        sha1(x.matrix.letter),
        {
            z <- x.matrix.letter
            attr(z, "digest::sha1") <- list(
                class = "matrix",
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )
    expect_identical(
        sha1(x.factor),
        {
            z <- x.factor
            attr(z, "digest::sha1") <- list(
                class = "factor",
                digits = 14L,
                zapsmall = 7L
            )
            digest(z, algo = "sha1")
        }
    )
})

test_that("a matrix and a vector should have a different hash", {
    expect_false(
        identical(
            sha1(x.numeric),
            sha1(matrix(x.numeric, nrow = 1))
        )
    )
    expect_false(
        identical(
            sha1(x.numeric),
            sha1(matrix(x.numeric, ncol = 1))
        )
    )
    expect_false(
        identical(
            sha1(letters),
            sha1(matrix(letters, nrow = 1))
        )
    )
    expect_false(
        identical(
            sha1(letters),
            sha1(matrix(letters, ncol = 1))
        )
    )
})

test_that("character(0) and numeric(0) should have a different hash", {
    expect_false(identical(sha1(character(0)), sha1(numeric(0))))
})

test_that("a POSIXct and a POSIXlt should give a different hash", {
    z <- as.POSIXct("2015-01-02 03:04:06.07", tz = "UTC")
    expect_false(
        identical(
            sha1(z),
            sha1(as.POSIXlt(z))
        )
    )
})

test_that("works with lm anova", {
    expect_identical(
        sha1(anova.list[["lm"]]),
        {
            y <- apply(
                anova.list[["lm"]],
                1,
                digest:::num2hex,
                digits = 4,
                zapsmall = 7
            )
            attr(y, "digest::sha1") <- list(
                class = c("anova", "data.frame"),
                digits = 4L,
                zapsmall = 7L
            )
            digest(y, algo = "sha1")
        }
    )
})

test_that("works with glm anova", {

    expect_identical(
        sha1(anova.list[["glm"]]),
        {
            y <- apply(
                anova.list[["glm"]],
                1,
                digest:::num2hex,
                digits = 4,
                zapsmall = 7
            )
            attr(y, "digest::sha1") <- list(
                class = c("anova", "data.frame"),
                digits = 4L,
                zapsmall = 7L
            )
            digest(y, algo = "sha1")
        }
    )

    expect_identical(
        sha1(anova.list[["glm.test"]]),
        {
            y <- apply(
                anova.list[["glm.test"]],
                1,
                digest:::num2hex,
                digits = 4,
                zapsmall = 7
            )
            attr(y, "digest::sha1") <- list(
                class = c("anova", "data.frame"),
                digits = 4L,
                zapsmall = 7L
            )
            digest(y, algo = "sha1")
        }
    )
})

test_that("different values for digits or zapsmall gives different hashes", {
    expect_identical(
        sha1(NULL, digits = 14),
        sha1(NULL, digits = 13)
    )
    expect_identical(
        sha1(NULL, zapsmall = 14),
        sha1(NULL, zapsmall = 13)
    )
})

test_that("some elements", {
    for (i in tail(seq_along(test.element), -1)) {
        expect_false(
            identical(
                sha1(test.element[[i]], digits = 14),
                sha1(test.element[[i]], digits = 13)
            )
        )
        expect_false(
            identical(
                sha1(test.element[[i]], zapsmall = 7),
                sha1(test.element[[i]], zapsmall = 6)
            )
        )
    }
})

test_that("each object should yield a different hash", {
    test.element <- c(test.element, anova.list)
    sapply(test.element, sha1)
    correct <- c(
        "8d9c05ec7ae28b219c4c56edbce6a721bd68af82",
        "d61eeea290dd09c5a3eba41c2b3174b6e4e2366d",
        "af23305d27f0409c91bdb86ba7c0cdb2e09a5dc6",
        "0c9ca70ce773deb0d9c0b0579c3b94856edf15cc",
        "095886422ad26e315c0960ef6b09842a1f9cc0ce",
        "6cc04c6c432bb91e210efe0b25c6ca809e6df2e3",
        "c1113ba008a349de64da2a7a724e501c1eb3929b",
        "6e12370bdc6fc457cc154f0525e22c6aa6439f4d",
        "1c1b5393c68a643bc79c277c6d7374d0b30cd985",
        "b48c17a2ac82601ff38df374f87d76005fb61cbd",
        "35280c99aa6a48bfc2810b72b763ccac0f632207",
        "f757cc017308d217f35ed8f0c001a57b97308fb7",
        "cfcf101b8449af67d34cdc1bcb0432fe9e4de08e",
        "a14384d1997440bad13b97b3ccfb3b8c0392e79a",
        "555f6bea49e58a2c2541060a21c2d4f9078c3086",
        "631d18dec342e2cb87614864ba525ebb9ad6a124",
        "b6c04f16b6fdacc794ea75c8c8dd210f99fafa65",
        "25485ba7e315956267b3fdc521b421bbb046325d",
        "6def3ca353dfc1a904bddd00e6a410d41ac7ab01",
        "cf220bcf84c3d0ab1b01f8f764396941d15ff20f",
        "2af8021b838f613aee7670bed19d0ddf1d6bc0c1",
        "270ed85d46524a59e3274d89a1bbf693521cb6af",
        "60e09482f12fda20f7d4a70e379c969c5a73f512",
        "10380001af2a541b5feefc7aab9f719b67330a42",
        "4580ff07f27eb8321421efac1676a80d9239572a",
        "d3022c5a223caaf77e9c564e024199e5d6f51bd5",
        "f54742ac61edd8c3980354620816c762b524dfc7"
    )

    expect_false(any(duplicated(correct)))

    # returns the same SHA1 on both 32-bit and 64-bit OS
    for (i in seq_along(test.element)) {
        expect_identical(sha1(test.element[[i]]),
                         correct[i])
    }
})

test_that("test error message", {
    junk <- pi
    class(junk) <- c("A", "B")

    expect_error(sha1(junk),
                 regexp = "sha1\\(\\) has not method for the 'A', 'B' class")
})
