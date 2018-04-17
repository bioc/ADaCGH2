\name{inputToADaCGH}
\alias{inputToADaCGH}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Convert CGH data to ff or RAM objects for use with ADaCGH2}
\description{
  Input data with CGH data are converted to several ff files and
  data checked for potential errors and location duplications.
}
\usage{
inputToADaCGH(ff.or.RAM = "RAM",
                      robjnames = c("cgh.dat", "chrom.dat",
                                   "pos.dat", "probenames.dat"),
                      ffpattern = paste(getwd(), "/", sep = ""),
                      MAList = NULL,
                      cloneinfo = NULL,
                      RDatafilename = NULL,
                      textfilename = NULL,
                      dataframe = NULL,
                      path = NULL,
                      excludefiles = NULL,
                      cloneinfosep = "\t",
                      cloneinfoquote = "\"",
                      minNumPerChrom = 10,
                      verbose = FALSE,
                      mc.cores = floor(detectCores()/2))

}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{ff.or.RAM}{ Whether you want to store the output as \code{ff}
    or RAM objects ("usual" R objects, such as data frames and vectors).  }

  \item{robjnames}{Name of the objects that will be created in you use
  \code{ff.or.RAM = "RAM"}. If the names existing in the environment
  from where the function is called, they will not be overwritten, and
  the function will abort. }

  
  \item{ffpattern}{ See argument \code{pattern} in
    \code{\link[ff]{ff}}. The default is to create the "ff" files in the
    current working directory. }

  \item{MAList}{The name of an object of class \code{MAList}
    %% (\code{\link[limma]{as.MAList}})
    (\code{\link[limma]{MAList-class}})
    or \code{SegList} (e.g.,
    \code{\link{dim.SegList}}). See vignnettes for these
    packages for details about these objects.
    
    You have to specify one, and only one, of \code{MAList},
    \code{RDatafilename}, \code{textfilename}, \code{path}.
  }

  \item{cloneinfo}{A character vector with the full path to a file that
    conforms to the characteristics of \code{file} in function
    \code{\link[snapCGH]{read.clonesinfo}} (see details in the vignette)
    or the name of a data frame with at least a column named "Chr" (with
    chromosomal informtaion) and "Position".

    This is only needed if you use \code{MAList} and your MAList object
    does not have Position and Chr columns.}

  \item{RDatafilename}{ Name of data RData file that contains the data frame
    with original, non-ff, data. Note: this is the name of the RData file
    (possibly including path), NOT the name of the data frame. (For
    that, look at \code{dataframe}).
    
    The first three columns of the data frame are the IDs of the probes,
    the chromosome number, and the position, and all remaining columns
    contain the data for the arrays, one column per array. The names of
    the first three column do not matter, but the order does. Names of the
    remaining columns will be used if existing; otherwise, fake array
    names will be created.

    You have to specify one, and only one, of \code{MAList},
    \code{RDatafilename}, \code{textfilename}, \code{path}.

  }

  \item{textfilename}{The name of a text file with the data. It should
    be a tab separated file, with a header.
    The first three columns of the data frame are the IDs of the probes,
    the chromosome number, and the position, and all remaining columns
    contain the data for the arrays, one column per array. The names of
    the first three column do not matter, but the order does. Names of the
    remaining columns will be used if existing; otherwise, fake array
    names will be created.


    You have to specify one, and only one, of \code{MAList},
    \code{RDatafilename}, \code{textfilename}, \code{path}.
    
  }

  \item{dataframe}{The name of a data frame with the data.
    The first three columns of the data frame are the IDs of the probes,
    the chromosome number, and the position, and all remaining columns
    contain the data for the arrays, one column per array. The names of
    the first three column do not matter, but the order does. Names of the
    remaining columns will be used if existing; otherwise, fake array
    names will be created.
  }

  
  \item{path}{The name of the directory (the full path) to where each of
  the individual, one-column, files are. We will read ALL of the files
  in this directory, except for those listed under
  \code{excludefiles}. One file has to be named "ID.txt", another
  "Chrom.txt", and a third "Pos.txt". The rest of the files can be named
  any way you want and those are the files that contain the CGH data.

  All of the files are expected to be one-column text files, with a
  first row with a header. The header will not be used for "ID.txt",
  "Chrom.txt", or "Pos.txt", but the header will be used as the name of
  the array/subject for the CGH data files.

    You have to specify one, and only one, of \code{MAList},
    \code{RDatafilename}, \code{textfilename}, \code{path}.

  }
  \item{excludefiles}{If you have specified \code{path}, names of files
  not to be read. A vector of strings. These should be the names of the
  files, without path information (as all of the files are in the same
  directory, as specified by \code{path}).
  }
  \item{cloneinfosep}{Argument to \code{\link{read.table}} if reading a
    \code{cloneinfo} file. Note: this is NOT used if reading a text file
  given in \code{textfilename}.}

  \item{cloneinfoquote}{Argument to \code{\link{read.table}} if reading a
    \code{cloneinfo} file. Note: this is NOT used if reading a text file
  given in \code{textfilename}.}

  % \item{na.omit}{Omit NAs? If there are NAs and na.omit is set to FALSE,
  %   the function will stop with an error (if you read from an RData
  %   file; rows with NAs are always excluded when reading from a txt
  %   file).

  %   Beware that with very large data sets, say 1000 columns times 5
  % million rows, if you use as input a RData object, you will probably
  % get an error related to our using \code{na.omit} on a huge data
  % frame. In these cases, you probably want to use as input a text file.
  % }
  
  \item{minNumPerChrom}{If any chromosome has fewer observations than
  minNumPerChrom the function will fail. This can help detect upstream
  pre-processing errors.}

