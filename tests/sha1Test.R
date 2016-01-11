
## tests for digest, taken from the examples in the manual page

stopifnot(require(digest))

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

# tests using detailed numbers
stopifnot(
    !identical(x.numeric, signif(x.numeric, 14))
)
stopifnot(
    !identical(x.matrix.num, signif(x.matrix.num, 14))
)
# returns the correct SHA1
stopifnot(
    identical(
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
)
stopifnot(
    identical(
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
)
stopifnot(
    identical(
        sha1(x.list),
        sha1(sapply(x.list, sha1))
    )
)
stopifnot(
    identical(
        sha1(x.dataframe),
        sha1(sapply(x.dataframe, sha1))
    )
)
stopifnot(
    identical(
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
)
stopifnot(
    identical(
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
)
stopifnot(
    identical(
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
)
# a matrix and a vector should have a different hash
stopifnot(
    !identical(
        sha1(x.numeric),
        sha1(matrix(x.numeric, nrow = 1))
    )
)
stopifnot(
    !identical(
        sha1(x.numeric),
        sha1(matrix(x.numeric, ncol = 1))
    )
)
stopifnot(
    !identical(
        sha1(letters),
        sha1(matrix(letters, nrow = 1))
    )
)
stopifnot(
    !identical(
        sha1(letters),
        sha1(matrix(letters, ncol = 1))
    )
)
# character(0) and numeric(0) should have a different hash
stopifnot(!identical(sha1(character(0)), sha1(numeric(0))))

# a POSIXct and a POSIXlt should give a different hash
z <- as.POSIXct("2015-01-02 03:04:06.07", tz = "UTC")
stopifnot(
    !identical(
        sha1(z),
        sha1(as.POSIXlt(z))
    )
)

lm.model.0 <- lm(weight ~ Time, data = ChickWeight)
lm.model.1 <- lm(weight ~ 1, data = ChickWeight)
glm.model.0 <- glm(weight ~ Time, data = ChickWeight, family = poisson)
glm.model.1 <- glm(weight ~ 1, data = ChickWeight, family = poisson)

anova.list <- list(
    lm = anova(lm.model.0, lm.model.1),
    glm = anova(glm.model.0, glm.model.1),
    glm.test = anova(glm.model.0, glm.model.1, test = "Chisq")
)

# works with lm anova"
z <- apply(
    anova.list[["lm"]],
    1,
    sha1,
    digits = 4,
    zapsmall = 7
)
stopifnot(
    identical(
        sha1(anova.list[["lm"]]),
        sha1(z)
    )
)
# works with glm anova"
z <- apply(
    anova.list[["glm"]],
    1,
    sha1,
    digits = 4,
    zapsmall = 7
)
stopifnot(
    identical(
        sha1(anova.list[["glm"]]),
        sha1(z)
    )
)
z <- apply(
    anova.list[["glm.test"]],
    1,
    sha1,
    digits = 4,
    zapsmall = 7
)
stopifnot(
    identical(
        sha1(anova.list[["glm.test"]]),
        sha1(z)
    )
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
    expand.grid(test.element[select.vector]),
    # add a list
    list(test.element[select.vector]),
    # add matrices
    matrix(1:10),
    matrix(seq(0, 10, length = 4)),
    matrix(letters),
    anova.list
)

cat("\ncorrect <- c(\n")
cat(
    sprintf("    \"%s\"", sapply(test.element, sha1)),
    sep = ",\n"
)
cat(")\n")

correct <- c(
    "8d9c05ec7ae28b219c4c56edbce6a721bd68af82",
    "d61eeea290dd09c5a3eba41c2b3174b6e4e2366d",
    "af23305d27f0409c91bdb86ba7c0cdb2e09a5dc6",
    "0c9ca70ce773deb0d9c0b0579c3b94856edf15cc",
    "095886422ad26e315c0960ef6b09842a1f9cc0ce",
    "106782e8c6c23661bc1fa86ac9cd727b477048e9",
    "d62218750fee5637dd59d08760866b83a7b01f69",
    "6e12370bdc6fc457cc154f0525e22c6aa6439f4d",
    "1c1b5393c68a643bc79c277c6d7374d0b30cd985",
    "b48c17a2ac82601ff38df374f87d76005fb61cbd",
    "35280c99aa6a48bfc2810b72b763ccac0f632207",
    "f757cc017308d217f35ed8f0c001a57b97308fb7",
    "599afff6b1a527c0ed04d67c736c426eaa3a1621",
    "a14384d1997440bad13b97b3ccfb3b8c0392e79a",
    "555f6bea49e58a2c2541060a21c2d4f9078c3086",
    "631d18dec342e2cb87614864ba525ebb9ad6a124",
    "b6c04f16b6fdacc794ea75c8c8dd210f99fafa65",
    "25485ba7e315956267b3fdc521b421bbb046325d",
    "2f239d17c9ca78234438cf35225efc6c26fad77a",
    "c789f0b3f2763f0800c2c796b010065431daabac",
    "13329ad5f9b9eb888a459fcb647af13de2556264",
    "756adc804296e4958495bd2fd5f0041b42258baa",
    "b866fbdd8897985ef296b23505c761b0e696dcb4",
    "ea06b32e9e6be66ec41e9ced7feae40555f996f3",
    "19bd9c8c9d8483c40856523875c4fb1f0712b7a6",
    "c75905bca0580a76ca38298317f4d3ed5ba39b99",
    "b48c17a2ac82601ff38df374f87d76005fb61cbd",
    "ad120a31f018cd9c8bc346f74217c3607fe8d79e",
    "24b4f80eedfbae5f0b618988f91468b4a13e45c9",
    "80eb128686c6c7a105b76a869e3d1542bc9cb375",
    "604a21e4a67bf4f4ad78389ad27c409c920347b4",
    "9ffdf9ee8a3e2b06c1bd1287af3d99733ba86d4f",
    "e8dc46f2034fc7cfa265acdce5680bff4ec8f511",
    "e23b7044b78b27b754463994599f3cd4a3dc37d9",
    "ced5b5edc6790416001ea737ff90adbd118decc6",
    "2e36adef4c5c9770866c0682f5a315124025bd4a",
    "4dceb033392f1431e512309aea2d71dca45238de",
    "521d4357e85a96a2a362ab9c0266455ad5aae320",
    "fa8e7870a11993c9984e945954957ebb52aaccf3",
    "3336ce1683797d5962285c3e163cb1901551c09c",
    "f757cc017308d217f35ed8f0c001a57b97308fb7",
    "3e1494ebbe9e46e7a7a20f97ae75425d07d9666d",
    "2c41f4729ccf7aa8e0d9df4c0aa72988a379b9c1",
    "d868bc69bc7de3e014170df981d5501bf84698eb",
    "9510a86a4aa4c4143b56a6e0209c4d9f35a01af5",
    "5e4e36b2ba897df66ac7b66ff0248be7823f5e11",
    "8585df8ab8324cf3c697887875fd140fe4624623",
    "bd9a241464c18148ecb98994e70f9b824cb1d434",
    "e4e8b5ab602cb4e43fbacf93f47f791b27466df7",
    "8b85007cdc832b180c05dc78ce801b72dfd00624",
    "1fb57235443e930b6df8e2f780ddc2d14f33fb65",
    "bb105fa2e00e726713364cf3c989abb096cafa85",
    "ac3000ea35cc3e2e57e9bd3fc8684719ff1f9f56",
    "870298a5b8ec8e0edb0145a98924be0ee0ee26f6",
    "32e8a5c1285347cca90f9dc9cc398a19546a6ae0",
    "60b1a18fab0bb491ab770731a38ab591c60508f2",
    "a7dbd237d071614101abb8eebc8277b6601cfc10",
    "03b14425fadf4f87f4b9265186ad5f9d467af1a0",
    "c1f066eedac34516b90193298df3a33634e8cef0",
    "268502a865572a2d3d4aab7fe004edc4139f0ab8",
    "1aaad777fb4f4028ea40371e5fdbf56dc2370c98",
    "c778d06f3c07911c488d0b37bfca39a1d1b98098",
    "c891bd7e66c34380d417ec9da622170e1bce61c6",
    "1bb9ef6afbc59d2b9fdbd338ace9e069276e40bf",
    "73d7cce35845fefad4cff4532927a8ac667d7331",
    "cca83666279e0be4ab93aea03119e7014b926a3f",
    "e5e4b2938c08223c825458ccc8552b7d28725189",
    "f1f15993d7d67bd2d5de97bd5c3e1de79b999fa3",
    "a01a454daabc389bbf08215581f4ecf787562010"
)
# returns the same SHA1 on both 32-bit and 64-bit OS"
for (i in seq_along(test.element)) {
    stopifnot(
        identical(
            sha1(test.element[[i]]),
            correct[i]
        )
    )
}

# calculates the SHA1 of a list as the SHA1 of a vector of SHA1 of each element
this.list <- list("a", "b")
stopifnot(
    identical(
        sha1(this.list),
        sha1(sapply(this.list, sha1))
    )
)
this.list <- list(letters, this.list)
stopifnot(
    identical(
        sha1(this.list),
        sha1(sapply(this.list, sha1))
    )
)

# does work with empty lists and data.frames
stopifnot(is.character(sha1(list())))
stopifnot(is.character(sha1(data.frame())))
stopifnot(is.character(sha1(list(a = 1, b = list(), c = data.frame()))))

# test error message
junk <- pi
class(junk) <- c("A", "B")
error.message <- try(sha1(junk))
stopifnot(
    grepl("sha1\\(\\) has not method for the 'A', 'B' class", error.message)
)
