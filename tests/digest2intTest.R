stopifnot(require(digest))

input <- letters[1:5]
hashed_seed_0 <- c(-902917054L, 14385563L, -289776295L, 592496261L, 286663184L)
stopifnot(identical(digest2int(input), hashed_seed_0))

hashed_seed_1 <- c(14385563L, -289776295L, 592496261L, 286663184L, 1208324078L)
stopifnot(identical(digest2int(input, 1L), hashed_seed_1))
