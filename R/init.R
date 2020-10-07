
##  digest -- hash digest functions for R
##
##  Copyright (C) 2003 - 2019  Dirk Eddelbuettel <edd@debian.org>
##
##  This file is part of digest.
##
##  digest is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 2 of the License, or
##  (at your option) any later version.
##
##  digest is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with digest.  If not, see <http://www.gnu.org/licenses/>.

.pkgenv <- new.env(parent=emptyenv())

.onLoad <- function(libname, pkgname) {
    ## we set a default level of two, with a possible override
    .pkgenv[["serializeVersion"]] <- getOption("serializeVersion", 2L)  # #nocov start
    ## allow old crc32 behaviour
    .pkgenv[["crc32Preference"]] <- getOption("digestOldCRC32Format", FALSE)
    ## allow version specific sha1 behaviour
    .pkgenv[["sha1PackageVersion"]] <- getOption("sha1PackageVersion",
                                                 packageVersion("digest"))
    ## cache if we are on Windows as the call is a little expensive (GH issue #137)
    .pkgenv[["isWindows"]] <- Sys.info()[["sysname"]] == "Windows"

    ## cache if serialize() supports 'nosharing'
    .pkgenv[["hasNoSharing"]] <- "nosharing" %in% names(formals(serialize))
}

.getSerializeVersion <- function() {
    ## return the options() value if set, otherwise the package env value
    ## doing it as a two-step ensure we can set a different default later
    getOption("serializeVersion", .pkgenv[["serializeVersion"]])
}

.getCRC32PreferOldOutput <- function() {
    ## return the options() value if set, otherwise the package env value
    ## doing it as a two-step ensure we can set a different default later
    getOption("digestOldCRC32Format", .pkgenv[["crc32Preference"]])
}

.getsha1PackageVersion <- function() {
    ## return the options() value if set, otherwise the package env value
    ## doing it as a two-step ensure we can set a different default later
    package_version(
        getOption("sha1PackageVersion", .pkgenv[["sha1PackageVersion"]])
    )
}

.isWindows <- function() {
    ## return the cached value of Sys.info()[["sysname"]] == "Windows"
    .pkgenv[["isWindows"]]
}

.hasNoSharing <- function() {
    ## return the cached value of "nosharing" %in% names(formals(serialize))
    .pkgenv[["hasNoSharing"]]
}
