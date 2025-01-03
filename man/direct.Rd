\docType{methods}
\name{direct}

\alias{md5}
\alias{md5.default}
\alias{md5.integer}
\alias{md5.numeric}
\alias{md5.raw}

\alias{xxh32}
\alias{xxh32.default}
\alias{xxh32.integer}
\alias{xxh32.numeric}
\alias{xxh32.raw}

\title{Apply hashing algorithms directly}
\author{Carl A. B. Pearson}
\usage{
md5(x, raw = TRUE, ...)
\method{md5}{default}(x, raw = TRUE, ...)
\method{md5}{integer}(x, raw = TRUE, ...)
\method{md5}{numeric}(x, raw = TRUE, ...)
\method{md5}{raw}(x, raw = TRUE, ...)

xxh32(x, raw = TRUE, ...)
\method{xxh32}{default}(x, raw = TRUE, ...)
\method{xxh32}{integer}(x, raw = TRUE, ...)
\method{xxh32}{numeric}(x, raw = TRUE, ...)
\method{xxh32}{raw}(x, raw = TRUE, ...)

}
\arguments{
\item{x}{the object to hash}

\item{raw}{a logical scalar; whether to return a raw (TRUE, the default) or a
character string.}

\item{...}{other arguments passed to \code{\link{digest}}; only used if the
direct method does not provide the generic for \code{x} argument.}
}
\description{
Calculate the hash of a simple object. The main difference with
\code{digest(x, algo = ...)} is that these direct methods can more quickly
hash simpler objects, because there are fewer checks on the input. When your
code can otherwise guarantee the inputs are fine, and those inputs are simpler
objects, these methods can help with performance.
}