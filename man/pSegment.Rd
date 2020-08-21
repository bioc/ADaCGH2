\name{pSegment}
\alias{pSegmentDNAcopy}
\alias{pSegmentHMM}
\alias{pSegmentGLAD}
\alias{pSegmentBioHMM}
\alias{pSegmentCGHseg}
\alias{pSegmentWavelets}
\alias{pSegmentHaarSeg}
\alias{pSegment}


\title{ Parallelized/"unified" versions of several aCGH segementation algorithms/methods}

\description{
  These functions parallelize several segmentation
  algorithms and make their calling use the same conventions as for
  other methods.
}


\usage{

pSegmentDNAcopy(cghRDataName, chromRDataName, merging = "MAD",
                mad.threshold = 3, smooth = TRUE,
                alpha=0.01, nperm=10000,
                p.method = "hybrid",
                min.width = 2,
                kmax=25, nmin=200,
                eta = 0.05,trim = 0.025,
                undo.splits = "none",
                undo.prune=0.05, undo.SD=3,
                typeParall = "fork",
                mc.cores = detectCores(),
                certain_noNA = FALSE,
                loadBalance = TRUE,
                ...)

pSegmentHaarSeg(cghRDataName, chromRDataName,
                merging = "MAD", mad.threshold = 3, 
                W = vector(),
                rawI = vector(), 
                breaksFdrQ = 0.001,			  
                haarStartLevel = 1,
                haarEndLevel = 5,
                typeParall = "fork",
                mc.cores = detectCores(),
                certain_noNA = FALSE,
                loadBalance = FALSE,
                ...)

pSegmentHMM(cghRDataName, chromRDataName,
            merging = "mergeLevels", mad.threshold = 3,
            aic.or.bic = "AIC",
            typeParall = "fork",
            mc.cores = detectCores(),
            certain_noNA = FALSE,
            loadBalance = TRUE,
            ...)



pSegmentBioHMM(cghRDataName, chromRDataName, posRDataName,
               merging = "mergeLevels", mad.threshold = 3,
               aic.or.bic = "AIC",
               typeParall = "fork",
               mc.cores = detectCores(),
               certain_noNA = FALSE,
               loadBalance = TRUE,
               ...)

pSegmentCGHseg(cghRDataName, chromRDataName, CGHseg.thres = -0.05,
               merging = "MAD", mad.threshold = 3,
               typeParall = "fork",
               mc.cores = detectCores(),
               certain_noNA = FALSE,
               loadBalance = TRUE,
               ...)


pSegmentGLAD(cghRDataName, chromRDataName,
             deltaN = 0.10,
             forceGL = c(-0.15, 0.15),
             deletion = -5,
             amplicon = 1,
             typeParall = "fork",
             mc.cores = detectCores(),
             certain_noNA = FALSE,
             GLADdetails = FALSE,
             loadBalance = TRUE,
             ...)


pSegmentWavelets(cghRDataName, chromRDataName, merging = "MAD",
                 mad.threshold = 3,
                 minDiff = 0.25,
                 minMergeDiff = 0.05,
                 thrLvl = 3, initClusterLevels = 10,
                 typeParall = "fork",
                 mc.cores = detectCores(),
                 certain_noNA = FALSE,
                 loadBalance = TRUE,
                 ...)




}
%- maybe also 'usage' for other objects documented here.
\arguments{
  
  \item{cghRDataName}{The Rdata file name that contains the
    \code{\link[ff]{ffdf}} with the aCGH data or the name of the
    in-memory, RAM, R object with the data (a data frame).

    If this is an \code{\link[ff]{ffdf}} object, it can be created using
    \code{\link[ff]{as.ffdf}} with a data frame with genes (probes) in
    rows and subjects or arrays in columns. You can also use
    \code{\link{inputToADaCGH}} to produce these type of files.

    Note that the type of object in \code{cghRDataName},
    \code{chromRDataName}, \code{posRDataName}, should all be of the
    same type: all \code{ff} objects, or all RAM objects, the usual R
    objects. Moreover, the type of input determines the type of output:
    if you use \code{ff} objects as input, you will get the output as an
    \code{ff} object.  }
    
    
  \item{chromRDataName}{The RData file name with the ff (short integer)
    vector with the chromosome indicator, or the name of the in-memory
    RAM R object with the data. Function
    \code{\link{inputToADaCGH}} produces these type of files. }
  
  \item{posRDataName}{The RData file name with the ff double vector with
    the location (e.g., position in kbases) of each probe in the
    chromosome, or the name of the in-memory RAM R object with the
    data. Function \code{\link{inputToADaCGH}} produces these
    type of files.}
  
  \item{merging}{Merging method; for most methods one of "MAD" or
    "mergeLevels". For CBS (pSegmentDNAcopy),  GGHseg (pSegmentCGHseg),
    HaarSeg (pSegmentHaarSeg), and Wavelets (as
    in Hsu et al. ---pSegmentWavelets)  also "none". This option
    does not apply to GLAD (which has its own merging-like approach). See
    details.}
  
  \item{mad.threshold}{If using \code{merging = "MAD"} the value such
    that all segments where abs(smoothed value) > m*MAD will be declared
    aberrant ---see p. i141 of Ben-Yaacov and Eldar. No effect if
    merging = "mergeLevels" (or "none").}


  \item{typeParall}{One of "fork" or "cluster". "fork" is unavailable in
  Windows, and will lead to sequential execution. "cluster" requires
  having set up a cluster before, with appropriate calls to
  \code{\link{makeCluster}}, in which case the cluster can be
  one of the available types (e.g., sockets, MPI, etc).

  Using "fork" and "cluster" will lead to different schemes for
  parallelization. See details and the vignette.}


\item{mc.cores}{The number of cores used if \code{typeParall =
    "fork"}. See details in \code{\link{mclapply}}}.

\item{certain_noNA}{Are you certain, absolutely sure, your data contain
  no missing values? (Default is FALSE). If you are, you can achieve
  considerable speed ups by setting it to TRUE. But if you set it to
  TRUE and you are wrong, some methods will fail (some with harder
  to understand error messages) and, even worse, other methods might
  appear to work (but give incorrect results). You've been warned.}

\item{loadBalance}{If TRUE (the default for all methods except HaarSeg)
  use load balancing with MPI (use
  \code{\link{clusterApplyLB}} instead of
  \code{\link{clusterApply}}) and a similar approach for
  forking ( set \code{mc.preschedule = FALSE} in the call to
  \code{\link{mclapply}} ).}
      
\item{smooth}{For DNAcopy only. If TRUE (default) carry out smoothing as
  explained in \code{\link[DNAcopy]{smooth.CNA}}.}

  
  \item{alpha}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{nperm}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{p.method}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{min.width}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{kmax}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.}
  \item{nmin}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.}
  \item{eta}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{trim}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{undo.splits}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{undo.prune}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 
  \item{undo.SD}{For DNAcopy only. See \code{\link[DNAcopy]{segment}}.} 


  \item{W}{For HaarSeg:  Weight matrix, corresponding to quality of measurment. 
    Insert 1/(sigma**2) as weights if your platform output sigma as
    the quality of measurment. W must have the same size as I.}
  \item{rawI}{For HaarSeg. Mininum of the raw red and raw green measurment, before the log.
    rawI is used for the non-stationary variance compensation. 
    rawI must have the same size as I. }
  \item{breaksFdrQ}{For HaarSeg.  The FDR q parameter. Common used
    values are 0.05, 0.01, 0.001. Default value is 0.001.}
  \item{haarStartLevel}{For HaarSeg.  The detail subband from which we
    start to detect peaks. The higher  this value is, the less sensitive
    we are to short segments. The default is value is 1, corresponding to
    segments of 2 probes.}
  \item{haarEndLevel}{For HaarSeg. The detail subband until which we
    use to detect peaks. The higher  this value is, the more sensitive we
    re to large trends in the data. This value DOES NOT indicate the
    largest possible segment that can be detected. The default is value is
    5, corresponding to step of 32 probes in each direction.}

  \item{aic.or.bic}{For HMM and BioHMM. One of "AIC" or "BIC". See
  \option{criteria} in \code{\link[snapCGH]{runBioHMM}}.} 


  \item{CGHseg.thres}{The threshold for the adaptive penalization in
    Picard et al.'s CGHseg. See p. 13 of the original paper. Must be a
    negative number. The default value used in the original reference
    is -0.5. However, our experience with the simulated data in
    Willenbrock and Fridlyand (2005) indicates that for those data
    values around -0.005 are more appropriate. We use here -0.05 as
    default.}


  \item{deltaN}{Only for GLAD. See \option{deltaN} in \code{\link[GLAD]{daglad}}.}
  \item{forceGL}{Only for GLAD. See \option{forceGL} in \code{\link[GLAD]{daglad}}.}
  \item{deletion}{Only for GLAD. See \option{deletion} in \code{\link[GLAD]{daglad}}.}
  \item{amplicon}{Only for GLAD. See \option{amplicon} in
    \code{\link[GLAD]{daglad}}.}
  \item{GLADdetails}{Only for GLAD. If set to TRUE the function returns
  verbose output about where it is along the execution. This option
  (setting it to FALSE) is likely to become hard-coded in the future.}
  


  \item{minMergeDiff}{Used only when doing merging in the wavelet
    method of Hsu et al..  The finall call as to which segments go together is done by
    a \code{mergeLevels} approach, but an initial collapsing of very
    close values is performed (otherwise, we could end up passing to
    mergeLevels as many initial levels as there are points). }

  \item{minDiff}{For Wavelets (Hsu et al.). Minimum (absolute)
    difference between the medians of two adjacent clusters for them to
    be considered truly different.  Clusters "closer" together than this
    are collapsed together to form a single cluster. }

  \item{thrLvl}{ The level used for the wavelet thresholding in Hsu et
    al.}

  \item{initClusterLevels}{For Wavelets (Hsu et al.). The initial number of clusters to form. }
 
  
  \item{...}{Additional arguments; not used.}
}



