\docType{methods}
\name{sha1}
\alias{sha1}
\alias{sha1.anova}
\alias{sha1.data.frame}
\alias{sha1.factor}
\alias{sha1.integer}
\alias{sha1.list}
\alias{sha1.matrix}
\alias{sha1.numeric}
\title{Calculate a SHA1 hash of an object}
\author{Thierry Onkelinx}
\usage{
sha1(x)
\method{sha1}{integer}(x)
\method{sha1}{anova}(x)
\method{sha1}{factor}(x)
\method{sha1}{list}(x)
\method{sha1}{numeric}(x)
\method{sha1}{matrix}(x)
\method{sha1}{data.frame}(x)
}
\arguments{
\item{x}{the object to calculate the SHA1}
}
\description{
Calculate a SHA1 hash of an object. The main difference with \code{digest(x, algo = "sha1")} is that \code{sha1()} will give the same hash on 32-bit and 64-bit systems.
}
