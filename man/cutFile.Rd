\name{cutFile}
\alias{cutFile}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Cut a file and return individual columns}

\description{ A text file is split by individual columns, creating as
  many files as individual columns. Splitting is used using multiple
  cores, if available.  Specified columns are renamed as ID.txt,
  Chrom.txt, Pos.txt, and other columns can be deleted. The individual
  files can then all be read from a given directory with
  \code{inputToADaCGH}.  }

\usage{
cutFile(filename,
        id.col,
        chrom.col,
        pos.col,
        sep = "\t",
        cols = NULL, 
        mc.cores = detectCores(),
        delete.columns = NULL,
        fork = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{

  \item{filename}{Name of the text file with the data. The file contains
  at least a column for probe ID, a column for Chromosome, and a column
  for position, and one or more for data. The column is expected to have
  a first row with an identifier. All columns are to be separated by a
  single separating ccharacter \code{colsep}.}
  
  \item{id.col}{The number of the column (starting from 1) that should
    be used as ID. This is the name before any columns are possibly
    deleted (see argument \code{delete.columns}).}
  
  \item{chrom.col}{The number of the column (starting from 1) that
    should be used as the identifier for Chromosome. This is the name
    before any columns are possibly deleted (see argument
    \code{delete.columns}).}
  
  \item{pos.col}{The number of the column (starting from 1) that should
    be used as the position (the coordinates). This is the name before any
    columns are possibly deleted (see argument \code{delete.columns}).}
  
  \item{cols}{The number of columns of the file. If not specified, we
    try to guess it. But guessing can be dangerous.}


  \item{sep}{The field or column separator, similar to \code{sep} in
    \code{read.table}, etc. The default is a tab. A space can be
    specified as 'sep = " "'. If you use the default in, say,
    \code{read.table}, which is 'sep = ""', then multiple
    consecutive tab or space field separators are taken as one ---this
    is also the behavior in \code{read.table} or awk, which is what we
    use.}
  
  \item{mc.cores}{The number of processes to launch simultaneously.}
  
  \item{delete.columns}{The number of the columns (starting from 1) that
    you do not want to preserve. You probably do not want to have too
    many of these, and if you do you should note that the file is cut
    into pieces BEFORE dealing with the unwanted columns so many
    unwanted columns will mean that we are doing many unwanted calls to
    cut.}


  \item{fork}{Should we fork R processes, via mclapply, or just send
  several system commands from this R process. The default (FALSE) is
  probably the most reasonable option for large files.}


}
\details{ This function is unlikely to work under Windows unless MinGW
  or similar are installed (and even then it might not work). This
  function should work under Mac OS, and it does in the machines we've
  tried it, but it seems not to work on the BioC testing machine.

  
  This function basically calls "head" and "awk" using \code{system},
  and trying to divide all the jobs into as many cores as you specify
  (argument \code{cores}). %% There
  %% are many ways in which this function can fail.
}

\value{

  This function is used for it main effect: cutting a file into
  individual one-column files. These files are names "col_1.txt",
  "col_2.txt", etc, and there are three called "ID.txt", "Chrom.txt",
  "Pos.txt". The files are created in the current working directory.

  As we move the files corresponding to "ID", "Chrom", and "Position",
  the stdout output is shown to the user (to check that things worked).
  
  After calling this function, you can call
  \code{\link{inputToADaCGH}}.  }

% \references{
% %% ~put references to the literature/web site here ~
% }


%% \note{ Converting a very large RData can be memory consuming. Since this
%%   function is mainly used for its side effects, it can be run in a
%%   separate process that will then be killed. See examples and comments
%%   in the vignette.}


\author{Ramon Diaz-Uriarte \email{rdiaz02@gmail.com}}


% \seealso{
% %% ~~objects to See Also as \code{\link{help}}, ~~~
% }
\examples{

## Read a tab separated file, and assign the first,
## second, and third positions to ID, Chrom, and Position

if( (.Platform$OS.type == "unix") && (Sys.info()['sysname'] != "Darwin") ) {
## This will not work in Windows, and might, or might not, work under Mac

fnametxt <- list.files(path = system.file("data", package = "ADaCGH2"),
                         full.names = TRUE, pattern = "inputEx.txt")
cutFile(fnametxt, 1, 2, 3, sep = "\t")

## Verify we have ID, Chrom, Pos
c("ID.txt", "Chrom.txt", "Pos.txt") \%in\% list.files(getwd())

## verify some other column

c("col_5.txt") \%in\% list.files(getwd())

## Read a white space separated file, and assign the first, second, and
## third positions to ID, Chrom, and Position, but remove the fifth
## column

fnametxt2 <- list.files(path = system.file("data", package = "ADaCGH2"),
                         full.names = TRUE, pattern = "inputEx-sp.txt")
cutFile(fnametxt2, 1, 2, 3, sep = " ", delete.columns = 5)

}
}

\keyword{ IO }
