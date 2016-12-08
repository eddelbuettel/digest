\name{makeRaw}
\alias{makeRaw}
\alias{makeRaw.default}
\alias{makeRaw.raw}
\alias{makeRaw.character}
\alias{makeRaw.digest}
\title{Create a raw object}
\usage{
makeRaw(object)

\method{makeRaw}{raw}(object)

\method{makeRaw}{character}(object)

\method{makeRaw}{digest}(object)

\method{makeRaw}{raw}(object)
}
\arguments{
  \item{object}{The object to convert into a \code{raw} vector}
}
\description{
  A helper function used to create \code{raw} methods.
}
\value{
  A \code{raw} vector is returned.
}
\author{Dirk Eddelbuettel}
\examples{
makeRaw("1234567890ABCDE")
}