\item{verbose}{If TRUE, provide additional information that can be
  useful to debug problems. Right now it provides the list of files that
  will be read if using a directory. The default is FALSE.}

\item{mc.cores}{The number of cores to use when reading files. This is
  always 1 in Windows. See details about the number of cores in
  \code{\link{mclapply}} and
  \code{\link[parallel]{detectCores}}. Contention problems in I/O might
  be minimized by making this number smaller or much smaller than what
  is returned by \code{\link[parallel]{detectCores}}. For larte jobs,
  please do some initial benchmarking. See comments and discussion in
  file "benchmark.pdf". In general, if you have a single SATA disk make
  this a small number (say, 2 or 3 or 6); in contrast, if you have many fast
  SAS disks in a RAID0 or RAID10 array, you can increase the number
  quite a bit (but generally always well below what detectCores
  gives). }

}
\details{
  If there are identical positions (in the same chromosome) a small
  random uniform variate is added to get unique locations.


  We carry out several checks (e.g., no duplicated
  positions), but note that we DO NOT check for extremely large or small
  values, and this includes NOT CHECKING for infinite values.


  Missing values are allowed in the data columns. However, we do not
  check for missing values in the ID, chromosome, or position columns,
  except if you are using as input an RData file or MA list. You better
  not have any missing values there; otherwise, things will break in
  strange ways. Why this inconsistency? Checking for missing values can
  consume a lot of resources (CPU and memory). If your are really huge,
  they will probably be stored as text files, and you are expected to
  use the appropriate tools there to filter (e.g., sed, awk,
  whatever). If they exist as an MA list or an RData file, they once
  fitted in RAM, so checking for these NAs is probably reasonable. 

  
  If you provide a text file as input (\code{textfilename}), the reading
  operation is carried out using \code{\link[ff]{read.table.ffdf}}, to
  allow for reading very large files. Using this option, however, does
  not force you to produce as output \code{ff} objects.

  
  
  Commented examples of reading objects from \pkg{limma} and
  \pkg{snapCGH} are provided in the vignnette.
  %%  ~~ If necessary, more details than the description above ~~
}

