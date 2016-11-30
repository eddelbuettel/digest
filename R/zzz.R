.onUnload <- function (libpath) { # nocov start
  library.dynam.unload("digest", libpath)
} # nocov end
