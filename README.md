## digest [![Build Status](https://travis-ci.org/eddelbuettel/digest.svg)](https://travis-ci.org/eddelbuettel/digest) [![License](http://img.shields.io/badge/license-GPL2-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![Downloads](http://cranlogs.r-pkg.org/badges/digest?color=brightgreen)](http://cran.rstudio.com/package=digest)

## What

The digest package provides a function `digest()` for the 
creation of hash digests of arbitrary R objects (using the md5, sha-1, 
sha-256, crc32, xxhash and murmurhash algorithms) permitting easy comparison
of R language objects, as well as a function 'hmac()' to create hash-based
message authentication code.

Please note that this package is not meant to be deployed for 
cryptographic purposes for which more comprehensive (and widely 
tested) libraries such as OpenSSL should be used.

## Author

Dirk Eddelbuettel, with contributions by Antoine Lucas, Jarek Tuszynski,
Henrik Bengtsson, Simon Urbanek, Mario Frasca, Bryan Lewis, Murray Stokely,
Hannes Muehleisen, Duncan Murdoch, Jim Hester and Wush Wu.

## License

GPL-2

