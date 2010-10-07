
\name{snowfallInit}
\alias{snowfallInit}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Initialize a cluster of workstations using snowfall
}

\description{ With either MPI or sockets, use snowfall to initialize a
  cluster to have ADaCGH2 run in parallel. Check possible errors during
  initialization.  }

\usage{
snowfallInit(universeSize = NULL, wdir = getwd(), 
             minUniverseSize = 2, exit_on_fail = FALSE, 
             maxnumcpus = 500, typecluster = "SOCK", 
             socketHosts = NULL,
             RNG = "RNGstream")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{universeSize}{Desired size of cluster (number of CPUs). Can be
    set to NULL. See details.
  }
  \item{wdir}{The common ---e.g., NFS mounted resource, a directory in
    your machine if running on only one computer, etc --- directory. We need a
    common directory for the graphics and ff files so that they are all found in the
    same location.
  }
  \item{minUniverseSize}{The minimal LAM/MPI universe for the function to
    return successfully. If the function determines that the available
    number of slaves is smaller than minUniverseSize it will fail (if
    exit\_on\_fail = TRUE) or give a warning.
  }
  \item{exit_on_fail}{If TRUE, kills R session if it cannot run
    succesfully. Setting it to TRUE is something you probably only want
    to do when running as an unattended service.    
  }
  \item{maxnumcpus}{
    Passed directly to snowfall. This is the new value of
    \code{\link[snowfall]{sfSetMaxCPUs}} set to a very large number to allow us
    to use large clusters.
  }
  \item{typecluster}{Either "MPI" or "SOCK". To use MPI, BEFORE calling
    this function you must configure your MPI environment properly and
    then load the R package \pkg{Rmpi}.
  }
  \item{socketHosts}{
    Passed to \code{\link[snowfall]{snowfall-init}}.
  }
  
  \item{RNG}{The type of random number generator. One of "RNGstream" (to
    use \pkg{rlecuyer}) or "SPRNG" (to use the \pkg{rsprng} package). If
    the generator requested is not available, the function tries to use
    the other one (givin a warning). To use either of these you need to
    have the appropriate package installed.}  }


\details{This function is designed to be used mainly with MPI, but
  clusters with sockets might be easier to create in any operating
  system without additional software. Moreover, installing Rmpi in
  Windows and Mac is not easy. Thus, by default, the cluster is one of
  sockets, and Rmpi is listed in "Enhances" (not "Depends" nor
  "Suggests"). But this function will fail if you try to use an MPI
  cluster and do not have \pkg{Rmpi} loaded. Moreover, even if you
  successfully install and load \pkg{Rmpi}, note that the cluster that
  gets created by default might not be the want you want (e.g., you
  might end up with a universe size of one), so it is up to you to
  configure and, if appropriate, start/boot your MPI environment before
  loading \pkg{Rmpi}.

  When using MPI, the recommended usage is to set only minUniverseSize,
  leaving "universeSize" as NULL. Then, the cluster will use as many
  nodes as available to MPI (found from "mpi.universe.size()"), or fail
  if the available number of nodes is less than minUniverseSize. This
  usage makes sense in many clusters where the actual number of nodes
  available can vary, but you definitely do not want to run a job unless
  a minimal number of nodes can be used. (Moreover, mpi.universe.size
  returning a very small number can be an indication of a configuration
  file problem).
  
  If "universeSize" is set, this will be the number of nodes of the
  cluster (unless you are using MPI and mpi.universe.size is smaller, in
  which case the function will fail).

  
}
\value{
  This function is used to create a cluster.
}
% \references{
% %% ~put references to the literature/web site here ~
% }
\author{
Ramon Diaz-Uriarte \email{rdiaz02@gmail.com} 
}

% \seealso{
% %% ~~objects to See Also as \code{\link{help}}, ~~~
% }
\examples{
snowfallInit(universeSize = 2, typecluster = "SOCK")

\dontrun{
## If you are using MPI, a better approach would be
snowfallInit(minUniverseSize = 4, typecluster = "MPI")
## where minUniverseSize is set to whatever
## you regard as an unacceptable minimum
}

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{programming}
