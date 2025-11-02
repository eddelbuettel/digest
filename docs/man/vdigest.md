

# Set a vectorised function for creating hash function digests

## Description

The <code>getVDigest</code> function extends <code>digest</code> by
allowing one to set a function that returns hash summaries as a
character vector of the same length as the input. It also provides a
performance advantage when repeated calls are necessary (e.g. applying a
hash function repeatedly to an object). The returned function contains
the same arguments as <code>digest</code> with the exception of the
<code>raw</code> argument (see <code>digest</code> for more details).

## Usage

<pre><code class='language-R'>getVDigest(algo=c("md5", "sha1", "crc32", "sha256", "sha512", "xxhash32",
                  "xxhash64", "murmur32", "spookyhash", "blake3", "crc32c",
                  "xxh3_64", "xxh3_128"),
             errormode=c("stop","warn","silent"))
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="algo">algo</code>
</td>
<td>
The algorithms to be used; currently available choices are
<code>md5</code>, which is also the default, <code>sha1</code>,
<code>crc32</code>, <code>sha256</code>, <code>sha512</code>,
<code>xxhash32</code>, <code>xxhash64</code>, <code>murmur32</code>,
<code>spookyhash</code>, <code>blake3</code>, <code>crc32c</code>,
<code>xxh3_64</code>, and <code>xxh3_128</code>.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="errormode">errormode</code>
</td>
<td>
A character value denoting a choice for the behaviour in the case of
error: ‘stop’ aborts (and is the default value), ‘warn’ emits a warning
and returns <code>NULL</code> and ‘silent’ suppresses the error and
returns an empty string.
</td>
</tr>
</table>

## Details

Note that since one hash summary will be returned for each element
passed as input, care must be taken when determining whether or not to
include the data structure as part of the object. For instance, to
return the equivalent output of <code>digest(list(“a”))</code> it would
be necessary to wrap the list object itself
<code>getVDigest()(list(list(“a”)))</code>

## Value

The <code>getVDigest</code> function returns a function for a given
algorithm and error-mode.

## See Also

<code>digest</code>, <code>serialize</code>, <code>md5sum</code>

## Examples

``` r
library("digest")

stretch_key <- function(d, n) {
    md5 <- getVDigest()
    for (i in seq_len(n))
        d <- md5(d, serialize = FALSE)
    d
}
stretch_key('abc123', 65e3)
```

    [1] "342092becf80e5bbd7cb80f013b9abc8"

``` r
sha1 <- getVDigest(algo = 'sha1')
sha1(letters)
```

     [1] "1f9928593251410322823fefea8c3ef79b4d0254" "ee6e7fdb03a0d35b3a6f499d0f8f610686551d51" "8e7f9fe32c49050c5ca146150fc58b93fbeea245" "e59165f73b7dc7e0d6ae94ec9aac9e8e95fd8a2c"
     [5] "7f608bde8f0e308aa8866d737ddebbfae9674163" "86e99e22d003547538a5f446165488f7861fa2c3" "ce27dce0e84ad90d3e90e9b571a73720d0fb4890" "221799200137b7d72dfc4a618465bec71333a58b"
     [9] "13b5c7533cccc95d2f7cd18df78ea78ed9111c02" "88b7c7c5f6921ec9e914488067552829a17a42a4" "6127e4cdbf02f18898554c037f0d4acb95c608ab" "984ca0fd9ed47ac08a31aeb88f9c9a5f905aeaa2"
    [13] "954da0ea9a5d0aa42516beebc5542c638161934c" "7d1e34387808d9f726efbb1c8eb0819a115afb52" "2e21764867596d832896d9d28d6e6489a0b27249" "666881f1f74c498e0292ccf3d9d26089ee79dae7"
    [17] "966dbbe6cf1c43ac784a8257b57896db9fd3f357" "4ab40e0c23010553e9e4c058ef58f50088f9e87c" "bfa0e51b33ebd3b9a823368b7e4c357b2b98790b" "fc1ba0a4718421f0050cc5e159703838f733aa59"
    [21] "25cce9eca8abedab78a765b49e74fba77f4463d4" "9d453f3128cb2fd55684b979a11d47c97f12dc87" "d612108f47c8accbeffd2d9d54c1fa7f74fb432d" "ef60fa66262167e7a31398b16fa762151c6d1b28"
    [25] "a235e3cc7109def777a99e660b9829cea48ce9a4" "d19d82f849bad81a39da932d3087a60c78de82c1"

``` r
md5Input <-
    c("",
      "a",
      "abc",
      "message digest",
      "abcdefghijklmnopqrstuvwxyz",
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
      paste("12345678901234567890123456789012345678901234567890123456789012",
            "345678901234567890", sep=""))
md5Output <-
    c("d41d8cd98f00b204e9800998ecf8427e",
      "0cc175b9c0f1b6a831c399e269772661",
      "900150983cd24fb0d6963f7d28e17f72",
      "f96b697d7cb7938d525a2f31aaf161d0",
      "c3fcd3d76192e4007dfb496cca67e13b",
      "d174ab98d277d9f5a5611c2c9f419d9f",
      "57edf4a22be3c955ac49da2e2107b67a")

md5 <- getVDigest()
stopifnot(identical(md5(md5Input, serialize = FALSE), md5Output))
stopifnot(identical(digest(list("abc")),
                 md5(list(list("abc")))))

sha512Input <-c(
    "",
    "The quick brown fox jumps over the lazy dog."
    )
sha512Output <- c(
    paste0("cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce",
           "47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"),
    paste0("91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bb",
           "c6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed")
    )

sha512 <- getVDigest(algo = 'sha512')
stopifnot(identical(sha512(sha512Input, serialize = FALSE), sha512Output))
```
