\name{outputToCGHregions}
\alias{outputToCGHregions}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
ADaCGH2 output as input to CGHregions
}
\description{
  Convert ADaCGH2 output to a data frame that can be used as
  input for \code{\link[CGHregions]{CGHregions}}.
}
\usage{
outputToCGHregions(output, directory = getwd())
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{output}{
    The name of the output from a call to a \code{\link{pSegment}} function.
}
  \item{directory}{
    The directory where the initial data transformation and the analysis
    have been carried out. It is a lot better if you just work on a
    single directory for a set of files. Otherwise, unless you keep very
    carefull track of where you do what, you will run into trouble.
  }
}
% \details{
% }
\value{
  A data frame of 4 + k columns that can be used as input to the
  \code{\link[CGHregions]{CGHregions}} function. The first four columns
  are the probe name, the chromosome, the position and the position. The
  last k columns are the calls for the k samples.
}
% \references{
% %% ~put references to the literature/web site here ~
% }
\author{
  Ramon Diaz-Uriarte \email{rdiaz02@gmail.com}
%%  ~~who you are~~
}
\note{
  This function does NOT check if the calls are meaningfull. In
  particular, you probably do NOT want to use this function when
  \code{\link{pSegment}} has been called using \option{merging = "none"}.

}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{pSegment}}
}
\examples{
snowfallInit(universeSize = 2, typecluster = "SOCK")

## To speed up R CMD check, we do not use inputEx1, but a much smaller
## data set. When you try the examples, you might one to use
## inputEx1 instead.

\dontrun{

fname <- list.files(path = system.file("data", package = "ADaCGH2"),
                     full.names = TRUE, pattern = "inputEx1")
}

fname <- list.files(path = system.file("data", package = "ADaCGH2"),
                     full.names = TRUE, pattern = "inputEx2")


tableChromArray <- inputDataToADaCGHData(filename = fname)

hs_mad.out <- pSegmentHaarSeg("cghData.RData",
                           "chromData.RData", merging = "MAD")

forcghr <- outputToCGHregions(hs_mad.out)
if(require(CGHregions)) {
  regions1 <- CGHregions(forcghr)
  regions1
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ IO }