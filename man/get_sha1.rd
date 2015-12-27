\docType{methods}
\name{get_sha1}
\alias{get_sha1}
\alias{get_sha1,ANY-method}
\alias{get_sha1,anova-method}
\alias{get_sha1,data.frame-method}
\alias{get_sha1,factor-method}
\alias{get_sha1,integer-method}
\alias{get_sha1,list-method}
\alias{get_sha1,matrix-method}
\alias{get_sha1,numeric-method}
\title{Calculate a SHA1 hash of an object}
\usage{
get_sha1(x)

\S4method{get_sha1}{ANY}(x)

\S4method{get_sha1}{integer}(x)

\S4method{get_sha1}{anova}(x)

\S4method{get_sha1}{factor}(x)

\S4method{get_sha1}{list}(x)

\S4method{get_sha1}{numeric}(x)

\S4method{get_sha1}{matrix}(x)

\S4method{get_sha1}{data.frame}(x)
}
\arguments{
\item{x}{the object to calculate the SHA1}
}
\description{
Calculate a SHA1 hash of an object
}
