
# $Id: digest.R,v 1.4 2005/11/03 05:00:48 edd Exp $

 digest <- function(object, algo=c("md5", "sha1", "crc32"), 
                    serialize=TRUE, file=FALSE, length=Inf) {
  algo = match.arg(algo)
  if (is.infinite(length))
    length=-1;                          # internally we use -1 for infinite len
  if (serialize && !file)
    object <- serialize(object, NULL, TRUE) # turns object into ascii string
  else if (!is.character(object)) 
    stop("Argument object must be of type character if serialize is FALSE")

  object = as.character(object)
  algoint <- switch(algo,
                    md5=1,
                    sha1=2,
                    crc32=3)
  if (file) {
    algoint = algoint+100;
    if (file.access(object)<0)
      stop(c("Can't open input file:", object))
  }
  val <- .Call("digest",
               as.character(object),
               as.integer(algoint),
               as.integer(length),
               PACKAGE="digest")
  return(val)
}



