
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

