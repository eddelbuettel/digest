
# $Id: digest.R,v 1.9 2007/03/09 03:53:56 edd Exp $

 digest <- function(object, algo=c("md5", "sha1", "crc32"), 
                    serialize=TRUE, file=FALSE, length=Inf, skip=0) {
  algo <- match.arg(algo)
  if (is.infinite(length)) {
    length <- -1               # internally we use -1 for infinite len
  }
  if (serialize && !file) {
    ## next two lines by
    ## 
    ## Message-ID: <59d7961d0607280852x386bac20tda7ca2d829da179@mail.gmail.com>
    ## From: "Henrik Bengtsson" <hb@stat.berkeley.edu>
    ## To: "r-devel@r-project.org" <r-devel@r-project.org>
    ## Cc: edd@debian.org
    ## Subject: Re: Package digest broken under R v2.4.0 devel
    ## Date: Fri, 28 Jul 2006 08:52:04 -0700
    ##
    ## replacing this
    ##   object <- serialize(object, NULL, TRUE) 
    ## which doesn't fly with R-devel pre-2.4.0
    ##
    object <- serialize(object, connection=NULL, ascii=TRUE)
    ## object <- paste(object, collapse="")

    ## Message-ID: <59d7961d0701060152k2027d19bi7ab07747f5eed6bf@mail.gmail.com>
    ## From: "Henrik Bengtsson" <hb@stat.berkeley.edu>
    ## To: "Dirk Eddelbuettel" <edd@debian.org>
    ## Subject: digest: rawToChar() instead of paste()
    ## Date: Sat, 6 Jan 2007 20:52:25 +1100
    ##
    ## Hi Dirk,
    ## 
    ## while trying to generate md5:s for large R objects I noticed that:
    ## 
    ##     object <- serialize(object, connection=NULL, ascii=TRUE);
    ##     object <- rawToChar(object);
    ## 
    ## is faster than and half the size of:
    ## 
    ##     object <- serialize(object, connection=NULL, ascii=TRUE);
    ##     object <- paste(object, collapse="");
    ## 
    object <- rawToChar(object)
  } else if (!is.character(object) && !inherits(object,"raw")) {
    stop("Argument object must be of type character or raw vector if serialize is FALSE")
  }
  if (inherits(object,"raw") && file)
    stop("file=TRUE cannot be used with a raw object")
  if (!inherits(object,"raw")) object <- as.character(object)
  algoint <- switch(algo,
                    md5=1,
                    sha1=2,
                    crc32=3)
  if (file) {
    algoint <- algoint+100
    object <- path.expand(object)
    if (file.access(object)<0) {
      stop(c("Can't open input file:", object))
    }
  }
  val <- .Call("digest",
               object,
               as.integer(algoint),
               as.integer(length),
               as.integer(skip),
               PACKAGE="digest")
  return(val)
}



