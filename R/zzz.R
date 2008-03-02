# $Id: zzz.R,v 1.2 2004/05/27 01:43:40 edd Exp $
.First.lib <- function(lib, pkg) {
  library.dynam("digest", pkg, lib )
}

