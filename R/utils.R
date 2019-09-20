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
