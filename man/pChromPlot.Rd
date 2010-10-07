\name{pChromPlot}
\alias{pChromPlot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Segment plots for aCGH as PNG}


\description{ Produce PNG figures of egment plots (by chromosome) for aCGH segmentation
  results. Internal calls are parallelized for increased speed and we
  use ff objets to allow the handling of very large objects. The output
  can include files for creating HTML with imagemaps.} 


\usage{
pChromPlot(outRDataName, cghRDataName, chromRDataName,
           probenamesRDataName,
           posRDataName = NULL,
           imgheight = 500,
           pixels.point = 3,
           pch = 20,
           colors = c("orange", "red", "green", "blue", "black"),
           imagemap = FALSE,
           ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{outRDataName}{
    The Rdata file name that contains the
    \code{\link[ff]{ffdf}} with the results from the segmentation as
    carried out by any of the \code{\link{pSegment}} functions.
  }


  \item{cghRDataName}{The Rdata file name that contains the
    \code{\link[ff]{ffdf}} with the aCGH data. This file can be created
    using \code{\link[ff]{as.ffdf}} with a data frame with genes
    (probes) in rows and subjects or arrays in columns. Function
    \code{\link{inputDataToADaCGHData}} produces these type of files.}
  
  
  \item{chromRDataName}{The RData file name with the ff (short integer)
    vector with the chromosome indicator. Function
    \code{\link{inputDataToADaCGHData}} produces these type of files. }
  
 

  \item{probenamesRDataName}{The RData file name with the 
    vector with the probe names. Function 
    \code{\link{inputDataToADaCGHData}} produces these type of
    files. Note that this is not an ff file.

}

 \item{posRDataName}{The RData file name with the ff double vector with
    the location (e.g., position in kbases) of each probe in
    the chromosome. Function
    \code{\link{inputDataToADaCGHData}} produces these type of files.
    Used for the spacing in the plots. If NULL, the x-axis goes from
    1:number of probes in that chromosome.
  }


  \item{imgheight}{
    Height of png image. See \code{\link{png}}.
  }
  
  \item{pixels.point}{
    Approximate number of pixels that each point takes; this determines
    also final figure size. With many probes per chromosome, you will
    want to make this a small value.
}
  \item{pch}{
    The type of plotting symbol. See \code{\link{par}}.
}
  \item{colors}{
    A five-element character vector with the colors for: probes without
    change, probes that have a "gained" status, probes that have a
    "lost" status, the line that connects (smoothed values of) probes,
    the horizontal line at the 0 level.
  }

\item{imagemap}{If FALSE only the png figure is produced. If TRUE, for
  each array * chromosome, to additional files are produced:
  "pngCoord_ChrNN@MM" and "geneNames_ChrNN@MM", where "NN" is the
  chromosome number and "MM" is the array name. The first file contains
  the coordinates of the png and radius and the second the gene or probe
  names, so that you can easily produce an HTML imagemap. (Former
  versions of ADaCGH did this automatically with Python. In this version
  we include the Python files under "imagemap-example".)}
  
  \item{...}{Additional arguments; not used.}
}

% \details{
% %%  ~~ If necessary, more details than the description above ~~
% }
\value{
   Used only for its side effects of producing PNG plots, stored in the
   current working directory (\command{getwd()}.)
}
% \references{
% %% ~put references to the literature/web site here ~
% }
\author{Ramon Diaz-Uriarte \email{rdiaz02@gmail.com}}

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

save(hs_mad.out, file = "hs_mad.out.RData", compress = FALSE)

pChromPlot(outRDataName = "hs_mad.out.RData",
                            cghRDataName = "cghData.RData",
                            chromRDataName = "chromData.RData",
                            posRDataName = "posData.RData",
                            probenamesRDataName = "probeNames.RData",
                            imgheight = 350)

\dontrun{
## Produce the coordinate and probe names files.
pChromPlot(outRDataName = "hs_mad.out.RData",
                            cghRDataName = "cghData.RData",
                            chromRDataName = "chromData.RData",
                            posRDataName = "posData.RData",
                            probenamesRDataName = "probeNames.RData",
                            imgheight = 350,
                            imagemap = TRUE)
}

}

\keyword{ hplot }
\keyword{ IO }
