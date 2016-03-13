
##  digest -- hash digest functions for R
##
##  Copyright (C) 2003 - 2015  Dirk Eddelbuettel <edd@debian.org>
##
##  This file is part of digest.
##
##  digest is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  digest is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with digest.  If not, see <http://www.gnu.org/licenses/>.

#' Create hash function digests for arbitrary R objects
#'
#' The \code{digest} function applies a cryptographical hash function to
#' arbitrary R objects. By default, the objects are internally serialized, and
#' either one of the currently implemented MD5 and SHA-1 hash functions
#' algorithms can be used to compute a compact digest of the serialized object.
#'
#' In order to compare this implementation with others, serialization of the
#' input argument can also be turned off in which the input argument must be a
#' character string for which its digest is returned.
#'
#' @param object An arbitrary R object which will then be passed to the
#'   \code{\link{serialize}} function, unless the \code{serialize} argument is
#'   set to \code{FALSE}.
#' @param algo The algorithms to be used; currently available choices are
#'   \code{md5}, which is also the default, \code{sha1}, \code{crc32},
#'   \code{sha256}, \code{sha512}, \code{xxhash32}, \code{xxhash64} and
#'   \code{murmur32}.
#' @param serialize A logical variable indicating whether the object should be
#'   serialized using \code{serialize} (in ASCII form). Setting this to
#'   \code{FALSE} allows to compare the digest output of given character strings
#'   to known control output. It also allows the use of raw vectors such as the
#'   output of non-ASCII serialization.
#' @param file A logical variable indicating whether the object is a file name
#'   or a file name if \code{object} is not specified.
#' @param length Number of characters to process. By default, when \code{length}
#'   is set to \code{Inf}, the whole string or file is processed.
#' @param skip Number of input bytes to skip before calculating the digest.
#'   Negative values are invalid and currently treated as zero. Special value
#'   \code{"auto"} will cause serialization header to be skipped if
#'   \code{serialize} is set to \code{TRUE} (the serialization header contains
#'   the R version number thus skipping it allows the comparison of hashes
#'   across platforms and some R versions).
#' @param ascii This flag is passed to the \code{serialize} function if
#'   \code{serialize} is set to \code{TRUE}, determining whether the hash is
#'   computed on the ASCII or binary representation.
#' @param raw A logical variable with a default value of FALSE, implying
#'   \code{digest} returns digest output as ASCII hex values. Set to TRUE to
#'   return \code{digest} output in raw (binary) form.
#' @param seed an integer to seed the random number generator.  This is only
#'   used in the \code{xxhash32}, \code{xxhash64} and \code{murmur32} functions
#'   and can be used to generate additional hashes for the same input if
#'   desired.
#' @param errormode A character value denoting a choice for the behaviour in the
#'   case of error: \sQuote{stop} aborts (and is the default value),
#'   \sQuote{warn} emits a warning and returns \code{NULL} and \sQuote{silent}
#'   suppresses the error and returns an empty string.
#'
#' @return
#'   The \code{digest} function returns a character string of a fixed length
#'   containing the requested digest of the supplied R object. This string is of
#'   length 32 for MD5; of length 40 for SHA-1; of length 8 for CRC32 a string;
#'   of length 8 for for xxhash32; of length 16 for xxhash64; and of length 8
#'   for murmur32.
#'
#' @details
#'   Cryptographic hash functions are well researched and documented. The MD5
#'   algorithm by Ron Rivest is specified in RFC 1321. The SHA-1 algorithm is
#'   specified in FIPS-180-1, SHA-2 is described in FIPS-180-2.
#'
#'   For md5, sha-1 and sha-256, this R implementation relies on standalone
#'   implementations in C by Christophe Devine. For crc32, code from the zlib
#'   library by Jean-loup Gailly and Mark Adler is used.
#'
#'   For sha-512, a standalone implementation from Aaron Gifford is used.
#'
#'   For xxhash32 and xxhash64, the reference implementation by Yann Collet is
#'   used.
#'
#'   For murmur32, the progressive implementation by Shane Day is used.
#'
#'   Please note that this package is not meant to be used for cryptographic
#'   purposes for which more comprehensive (and widely tested) libraries such as
#'   OpenSSL should be used. Also, it is known that crc32 is not
#'   collision-proof. For sha-1, recent results indicate certain cryptographic
#'   weaknesses as well. For more details, see for example
#'   \url{http://www.schneier.com/blog/archives/2005/02/cryptanalysis_o.html}.
#'
#' @references
#'   MD5: \url{http://www.ietf.org/rfc/rfc1321.txt}.
#'
#'   SHA-1: \url{http://www.itl.nist.gov/fipspubs/fip180-1.htm}. SHA-256:
#'   \url{http://csrc.nist.gov/publications/fips/fips180-2/fips180-2withchangenotice.pdf}.
#'   CRC32:  The original reference webpage at \code{rocksoft.com} has vanished
#'   from the web; see
#'   \url{https://en.wikipedia.org/wiki/Cyclic_redundancy_check} for general
#'   information on CRC algorithms.
#'
#'   \url{http://www.aarongifford.com/computers/sha.html} for the integrated C
#'   implementation of sha-512.
#'
#'   The page for the code underlying the C functions used here for sha-1 and
#'   md5, and further references, is no longer accessible.  Please see
#'   \url{https://en.wikipedia.org/wiki/SHA-1} and
#'   \url{https://en.wikipedia.org/wiki/MD5}.
#'
#'   \url{http://zlib.net} for documentation on the zlib library which supplied
#'   the code for crc32.
#'
#'   \url{http://en.wikipedia.org/wiki/SHA_hash_functions} for documentation on
#'   the sha functions.
#'
#'   \url{https://code.google.com/p/xxhash/} for documentation on the xxHash
#'   functions.
#'
#'   \url{https://code.google.com/p/smhasher/} for documentation on MurmurHash.
#'
#' @author Dirk Eddelbuettel \email{edd@debian.org} for the \R interface;
#'   Antoine Lucas for the integration of crc32; Jarek Tuszynski for the
#'   file-based operations; Henrik Bengtsson and Simon Urbanek for improved
#'   serialization patches; Christophe Devine for the hash function
#'   implementations for sha-1, sha-256 and md5; Jean-loup Gailly and Mark Adler
#'   for crc32; Hannes Muehleisen for the integration of sha-512; Jim Hester for
#'   the integration of xxhash32, xxhash64 and murmur32.
#'
#' @seealso \code{\link{serialize}}, \code{\link{md5sum}}
#' @example vignettes/example-digest.R
#' @keywords misc
#' @export
#' @useDynLib digest, digest_impl=digest
digest <- function(object, algo = c("md5", "sha1", "crc32", "sha256", "sha512",
                                    "xxhash32", "xxhash64", "murmur32"),
                   serialize = TRUE, file = FALSE, length = Inf,
                   skip = "auto", ascii = FALSE, raw = FALSE, seed = 0,
                   errormode = c("stop","warn","silent")) {

    algo <- match.arg(algo)
    errormode <- match.arg(errormode)

    .errorhandler <- function(txt, obj = "", mode = "stop") {
        if (mode == "stop") {
            stop(txt, obj, call. = FALSE)
        } else if (mode == "warn") {
            warning(txt, obj, call. = FALSE)
            return(invisible(NA))
        } else {
            return(invisible(NULL))
        }
    }

    if (is.infinite(length)) {
        length <- -1               # internally we use -1 for infinite len
    }

    if (is.character(file) && missing(object)) {
        object <- file
        file <- TRUE
    }

    if (serialize && !file) {
        object <- serialize(object, connection = NULL, ascii = ascii)
        ## we support raw vectors, so no mangling of 'object' is necessary
        ## regardless of R version
        ## skip="auto" - skips the serialization header [SU]
        if (any(!is.na(pmatch(skip,"auto")))) {
            if (ascii) {
                ## HB 14 Mar 2007:
                ## Exclude serialization header (non-data dependent bytes but R
                ## version specific).  In ASCII, the header consists of for rows
                ## ending with a newline ('\n').  We need to skip these.
                ## The end of 4th row is *typically* within the first 18 bytes
                skip <- which(object[1:30] == as.raw(10))[4]
            } else {
                skip <- 14
            }
            ## Was: skip <- if (ascii) 18 else 14
        }
    } else if (!is.character(object) && !inherits(object,"raw")) {
        return(.errorhandler(paste("Argument object must be of type character",
                                   "or raw vector if serialize is FALSE"),
                             mode = errormode))
    }

    if (file && !is.character(object)) {
        return(.errorhandler(
            "file=TRUE can only be used with a character object",
            mode = errormode))
    }

    ## HB 14 Mar 2007:  null op, only turned to char if alreadt char
    ##if (!inherits(object,"raw"))
    ##  object <- as.character(object)
    algoint <- switch(algo,
                      md5 = 1,
                      sha1 = 2,
                      crc32 = 3,
                      sha256 = 4,
                      sha512 = 5,
                      xxhash32 = 6,
                      xxhash64 = 7,
                      murmur32 = 8)
    if (file) {
        algoint <- algoint + 100
        object <- path.expand(object)
        if (!file.exists(object)) {
            return(.errorhandler("The file does not exist: ",
                                 object, mode = errormode))
        }
        if (!isTRUE(!file.info(object)$isdir)) {
            return(.errorhandler("The specified pathname is not a file: ",
                                 object, mode = errormode))
        }
        if (file.access(object, 4)) {
            return(.errorhandler("The specified file is not readable: ",
                                 object, mode = errormode))
        }
    }
    ## if skip is auto (or any other text for that matter), we just turn it
    ## into 0 because auto should have been converted into a number earlier
    ## if it was valid [SU]
    if (is.character(skip)) skip <- 0
    val <- .Call(digest_impl,
                 object,
                 as.integer(algoint),
                 as.integer(length),
                 as.integer(skip),
                 as.integer(raw),
                 as.integer(seed))
    return(val)
}