\details{

In most cases, these are wrappers to the original code, with
modifications for parallelization and for using \code{\link[ff]{ff}}
objects, if appropriate.


Using option \code{typeParall = "fork"} will, as it says, use the
forking mechanism available in package \code{parallel}. The objects used
can be either \code{ff} objects or regular R objects. Using
\code{typeParall = "cluster"} will use a pre-existing cluster, and the
objects used must be \code{ff} ones, since we only pass pointers to the
objects, not the objects themselves, to try to minimize communication
and memory usage. To put it the other way around: if you use RAM
objects, you must use \code{typeParall = "fork"}; with \code{ff} objects
you can use both \code{typeParall = "cluster"} and \code{typeParall =
"fork"}. Further details are provided in the vignette.



For HMM, BioHMM, CGHseg, and Wavelets, the first part of the analysis is
conducted parallelizing over array by chromosome (because the methods
are slow and/or very memory consuming). The final step (merging),
however, is carried out over array (it is a step that must be carried
array-wise). For all other methods, we have parallelized over arrays:
the extra communication overheads of the much finer-grained
parallelization of array by chromosome are rarely justified with these
methods and, in the case of GLAD, would require modifying the original C
code. 


% We have parallelized all computations by array (in contrast to former
% versions of ADaCGH, where some computations, depending on number of
% samples, could be parallelized over array*chromosome). 


CGHseg has been implemented here following the original authors
description. Note that several publications incorrectly claim that they
use the CGHseg approach when, actually, they are only using the
"segment" function in the "tilingArray" package, but they are missing
the key step of choosing the optimal number of segments (see p. 13 in
Picard et al, 2005). We implement the author's method in our (internal,
so use "ADaCGH2:::piccardsKO" to see it) function "piccardsKO".


