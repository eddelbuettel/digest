.onUnload <- function (libpath) {
  library.dynam.unload("digest", libpath)
}
