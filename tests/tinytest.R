
if (requireNamespace("tinytest", quietly=TRUE)) {

    ## Set a seed to make the test deterministic
    set.seed(42)

    ## there are several more granular ways to test files in a
    ## tinytest directory, see its package vignette; tests can also
    ## run once the package is installed using the same command

    ## we need version 0.9.3 or later
    if (packageVersion("tinytest") >= "0.9.3") {
        ## expect_length is in tinytest 1.4.1
        if (!"expect_length" %in% getNamespaceExports("tinytest")) {
            expect_length <- function(x, n) tinytest::expect_equal(length(x), n)
        }
        tinytest::test_package("digest")
    }
}
