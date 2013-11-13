\name{pChromPlot}
\alias{pChromPlot}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  Segment plots for aCGH as PNG}


\description{ Produce PNG figures of segment plots (by chromosome) for aCGH segmentation
  results. Internal calls are parallelized for increased speed and we
  use ff objets to allow the handling of very large objects. The output
  can include files for creating HTML with imagemaps.} 


\usage{
pChromPlot(outRDataName, cghRDataName, chromRDataName,
           probenamesRDataName = NULL,
           posRDataName = NULL,
           imgheight = 500,
           pixels.point = 3,
           pch = 20,
           colors = c("orange", "red", "green", "blue", "black"),
           imagemap = FALSE,
           typeParall = "fork",
           mc.cores = detectCores(),
           typedev = "default",
           certain_noNA = FALSE,
           loadBalance = TRUE,
           ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{outRDataName}{
    
    The RAM  object or the RData file name that contains the results
    from the segmentation (as an \code{\link[ff]{ffdf}} object), as
    carried out by any of the \code{\link{pSegment}} functions.
    

    Note that the type of object in \code{outRDataName},
    \code{cghRDataName},
    \code{chromRDataName}, \code{posRDataName}, should all be of the
    same type: all \code{ff} objects, or all RAM   objects.

    As well, note that if you use RAM objects, you must use
    \code{typeParall = "fork"}; with \code{ff} objects you can use both
    \code{typeParall = "cluster"} and \code{typeParall =
    "fork"}. Further details are provided in the vignette.
  }

    \item{cghRDataName}{The Rdata file name that contains the
    \code{\link[ff]{ffdf}} with the aCGH data or the name of the RAM object with the data.

        If this is an \code{\link[ff]{ffdf}} object, it can be created using
    \code{\link[ff]{as.ffdf}} with a data frame with genes (probes) in
    rows and subjects or arrays in columns. You can also use
    \code{\link{inputToADaCGH}} to produce these type of files.
  }
  
  \item{chromRDataName}{The RData file name with the ff (short integer)
    vector with the chromosome indicator, or the name of the RAM object
    with the data. Function \code{\link{inputToADaCGH}} produces
    these type of files. }
  
  \item{posRDataName}{The RData file name with the ff double vector with
    the location (e.g., position in kbases) of each probe in the
    chromosome, or the name of the RAM object with the data. Function
    \code{\link{inputToADaCGH}} produces these type of files.

    This argument is used for the spacing in the plots. If NULL, the
    x-axis goes from 1:number of probes in that chromosome.

  }
  

  \item{probenamesRDataName}{The RData file name with the vector with
    the probe names or the RAM object. Function
    \code{\link{inputToADaCGH}} produces these type of
    files. (Note even if this is an RData file stored on disk, this
    is not an ff file.)  This won't be needed unless you set
    \code{imagemap = TRUE}.}


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
  each array * chromosome, two additional files are produced:
  "pngCoord_ChrNN@MM" and "geneNames_ChrNN@MM", where "NN" is the
  chromosome number and "MM" is the array name. The first file contains
  the coordinates of the png and radius and the second the gene or probe
  names, so that you can easily produce an HTML imagemap. (Former
  versions of ADaCGH did this automatically with Python. In this version
  we include the Python files under "imagemap-example".)}


  \item{typeParall}{One of "fork" or "cluster". "fork" is unavailable in
  Windows, and will lead to sequential execution. "cluster" requires
  having set up a cluster before, with appropriate calls to
  \code{\link[parallel]{makeCluster}}, in which case the cluster can be
  one of the available types (e.g., sockets, MPI, etc).

  Using "fork" and "cluster" will lead to different schemes for
  parallelization. See the vignette.


  If you use \code{ff} objects, you can use different options for
  \code{typeParall} for segmentation and plotting.
}
\item{mc.cores}{The number of cores used if \code{typeParall =
    "fork"}. See details in \code{\link[parallel]{mclapply}}}.

\item{typedev}{The device type. One of "cairo", "cairo-png", "Cairo", or
  "default". "Cairo" requires the Cairo package to be available, but
  might work with headless Linux server without png support, and might
  be a better choice with Mac OS. "default" chooses "Cairo" for Mac, and
  "cairo" otherwise.}

\item{certain_noNA}{Are you certain, absolutely sure, your data contain
  no missing values? (Default is FALSE). If you are, you can achieve
  considerable speed ups by setting it to TRUE. See the help for this
  option in  \code{\link{pSegment}}. Of course, if you are setting it to
  true, the object you pass with the output, \code{outRDataName}, must
  have been generated using \code{certain_noNA}.}

\item{loadBalance}{If TRUE (the default) use load balancing with MPI
  (use \code{\link[parallel]{clusterApplyLB}} instead of
  \code{\link[parallel]{clusterApply}}) and a similar approach for forking (
  set \code{mc.preschedule = FALSE} in the call to \code{\link[parallel]{mclapply}}
  ).}
 

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

#####################################################
###
### Using forking with RAM objects
###
#####################################################

### Note to windows users: under Windows, this will
### result in sequential execution, as forking is not
### available.


## Get example input data and create data objects

data(inputEx)

## (this is not necessary, but is convenient;
##  you could do the subsetting in the call themselves)
cgh.dat <- inputEx[, -c(1, 2, 3)]
chrom.dat <- as.integer(inputEx[, 2])
pos.dat <- inputEx[, 3]



## Segment with HaarSeg
haar.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat,
                                   merging = "MAD")


