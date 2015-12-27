\name{num_32_64}
\author{Thierry Onkelinx}
\alias{num_32_64}
\title{Convert a numeric to a character string}
\usage{
num_32_64(x, digits = 6, zapsmall = 7)
}
\arguments{
\item{x}{the numeric to convert}

\item{digits}{the approximate number of significant digits in base 10. Will
be converted to a base 16 equivalent}

\item{zapsmall}{the apporixmate negative magnitute of the smallest relevant
digit. Will be converted to a base 2 equivalent. Values smaller than this
number are equivalent to 0.}
}
\value{
a character vector
}
\description{
This function should give the same output on 32-bit and 64-bit systems
}
