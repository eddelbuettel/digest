

# compute a hash-based message authentication code

[**Source code**](https://github.com/eddelbuettel/digest/tree/master/R/#L)

## Description

The <code>hmac</code> function calculates a message authentication code
(MAC) involving the specified cryptographic hash function in combination
with a given secret key.

## Usage

<pre><code class='language-R'>hmac(key, object,
     algo = c("md5", "sha1", "crc32", "sha256", "sha512"),
     serialize = FALSE, raw = FALSE, ...)
</code></pre>

## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="key">key</code>
</td>
<td>
An arbitrary character or numeric vector, to use as pre-shared secret
key.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="object">object</code>
</td>
<td>
An arbitrary R object which will then be passed to the
<code>serialize</code> function, unless the <code>serialize</code>
argument is set to <code>FALSE</code>.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="algo">algo</code>
</td>
<td>
The algorithms to be used; currently available choices are
<code>md5</code>, which is also the default, <code>sha1</code>,
<code>crc32</code> and <code>sha256</code>.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="serialize">serialize</code>
</td>
<td>
default value of <code>serialize</code> is here FALSE, not TRUE as it is
in <code>digest</code>.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="raw">raw</code>
</td>
<td>
This flag alters the type of the output. Setting this to
<code>TRUE</code> causes the function to return an object of type
<code>“raw”</code> instead of <code>“character”</code>.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="...">…</code>
</td>
<td>
All remaining arguments are passed to <code>digest</code>.
</td>
</tr>
</table>

## Value

The <code>hmac</code> function uses the <code>digest</code> to return a
hash digest as specified in the RFC 2104.

## Author(s)

Mario Frasca <a href="mailto:mfrasca@zonnet.nl">mfrasca@zonnet.nl</a>.

## References

MD5:
<a href="https://www.ietf.org/rfc/rfc1321.txt">https://www.ietf.org/rfc/rfc1321.txt</a>.

SHA-1:
<a href="https://en.wikipedia.org/wiki/SHA-1">https://en.wikipedia.org/wiki/SHA-1</a>.
SHA-256:
<a href="https://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf">https://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf</a>.
CRC32: The original reference webpage at <code>rocksoft.com</code> has
vanished from the web; see
<a href="https://en.wikipedia.org/wiki/Cyclic_redundancy_check">https://en.wikipedia.org/wiki/Cyclic_redundancy_check</a>
for general information on CRC algorithms.

The support page for the code underlying the C functions used here for
the sha-512 function is no longer accessbible, please see
<a href="https://web.mit.edu/freebsd/head/crypto/openssh/openbsd-compat/sha2.c">https://web.mit.edu/freebsd/head/crypto/openssh/openbsd-compat/sha2.c</a>
for the code and the eponymous website of Aaron Gifford, its author, for
more.

The page for the code underlying the C functions used here for sha-1 and
md5, and further references, is no longer accessible. Please see
<a href="https://en.wikipedia.org/wiki/SHA-1">https://en.wikipedia.org/wiki/SHA-1</a>
and
<a href="https://en.wikipedia.org/wiki/MD5">https://en.wikipedia.org/wiki/MD5</a>.

<a href="https://zlib.net">https://zlib.net</a> for documentation on the
zlib library which supplied the code for crc32.

<a href="https://en.wikipedia.org/wiki/SHA_hash_functions">https://en.wikipedia.org/wiki/SHA_hash_functions</a>
for documentation on the sha functions.

## See Also

<code>digest</code>

## Examples

``` r
library("digest")




# Standard RFC 2104 test vectors
current <- hmac('Jefe', 'what do ya want for nothing?', "md5")
target <- '750c783e6ab0b503eaa86e310a5db738'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0x0b, 16), 'Hi There', "md5")
target <- '9294727a3638bb1c13f48ef8158bfc9d'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0xaa, 16), rep(0xdd, 50), "md5")
target <- '56be34521d144c88dbb8c733f0e8b3f6'
stopifnot(identical(target, as.character(current)))

# SHA1 tests inspired to the RFC 2104 and checked against the python
# hmac implementation.
current <- hmac('Jefe', 'what do ya want for nothing?', "sha1")
target <- 'effcdf6ae5eb2fa2d27416d5f184df9c259a7c79'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0x0b, 16), 'Hi There', "sha1")
target <- '675b0b3a1b4ddf4e124872da6c2f632bfed957e9'
stopifnot(identical(target, as.character(current)))

current <- hmac(rep(0xaa, 16), rep(0xdd, 50), "sha1")
target <- 'd730594d167e35d5956fd8003d0db3d3f46dc7bb'
stopifnot(identical(target, as.character(current)))
```
