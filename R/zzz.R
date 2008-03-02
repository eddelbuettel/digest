# $Id: zzz.R,v 1.1 2003/11/29 01:49:27 edd Exp $
.First.lib <- function(lib, pkg) {
  if (as.numeric(R.version$minor) < 8)  # need serialize package for R < 1.8.0
    if (!require(serialize, quiet=TRUE))
      stop("The required library serialize could not be loaded")
  library.dynam("digest", pkg, lib )
}

