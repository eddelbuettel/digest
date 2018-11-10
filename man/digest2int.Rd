\name{digest2int}
\alias{digest2int}
\title{hash arbitrary string to integer}
\description{
  The \code{digest2int} function calculates integer hash of an arbitrary string.
  This is useful for radnomized experiments, feature hashing, etc.
}
\usage{
digest2int(x, seed = 0L)
}
\arguments{
  \item{x}{An arbitrary character vector.}
  \item{seed}{an integer for algorithm initial state.
  Function will produce different hashes for same input and different seed values.}
}
\value{
  The \code{digest2int} function returns integer vector of the same length
  as input vector \code{x}.
}
\references{
  Jenkins's \code{one_at_a_time} hash:
  \url{https://en.wikipedia.org/wiki/Jenkins_hash_function#one_at_a_time}.
}
\author{Dmitriy Selivanov \email{selivanov.dmitriy@gmail.com} for the \R interface;
    Bob Jenkins for original implementation
    \url{http://www.burtleburtle.net/bob/hash/doobs.html}
}
\seealso{\code{\link{digest}}}

\examples{

current <- digest2int("The quick brown fox jumps over the lazy dog", 0L)
target <- 1369346549L
stopifnot(identical(target, current))

}
\keyword{misc}