\value{

  This function is used mainly for its side effects: writing either
  several \code{ff} files to the current working directory, or several
  RAM objects (the usual, in memory, local, R objects). The actual names
  are printed out.  
  
  %% Since we need to manipulate the complete set of original data, the
  %% return value is a data frame that could be used later to speed up
  %% certain calculations. Right now, however, this is not used for
  %% anything, except for information purposes.  This table is similar to a
  %% dictionary or hash table.  This data frame has (number of arrays *
  %% number of chromosomes) rows. The columns are
  
  %% \item{Index}{The integer index of the entry, 1:number of
  %%   arrays * number of chromosomes}
  %% \item{ArrayNum}{The array number}
  %% \item{Arrayname}{The name of the array}
  %% \item{ChromNum}{The chrosome number}
  %% \item{ChromName}{The chromosome name. Yes, chromosome must be numeric,
  %%   but the values of ChromNum form a set of integers starting at one and
  %%   going up to the total number of different chromosomes. E.g., if you
  %%   only have two chromosomes, say 3 and 22, ChromNum contains values 1
  %%   and 2, whereas ChromName contains values 3 and 22.}
  %% \item{posInit}{The first position (in a vector ordered from 1 to total
  %%   number of probes, with probes ordered by chromosome and position
  %%   within chromosome) of a probe of this chromosome.}
  %% \item{posEnd}{The last position of a probe of this chromosome.}

  %% Further details: this object is created inside several of the pSegment
  %% functions to distribute and speed up the parallel jobs. We call a
  %% function that is called by inputToADaCGH itself. Recreating
  %% this object is not really needed if you are using ff objects, but
  %% creating it is very fast anyway, and passing the object or creating it
  %% depending on whether you use ff or not would be a lot more cumbersome
  %% for the user.

}

% \references{
% %% ~put references to the literature/web site here ~
% }


%% \note{ Converting a very large RData can be memory consuming. Since this
%%   function is mainly used for its side effects, it can be run in a
%%   separate process that will then be killed. See examples and comments
%%   in the vignette.}
%%  No longer the case.

\author{Ramon Diaz-Uriarte \email{rdiaz02@gmail.com}}


\seealso{
  \code{\link{cutFile}} for obtaining files in the format needed if you  read from a directory.
}
%%
\examples{


## Create a temp dir for storing output.
## (Not needed, but cleaner).
dir.create("ADaCGH2_example_input_dir")
originalDir <- getwd()
setwd("ADaCGH2_example_input_dir")
## Sys.sleep(1)

## Get location (and full filename) of example data file
fnameRData <- list.files(path = system.file("data", package = "ADaCGH2"),
                         full.names = TRUE, pattern = "inputEx.RData")

fnametxt <- list.files(path = system.file("data", package = "ADaCGH2"),
                         full.names = TRUE, pattern = "inputEx.txt")

namepath <- system.file("example-datadir", package = "ADaCGH2")

## Read from RData and write to ff
inputToADaCGH(ff.or.RAM = "ff",
                      RDatafilename = fnameRData)

## Read from text file and write to ff
inputToADaCGH(ff.or.RAM = "ff",
                      textfilename = fnametxt)


## Read from text file and write to RAM
inputToADaCGH(ff.or.RAM = "RAM",
                      textfilename = fnametxt)

## Read from a directory and write to ff
inputToADaCGH(ff.or.RAM = "ff",
                      path = namepath)

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


### Running in a separate process. Only makes sense
### if returning ff objects (ff.or.RAM = "ff")
### This example will not work on Windows

\dontrun{
mcparallel(inputToADaCGH(ff.or.RAM = "ff",
                                 RDatafilename = fnameRData),
                                 silent = FALSE)
  tableChromArray <- mccollect()
  if(inherits(tableChromArray, "try-error")) {
    stop("ERROR in input data conversion")
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
}

### Try to prevent problems in R CMD check
## Sys.sleep(2)

### Delete temp dir
setwd(originalDir)
## Sys.sleep(2)
unlink("ADaCGH2_example_input_dir", recursive = TRUE)
## Sys.sleep(2)

}
\keyword{ IO }






% FIXME: and RData -> RAM? This would be silly. But do something about it?
% It works (seems to work)
% inputToADaCGH(ff.or.RAM = "RAM",
%                       RDatafilename = fnameRData)

