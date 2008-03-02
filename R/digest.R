
# $Id$

digest <- function(object, algo="md5", serialize=TRUE) {
  if (serialize)
    object <- serialize(object, NULL, TRUE) # turns object into ascii string
  else if (!is.character(object)) 
    stop("Argument object must be of type character if serialize is FALSE")

  if (is.character(algo)) {
    algoint <- switch(algo,
                      md5=1,
                      sha1=2)
    val <- .Call("digest",
                 as.character(object),
                 as.integer(algoint),
                 PACKAGE="digest")
    return(val)
  } else {
    error("The algo argument must be of type character")
  }
}


