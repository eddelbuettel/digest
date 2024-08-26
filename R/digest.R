
##  digest -- hash digest functions for R
##
##  Copyright (C) 2003 - 2024  Dirk Eddelbuettel <edd@debian.org>
##  Copyright (C) 2009 - 2019  Henrik Bengtsson
##  Copyright (C) 2012 - 2019  Hannes Muehleisen
##  Copyright (C) 2014 - 2019  Jim Hester
##  Copyright (C) 2019         Kendon Bell
##  Copyright (C) 2019         Matthew de Queljoe
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

digest <- function(object, algo=c("md5", "sha1", "crc32", "sha256", "sha512",
                                  "xxhash32", "xxhash64", "murmur32",
                                  "spookyhash", "blake3", "crc32c",
                                  "xxh3_64", "xxh3_128"),
                   serialize=TRUE,
                   file=FALSE,
                   length=Inf,
                   skip="auto",
                   ascii=FALSE,
                   raw=FALSE,
                   seed=0,
                   errormode=c("stop","warn","silent"),
                   serializeVersion=.getSerializeVersion()) {

    algoint <- algo_int[[algo[1]]]
    errormode <- match.arg(errormode, c("stop", "warn", "silent"))

    if (is.null(algoint)) {
        return(.errorhandler(paste0("Did not understand algo=", algo[1]), mode=errormode))  # #nocov
    }
    
    if (is.infinite(length)) {
        length <- -1               # internally we use -1 for infinite len
    }

    if (is.character(file) && missing(object)) {
        object <- file                  # nocov
        file <- TRUE                  	# nocov
    }

    is_streaming_algo <- algoint == 9L

    if (is_streaming_algo && !serialize) {
        return(.errorhandler(paste0(algo[1], " algorithm is not available without serialization."),  # #nocov
                      mode=errormode))                                                      # #nocov
    }

    if (serialize && !file) {
        if (!is_streaming_algo) {
            ## support the 'nosharing' option in pqR's serialize()
            object <- if (.hasNoSharing())
                serialize (object, connection=NULL, ascii=ascii,
                           nosharing=TRUE, version=serializeVersion)
            else
                serialize (object, connection=NULL, ascii=ascii,
                           version=serializeVersion)
        }
        ## we support raw vectors, so no mangling of 'object' is necessary
        ## regardless of R version
        ## skip="auto" - skips the serialization header [SU]
        if (is.character(skip) && skip == "auto")
            skip <- set_skip(object, ascii)

    } else if (!is.character(object) && !inherits(object,"raw") &&
               !is_streaming_algo) {
        return(.errorhandler(paste("Argument object must be of type character",		    # #nocov
                                   "or raw vector if serialize is FALSE"), mode=errormode)) # #nocov
    }
    if (file && !is.character(object))
        return(.errorhandler("file=TRUE can only be used with a character object",          # #nocov
                             mode=errormode))                                               # #nocov

    if (file && is_streaming_algo)
        return(.errorhandler(paste0(algo[1], " algorithm can not be used with files."),        # #nocov
                             mode=errormode))                                               # #nocov

    ## HB 14 Mar 2007:  null op, only turned to char if alreadt char
    ##if (!inherits(object,"raw"))
    ##  object <- as.character(object)
    if (file) {
        algoint <- algoint+100L
        object <- path.expand(object)
        if (.isWindows()) object <- enc2utf8(object)
        check_file(object, errormode)
    }
    ## if skip is auto (or any other text for that matter), we just turn it
    ## into 0 because auto should have been converted into a number earlier
    ## if it was valid [SU]
    if (is.character(skip)) skip <- 0
    if (!is_streaming_algo) {
        val <- .Call(digest_impl,
                     object,
                     algoint,
                     as.integer(length),
                     as.integer(skip),
                     as.integer(raw),
                     as.integer(seed))
    } else if (algoint == 9L){
        # 0s are the seeds. They are included to enable testing against fastdigest.
        val <- paste(.Call(spookydigest_impl, object, skip, 0, 0, serializeVersion, NULL), collapse="")
    }

    ## crc32 output was not guaranteed to be eight chars long, which we corrected
    ## this allows to get the old behaviour back for compatibility
    if ((algoint == 3 || algoint == 103) && .getCRC32PreferOldOutput()) {
        val <- sub("^0+", "", val)
    }

    return(val)
}

## utility functions used by digest() and  getVDigest() below

.errorhandler <- function(txt, obj="", mode="stop") {
    if (mode == "stop") {                                                                # nocov start
        stop(txt, obj, call.=FALSE)
    } else if (mode == "warn") {
        warning(txt, obj, call.=FALSE)
        return(invisible(NA))
    } else {
        return(invisible(NULL))                                                          # nocov end
    }
}

algo_int <- list(
    md5 = 1L,
    sha1 = 2L,
    crc32 = 3L,
    sha256 = 4L,
    sha512 = 5L,
    xxhash32 = 6L,
    xxhash64 = 7L,
    murmur32 = 8L,
    spookyhash = 9L,
    blake3 = 10L,
    crc32c = 11L,
    xxh3_64 = 12L,
    xxh3_128 = 13L
)

## HB 14 Mar 2007:
## Exclude serialization header (non-data dependent bytes but R
## version specific).  In ASCII, the header consists of for rows
## ending with a newline ('\n').  We need to skip these.
## The end of 4th row is *typically* within the first 18 bytes
set_skip <- function(object, ascii){
    if (!ascii)
        return(14)
    ## Was: skip <- if (ascii) 18 else 14
    which(object[1:30] == as.raw(10))[4]         					# nocov
}

check_file <- function(object, errormode){
    if (!file.exists(object)) {
        return(.errorhandler("The file does not exist: ", object, mode=errormode)) 	# nocov start
    }
    if (!isTRUE(!file.info(object)$isdir)) {
        return(.errorhandler("The specified pathname is not a file: ",
                             object, mode=errormode))
    }
    if (file.access(object, 4)) {
        return(.errorhandler("The specified file is not readable: ",
                             object, mode=errormode))                  			# #nocov end
    }
}
