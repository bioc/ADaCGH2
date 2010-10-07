\name{inputDataToADaCGHData}
\alias{inputDataToADaCGHData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Convert CGH data to ff data frames}
\description{
  An input data frame with CGH data is converted to several ff files and
  data checked for potential errors and location duplications.
}
\usage{
inputDataToADaCGHData(ffpattern = paste(getwd(), "/", sep = ""),
                      MAList = NULL,
                      cloneinfo = NULL,
                      filename = NULL,
                      sep = "\t",
                      quote = "\"",
                      na.omit = FALSE,
                      minNumPerChrom = 10)

}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{ffpattern}{ See argument \code{pattern} in
    \code{\link[ff]{ff}}. The default is to create the "ff" files in the
    current working directory. }

  \item{MAList}{The name of an object of class \code{MAList}
    (\code{\link[limma]{as.MAList}}) or \code{SegList} (e.g.,
    \code{\link[snapCGH]{dim.SegList}}). See vignnettes for these
    packages for details about these objects.}
  \item{cloneinfo}{A character vector with the full path to a file that
    conforms to the characteristis of \code{file} in function
    \code{\link[snapCGH]{read.clonesinfo}} (see details in the vignette)
    or the name of a data frame with at least a column named "Chr" (with
    chromosomal informtaion) and "Position".}

  \item{filename}{ Name of data RData file that contains the data frame
    with original, non-ff, data. Note: this is the name of the RData file
    (possibly including path), NOT the name of the data frame.
    
    The first three columns of the data frame are the IDs of the probes,
    the chromosome number, and the position, and all remaining columns
    contain the data for the arrays, one column per array. The names of
    the first three column do not matter, but the order does. Names of the
    remaining columns will be used if existing; otherwise, fake array
    names will be created.
  }
  \item{sep}{Argument to \code{\link{read.table}} if reading a
    \code{cloneinfo} file.}

  \item{quote}{Argument to \code{\link{read.table}} if reading a
    \code{cloneinfo} file.}

  \item{na.omit}{Omit NAs? If there are NAs and na.omit is set to FALSE,
    the function will stop with an error.}
  
  \item{minNumPerChrom}{If any chromosome has fewer observations than
  minNumPerChrom the function will fail. This can help detect upstream
  pre-processing errors.}

}
\details{
  If there are identical positions (in the same chromosome) a small
  random uniform variate is added to get unique locations.

  Commented examples of reading objects from \pkg{limma} and
  \pkg{snapCGH} are provided in the vignnette.
  %%  ~~ If necessary, more details than the description above ~~
}
\value{
  This function is used mainly for its side effects: writing several ff
  files to the current working directory (the actual names are printed
  out).
  
  In addition, and since we need to manipulate the complete set of
  original data, the return value is a data frame that is could be used
  later to speed up certain calculations. Right now, however, this is
  not used for anything, except for information purposes.
  This table is similar to a dictionary or
  hash table.  This data frame has (number of
  arrays * number of chromosomes) rows. The columns are
  
  \item{Index}{The integer index of the entry, 1:number of
    arrays * number of chromosomes}
  \item{ArrayNum}{The array number}
  \item{Arrayname}{The name of the array}
  \item{ChromNum}{The chrosome number}
  \item{ChromName}{The chromosome name. Yes, chromosome must be numeric,
    but the values of ChromNum form a set of integers starting at one and
    going up to the total number of different chromosomes. E.g., if you
    only have two chromosomes, say 3 and 22, ChromNum contains values 1
    and 2, whereas ChromName contains values 3 and 22.}
  \item{posInit}{The first position (in a vector ordered from 1 to total
    number of probes, with probes ordered by chromosome and position
    within chromosome) of a probe of this chromosome.}
  \item{posEnd}{The last position of a probe of this chromosome.}
}

% \references{
% %% ~put references to the literature/web site here ~
% }


\note{
  Converting a very large data set into a set of ff files can be memory
  consuming. Since this function is mainly used for its side effects
  (leaving the ff files in the disk), it
  can be run in a separate process that will then be killed. See an
  example below.
}


\author{Ramon Diaz-Uriarte \email{rdiaz02@gmail.com}}


% \seealso{
% %% ~~objects to See Also as \code{\link{help}}, ~~~
% }
\examples{

fname <- list.files(path = system.file("data", package = "ADaCGH2"),
                     full.names = TRUE, pattern = "inputEx1")
tableChromArray <- inputDataToADaCGHData(filename = fname)


### Running in a separate process
  if(require(multicore)) {
  parallel(inputDataToADaCGHData(filename = fname), silent = FALSE)
  tableChromArray <- collect()[[1]]
  if(inherits(tableChromArray, "try-error")) {
    stop("ERROR in input data conversion")
  }
}

}
\keyword{ IO }