pChromPlot(haar.RAM.fork,
           cghRDataName = cgh.dat,
           chromRDataName = chrom.dat,
           posRDataName = pos.dat,
           imgheight = 350)


\dontrun{

#####################################################
###
### Using a cluster with ff objects and create imagemaps
###
#####################################################



## Create a temp dir for storing output
dir.create("ADaCGH2_plot_tmp_dir")
originalDir <- getwd()
setwd("ADaCGH2_plot_tmp_dir")


## Start a socket cluster. Change the appropriate number of CPUs
## for your hardware and use other types of clusters (e.g., MPI)
## if you want.

cl2 <- makeCluster(4,"PSOCK")
clusterSetRNGStream(cl2)
setDefaultCluster(cl2) 
clusterEvalQ(NULL, library("ADaCGH2"))
## The following is not really needed if you create the cluster AFTER
## changing directories. But better to be explicit.
wdir <- getwd()
clusterExport(NULL, "wdir")
clusterEvalQ(NULL, setwd(wdir))


## Get input data in ff format
## (we loaded the RData above, but we need to find the full path
## to use it in the call to inputToADaCGH)

fname <- list.files(path = system.file("data", package = "ADaCGH2"),
                     full.names = TRUE, pattern = "inputEx.RData")

inputToADaCGH(ff.or.RAM = "ff",
              RDatafilename = fname)



## Segment with HaarSeg

haar.ff.cluster <- pSegmentHaarSeg("cghData.RData",
                                   "chromData.RData",
                                   merging = "MAD",
                                   typeParall= "cluster")

## Save the output (an ff object) and plot
save(haar.ff.cluster, file = "haar.ff.cluster.out.RData",
     compress = FALSE)


pChromPlot(outRDataName = "haar.ff.cluster.out.RData",
           cghRDataName = "cghData.RData",
           chromRDataName = "chromData.RData",
           posRDataName = "posData.RData",
           probenamesRDataName = "probeNames.RData",
           imgheight = 350,
           imagemap = TRUE,
           typeParall= "cluster")

### Explicitly stop cluster
stopCluster(NULL)

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

lapply(haar.ff.cluster, delete)
rm(haar.ff.cluster)
unlink("haar.ff.cluster.out.RData")

### Try to prevent problems in R CMD check
Sys.sleep(2)


### Delete all png files and temp dir
setwd(originalDir)
Sys.sleep(2)
unlink("ADaCGH2_plot_tmp_dir", recursive = TRUE)
Sys.sleep(2)

}

### PNGs are in this directory
getwd()

}

\keyword{ hplot }
\keyword{ IO }





%% \dontrun{
%% we used here files from older examples.
%% ## Produce the coordinate and probe names files.
%% pChromPlot(outRDataName = "hs_mad.out.RData",
%%            cghRDataName = "cghData.RData",
%%            chromRDataName = "chromData.RData",
%%            posRDataName = "posData.RData",
%%            probenamesRDataName = "probeNames.RData",
%%            imgheight = 350,
%%            imagemap = TRUE)
%% }





