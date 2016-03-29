\name{outputToCGHregions}
\alias{outputToCGHregions}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
ADaCGH2 output as input to CGHregions
}

\description{ Convert ADaCGH2 output to a data frame that can be used as
  input for \code{\link[CGHregions]{CGHregions}}. This function takes as
  input the two possible types of input produced by the
  \code{\link{pSegment}} functions: either an ff object (and its
  associated directory) or the names of the RAM objects (the usual, in
  memory R objects) with the output, and chromosome, position, and probe
  name information.

}

\usage{
outputToCGHregions(ffoutput = NULL, directory = getwd(),
                               output.dat = NULL,
                               chrom.dat = NULL,
                               pos.dat = NULL,
                               probenames.dat = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ffoutput}{
    The name of the ff object with the output from a call to a
    \code{\link{pSegment}} function. You must provide either this
    argument or all of the arguments output.dat, chrom.dat, pos.dat and
    probenames.dat. 
}
  \item{directory}{
    The directory where the initial data transformation and the analysis
    have been carried out. It is a lot better if you just work on a
    single directory for a set of files. Otherwise, unless you keep very
    carefull track of where you do what, you will run into trouble.

    This is only relevant if you use an \code{ff} object (i.e., if
    \code{ffoutput} is not NULL.)
  }

  \item{output.dat}{The name of the RAM object with the output from
    a call to a \code{\link{pSegment}} function. You must provide this
    argument (as well as chrom.dat, pos.dat and probenames.dat) OR the
    name of an ffobject to argument \code{ffoutput.}}

  \item{chrom.dat}{The name of the RAM object with the chromosome
  data information. See the help for \code{\link{inputToADaCGH}}.}


\item{pos.dat}{The name of the RAM object with the position data
  information. See the help for \code{\link{inputToADaCGH}}.}

\item{probenames.dat}{The name of the RAM object with the probe
names. See the help for \code{\link{inputToADaCGH}}.}

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


  Moreover, we do not check if there are missing values, and CGHregions
  is likely to fail when there are NAs. Finally, we do not try to use
  \code{ff} objects, so using this function with very large objects will
  probably fail. 
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
  \code{\link{pSegment}}
}
\examples{



## Get location (and full filename) of example data file
## We will read from a text file

fnametxt <- list.files(path = system.file("data", package = "ADaCGH2"),
                         full.names = TRUE, pattern = "inputEx.txt")


##################################
#####
##### Using RAM objects
#####
##################################

## Read data into RAM objects




inputToADaCGH(ff.or.RAM = "RAM",
                      textfilename = fnametxt)

## Run segmentation (e.g., HaarSeg)

haar.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat,
                                   merging = "MAD")

forcghr <- outputToCGHregions(output.dat = haar.RAM.fork,
                              chrom.dat = chrom.dat,
                              pos.dat = pos.dat,
                              probenames.dat = probenames.dat)

## Run CGHregions
if(require(CGHregions)) {
  regions1 <- CGHregions(na.omit(forcghr))
  regions1
}

##################################
#####
##### Using ff objects
#####
##################################

if(.Platform$OS.type != "windows") {

## We do not want this to run in Windows the automated tests since
## issues with I/O. It should work, though, in interactive usage


## Create a temp dir for storing output.
## (Not needed, but cleaner).
dir.create("ADaCGH2_cghreg_example_tmp_dir")
originalDir <- getwd()
setwd("ADaCGH2_cghreg_example_tmp_dir")
## Sys.sleep(1)


inputToADaCGH(ff.or.RAM = "ff",
                      textfilename = fnametxt)



haar.ff.fork <- pSegmentHaarSeg("cghData.RData",
                                "chromData.RData",
                                merging = "MAD")

forcghr.ff <- outputToCGHregions(ffoutput = haar.ff.fork)

if(require(CGHregions)) {
  regions1 <- CGHregions(na.omit(forcghr.ff))
  regions1
}

### Clean up (DO NOT do this with objects you want to keep!!!)
load("chromData.RData")
load("posData.RData")
load("cghData.RData")

delete(cghData); rm(cghData)
delete(posData); rm(posData)
delete(chromData); rm(chromData)
unlink("chromData.RData")
unlink("posData.RData")
unlink("cghData.RData")
unlink("probeNames.RData")

lapply(haar.ff.fork, delete)
rm(haar.ff.fork)

### Delete all files and temp dir
setwd(originalDir)
## Sys.sleep(2)
unlink("ADaCGH2_cghreg_example_tmp_dir", recursive = TRUE)
## Sys.sleep(2)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ IO }