When using GLAD, we use the HaarSeg approach. This is the same as using
the \code{daglad} function with argument \code{smoothfunc = "haarseg"}.


For BioHMM and HMM the smoothed results are merged, by default by the
mergeLevels algorithm, as recommended in \cite{Willenbrock and
Fridlyand, 2005}. For DNAcopy the default used to be mergeLevels,
following the above recommendations, but we are now using MAD by
default, as it is much faster and it is unclear that mergeLevels is the
right approach with the type of data available today. Your mileage might
vary and you probably will want to try both on some test data and check which
makes more sense.


Merging is also done in GLAD (with GLAD's own merging algorithm). For
HaarSeg, calling/merging is carried out using MAD, following page i141
of Ben-Yaacov and Eldar, section 2.3, "Determining aberrant intervals":
a MAD (per their definition) is computed and any segment with absolute
value larger than mad.threshold * MAD is considered aberrant.  Merging
is also performed for CGHseg (the default, however, is MAD, not
mergeLevels).  Merging (using either of "mergeLevels" or "MAD") can also
be used with the wavelet-based method of Hsu et al.; please note that
the later is an experimental feature implemented by us, and there is no
study of its performance.


In summary, for all segmentation methods (except GLAD) merging is
available as either "mergeLevels" or "MAD". For DNAcopy, CGHseg,
HaarSeg, and wavelets as in Hsu et al., you can also choose no merging,
though this will rarely be what you want (we offer this option to allow
using the original authors' choices in their first descriptions of
methods).


When using mergeLevels, we map the results to states of "Alteration", so
that we categorize each probe as taking one, and only one, of three
possible values, -1 (loss of genomic DNA), 0 (no change in DNA content),
+1 (gain of genomic DNA). We have made the assumption, in this mapping,
that the "no change" class is the one that has the absolute value
closest to zero, and any other classes are either gains or losses. When
the data are normalized, the "no change" class should be the most common
one. When using MAD this step is implicit in the procedure ( any segment
with absolute value larger than mad.threshold * MAD is considered
aberrant).

  
Note that "mergeLevels", in addition to being used for calling gains and
losses, results in a decrease in the number of distinct smoothed values,
since it can merge two or more adjacent smoothed levels. "MAD", in
contrast, performs no merging as such, but only calling.

}


\value{A list of two components (the components will be either
  \code{ff} or regular, in-memory R objects, depending on the input):
  
  \item{outSmoothed}{The smoothed values, as either a
    \code{\link[ff]{ffdf}} object or a data frame object. Each column is
    an array or sample, and each row a probe.}
  
  \item{outState}{The calls for each probe, as either an
    \code{\link[ff]{ffdf}} object or a data frame object. Each column is
    an array or sample, and each row a probe. For methods that accept
    "none" as an argument to \option{merging}, the states cannot be
    interpreted directly as gain or loss; they are simply discrete codes
    for distinct segments.}
  
  If the output uses \code{\link[ff]{ffdf}}, rows and columns of each
  element can be accessed in the usual way for \code{\link[ff]{ffdf}}
  objects, but accept also most of the usual R operations for data
  frames.

}

