
getVDigest <- function(algo = c("md5", "sha1", "crc32", "sha256", "sha512",
                                 "xxhash32", "xxhash64", "murmur32", "spookyhash"),
                        errormode=c("stop","warn","silent")){
    algo <- match.arg(algo)
    errormode <- match.arg(errormode)
    algoint <- algo_int(algo)
    non_streaming_algos <- c("md5", "sha1", "crc32", "sha256", "sha512",
                             "xxhash32", "xxhash64", "murmur32")
    if (algo %in% non_streaming_algos)
        return(non_streaming_digest(algo, errormode, algoint))
    streaming_digest(algo, errormode, algoint)
}

non_streaming_digest <- function(algo, errormode, algoint){
    function(object,
             serialize=TRUE,
             file=FALSE,
             length=Inf,
             skip="auto",
             ascii=FALSE,
             seed=0,
             serializeVersion=.getSerializeVersion()){

        if (is.infinite(length))
            length <- -1               # internally we use -1 for infinite len

        if (is.character(file) && missing(object)) {
            object <- file                  # nocov
            file <- TRUE                  	# nocov
        }

        if (serialize && !file) {
            ## support the 'nosharing' option in pqR's base::serialize()
            object <- if ("nosharing" %in% names(formals(base::serialize)))
                serialize_(
                    object,
                    connection = NULL,
                    ascii = ascii,
                    nosharing = TRUE,
                    version = serializeVersion
                )
            else
                serialize_(object,
                           connection = NULL,
                           ascii = ascii,
                           version = serializeVersion)
            ## we support raw vectors, so no mangling of 'object' is necessary
            ## regardless of R version
            ## skip="auto" - skips the serialization header [SU]
            if (any(!is.na(pmatch(skip,"auto"))))
                skip <- set_skip(object, ascii)

        } else if (!is.character(object) && !inherits(object,"raw")) {
            return(.errorhandler(paste("Argument object must be of type character",	  # #nocov
                                       "or raw vector if serialize is FALSE"), mode=errormode)) # #nocov
        }
        if (file && !is.character(object))
            return(.errorhandler("file=TRUE can only be used with a character object",          # #nocov
                                 mode=errormode))                                               # #nocov

        if (file) {
            algoint <- algoint+100
            object <- path.expand(object)
            check_file(object, errormode)
        }
        ## if skip is auto (or any other text for that matter), we just turn it
        ## into 0 because auto should have been converted into a number earlier
        ## if it was valid [SU]
        if (is.character(skip)) skip <- 0
        val <- .Call(
            vdigest_impl,
            object,
            as.integer(algoint),
            as.integer(length),
            as.integer(skip),
            0L, # raw always FALSE
            as.integer(seed)
        )
        ## crc32 output was not guaranteed to be eight chars long, which we corrected
        ## this allows to get the old behaviour back for compatibility
        if ((algoint == 3 || algoint == 103) && .getCRC32PreferOldOutput()) {
            val <- sub("^0+", "", val)                                          		# #nocov
        }

        return(val)
    }
}

streaming_digest <- function(algo, errormode, algoint){
    function(object,
             serialize=TRUE,
             file=FALSE,
             length=Inf,
             skip="auto",
             ascii=FALSE,
             seed=0,
             serializeVersion=.getSerializeVersion()){

        if (is.infinite(length))
            length <- -1               # internally we use -1 for infinite len

        if (is.character(file) && missing(object)) {
            object <- file                  # nocov
            file <- TRUE                  	# nocov
        }

        if (!serialize){
            .errorhandler(paste0(algo, " algorithm is not available without serialization."),  # #nocov
                          mode=errormode)                                                      # #nocov
        }

        if (serialize && !file) {
            ## we support raw vectors, so no mangling of 'object' is necessary
            ## regardless of R version
            ## skip="auto" - skips the serialization header [SU]
            if (any(!is.na(pmatch(skip,"auto"))))
                skip <- set_skip(object, ascii)
        }

        if (file)
            return(.errorhandler(paste0(algo, " algorithm can not be used with files."),        # #nocov
                                 mode=errormode))                                               # #nocov


        ## if skip is auto (or any other text for that matter), we just turn it
        ## into 0 because auto should have been converted into a number earlier
        ## if it was valid [SU]
        if (is.character(skip)) skip <- 0                                          		# #nocov
        if (algo == "spookyhash"){
            # 0s are the seeds. They are included to enable testing against fastdigest.
            val <- vapply(object,
                          function(o)
                              paste(
                                  .Call(spookydigest_impl, o, skip, 0, 0, serializeVersion),
                                  collapse = ""
                              ),
                          character(1),
                          USE.NAMES = FALSE)
        }

        ## crc32 output was not guaranteed to be eight chars long, which we corrected
        ## this allows to get the old behaviour back for compatibility
        if ((algoint == 3 || algoint == 103) && .getCRC32PreferOldOutput()) {
            val <- sub("^0+", "", val)                                          		# #nocov
        }

        return(val)
    }
}

serialize_ <- function(object, ...){
    if (length(object))
        return(lapply(object, base::serialize, ...))
    base::serialize(object, ...)
}

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

algo_int <- function(algo)
    switch(
        algo,
        md5 = 1,
        sha1 = 2,
        crc32 = 3,
        sha256 = 4,
        sha512 = 5,
        xxhash32 = 6,
        xxhash64 = 7,
        murmur32 = 8,
        spookyhash = 9
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
