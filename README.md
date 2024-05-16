## digest: Compact hash representations of arbitrary R objects

[![ci](https://github.com/eddelbuettel/digest/workflows/ci/badge.svg)](https://github.com/eddelbuettel/digest/actions?query=workflow%3Aci)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)
[![CRAN](http://www.r-pkg.org/badges/version/digest)](https://cran.r-project.org/package=digest)
[![Dependencies](https://tinyverse.netlify.app/badge/digest)](https://cran.r-project.org/package=digest)
[![Debian package](https://img.shields.io/debian/v/r-cran-digest/sid?color=green)](https://packages.debian.org/sid/r-cran-digest)
[![r-universe](https://eddelbuettel.r-universe.dev/badges/digest)](https://eddelbuettel.r-universe.dev/digest)
[![Downloads (monthly)](http://cranlogs.r-pkg.org/badges/digest?color=brightgreen)](https://www.r-pkg.org:443/pkg/digest)
[![Downloads (total)](https://cranlogs.r-pkg.org/badges/grand-total/digest?color=brightgreen)](https://www.r-pkg.org:443/pkg/digest)
[![CRAN use](https://jangorecki.gitlab.io/rdeps/digest/CRAN_usage.svg?sanitize=true)](https://cran.r-project.org/package=digest)
[![CRAN indirect](https://jangorecki.gitlab.io/rdeps/digest/indirect_usage.svg?sanitize=true)](https://cran.r-project.org/package=digest)
[![BioConductor use](https://jangorecki.gitlab.io/rdeps/digest/BioC_usage.svg?sanitize=true)](https://cran.r-project.org/package=digest)
[![Code Coverage](https://img.shields.io/codecov/c/github/eddelbuettel/digest/master.svg)](https://app.codecov.io/gh/eddelbuettel/digest)
[![Last Commit](https://img.shields.io/github/last-commit/eddelbuettel/digest)](https://github.com/eddelbuettel/digest)
[![Documentation](https://img.shields.io/badge/documentation-is_here-blue)](https://eddelbuettel.github.io/digest/)

Compact hash representations of arbitrary R objects

### Overview

The digest package provides a principal function `digest()` for the creation
of hash digests of arbitrary R objects (using the md5, sha-1, sha-256, crc32,
xxhash, murmurhash, spookyhash, blake3, crc32c, xxh3\_64, and xxh3\_128
algorithms) permitting easy comparison of R language objects.

Extensive documentation is available at the [package documentation site](https://eddelbuettel.github.io/digest/).

#### Examples

As R can serialize any object, we can run `digest()` on any object:

```r
R> library(digest)
R> digest(trees)
[1] "12412cbfa6629c5c80029209b2717f08"
R> digest(lm(log(Height) ~ log(Girth), data=trees))
[1] "e25b62de327d079b3ccb98f3e96987b1"
R> digest(summary(lm(log(Height) ~ log(Girth), data=trees)))
[1] "86c8c979ee41a09006949e2ad95feb41"
R>
```

By using the hash sum, which is very likely to be unique, to identify an
underlying object or calculation, one can easily implement caching strategies.
This is a common use of the digest package.

#### Other Functions

A small number of additional functions is available:

- `sha1()` for numerally stable hashsums,
- `hmac()` for hashed message authentication codes based on a key,
- `AES()` for Advanced Encryption Standard block ciphers,
- `getVDigest()` as a function generator for vectorised versions.

### Note

Please note that this package is not meant to be deployed for
cryptographic purposes. More comprehensive and widely tested
libraries such as OpenSSL should be used instead.

### Installation

The package is on [CRAN](https://cran.r-project.org) and can be installed
via a standard

```r
install.packages("digest")
```

### Continued Testing

As we rely on the [tinytest](https://cran.r-project.org/package=tinytest) package, the
already-installed package can also be verified via

```r
tinytest::test_package("digest")
```

at any later point.

### Author

Dirk Eddelbuettel, with contributions by Antoine Lucas, Jarek Tuszynski,
Henrik Bengtsson, Simon Urbanek, Mario Frasca, Bryan Lewis, Murray Stokely,
Hannes Muehleisen, Duncan Murdoch, Jim Hester, Wush Wu, Qiang Kou, Thierry
Onkelinx, Michel Lang, Viliam Simko, Kurt Hornik, Radford Neal, Kendon Bell,
Matthew de Queljoe, Ion Suruceanu, Bill Denney, Dirk Schumacher, Winston
Chang, Dean Attali, and Michael Chirico.

### License

GPL (>= 2)
