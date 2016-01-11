
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
        digest(c(class = "numeric", digest:::num2hex(x.numeric)), algo = "sha1")
    )
)
stopifnot(
    identical(
        sha1(letters),
        digest(letters, algo = "sha1")
    )
)
stopifnot(
    identical(
        sha1(x.list),
        digest(
            sapply(x.list, sha1),
            algo = "sha1"
        )
    )
)
stopifnot(
    identical(
        sha1(x.dataframe),
        digest(sapply(x.dataframe, sha1), algo = "sha1")
    )
)
stopifnot(
    identical(
        sha1(x.matrix.num),
        digest(
            matrix(
                apply(x.matrix.num, 2, digest:::num2hex),
                ncol = ncol(x.matrix.num)
            ),
            algo = "sha1"
        )
    )
)
stopifnot(
    identical(
        sha1(x.matrix.letter),
        digest(x.matrix.letter, algo = "sha1")
    )
)
stopifnot(
    identical(
        sha1(x.factor),
        digest(x.factor, algo = "sha1")
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
    test.element[select.vector],
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
    "0df9019fab513592066cc292d412b9054575d844",
    "f374b4a83af21bb028483fd33dfa811aca7abb96",
    "aab32679863f96be701bd786181883ddbcdbe331",
    "37dadeab8d8ce7611f230f9524c1e8ab751c4a6a",
    "106782e8c6c23661bc1fa86ac9cd727b477048e9",
    "d62218750fee5637dd59d08760866b83a7b01f69",
    "ad8d56a358f1c91717e506012ea43a9b700a8d51",
    "0f0714f1142eed0701166aa2d6dcdd798c8420e6",
    "49731da30df853ee8959035e3e309df129ad5348",
    "479a3ed1def01887df9f1b1343b6c7fc4c8b5e54",
    "1f9928593251410322823fefea8c3ef79b4d0254",
    "75d14c9556ddf556ff9f33e40a1d3f30ff678f4a",
    "692ff1b9390cfc01625d8dbb850d04426e193889",
    "f4403adc0f5e5e270450150646a7ad0652783047",
    "57a31c611a21e5ea549979c179889bc656c22d38",
    "3bc1c85261b958307340b7a8a9fcff3e2586516b",
    "3c23872b9b4e17b16c1d640fe3c29f251202b012",
    "4e0c523ee2f077c6ef4b98962efa75913558b226",
    "188710fe63fedb3f4637db5eeb2ecdbc824aa179",
    "f3863e2ce42f3507b0d65b013b70c84804e246ef",
    "b80d70d237e29439e4b3c030506309e0c7b6e2fc",
    "25228aa01875f7c88b51c299a332c6bd82257d06",
    "51fe9849f2b30d02c73cd7870d5d9b3a19e83654",
    "abe4f955c61ad38a026b4541ca34690bc6c10109",
    "692ff1b9390cfc01625d8dbb850d04426e193889",
    "f4403adc0f5e5e270450150646a7ad0652783047",
    "57a31c611a21e5ea549979c179889bc656c22d38",
    "3bc1c85261b958307340b7a8a9fcff3e2586516b",
    "3c23872b9b4e17b16c1d640fe3c29f251202b012",
    "4e0c523ee2f077c6ef4b98962efa75913558b226",
    "49731da30df853ee8959035e3e309df129ad5348",
    "d1fafdecb299e9f16ba224ecb4a0601fd31859f5",
    "cac51e723748aae54d21b79b40b48f9000f5e90e",
    "91619e26fbae8cd58c353ee18689728c0c87d002",
    "53371b092b9b535e58350b4a8078417c9a2419a1",
    "19a58a3f233de56000e1a1f66ef538904cf3bebe",
    "20864973f3a271ea8b27e2c75face8663d1a900c",
    "980927373c7acbe1cf33fa98f653927da59f70b6",
    "f5c3d80ad7d3253be3309ec910508a6e56c2f178",
    "8c420b12a14e1ed1f348fee29e864544147c8796",
    "2bb87174a86b9d91245f644833075adea1629688",
    "25da8f8c0616f5a4a358c8796880b60b0dde554e",
    "3acded8f82d10418afdf622455bf128e4eb43f68",
    "51c5a4b954fd3bb48e01cd1e251636e753ba257f",
    "1f9928593251410322823fefea8c3ef79b4d0254",
    "ee6e7fdb03a0d35b3a6f499d0f8f610686551d51",
    "8e7f9fe32c49050c5ca146150fc58b93fbeea245",
    "e59165f73b7dc7e0d6ae94ec9aac9e8e95fd8a2c",
    "7f608bde8f0e308aa8866d737ddebbfae9674163",
    "86e99e22d003547538a5f446165488f7861fa2c3",
    "ce27dce0e84ad90d3e90e9b571a73720d0fb4890",
    "221799200137b7d72dfc4a618465bec71333a58b",
    "13b5c7533cccc95d2f7cd18df78ea78ed9111c02",
    "88b7c7c5f6921ec9e914488067552829a17a42a4",
    "6127e4cdbf02f18898554c037f0d4acb95c608ab",
    "984ca0fd9ed47ac08a31aeb88f9c9a5f905aeaa2",
    "954da0ea9a5d0aa42516beebc5542c638161934c",
    "7d1e34387808d9f726efbb1c8eb0819a115afb52",
    "2e21764867596d832896d9d28d6e6489a0b27249",
    "666881f1f74c498e0292ccf3d9d26089ee79dae7",
    "966dbbe6cf1c43ac784a8257b57896db9fd3f357",
    "4ab40e0c23010553e9e4c058ef58f50088f9e87c",
    "bfa0e51b33ebd3b9a823368b7e4c357b2b98790b",
    "fc1ba0a4718421f0050cc5e159703838f733aa59",
    "25cce9eca8abedab78a765b49e74fba77f4463d4",
    "9d453f3128cb2fd55684b979a11d47c97f12dc87",
    "d612108f47c8accbeffd2d9d54c1fa7f74fb432d",
    "ef60fa66262167e7a31398b16fa762151c6d1b28",
    "a235e3cc7109def777a99e660b9829cea48ce9a4",
    "d19d82f849bad81a39da932d3087a60c78de82c1",
    "dae859199c1d5675f0fae4979577a36b69a69b33",
    "c3f7861de715b263e876ae768daabcae34fb2eb9",
    "86903d2ce8429a414b5168fb8faecffd08835a96"
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

stopifnot(!identical(sha1(character(0)), sha1(numeric(0))))

# test error message
junk <- pi
class(junk) <- c("A", "B")
error.message <- try(sha1(junk))
stopifnot(
    grepl("sha1\\(\\) has not method for the 'A', 'B' class", error.message)
)
