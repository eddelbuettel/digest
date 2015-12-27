\docType{methods}
\name{sha1}
\alias{sha1}
\alias{sha1,ANY-method}
\alias{sha1,anova-method}
\alias{sha1,data.frame-method}
\alias{sha1,factor-method}
\alias{sha1,integer-method}
\alias{sha1,list-method}
\alias{sha1,matrix-method}
\alias{sha1,numeric-method}
\title{Calculate a SHA1 hash of an object}
\author{Thierry Onkelinx}
\usage{
sha1(x)

\S4method{sha1}{ANY}(x)

\S4method{sha1}{integer}(x)

\S4method{sha1}{anova}(x)

\S4method{sha1}{factor}(x)

\S4method{sha1}{list}(x)

\S4method{sha1}{numeric}(x)

\S4method{sha1}{matrix}(x)

\S4method{sha1}{data.frame}(x)
}
\arguments{
\item{x}{the object to calculate the SHA1}
}
\description{
Calculate a SHA1 hash of an object
}
