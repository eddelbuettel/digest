
##  digest -- hash digest functions for R
##
##  Copyright (C) 2003 - 2018  Dirk Eddelbuettel <edd@debian.org>
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
                                  "xxhash32", "xxhash64", "murmur32", "spookyhash"),
                   serialize=TRUE,
                   file=FALSE,
                   length=Inf,
                   skip="auto",
                   ascii=FALSE,
                   raw=FALSE,
                   seed=0,
                   errormode=c("stop","warn","silent"),
                   serializeVersion=.getSerializeVersion()) {

    algo <- match.arg(algo)
    errormode <- match.arg(errormode)

    if (is.infinite(length)) {
        length <- -1               # internally we use -1 for infinite len
    }

    if (is.character(file) && missing(object)) {
        object <- file                  # nocov
        file <- TRUE                  	# nocov
    }

    streaming_algos <- c("spookyhash")
    non_streaming_algos <- c("md5", "sha1", "crc32", "sha256", "sha512",
                             "xxhash32", "xxhash64", "murmur32")
    if(algo %in% streaming_algos && !serialize){
        .errorhandler(paste0(algo, " algorithm is not available without serialization."),  # #nocov
                      mode=errormode)                                                      # #nocov
    }

    if (serialize && !file) {
        if(algo %in% non_streaming_algos){
            ## support the 'nosharing' option in pqR's base::serialize()
            object <- if ("nosharing" %in% names(formals(base::serialize)))
                base::serialize (object, connection=NULL, ascii=ascii,
                                 nosharing=TRUE, version=serializeVersion)
            else
                base::serialize (object, connection=NULL, ascii=ascii,
                                 version=serializeVersion)
        }
        ## we support raw vectors, so no mangling of 'object' is necessary
        ## regardless of R version
        ## skip="auto" - skips the serialization header [SU]
        if (any(!is.na(pmatch(skip,"auto"))))
            skip <- set_skip(object, ascii)

    } else if (!is.character(object) && !inherits(object,"raw") &&
               algo %in% non_streaming_algos) {
        return(.errorhandler(paste("Argument object must be of type character",		    # #nocov
                                   "or raw vector if serialize is FALSE"), mode=errormode)) # #nocov
    }
    if (file && !is.character(object))
        return(.errorhandler("file=TRUE can only be used with a character object",          # #nocov
                             mode=errormode))                                               # #nocov

    if (file && algo %in% streaming_algos)
        return(.errorhandler(paste0(algo, " algorithm can not be used with files."),        # #nocov
                             mode=errormode))                                               # #nocov

    ## HB 14 Mar 2007:  null op, only turned to char if alreadt char
    ##if (!inherits(object,"raw"))
    ##  object <- as.character(object)
    algoint <- algo_int(algo)
    if (file) {
        algoint <- algoint+100
        object <- path.expand(object)
        check_file(object, errormode)
    }
    ## if skip is auto (or any other text for that matter), we just turn it
    ## into 0 because auto should have been converted into a number earlier
    ## if it was valid [SU]
    if (is.character(skip)) skip <- 0
    if (algo %in% non_streaming_algos) {
        val <- .Call(digest_impl,
                     object,
                     as.integer(algoint),
                     as.integer(length),
                     as.integer(skip),
                     as.integer(raw),
                     as.integer(seed))
    } else if (algo == "spookyhash"){
        # 0s are the seeds. They are included to enable testing against fastdigest.
        val <- paste(.Call(spookydigest_impl, object, skip, 0, 0, serializeVersion), collapse="")
    }

    ## crc32 output was not guaranteed to be eight chars long, which we corrected
    ## this allows to get the old behaviour back for compatibility
    if ((algoint == 3 || algoint == 103) && .getCRC32PreferOldOutput()) {
        val <- sub("^0+", "", val)
    }

    return(val)
}
