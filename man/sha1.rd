\docType{methods}
\name{sha1}
\alias{sha1}
\alias{sha1.anova}
\alias{sha1.data.frame}
\alias{sha1.list}
\alias{sha1.matrix}
\alias{sha1.numeric}
\title{Calculate a SHA1 hash of an object}
\author{Thierry Onkelinx}
\usage{
sha1(x, digits = 14, zapsmall = 7)
\method{sha1}{anova}(x, digits = 4, zapsmall = 7)
\method{sha1}{list}(x, digits = 14, zapsmall = 7)
\method{sha1}{numeric}(x, digits = 14, zapsmall = 7)
\method{sha1}{matrix}(x, digits = 14, zapsmall = 7)
\method{sha1}{data.frame}(x, digits = 14, zapsmall = 7)
}
\arguments{
\item{x}{the object to calculate the SHA1}

\item{digits}{the approximate number of significant digits in base 10. Will
be converted to a base 16 equivalent. Defaults to \code{digits = 14}, expect for
sha1.anova where \code{digits = 4}}

\item{zapsmall}{the apporixmate negative magnitute of the smallest relevant
digit. Will be converted to a base 2 equivalent. Values smaller than this
number are equivalent to 0. Defaults to \code{zapsmall = 7}}
}
\description{
Calculate a SHA1 hash of an object. The main difference with
\code{digest(x, algo = "sha1")} is that \code{sha1()} will give the same hash on
32-bit and 64-bit systems. Note that the results depends on the setting of
\code{digits} and \code{zapsmall} when handling floating point numbers. The
current defaults keep \code{digits} and \code{zapsmall} as large as possible
while maintaining the same hash on 32 bit and 64 bit systems.
}
