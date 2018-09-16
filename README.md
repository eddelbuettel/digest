## digest [![Build Status](https://travis-ci.org/eddelbuettel/digest.svg)](https://travis-ci.org/eddelbuettel/digest) [![License](http://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![CRAN](http://www.r-pkg.org/badges/version/digest)](https://cran.r-project.org/package=digest) [![Downloads](http://cranlogs.r-pkg.org/badges/digest?color=brightgreen)](http://www.r-pkg.org/pkg/digest) [![Code Coverage](https://img.shields.io/codecov/c/github/eddelbuettel/digest/master.svg)](https://codecov.io/gh/eddelbuettel/digest)

Compact hash representations of arbitrary R objects

### Overview

The digest package provides a principal function `digest()` for the 
creation of hash digests of arbitrary R objects (using the md5, sha-1, 
sha-256, crc32, xxhash and murmurhash algorithms) permitting easy comparison
of R language objects.

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
underlying object or calculation, one can easily caching strategies for which
the digest package is somewhat widely used.

#### Other Functions

A small number of additional functions is available:

- `sha1()` for numerally stable hashsums,
- `hmac()` for hashed message authentication codes based on a key,
- `AES()` for Advanced Encryption Standard block ciphers.

### Note

Please note that this package is not meant to be deployed for 
cryptographic purposes for which more comprehensive (and widely 
tested) libraries such as OpenSSL should be used.

### Author

Dirk Eddelbuettel, with contributions by Antoine Lucas, Jarek Tuszynski,
Henrik Bengtsson, Simon Urbanek, Mario Frasca, Bryan Lewis, Murray Stokely,
Hannes Muehleisen, Duncan Murdoch, Jim Hester, Wush Wu, Qiang Kou, Thierry
Onkelinx, Michel Lang, Viliam Simko, Kurt Hornik and Radford Neal.

### License

GPL (>= 2)