\references{

Diaz-Uriarte, R. (2014). ADaCGH2: parallelized analysis of (big) CNA
data. \emph{Bioinformatics}, \bold{30}: 1759--1761.
  
Carro A, Rico D, Rueda O M, Diaz-Uriarte R, and Pisano DG.
  (2010). waviCGH: a web application for the analysis and visualization of
  genomic copy number alterations. \emph{Nucleic Acids Research}, \bold{38 Suppl}:W182--187.

  
Fridlyand, Jane   and Snijders, Antoine  M.  and Pinkel, Dan   and
Albertson, Donna  G. (2004). Hidden Markov models approach to the
analysis of array CGH data. \emph{Journal of Multivariate Analysis},
\bold{90}: 132--153. 
  
  Hsu L, Self SG, Grove D, Randolph T, Wang K, Delrow JJ, Loo L, Porter
P. (2005) Denoising array-based comparative genomic hybridization data
using wavelets. \emph{Biostatistics}, \bold{6}:211-26.


Hupe, P.  and Stransky, N.  and Thiery, J. P.  and Radvanyi, F.  and
Barillot, E. (2004). Analysis of array CGH data: from signal ratio to
gain and loss of DNA regions. \emph{Bioinformatics}, \bold{20}:
3413--3422. 


  Lingjaerde OC, Baumbusch LO, Liestol K, Glad I,
Borresen-Dale AL. (2005). CGH-Explorer: a program for analysis of
CGH-data. \emph{Bioinformatics}, \bold{21}: 821--822.



Marioni, J. C.  and Thorne, N. P.  and Tavare, S. (2006). BioHMM: a
heterogeneous hidden Markov model for segmenting array CGH
data. \emph{Bioinformatics}, \bold{22}: 1144--1146.





  Olshen, A. B.  and Venkatraman, E. S.  and Lucito, R.  and Wigler,
  M. (2004) Circular binary segmentation for the analysis of array-based
  DNA copy number data. \emph{Biostatistics}, \bold{4}, 557--572.
  \url{http://www.mskcc.org/biostat/~olshena/research}.


  Picard, F.  and Robin, S.  and Lavielle, M.  and Vaisse, C.  and
  Daudin, J. J. (2005). A statistical approach for array CGH data
  analysis. \emph{BMC Bioinformatics}, \bold{6},
  27. \url{http://dx.doi.org/10.1186/1471-2105-6-27}. 


  
  Price TS, Regan R, Mott R, Hedman A, Honey B, Daniels RJ,
Smith L, Greenfield A, Tiganescu A, Buckle V, Ventress N, Ayyub H,
Salhan A, Pedraza-Diaz S, Broxholme J, Ragoussis J, Higgs DR, Flint J,
Knight SJ. (2005) SW-ARRAY: a dynamic programming solution for the
identification of copy-number changes in genomic DNA using array
comparative genome hybridization data. \emph{Nucleic Acids Res.},
\bold{33}:3455-64. 


  Willenbrock, H. and Fridlyand, J. (2005). A comparison study: applying
  segmentation to array CGH data for downstream
  analyses. \emph{Bioinformatics}, \bold{21}, 4084--4091.
  

  
  Diaz-Uriarte, R. and Rueda, O.M. (2007). ADaCGH: A parallelized
  web-based application and R package for the analysis of aCGH data,
  \emph{PLoS ONE}, \bold{2}: e737.

  Ben-Yaacov, E. and Eldar, Y.C. (2008). A Fast and Flexible Method for
the Segmentation of aCGH Data, \emph{Bioinformatics}, \bold{24}: i139-i145.

}





\author{

The code for DNAcopy, HMM, BioHMM, and GLAD are basically wrappers
around the original functions by their corresponding authors, with some
modiffications for parallelization and usage of ff objects. The original
packages are: \code{DNAcopy}, \code{aCGH}, \code{snapCGH}, \code{cgh},
\code{GLAD}, respectively. The CGHseg method uses package
\code{tilingArray}.


HaarSeg has been turned into an R package, available from
\url{https://r-forge.r-project.org/projects/haarseg/}. That package
uses, at its core, the same R and C code as we do, from Ben-Yaacov and
Eldar. We have not used the available R package for historical reasons
(we used Eldar and Ben-Yaacov's C and R code in the former ADaCGH
package, before a proper R package was available).


For the wavelet-based method we have only wrapped the code that was
kindly provided by L. Hsu and D. Grove, and parallelized a few
calls. Their original code is included in the sources of the package.


Parallelization and modifications for using ff and additions are by
Ramon Diaz-Uriarte         
\email{rdiaz02@gmail.com}

}

\seealso{
  \code{\link{pChromPlot}},
  \code{\link{inputToADaCGH}}
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
##    You might want to adapt mc.cores to your hardware
haar.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat,
                                 merging = "MAD",
                                 mc.cores = 2)

## What does the output look like?
lapply(haar.RAM.fork, head)

## Where and what length are segments in first sample?
rle(haar.RAM.fork$outSmoothed[, 1])


## Repeat, without load-balancing
##    You might want to adapt mc.cores to your hardware
haar.RAM.fork.nlb <- pSegmentHaarSeg(cgh.dat, chrom.dat,
                                     merging = "MAD",
                                     loadBalance = FALSE,
                                     mc.cores = 2)


if(.Platform$OS.type != "windows") {

## We do not want this to run in Windows the automated tests since
## issues with I/O. It should work, though, in interactive usage


#####################################################
###
### Using forking with ff objects
###
#####################################################

### Note to windows users: under Windows, this will
### result in sequential execution, as forking is not
### available.



## Create a temp dir for storing output and ff objects.
## (Not needed, but cleaner).

dir.create("ADaCGH2_example_tmp_dir")
originalDir <- getwd()
setwd("ADaCGH2_example_tmp_dir")


## Get input data in ff format
## (we loaded the RData above, but we need to find the full path
##  to use it in the call to inputToADaCGH)

fname <- list.files(path = system.file("data", package = "ADaCGH2"),
                     full.names = TRUE, pattern = "inputEx.RData")

inputToADaCGH(ff.or.RAM = "ff",
                      RDatafilename = fname)


## Segment with HaarSeg

##    You might want to adapt mc.cores to your hardware    
haar.ff.fork <- pSegmentHaarSeg("cghData.RData",
                                "chromData.RData",
                                merging = "MAD",
                                mc.cores = 2)

## What does the output look like?
haar.ff.fork
## Note the warnings; we will be gentler in next example.


#####################################################
###
### Using a cluster with ff objects
###
#####################################################


## Start a socket cluster. Change the appropriate number of CPUs
## for your hardware and use other types of clusters (e.g., MPI)
## if you want.

cl2 <- parallel::makeCluster(2,"PSOCK")
parallel::clusterSetRNGStream(cl2)
parallel::setDefaultCluster(cl2) 
parallel::clusterEvalQ(NULL, library("ADaCGH2"))
## The following is not really needed if you create the cluster AFTER
## changing directories. But better to be explicit.
wdir <- getwd()
parallel::clusterExport(NULL, "wdir")
parallel::clusterEvalQ(NULL, setwd(wdir))



## Segment with HaarSeg

haar.ff.cluster <- pSegmentHaarSeg("cghData.RData",
                                   "chromData.RData",
                                   merging = "MAD",
                                   typeParall= "cluster")


## Avoid warnings by opening the objects
names(haar.ff.cluster)
open(haar.ff.cluster$outSmoothed)
open(haar.ff.cluster$outState)

## Alternatively, we can open the two ffdfs with lapply
## lapply(haar.ff.cluster, open)



##########################################
###
### Compare output (should be identical)
###
##########################################

all.equal(haar.ff.cluster$outSmoothed[ , ],
          haar.ff.fork$outSmoothed[ , ])

all.equal(haar.ff.cluster$outSmoothed[ , ],
          haar.RAM.fork$outSmoothed[ , ])

identical(haar.ff.cluster$outState[ , ],
          haar.ff.fork$outState[ , ])

identical(haar.ff.cluster$outState[ , ],
          haar.RAM.fork$outState[ , ])


#####################################################################
####
####                    Clean up actions
####
####  (These are not needed. They are convenient here, to prevent
####   leaving garbage in your hard drive. In "real life" you will
####   have to decide what to delete and what to store).
#####################################################################


### Explicitly stop cluster
parallel::stopCluster(cl2)

### All objects (RData and ff) are left in this directory
getwd()

### We will clean it up, and do it step-by-step
### BEWARE: DO NOT do this with objects you want to keep!!!

## Remove ff and RData for the data

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


## Remove ff and R objects with segmentation results

lapply(haar.ff.fork, delete)
rm(haar.ff.fork)

lapply(haar.ff.cluster, delete)
rm(haar.ff.cluster)


### Try to prevent problems in R CMD check
## Sys.sleep(2)

### Delete temp dir
setwd(originalDir)
## Sys.sleep(2)
unlink("ADaCGH2_example_tmp_dir", recursive = TRUE)
## Sys.sleep(2)
}
}

% #### Writing
% common <- cghE1[, 1:4]
% writeResults(hmm.out, cghE1[, 5:7], common)
% writeResults(glad.out, cghE1[, 5:7], common)        
% writeResults(cghseg.out, cghE1[, 5:7], common)   
% writeResults(ace.out.sum, cghE1[, 5:7], common)
% writeResults(wave.out, cghE1[, 5:7], common)
% writeResults(wave.nm.out, cghE1[, 5:7], common)
% writeResults(cbs.out, cghE1[, 5:7], common)
% writeResults(haar.out, cghE1[, 5:7], common)

% try(writeResults(psw.pos.out, common))
% try(writeResults(psw.neg.out, common))
% try(writeResults(biohmm.out, cghE1[, 5:6], common))



% segmentPlot(hmm.out, 
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% segmentPlot(glad.out,
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% segmentPlot(cghseg.out,
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% segmentPlot(wave.out, 
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% segmentPlot(wave.out, 
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% segmentPlot(haar.out,
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% segmentPlot(cbs.out, 
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")

% try(segmentPlot(psw.pos.out,
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs"))

% try(segmentPlot(psw.neg.out,
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs"))

% try(segmentPlot(biohmm.out, 
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs"))

% segmentPlot(ace.out.sum, 
%             geneNames = cghE1[, 1],
%             yminmax = yminmax,
%             idtype = "ug",
%             organism = "Hs")
% }


\keyword{ nonparametric }










%% Old examples, from old help


% ## Create a temp dir for storing output.
% ## (Not needed, but cleaner).

% dir.create("ADaCGH2_example_tmp_dir")
% originalDir <- getwd()
% setwd("ADaCGH2_example_tmp_dir")



% ## Start a socket cluster. Change the appropriate number of CPUs
% ## for your hardware

% snowfallInit(universeSize = 2, typecluster = "SOCK")

% ## Get input data in ff format

% ## To speed up R CMD check, we do not use inputEx1, but a much smaller
% ## data set. When you try the examples, you might want to use
% ## inputEx1 instead.

% \dontrun{

% fname <- list.files(path = system.file("data", package = "ADaCGH2"),
%                      full.names = TRUE, pattern = "inputEx1")
% }

% fname <- list.files(path = system.file("data", package = "ADaCGH2"),
%                      full.names = TRUE, pattern = "inputEx2")

% tableChromArray <- inputToADaCGH(filename = fname)



% ### Run all segmentation methods using ff objects and cluster

% cbs.out <- pSegmentDNAcopy("cghData.RData",
%                            "chromData.RData",
%                            typeParall = "cluster")
% cbs_mad.out <- pSegmentDNAcopy("cghData.RData",
%                            "chromData.RData", merging = "MAD",
%                            typeParall = "cluster")
% cbs_none.out <- pSegmentDNAcopy("cghData.RData",
%                            "chromData.RData", merging = "none",
%                            typeParall = "cluster")

% names(cbs.out)
% cbs.out$outState ## not the best way
% open(cbs.out$outSmoothed) ## better
% cbs.out$outSmoothed
% rle(cbs.out$outSmoothed[, 1])

% open(cbs_mad.out$outSmoothed)
% rle(cbs_mad.out$outSmoothed[, 1])



% biohmm_ml.out <- pSegmentBioHMM("cghData.RData",
%                            "chromData.RData",
%                            "posData.RData",
%                             merging = "mergeLevels",
%                             typeParall = "cluster")

% biohmm_mad.out <- pSegmentBioHMM("cghData.RData",
%                            "chromData.RData",
%                            "posData.RData",
%                             merging = "MAD",
%                            typeParall = "cluster")
% biohmm_mad_bic.out <- pSegmentBioHMM("cghData.RData",
%                            "chromData.RData",
%                            "posData.RData",
%                             merging = "MAD",
%                             aic.or.bic = "BIC",
%                            typeParall = "cluster")



% cghseg_ml.out <- pSegmentCGHseg("cghData.RData",
%                            "chromData.RData", merging = "mergeLevels",
% typeParall = "cluster")
% cghseg_mad.out <- pSegmentCGHseg("cghData.RData",
%                            "chromData.RData", merging = "MAD",
% typeParall = "cluster")
% cghseg_none.out <- pSegmentCGHseg("cghData.RData",
%                            "chromData.RData", merging = "none",
% typeParall = "cluster")




% ##############################################################
% ###
% ### Run all segmentation methods using forking with ff objects
% ###
% ##############################################################

% cbs.out.ff.fo <- pSegmentDNAcopy("cghData.RData",
%                            "chromData.RData")
% cbs_mad.ff.fo <- pSegmentDNAcopy("cghData.RData",
%                            "chromData.RData", merging = "MAD")
% cbs_none.ff.fo <- pSegmentDNAcopy("cghData.RData",
%                            "chromData.RData", merging = "none")



% hs_ml.out <- pSegmentHaarSeg("cghData.RData",
%                            "chromData.RData", merging = "mergeLevels")
% hs_mad.out <- pSegmentHaarSeg("cghData.RData",
%                            "chromData.RData", merging = "MAD")

% open(hs_ml.out[[2]])
% open(hs_mad.out[[2]])
% summary(hs_ml.out[[2]][,])
% summary(hs_mad.out[[2]][,])


% hmm_ml.out <- pSegmentHMM("cghData.RData",
%                            "chromData.RData", merging = "mergeLevels")
% hmm_mad.out <- pSegmentHMM("cghData.RData",
%                            "chromData.RData", merging = "MAD")
% hmm_mad_bic.out <- pSegmentHMM("cghData.RData",
%                            "chromData.RData", merging = "MAD",
%                             aic.or.bic = "BIC")

% ## we can open the two ffdfs in the list with lapply
% lapply(hmm_ml.out, open)
% lapply(hmm_mad.out, open)
% lapply(hmm_mad_bic.out, open)


% rle(hmm_ml.out[[2]][, 3])$lengths
% rle(hmm_mad.out[[2]][, 3])$lengths

% ## MAD and mergeLevels seem to make similar calls in second array
% rle(hmm_ml.out[[2]][, 2])$lengths
% rle(hmm_mad.out[[2]][, 2])$lengths

% ## but smoothed values are grouped differently
% rle(hmm_ml.out[[1]][, 2])$lengths
% rle(hmm_mad.out[[1]][, 2])$lengths

% ## And BIC leads to differences compared to AIC
% open(hmm_mad_bic.out[[2]])
% rle(hmm_mad_bic.out[[1]][, 2])$lengths
% rle(hmm_mad_bic.out[[2]][, 2])$lengths

% ### BioHMM is very slow and can crash
% \dontrun{
% biohmm_ml.out <- pSegmentBioHMM("cghData.RData",
%                            "chromData.RData",
%                            "posData.RData",
%                             merging = "mergeLevels")
% biohmm_mad.out <- pSegmentBioHMM("cghData.RData",
%                            "chromData.RData",
%                            "posData.RData",
%                             merging = "MAD")
% biohmm_mad_bic.out <- pSegmentBioHMM("cghData.RData",
%                            "chromData.RData",
%                            "posData.RData",
%                             merging = "MAD",
%                             aic.or.bic = "BIC")

% lapply(biohmm_ml.out, open)
% lapply(biohmm_mad.out, open)
% lapply(biohmm_mad_bic.out, open)

% summary(biohmm_ml.out[[2]][,])
% summary(biohmm_mad.out[[2]][,])
% summary(biohmm_mad_bic.out[[2]][,])

% summary(biohmm_ml.out[[1]][,])
% summary(biohmm_mad.out[[1]][,])
% summary(biohmm_mad_bic.out[[1]][,])
% }


% cghseg_ml.out <- pSegmentCGHseg("cghData.RData",
%                            "chromData.RData", merging = "mergeLevels")
% cghseg_mad.out <- pSegmentCGHseg("cghData.RData",
%                            "chromData.RData", merging = "MAD")
% cghseg_none.out <- pSegmentCGHseg("cghData.RData",
%                            "chromData.RData", merging = "none")

% lapply(cghseg_ml.out, open)
% lapply(cghseg_mad.out, open)
% lapply(cghseg_none.out, open)

% summary(cghseg_ml.out[[1]][,])
% summary(cghseg_mad.out[[1]][,])
% summary(cghseg_none.out[[1]][,])

% summary(cghseg_ml.out[[2]][,])
% summary(cghseg_mad.out[[2]][,])
% summary(cghseg_none.out[[2]][,])


% glad.out <- pSegmentGLAD("cghData.RData",
%                           "chromData.RData")


% waves_ml.out <- pSegmentWavelets("cghData.RData",
%                            "chromData.RData", merging = "mergeLevels")
% waves_mad.out <- pSegmentWavelets("cghData.RData",
%                            "chromData.RData", merging = "MAD")
% waves_none.out <- pSegmentWavelets("cghData.RData",
%                            "chromData.RData", merging = "none")

% lapply(waves_ml.out, open)
% lapply(waves_mad.out, open)
% lapply(waves_none.out, open)


% summary(waves_ml.out[[1]][,])
% summary(waves_mad.out[[1]][,])
% summary(waves_none.out[[1]][,])

% summary(waves_ml.out[[2]][,])
% summary(waves_mad.out[[2]][,])
% summary(waves_none.out[[2]][,])




% ##############################################################
% ###
% ### Run all segmentation methods using forking with RAM, in-RAM, objects
% ###
% ##############################################################

% ## First, create the data objects

% load(fname)
% cgh.dat <- inputEx2[, -c(1, 2, 3)]
% chrom.dat <- as.integer(inputEx2[, 2])
% pos.dat <- inputEx2[, 3]



% cbs.out.l.fo <- pSegmentDNAcopy(cgh.dat, chrom.dat)
% cbs_mad.l.fo <- pSegmentDNAcopy(cgh.dat, chrom.dat,merging = "MAD")
% cbs_none.l.fo <- pSegmentDNAcopy(cgh.dat, chrom.dat, merging = "none")



% hmm.d.f <- pSegmentHMM(cgh.dat, chrom.dat, merging = "mergeLevels")
% hmm.d.f.2 <- pSegmentHMM(cgh.dat, chrom.dat, merging = "MAD")



% hs.d.f <- pSegmentHaarSeg(cgh.dat, chrom.dat, merging = "mergeLevels")

% identical(hs_ml.out2[[1]][,], hs_ml.out[[1]][,])
% identical(hs_ml.out2[[2]][,], hs_ml.out[[2]][,])



% gl.d.f <- pSegmentGLAD(cgh.dat, chrom.dat)




% biohmm_ml.out <- pSegmentBioHMM(cgh.dat,
%                            chrom.dat,
%                            pos.dat,
%                             merging = "mergeLevels")
% biohmm_mad.out <- pSegmentBioHMM(cgh.dat,
%                            chrom.dat,
%                            pos.dat,
%                             merging = "MAD")
% biohmm_mad_bic.out <- pSegmentBioHMM(cgh.dat,
%                            chrom.dat,
%                            pos.dat,
%                             merging = "MAD",
%                             aic.or.bic = "BIC")




% cghseg_ml.out2 <- pSegmentCGHseg(cgh.dat,
%                                 chrom.dat,
%                                 merging = "mergeLevels")

% cghseg_mad.out2 <- pSegmentCGHseg(cgh.dat,
%                                 chrom.dat,
%                                 merging = "mergeLevels")

% cghseg_none.out2 <- pSegmentCGHseg(cgh.dat,
%                                 chrom.dat,
%                                 merging = "none")




% waves_ml.out2 <- pSegmentWavelets(cgh.dat,
%                            chrom.dat, merging = "mergeLevels")
% waves_mad.out2 <- pSegmentWavelets(cgh.dat,
%                            chrom.dat, merging = "MAD")
% waves_none.out2 <- pSegmentWavelets(cgh.dat,
%                            chrom.dat, merging = "none")



% ####
% ####+

% ##      cluster (not forking) with ff objects

% glad.out <- pSegmentGLAD("cghData.RData",
%                           "chromData.RData", typeParall = "cluster")

% hmm_ml.out <- pSegmentHMM("cghData.RData",
%                            "chromData.RData", merging = "mergeLevels",
%                           typeParall = "cluster")

% hmm_ml.out2 <- pSegmentHMM("cghData.RData",
%                            "chromData.RData", merging = "MAD",
%                           typeParall = "cluster")








% ############## Clean up actions
% ####  (These are not needed. They are convenient here, to prevent
% ####   leaving garbage in your hard drive. In "real life" you will
% ####   have to decide what to delete and what to store).



% ### Explicitly stop cluster
% sfStop()


% ### All objects (RData and ff) are left in this directory
% getwd()

% ### We will clean it up, and do it step-by-step
% ### BEWARE: DO NOT do this with objects you want to keep!!!

% ## Remove ff and RData for the data

% load("chromData.RData")
% load("posData.RData")
% load("cghData.RData")

% delete(cghData); rm(cghData)
% delete(posData); rm(posData)
% delete(chromData); rm(chromData)
% unlink("chromData.RData")
% unlink("posData.RData")
% unlink("cghData.RData")
% unlink("probeNames.RData")


% ## Remove ff and R objects with segmentation results

% lapply(cbs.out, delete)
% rm(cbs.out)

% lapply(cbs_mad.out, delete)
% rm(cbs_mad.out)

% lapply(cbs_none.out, delete)
% rm(cbs_none.out)

% lapply(hs_ml.out, delete)
% rm(hs_ml.out)

% lapply(hs_mad.out, delete)
% rm(hs_mad.out)

% lapply(hmm_ml.out, delete)
% rm(hmm_ml.out)

% lapply(hmm_mad.out, delete)
% rm(hmm_mad.out)

% lapply(hmm_mad_bic.out, delete)
% rm(hmm_mad_bic.out)

% lapply(cghseg_ml.out, delete)
% rm(cghseg_ml.out)

% lapply(cghseg_mad.out, delete)
% rm(cghseg_mad.out)

% lapply(cghseg_none.out, delete)
% rm(cghseg_none.out)

% lapply(glad.out, delete)
% rm(glad.out)

% lapply(waves_mad.out, delete)
% rm(waves_mad.out)

% lapply(waves_ml.out, delete)
% rm(waves_ml.out)

% lapply(waves_none.out, delete)
% rm(waves_none.out)


% \dontrun{
% ## Execute only if you run the BioHMM examples
% lapply(biohmm_ml.out, delete)
% rm(biohmm_ml.out)
% lapply(biohmm_mad.out, delete)
% rm(biohmm_mad.out)
% lapply(biohmm_mad_bic.out, delete)
% rm(biohmm_mad_bic.out)
% }

% ### Try to prevent problems in R CMD check
% Sys.sleep(2)
% ### To prevent CMD check from crashing after cleanEx
% detach("package:rlecuyer", unload = TRUE)


% ### Delete temp dir
% setwd(originalDir)
% Sys.sleep(2)
% unlink("ADaCGH2_example_tmp_dir", recursive = TRUE)
% Sys.sleep(2)

% }

