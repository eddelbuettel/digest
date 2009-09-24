
# $Id: digest.R,v 1.11 2007/03/13 02:49:36 edd Exp edd $

 digest <- function(object, algo=c("md5", "sha1", "crc32", "sha256"),
                    serialize=TRUE, file=FALSE, length=Inf,
                    skip="auto", ascii=FALSE) {
   algo <- match.arg(algo)
   if (is.infinite(length)) {
     length <- -1               # internally we use -1 for infinite len
   }

   if (is.character(file) && missing(object)) {
     object <- file
     file <- TRUE
   }

   if (serialize && !file) {
     object <- serialize(object, connection=NULL, ascii=ascii)
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
     stop("Argument object must be of type character or raw vector if serialize is FALSE")
   }
   if (file && !is.character(object))
     stop("file=TRUE can only be used with a character object")
   ## HB 14 Mar 2007:  null op, only turned to char if alreadt char
   ##if (!inherits(object,"raw"))
   ##  object <- as.character(object)
   algoint <- switch(algo,
                     md5=1,
                     sha1=2,
                     crc32=3,
                     sha256=4)
   if (file) {
     algoint <- algoint+100
     object <- path.expand(object)
     if (file.access(object)<0) {
       stop(c("Can't open input file:", object))
     }
   }
   ## if skip is auto (or any other text for that matter), we just turn it
   ## into 0 because auto should have been converted into a number earlier
   ## if it was valid [SU]
   if (is.character(skip)) skip <- 0
   val <- .Call("digest",
                object,
                as.integer(algoint),
                as.integer(length),
                as.integer(skip),
                PACKAGE="digest")
   return(val)
}



