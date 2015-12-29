
## tests for digest, taken from the examples in the manual page

stopifnot(require(digest))

# calculate sha1 fingerprints
x.numeric <- 1.2345678901234567890123456789
x.list <- list(letters, x.numeric)
x.dataframe <- data.frame(
    X = letters,
    Y = x.numeric,
    Z = factor(letters),
    stringsAsFactors = FALSE
)
x.matrix.num <- as.matrix(x.numeric)
x.matrix.letter <- as.matrix(letters)
x.dataframe.round <- x.dataframe
x.dataframe.round$Y <- signif(x.dataframe.round$Y, 14)
x.factor <- factor(letters)

# tests using detailed numbers
stopifnot(
    !identical(x.numeric, signif(x.numeric, 14))
)
stopifnot(
    !identical(x.matrix.num, signif(x.matrix.num, 14))
)
# returns the correct SHA1
x.hex <- sprintf("%a", x.numeric)
exponent <- as.integer(gsub("^.*p", "", x.hex))
zapsmall.hex <- floor(log2(10 ^ -7))
digits.hex <- ceiling(log(10 ^ 14, base = 16))
mantissa <- gsub(".*x1\\.{0,1}", "",x.hex)
mantissa <- gsub("p.*$", "", mantissa)
mantissa <- substring(mantissa, 1, digits.hex)
mantissa <- gsub("0$", "", mantissa)
negative <- ifelse(grepl("^-", x.hex), "-", "")
stopifnot(
    identical(
        sha1(x.numeric),
        sha1(paste0(negative, mantissa, " ", exponent))
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
        sha1(as.vector(x.matrix.num))
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
    # empty vector
    logical(0), integer(0), numeric(0), character(0),
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
    "37dadeab8d8ce7611f230f9524c1e8ab751c4a6a",
    "37dadeab8d8ce7611f230f9524c1e8ab751c4a6a",
    "37dadeab8d8ce7611f230f9524c1e8ab751c4a6a",
    "ad8d56a358f1c91717e506012ea43a9b700a8d51",
    "0f0714f1142eed0701166aa2d6dcdd798c8420e6",
    "5db33863310fda479e9367aa8b69e339565fb312",
    "5db33863310fda479e9367aa8b69e339565fb312",
    "1f9928593251410322823fefea8c3ef79b4d0254",
    "c799247ef7cc5eb0a3544aa1aef1039e270579a4",
    "692ff1b9390cfc01625d8dbb850d04426e193889",
    "4a07275045c4b13d1ffa085be774343227c05f7c",
    "051deeb6fb87e61a7a5a35c80e3b8351f1531ec3",
    "3bc1c85261b958307340b7a8a9fcff3e2586516b",
    "3c23872b9b4e17b16c1d640fe3c29f251202b012",
    "0fc188b4fd874e5ea411a241feb0e247faada054",
    "188710fe63fedb3f4637db5eeb2ecdbc824aa179",
    "5c251c1a5a3113b9261ec12aaef062a994d908c8",
    "78d23c7b572a943f697584705cc9514d32269bfd",
    "25228aa01875f7c88b51c299a332c6bd82257d06",
    "51fe9849f2b30d02c73cd7870d5d9b3a19e83654",
    "c165458381d503502e811a153f262fe6a1dfa55e",
    "692ff1b9390cfc01625d8dbb850d04426e193889",
    "4a07275045c4b13d1ffa085be774343227c05f7c",
    "051deeb6fb87e61a7a5a35c80e3b8351f1531ec3",
    "3bc1c85261b958307340b7a8a9fcff3e2586516b",
    "3c23872b9b4e17b16c1d640fe3c29f251202b012",
    "0fc188b4fd874e5ea411a241feb0e247faada054",
    "5db33863310fda479e9367aa8b69e339565fb312",
    "7fb7dc4afcf762daf6636854257587a1c8e7b144",
    "653a174a607115158c524d67f96d859ea9d3a6a0",
    "1d07a67017c81f3ac4110b4c1ad953cf41fed47a",
    "a5844210ce302594bd43ed7465c67278218172c3",
    "f8d8e7894c30b7c3ab386a11a554a7dead9d398b",
    "5e7432ffb37cd554faf8536dcecc4bedfa72a1e8",
    "7655592ceb37d4f920cb2dfd9e242044d5acdf29",
    "d9c186396c5a79390758618b8358d9563029e960",
    "710ded514e2bf24f2703c031577d5b5e10c1963a",
    "00145b50b536d59ade3c6302593fc8f75db50782",
    "64347b1b92bb235b29dcc7dc781fc483179c808f",
    "c0b3c2ed33d9e88da6a73fa6956915c70ef38a20",
    "710ded514e2bf24f2703c031577d5b5e10c1963a",
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
    "44b53cab69e59d93951b81e66bb0f00a87881580",
    "6094e12d3db414c197b78ed449e78f8ab65e5fb6",
    "c2d0cf902c070f0b6d33f2b6079155461d56a2e3"
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
