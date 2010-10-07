### FIXME: comment out nodeWhere!!!
### do I want put.part.rdata.together in the package??

### FIXME: if using fork or parallel, probably don't want
##  to call quit.


## .__ADaCGH_WEB_APPL <- TRUE in web appl!
if(exists(".__ADaCGH_WEB_APPL", env = .GlobalEnv))
{
  warningsForUsers <- vector()
#  running.as.web.adacgh <- TRUE
} else if (exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv)) {
  warningsForUsers <- vector()
#  running.as.web.adacgh <- FALSE
} else {
#  running.as.web.adacgh <- FALSE
  warningsForUsers <- warning
}

mydcat <- function(x) {
  cat("\n", x, "\n")
}


mydcat2 <- function(x) {
  cat("\n ")
  cat(deparse(substitute(x)))
  cat("\n", x, "\n")
}

mydcat3 <- function() {
  ## to understand where are arguments from, etc
  ## with papply in slaves
  cat("\n parent frame \n")
  print(parent.frame())
  cat("\n environment \n")
  print(environment())
  cat("\n parent.env \n")
  print(parent.env(environment()))

  cat("\n PID \n")
  print(Sys.getpid())
}

names.formals.changepoints.1.18 <- c("genomdat",
                                     "data.type",
                                     "alpha",
                                     "weights",
                                     "sbdry",
                                     "sbn",
                                     "nperm",
                                     "p.method",
                                     "min.width",
                                     "kmax",
                                     "nmin",
                                     "trimmed.SD",
                                     "undo.splits",
                                     "undo.prune",
                                     "undo.SD",
                                     "verbose",
                                     "ngrid",
                                     "tol")

## in v.1.18.0 we take advantage weights has default of NULL in changepoints

vDNAcopy <- package_version(packageDescription("DNAcopy")$Version)
if (vDNAcopy >= "1.17.1")
  {
    cat("Setting adacgh_changepoints to DNAcopy:::changepoints\n")
    adacgh_changepoints <- DNAcopy:::changepoints
    cat("Setting adacgh_trimmed.variance to DNAcopy:::trimmed.variance\n")
    adacgh_trimmed.variance <- DNAcopy:::trimmed.variance
  } else {
    cat("Setting adacgh_changepoints to changepoints\n")
    adacgh_changepoints <- changepoints
    cat("Setting adacgh_trimmed.variance to trimmed.variance\n")
    adacgh_trimmed.variance <- trimmed.variance
  }

if(vDNAcopy >= "1.18.0") {
  names.formals.changepoints <- names.formals.changepoints.1.18
} else {
  names.formals.changepoints <- names.formals.changepoints.1.17
}

if(!identical(names.formals.changepoints, names(formals(adacgh_changepoints)))) {
  m1 <- "Arguments to DNAcopy function changepoints have changed.\n"
  m2 <- "Either your version of DNAcopy is newer than ours, or older.\n"
  m3 <- "If your version is different from 1.18.0 or 1.19.0 o 1.20.0\n please let us know of this problem.\n"
  m4 <- "We are assuming you are using DNAcopy version 1.18.0 or 1.19.0 or 1.20.0,\n"
  m6 <- paste("Your version of DNAcopy is ", packageDescription("DNAcopy")$Version, ".\n")
  mm <- paste(m1, m2, m3, m4, m5, m6)
  stop(mm)
}


## As of v. 1.12 at least snapCGH finally has a namespace. So now we have
## to do

if(package_version(packageDescription("snapCGH")$Version) > "1.11") {
  myfit.model <- snapCGH:::fit.model
} else {
  myfit.model <- fit.model
}


## becasue even if fit.model is documented, it is NOT exported.
## Well, they get away with it because there are no executable examples
## in the help for fit.model.



    

snowfallInit <- function(universeSize = NULL, 
                         wdir = getwd(), minUniverseSize = 2,
                         exit_on_fail = FALSE,
                         maxnumcpus = 500,
                         typecluster = "SOCK",
                         socketHosts = NULL,
                         RNG = "RNGstream") {

  sfSetMaxCPUs <- maxnumcpus
  trythis <- try({
    require(snowfall)
    if(! is.null(universeSize))
      minUniverseSize <- universeSize

    if(typecluster == "MPI") {
      if(! ("package:Rmpi" %in% search()))
        stop("To use MPI, configure your MPI environment and ",
             "load the Rmpi package")
      ## We do not want a "require(Rmpi) because this will
      ## almost always lead to undesider configurations
      if(mpi.universe.size() < minUniverseSize) {
        if(exit_on_fail)
          stop("MPI problem: universe size < minUniverseSize")
        else
          warning("MPI problem: universe size < minUniverseSize")
      }
      if(! is.null(universeSize)) {
        sfInit(parallel = TRUE, cpus = minUniverseSize, type = "MPI")
      } else {
        sfInit(parallel = TRUE, cpus = mpi.universe.size(), type = "MPI")
      }
    } else { ## sockets
      sfInit(parallel = TRUE, cpus = minUniverseSize, type = "SOCK",
               socketHosts = socketHosts)
    }

    sfClusterEval(rm(list = ls(env = .GlobalEnv), envir =.GlobalEnv))
    rngenerators <- c("SPRNG", "RNGstream")
    t1 <- try(sfClusterSetupRNG(type = RNG))
    if(inherits(t1, "try-error")) {
      othergen <- setdiff(rngenerators, RNG)
      t2 <- try(sfClusterSetupRNG(type = othergen))
      if(inherits(t2, "try-error"))
        stop("No suitable random number generator found for the cluster. ",
             "Please install the packages rsprng or rlecuyer")
      else
        warning("You requested random number generator ", RNG,
                " but it was not available.  ",
                "Using ", othergen, " instead.")
    }
      
    
    sfExport("wdir")
    setwd(wdir)
    sfClusterEval(setwd(wdir))
    sfLibrary("ADaCGH2", character.only = TRUE)
  })
  if(inherits(trythis, "try-error")) {
    cat("\nSnowfall error\n", file = "Status.msg")
    if(exit_on_fail) quit(save = "yes", status = 12, runLast = FALSE)
  } 
}

  
## Watch out for possible confusion:
## cghRdataName is the NAME of the RData file
##

nodeWhere <- function(nodeMessage) {
  ## this is a debugging function, etc
  if(is.null(nodeMessage)) nodeMessage <- ""
  nodeMessage <- paste("nodeWhere", nodeMessage, sep = "_")
  fn <- paste(nodeMessage, paste(sample(letters,8), sep = "", collapse = ""),
              sep = "_")
  
  capture.output(print(nodeMessage), file = fn)
  capture.output(cat("\n HOSTNAME IS "), file = fn, append = TRUE)
  capture.output( {
    print(system("hostname", intern = TRUE))
    print(date())
    
    gcmessage("     .... internal gc is ")
    
    ## Problem is: we get function arguments
    cat("\n Memory sizes this level\n ")
    sizesobj(6) ## 'cause we are deep down within caputre, function call, 
    cat("\n\n Memory sizes one level up\n ")
    sizesobj(7)
  }, file = fn, append = TRUE)
  
}

gcmessage <- function(text) {
  cat("\n ", text, "\n")
  print(gc())
}

mysize <- function(x) {
  cat("\n Size of object ", deparse(substitute(x)), ": ",
      round(object.size(x)/10^6, 1), "MB \n")
  
}

sizesobj <- function(n = 1,  minsizeshow = 0.5) {
  ## n: how far up to go
  l1 <- ls(env = parent.frame(n = n))
  if(length(l1) > 0) {
   
    ## The following does not work reliably, probably because
    ## of name passing issues in sapply, function(x) etc
    ## r1 <- sapply(l1,
    ##              function(x)
    ##              object.size(get(x, env = parent.frame(n = n + 2))))

    sizes <- rep(NA, length(l1))
    for(i in 1:length(l1)) sizes[i] <- object.size(get(l1[i],
                                                       env = parent.frame(n = n)))
    names(sizes) <- l1
    sizes <- sort(sizes, decreasing = TRUE)
    sizes <- round(as.matrix(sizes/10^6), 1)
    sizes <- sizes[sizes >= minsizeshow, , drop = FALSE]
    colnames(sizes) <- "Size(MB)"
    print(sizes)
  }
}

getOutValue <- function(outRDataName, components, array, posInitEnd = NULL) {
  ## component: 1 for Smoothed, 2 for State, 3 for both.
  nmobj <- load(outRDataName)

  if(!inherits(get(nmobj, inherits = FALSE)[[1]], "ffdf"))
    stop("outRDataName must be a list of ffdf")
  if(!inherits(get(nmobj, inherits = FALSE)[[2]], "ffdf"))
    stop("outRDataName must be a list of ffdf")
  
  if((components == 1) | (components == 3)) {
    open(get(nmobj, inherits = FALSE)[[1]], readonly = TRUE)
    if(is.null(posInitEnd))
      tmp1 <- get(nmobj, inherits = FALSE)[[1]][, array]
    else
      tmp1 <- get(nmobj, inherits = FALSE)[[1]][[array]][ri(posInitEnd[1], posInitEnd[2])]
    close(get(nmobj, inherits = FALSE)[[1]])
  }
  if((components == 2) | (components == 3)) {
    open(get(nmobj, inherits = FALSE)[[2]], readonly = TRUE)
    if(is.null(posInitEnd))
      tmp2 <- get(nmobj, inherits = FALSE)[[2]][, array]
    else
      tmp2 <- get(nmobj, inherits = FALSE)[[2]][[array]][ri(posInitEnd[1], posInitEnd[2])]
    close(get(nmobj, inherits = FALSE)[[2]])
  }
  if(components == 1)
    return(tmp1)
  else if(components == 2)
    return(tmp2)
  else return(cbind(tmp1, tmp2)) ## smoothed, state
}



getCGHValue <- function(cghRDataName, array, posInitEnd = NULL) {
  nmobj <- load(cghRDataName)
  if(!inherits(get(nmobj, inherits = FALSE), "ffdf"))
    stop("cghRDataName must be of class ffdf")
  open(get(nmobj, inherits = FALSE), readonly = TRUE)
  if(is.null(posInitEnd))
    tmp <- get(nmobj, inherits = FALSE)[, array]
  else
    tmp <- get(nmobj, inherits = FALSE)[[array]][ri(posInitEnd[1], posInitEnd[2])]
  close(get(nmobj, inherits = FALSE))
  return(tmp)
}



getChromValue <- function(chromRDataName, posInitEnd = NULL) {
  nmobj <- load(chromRDataName)
  open(get(nmobj, inherits = FALSE), readonly = TRUE)
  if(is.null(posInitEnd))
    tmp <- get(nmobj, inherits = FALSE)[]
  else
    tmp <- get(nmobj, inherits = FALSE)[ri(posInitEnd[1], posInitEnd[2])]
  close(get(nmobj, inherits = FALSE))
  return(tmp)
}

getPosValue <- getChromValue


getNames <- function(namesRDataName, posInitEnd = NULL) {
  ## This is a simple character vector. Not an ff object
  ## No notion of open or close and no range index
  nmobj <- load(namesRDataName)
  if(is.null(posInitEnd))
    tmp <- get(nmobj, inherits = FALSE)
  else
    tmp <- get(nmobj, inherits = FALSE)[posInitEnd[1]:posInitEnd[2]]
  rm(list = nmobj)
  if(is.factor(tmp)) {
    warning("getNames operating on a factor object")
    tmp <- as.character(tmp)
  }
  return(tmp)
}
  

getffObj <- function(RDataName, silent = FALSE) {
  nmobj <- load(RDataName, env = parent.frame())
    if(!silent) {
      cat("\n Making an assignment in the calling environment!!! \n")
      cat("We just created (or overwrote)", nmobj, "\n")
      cat("Don't forget to close", nmobj, "\n")
    }
  open(get(nmobj, inherits = FALSE, envir = parent.frame()), readonly = TRUE)
  return(nmobj)
}


ffVecOut <- function(smoothedVal, vmode = "double") {
  pattern <- paste(getwd(), paste(sample(letters, 4), collapse = ""),
                   sep = "/")
  vv <- ff(smoothedVal,
           vmode = vmode,
           pattern = pattern)
  close(vv)
  return(vv)
}

ffListOut <- function(smoothedVal, stateVal) {
  pattern <- paste(getwd(), paste(sample(letters, 4), collapse = ""),
                   sep = "/")
  smoothed <- ff(smoothedVal,
                 vmode = "double",
                 pattern = pattern)
  state <- ff(stateVal,
              vmode = "integer", ## could be short but allow pathological cases
              pattern = pattern)
  close(smoothed)
  close(state)
  return(list(smoothed = smoothed,
              state = state))
}

outToffdf <- function(out, arrayNames) {
  nelem <- length(out)
  if(is.null(arrayNames))
    arrayNames <- paste("A", 1:nelem, sep = "")
  ## this is horrible, but I can't get it to work otherwise
  p1 <- paste("outSmoothed <- ffdf(",
              paste(arrayNames, " = out[[", 1:nelem, "]]$smoothed", sep = "",
                    collapse = ", "),
              ")")
  p2 <- paste("outState <- ffdf(",
              paste(arrayNames, "= out", "[[", 1:nelem, "]]$state", sep = "",
                    collapse = ", "),
              ")")
  eval(parse(text = p1))
  eval(parse(text = p2))
  colnames(outSmoothed) <- colnames(outState) <- arrayNames
  close(outSmoothed)
  close(outState)
  return(list(outSmoothed = outSmoothed, outState = outState))
}

vectorFromffList <- function(indices, lff) {
  ## Put together the "by chromosome by array" pieces
  ## into a single "by array" vector.
  ## This implementation might not be very efficient.
  return(
         unlist(lapply(lff[indices],
                       function(x) {
                         open(x)
                         tmp <- x[]
                         close(x)
                         return(tmp)
                       }))
         )
}

vectorForArray <- function(t1, array, listofff) {
  indices <- t1$Index[t1$ArrayNum == array]
  ## Note: it is key that t1 is ordered by position for
  ##       a sequence of increasing indices.
  vectorFromffList(indices, listofff)
}

vectorForArrayL2 <- function(t1, array, listofff, element) {
  ## the list is a two element list for each position
  indices <- t1$Index[t1$ArrayNum == array]
  ## Note: it is key that t1 is ordered by position for
  ##       a sequence of increasing indices.
  vectorFromffList2(indices, listofff, element)
}

vectorFromffList2 <- function(indices, lff, element) {
  ## Put together the "by chromosome by array" pieces
  ## into a single "by array" vector.
  ## This implementation might not be very efficient.
  ## Probably an ff object can be returned
  ## from concatenating several??
  return(
         unlist(lapply(lff[indices],
                       function(x) {
                         open(x[[element]])
                         tmp <- x[[element]][]
                         close(x[[element]])
                         return(tmp)
                       }))
         )
}


wrapCreateTableArrChr <- function(cghRDataName, chromRDataName) {
  ## SPEED: if you are using this function, you do not really need it.
  ## The table is created somewhere else
  ## and cghdata is read at other places, likewise with chrom
  ## But with 30 arrays of 10^6 probes each, it takes
  ## less than 0.020 seconds and is light on memory.
  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  if(is.null(arrayNames)) {
    narr <- ncol(get(nameCgh))
    arrayNames <- paste("A", 1:narr, sep = "")
  }
  close(get(nameCgh))
  createTableArrChrom(arrayNames, getChromValue(chromRDataName))
}

createTableArrChrom <- function(arraynames, chrom) {
  rle.chr <- intrle(as.integer(chrom))
  if(is.null(rle.chr)) rle.chr <- rle(as.integer(chrom))
  chr.end <- cumsum(rle.chr$lengths)
  chr.start <- c(1, chr.end[-length(chr.end)] + 1)
  ncrom <- length(chr.start)
  narrays <- length(arraynames)
  rrc <- rep(narrays, ncrom)
  
  return(data.frame(Index = 1:(narrays * ncrom),
                    ArrayNum = rep(1:narrays, ncrom),
                    ArrayName = rep(arraynames, ncrom),
                    ChromNum = rep(1:ncrom, rrc),
                    ChromName = rep(rle.chr$values, rrc),
                    posInit = rep(chr.start, rrc),
                    posEnd  = rep(chr.end, rrc)))
}

is.wholeposnumber <- function(x, tol = .Machine$double.eps^0.5) {
  ## from "is.integer" help, modified
  abs(abs(x) - round(x)) < tol
}

inputDataToADaCGHData <- function(ffpattern = paste(getwd(), "/", sep = ""),
                                  MAList = NULL,
                                  cloneinfo = NULL,
                                  filename = NULL,
                                  sep = "\t",
                                  quote = "\"",
                                  na.omit = FALSE,
                                  minNumPerChrom = 10) {

  ## We could use eval(substitute or get(
  ## but we modify the object for sure when eliminating rownames
  ## and possibly when reordering. So might as well just load, copy,
  ## remove, and gc.


  if(!is.null(filename) & !is.null(MAList))
    stop("You must provide only one of filename OR MAList")
  if(is.null(filename) & is.null(MAList))
    stop("You must provide exactly one of filename OR MAList")


  ## There is a subtle diff in behavior of inherits between R 2.11 and R 2.12.
  ## The "any" after inherits would not be needed in R-2.12
  
  if(!is.null(MAList)) {
    if(!(any(inherits(MAList, c("SegList", "MAList")))))
      stop("MAList must be an object of class SegList (as produced by snapCGH) ",
           "or of class MAList (as produced by limma)")
    
    if((!all(c("Position", "Chr") %in% colnames(MAList$genes))) &
       is.null(cloneinfo))
      stop("If your MAList object does not have Position and Chr columns ",
           "you must provide a cloneinfo argument with the name of an object with them")

    if(is.null(cloneinfo))
      inputData <- data.frame(ID = MAList$genes$ID,
                              Chr = MAList$genes$Chr,
                              Pos = MAList$genes$Position,
                              MAList$M)
    else {
      #what is clone info?
      if(typeof(cloneinfo) == "character") {## we assume path to a file
        cat("Assuming cloneinfo is a file (possibly with full path)  ")
        Table <- read.table(cloneinfo, sep = sep, quote = quote,
                                header = TRUE)
        ## Code directly from snapCGH
        Chr <- as.character(Table$Chr)
        indX <- which(Chr == "X" | Chr == "x")
        indY <- which(Chr == "Y" | Chr == "y")
        Chr[indX] <- 23
        Chr[indY] <- 24
        cloneinfo <- data.frame(Chr = as.numeric(Chr),
                                Position = Table$Position)
      } else {
        cat("Assuming cloneinfo is an R data frame ")
        cloneinfo <- get(deparse(substitute(cloneinfo)))
      }
      
      inputData <- data.frame(ID = MAList$genes$ID,
                              Chr = cloneinfo$Chr,
                              Pos = cloneinfo$Position,
                              MAList$M)
    }
    
  }
  
  
  if(!is.null(filename)) {
    nmobj <- load(filename)
    inputData <- get(nmobj, inherits = FALSE)
    rm(list = nmobj)
    rm(nmobj)
    gc()
  }

  if(na.omit)
    if(any(is.na(inputData))) {
      warning("Eliminating all rows with missing values")
      inputData <- na.omit(inputData)
    }
  
  rownames(inputData) <- NULL ## Don't? Takes a lot of memory not recoverd later
  ## but we don't want rownames in ffdf objects.
  if(any(is.na(inputData))) 
    caughtUserError2(paste("Your aCGH file contains missing values. \n",
                              "That is not allowed.\n"))
  gc(); gc()
  if(!is.numeric(inputData[, 2]))
    caughtUserError2(paste("Chromosome contains non-numeric data.\n",
                              "That is not allowed.\n"))

  if(any(table(inputData[, 2]) < minNumPerChrom))
    caughtUserError2(paste("At least one of your chromosomes has less than ",
                     minNumPerChrom, " observations.\n That is not allowed.\n"))

  if(!all(is.wholeposnumber(inputData[, 2])))
    caughtUserError2("Chromosome is NOT a positive integer!!\n")
  if(max(inputData[, 2]) > 65000)
    caughtUserError2("Chromosome has more than 65000 levels!!\n")
  
  if(any(!sapply(inputData[, -c(1, 2, 3)], is.numeric)))
    caughtUserError2(paste("Your aCGH file contains non-numeric data. \n",
                              "That is not allowed.\n")   )
  gc()

  ## Do we have any identical MidPos in the same chromosome??  Just to solve
  ## it quickly and without nasty downstream consequences, we add a runif to
  ## midPos. But NO further averaging.
   
  tmp <- paste(inputData[, 2], inputData[, 3], sep = ".")
  if (sum(duplicated(tmp))) {
    cat("\n We have identical MidPos!!! \n")
    if(exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv))
      capture.output(print("We have identical MidPos!!!"),
                     file = "WARNING.DUPLICATED")
    ## add a random variate, to break ties:
    inputData[duplicated(tmp), 3] <-
      inputData[duplicated(tmp), 3] +
        runif(sum(duplicated(tmp)))
    ## check it worked
    tmp <- paste(inputData[, 2], inputData[, 3], sep = ".")
    if (sum(duplicated(tmp)))
      caughtOurError2("still duplicated MidPoints; shouldn't happen")
    rm(tmp)
    gc()
  }
  ## Reorder, just in case
  reorder <- order(inputData[, 2],
                   inputData[, 3])
  if(!(identical(reorder, seq_len(nrow(inputData)))))
    inputData <- inputData[reorder, ]
  
  probeNames <- inputData[, 1]
  if(is.factor(probeNames)) probeNames <- as.character(probeNames)
  save(file = "probeNames.RData", probeNames, compress = FALSE)
  rm(probeNames)
##   gcmessage("after rm probeNames")

  chromData <- ff(as.integer(inputData[, 2]), vmode = "ushort",
                  pattern = ffpattern)
  close(chromData)
  save(file = "chromData.RData", chromData, compress = FALSE)
  rm(chromData)
  posData <- ff(inputData[, 3], vmode = "double",
                  pattern = ffpattern)
  close(posData)
  save(file = "posData.RData", posData, compress = FALSE)
  rm(posData)
##   gcmessage("after rm posData and chromData")
  if(is.null(colnames(inputData))) {
    narr <- ncol(inputData) - 3
    colnames(inputData) <- c("1", "2", "3", paste("A", 1:narr, sep = ""))
  }

  tableArrChr <- createTableArrChrom(colnames(inputData)[-c(1, 2, 3)],
                                     inputData[, 2])
  
  ## not needed here; can be done inside as.ffdf
  ## inputData <- inputData[, -c(1, 2, 3), drop = FALSE]

  if( packageDescription("ff")$Version >= "2.1-2" )
    cghData <- as.ffdf(inputData[, -c(1, 2, 3), drop = FALSE],
                       col_args=list(pattern = ffpattern))
  else
    cghData <- as.ffdf(inputData[, -c(1, 2, 3), drop = FALSE],
                       pattern = ffpattern)
  
  close(cghData)
  rm(inputData)
  save(file = "cghData.RData", cghData, compress = FALSE)
  rm(cghData)
###  gcmessage("after rm inputData")
  gcmessage("\n Calling gc before returning to track memory usage \n")
  cat("\n Files saved in current directory \n", getwd(),
      " with names :\n",
      "chromData.RData, posData.RData, cghData.RData, probeNames.RData \n")

 return(tableArrChr)
}



outputToCGHregions <- function(output, directory = getwd()) {
  ## aqui cambiar el dir
  the.former.dir <- getwd()
  setwd(directory)
  probeNames <- get(load("probeNames.RData"), inherits = FALSE)
  posData <- get(load("posData.RData"), inherits = FALSE)
  chromData <- get(load("chromData.RData"), inherits = FALSE)
  open(posData)
  open(chromData)
  open(output[["outState"]])
  
  out <- data.frame(probes = probeNames, 
                    chrom = chromData[],
                    pos1 = posData[],
                    pos2 = posData[],
                    as.data.frame(output[["outState"]]))
  setwd(the.former.dir)
  close(posData)
  close(chromData)
  close(output[["outState"]])
  out
}


## this is not used now
break.and.write.vector <- function(i, pos.start, pos.end, infile, outfile) {
  nmobj <- load(infile)
  if(inherits(get(nmobj, inherits = FALSE), "ff"))
    open(get(nmobj, inherits = FALSE), readonly = TRUE)
  ## maybe write the txt also?? FIXME
  oname <- paste(outfile, i, sep = "")
  assign(oname, get(nmobj, inherits = FALSE)[pos.start[i] : pos.end[i]])
  save(file = paste(oname, ".RData", sep = ""),
       list = c(oname), compress = FALSE)
}





#####################################################
#####################################################
##############
##############    Methods
##############
#####################################################
#####################################################

pSegmentGLAD <- function(cghRDataName, chromRDataName,
                         deltaN = 0.10,
                         forceGL = c(-0.15, 0.15),
                         deletion = -5,
                         amplicon = 1, ...) {

  ## check appropriate class of objects
  
  ## stop.na.inf(x)
  ## stop.na.inf(chrom.numeric)
  ## warn.too.few.in.chrom(chrom.numeric)

  require("GLAD") || stop("Package not loaded: GLAD")
  sfLibrary("GLAD", character.only = TRUE)
  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))

  outsf <- sfClusterApplyLB(1:narrays,
                            internalGLAD,
                            cghRDataName,
                            chromRDataName,
                            nvalues,
                            deltaN,
                            forceGL,
                            deletion,
                            amplicon)
  ## a hack to avoid sfClusterApply from catching the error and aborting
  te <- unlist(unlist(lapply(outsf, function(x) inherits(x, "my-try-error"))))
  if(any(te)) {
    m1 <- "The GLAD code occassionally crashes (don't blame us!)."
    m2 <- "This often happens in function DelRegionTooSmal."
    m3 <- "You might want to use another method"
    mm <- paste(m1, m2, m3)
    caughtError(mm)
  }
  
  ## nodeWhere("pSegmentGLAD")
  return(outToffdf(outsf, arrayNames))
}

internalGLAD <- function(index, cghRDataName, chromRDataName,
                         nvalues,
                         deltaN,
                         forceGL,
                         deletion,
                         amplicon) {
##  cghvalues <- getCGHval(cghRDataName, index)
##  chromvalues <- getChromval(chromRDataName)
  tmpf <- list(profileValues = data.frame(
                 LogRatio = getCGHValue(cghRDataName, index),
                 PosOrder = 1:nvalues,
                 Chromosome = getChromValue(chromRDataName)))
  class(tmpf) <- "profileCGH"

  ## GLAD produces lots of gratuitous output. Capture it
  ## to ignore it
  tmp <- capture.output(
                        outglad <- try(daglad(tmpf, deltaN = deltaN,
                                              forceGL = forceGL,
                                              deletion = deletion,
                                              amplicon = amplicon,
                                              verbose = FALSE))
  )
  
  rm(tmpf)
  rm(tmp)
  ## nodeWhere("internalGLAD")
  if(inherits(outglad, "try-error")) {
    ## a hack to avoid sfClusterApply from catching the error and aborting
    class(outglad) <- "my-try-error"
    return(outglad)
  } else {
    return(ffListOut(outglad$profileValues$Smoothing,
                     outglad$profileValues$ZoneGNL))
  }
}

pSegmentDNAcopy <- function(cghRDataName, chromRDataName,
                            merging = "mergeLevels",
                            mad.threshold = 3,
                            smooth = TRUE,
                            alpha=0.01, nperm=10000,
                            p.method = "hybrid",
                            min.width = 2,
                            kmax=25, nmin=200,
                            eta = 0.05,
                            ## sbdry = NULL,
                            trim = 0.025,
                            undo.splits = "none",
                            undo.prune=0.05, undo.SD=3,
                            ## following options for mergeLevels
                            ## merge.pv.thresh = 1e-04,
                            ## merge.ansari.sign = 0.05,
                            ## merge.thresMin = 0.05,
                            ## merge.thresMax = 0.5,
                            ...) {

  ## sbdry = NULL in segment. I.e., compute it if not default
  ## We do that here.

  ## temporary hack: Ein?? FIXME!!!
  ## mergeSegs <- ifelse(merging == "mergeLevels", TRUE, FALSE)


  
  ## Nobody touches these options. So hard-code here.
  merge.pv.thresh = 1e-04
  merge.ansari.sign = 0.05
  merge.thresMin = 0.05
  merge.thresMax = 0.5
  
  getbdry <- DNAcopy:::getbdry
  
  if (nperm == 10000 & alpha == 0.01 & eta == 0.05) {
    sbdry <- default.DNAcopy.bdry
  } else {
    max.ones <- floor(nperm * alpha) + 1
    sbdry <- getbdry(eta, nperm, max.ones)
  }
  sbn <- length(sbdry)

  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))

  outsf <- sfClusterApplyLB(1:narrays,
                            internalDNAcopy,
                            cghRDataName =   cghRDataName,
                            chromRDataName = chromRDataName,
                            merging =      merging,
                            smooth =        smooth,
                            alpha =         alpha,     
                            nperm =         nperm,    
                            kmax =          kmax,      
                            nmin =          nmin,
                            eta =           eta,
                            trim =          trim,      
                            undo.prune =    undo.prune,
                            undo.SD =       undo.SD,   
                            sbdry =         sbdry,     
                            sbn =           sbn,
                            merge.pv.thresh = merge.pv.thresh,
                            merge.ansari.sign = merge.ansari.sign,
                            merge.thresMin = merge.thresMin,
                            merge.thresMax = merge.thresMax,
                            p.method = p.method,
                            undo.splits = undo.splits,
                            min.width =min.width,
                            mad.threshold = mad.threshold
                            )                 

  ## nodeWhere("pSegmentDNAcopy")
  ## FIXME: classes!! for all output!!
  ## class(out) <- c("adacgh.generic.out", "adacghHaarSeg")
  return(outToffdf(outsf, arrayNames))
}

internalDNAcopy <- function(index, cghRDataName, chromRDataName,
                            merging, smooth,
                            alpha, nperm, kmax, nmin,
                            eta, trim,
                            undo.prune, undo.SD,
                            sbdry, sbn,
                            merge.pv.thresh,
                            merge.ansari.sign,
                            merge.thresMin, merge.thresMax,
                            p.method,
                            undo.splits,
                            min.width,
                            mad.threshold) {

  cghdata <- getCGHValue(cghRDataName, index)
  chrom.numeric <- getChromValue(chromRDataName)
  if(smooth)
    cghdata <- internalDNAcopySmooth(cghdata,
                                chrom.numeric = chrom.numeric,
                                smooth.region = 2, outlier.SD.scale = 4,
                                smooth.SD.scale = 2, trim = 0.025)
  outseg <-
    internalDNAcopySegm(cghdata,
                        chrom.numeric = chrom.numeric,
                        sbdry =         sbdry,     
                        sbn =           sbn,
                        alpha =         alpha,     
                        nperm =         nperm,    
                        kmax =          kmax,      
                        nmin =          nmin,      
                        trim =          trim,      
                        undo.prune =    undo.prune,
                        undo.SD =       undo.SD,
                        p.method =      p.method,
                        undo.splits =   undo.splits,
                        min.width =     min.width
                        )
  rm(chrom.numeric)

  ## If there is no merging, outseg is as given above.
  ## It is modified if we do merging
  if(merging == "mergeLevels") {
    outseg <- ourMerge(cghdata, outseg[ , 1],
                       merge.pv.thresh = merge.pv.thresh,
                       merge.ansari.sign = merge.ansari.sign,
                       merge.thresMin = merge.thresMin,
                       merge.thresMax = merge.thresMax)
  } else if(merging == "MAD") {
    mad.subj <- median(abs(cghdata - outseg[, 1]))/0.6745
    thresh <- mad.threshold * mad.subj
    outseg[, 2] <- ifelse( (abs(outseg[, 1]) > thresh), 1, 0) * sign(outseg[, 1])
  } else if(merging != "none") {
    stop("This merging method not implemented")
  }
  
  rm(cghdata)
  ## nodeWhere("internalDNAcopy")
  return(ffListOut(outseg[, 1], outseg[, 2]))
}




pSegmentHaarSeg <- function(cghRDataName, chromRDataName,
                            merging = "MAD",
                            mad.threshold = 3,
                            W = vector(),
                            rawI = vector(), 
                            breaksFdrQ = 0.001,			  
                            haarStartLevel = 1,
                            haarEndLevel = 5, 
                            ...) {

  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))

  ## FIXME: change this!! we can do it simpler!!
  nameChrom <- getffObj(chromRDataName, silent = TRUE)
  rle.chr <- intrle(as.integer(get(nameChrom)[]))
  chr.end <- cumsum(rle.chr$lengths)
  chr.start <- c(1, chr.end[-length(chr.end)] + 1)
  chromPos <- cbind(chr.start, chr.end)
  close(get(nameChrom)) 

  
  outsf <- sfClusterApplyLB(1:narrays,
                            internalHaarSeg,
                            mad.threshold = mad.threshold,
                            cghRDataName = cghRDataName,
                            chromPos,
                            W, rawI,
                            breaksFdrQ,
                            haarStartLevel,
                            haarEndLevel,
                            merging)
  ## nodeWhere("pSegmentHaarSeg")
  return(outToffdf(outsf, arrayNames))
}

internalHaarSeg <- function(index, cghRDataName, mad.threshold,
                            chromPos,
                            W, rawI,
                            breaksFdrQ,
                            haarStartLevel,
                            haarEndLevel,
                            merging) {

  xvalue <- getCGHValue(cghRDataName, index)
  haarout <- ad_HaarSeg(I = xvalue,
                        chromPos = chromPos,
                        W = W, rawI = rawI,
                        breaksFdrQ = breaksFdrQ,
                        haarStartLevel = haarStartLevel,
                        haarEndLevel = haarEndLevel)[[2]]
  if(merging == "MAD") {
    mad.subj <- median(abs(xvalue - haarout))/0.6745
    rm(xvalue)
    thresh <- mad.threshold * mad.subj
    ## nodeWhere("internalHaarSeg")
    return(ffListOut(haarout,
                     ifelse( (abs(haarout) > thresh), 1, 0) * sign(haarout)))
  } else if(merging == "mergeLevels") {
    return(ffListOut(haarout,
                     ourMerge(xvalue, haarout)))
  } else {
    stop("This merging method not recognized")
  }
}


pSegmentHMM <- function(cghRDataName, chromRDataName, merging = "mergeLevels", mad.threshold = 3,
                        aic.or.bic = "AIC",
                        ...) {
  ## The table exists. No need to re-create if
  ## really paranoid about speed

  tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)
    
  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))


  
  
  ## Parallelized by arr by chrom
  out0 <- sfClusterApplyLB(tableArrChrom$Index,
                           internalHMM,
                           tableArrChrom,
                           cghRDataName,
                           aic.or.bic)
  ## nodeWhere("pSegmentHMM_0")
  ## Parallelized by array
  if(merging == "mergeLevels") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMerge,
                            out0,
                            tableArrChrom,
                            cghRDataName)
  } else if(merging == "MAD") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMADCall,
                            out0,
                            tableArrChrom,
                            cghRDataName,
                            mad.threshold)
  } else {
    stop("This merging method not recognized")
  }
  
  ## nodeWhere("pSegmentHMM_1")
  return(outToffdf(out, arrayNames))
}

internalHMM <- function(tableIndex, tableArrChrom, cghRDataName, aic.or.bic) {
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalHMM")
  return(hmmWrapper(getCGHValue(cghRDataName, arrayIndex, chromPos), aic.or.bic))
}

hmmWrapper <- function(logratio, aic.or.bic) {
  ## Fit HMM, and return the predicted
  ## we do not pass Chrom since we only fit by Chrom.
  ##  cat("\n Disregard the 'sample is  1 	Chromosomes: 1' messages!!!\n")
  Pos <- Clone <- 1:length(logratio)
  Chrom <- rep(1, length(logratio))
  obj.aCGH <- create.aCGH(data.frame(logratio),
                          data.frame(Clone = Clone,
                                     Chrom = Chrom,
                                     kb = Pos))
  ## we could wrap this in "capture.output"
  if(aic.or.bic == "AIC")
    res <- find.hmm.states(obj.aCGH, aic = TRUE, bic = FALSE)
  else
    res <- find.hmm.states(obj.aCGH, aic = FALSE, bic = TRUE)
  hmm(obj.aCGH) <- res
  ## nodeWhere("hmmWrapper")
  return(ffVecOut(obj.aCGH$hmm$states.hmm[[1]][, 6]))
}

internalMADCall <- function(index, smoothedff, tableArrChrom, cghRDataName,
                            mad.threshold) {
  ## calling via MAD, as in HaarSeg
  smoothed <- vectorForArray(tableArrChrom, index, smoothedff)
  ## xvalue <- getCGHValue(cghRDataName, index)
  ## mad.subj <- median(abs(xvalue - smoothed))/0.6745
  mad.subj <- median(abs(
                         getCGHValue(cghRDataName, index) -
                         smoothed
                         ))/0.6745
  thresh <- mad.threshold * mad.subj
  ## nodeWhere("internalMADCall")
##  cat("\n MADCall: thresh is ", thresh)
  return(ffListOut(smoothed,
                   ifelse( (abs(smoothed) > thresh), 1, 0) * sign(smoothed)))

}

simpleMADCall <- function(original, smoothed, mad.threshold) {
  ## Like internal MADCall, but when you have the vectors already
  ## Unlikely it makes sense to use it, because of duplication.
  ## See what we do in internalDNAcopy
  mad.subj <- median(abs(original - smoothed))/0.6745
  thresh <- mad.threshold * mad.subj
  return(cbind(smoothed, ifelse( (abs(smoothed) > thresh), 1, 0) * sign(smoothed)))
}


internalMerge <- function(index, smoothedff, tableArrChrom, cghRDataName) {
  outseg <- ourMerge(
                     getCGHValue(cghRDataName, index),
                     vectorForArray(tableArrChrom, index, smoothedff)
                     )
  ## nodeWhere("internalMerge")
  return(ffListOut(outseg[, 1], outseg[, 2]))
}



pSegmentBioHMM <- function(cghRDataName, chromRDataName, posRDataName,
                           merging = "mergeLevels", mad.threshold = 3,
                           aic.or.bic = "AIC",                           
                           ...) {
  tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)

  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))

  out0 <- sfClusterApplyLB(tableArrChrom$Index,
                           internalBioHMM,
                           tableArrChrom,
                           cghRDataName,
                           posRDataName,
                           aic.or.bic)
  ## nodeWhere("pSegmentBioHMM_0")
  te <- unlist(unlist(lapply(out0, function(x) inherits(x, "my-try-error"))))
  if(any(te)) {
    m1 <- "The BioHMM code occassionally crashes (don't blame us!)."
    m2 <- "You can try rerunning it a few times."
    m2b <- "You can use another method. "
    m3 <- "You can also tell the authors of the BioHMM package"
    m4 <- " that you get the error(s): \n\n "
    mm <- paste(m1, m2, m2b, m3, m4, paste(out0[which(te)], collapse = "    \n   "))
    caughtError(mm)
  }

  ## Parallelized by array
 if(merging == "mergeLevels") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMerge,
                            out0,
                            tableArrChrom,
                            cghRDataName)
  } else if(merging == "MAD") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMADCall,
                            out0,
                            tableArrChrom,
                            cghRDataName,
                            mad.threshold)
  } else {
    stop("This merging method not recognized")
  }
  
  ## nodeWhere("pSegmentBioHMM_1")
  return(outToffdf(out, arrayNames))
}

internalBioHMM <- function(tableIndex, tableArrChrom, cghRDataName,
                           posRDataName, aic.or.bic) {
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalBioHMM")
  return(BioHMMWrapper(getCGHValue(cghRDataName, arrayIndex, chromPos),
                       getPosValue(posRDataName, chromPos), aic.or.bic))
}

BioHMMWrapper <- function(logratio, Pos, aic.or.bic) {
##  cat("\n       .... running BioHMMWrapper \n")
  ydat <- matrix(logratio, ncol=1)
  n <- length(ydat)
  res <- try(myfit.model(sample = 1, chrom = 1, dat = matrix(ydat, ncol = 1),
                         datainfo = data.frame(Name = 1:n, Chrom = rep(1, n),
                           Position = Pos),
                         aic = ifelse(aic.or.bic == "AIC", TRUE, FALSE),
                         bic = ifelse(aic.or.bic == "BIC", TRUE, FALSE)
                         ))
  ## nodeWhere("BioHMMWrapper")
  if(inherits(res, "try-error")) {
    class(res) <- "my-try-error"
    return(res)
  } else {
    return(ffVecOut(res$out.list$mean))
  }
}

pSegmentCGHseg <- function(cghRDataName, chromRDataName, CGHseg.thres = -0.05,
                           merging = "MAD", mad.threshold = 3, ...) {
  ## merge: "MAD", "mergeLevels", "none"
  ## We always use mergeSegs. OK for gain/loss/no-change,
  ## but it breaks the underlying segments
  tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)

  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))


  ## Parallelized by arr by chrom
  ## if merge != "none", then it returns ONLY the smoothed values
  out0 <- sfClusterApplyLB(tableArrChrom$Index,
                           internalCGHseg,
                           tableArrChrom,
                           cghRDataName,
                           CGHseg.thres,
                           merging)
    ## nodeWhere("pSegmentCGHseg_0")

  if(merging == "mergeLevels") {
    ## Parallelized by array
    out <- sfClusterApplyLB(1:narrays,
                            internalMerge,
                            out0,
                            tableArrChrom,
                            cghRDataName)
    ## nodeWhere("pSegmentCGHseg_mergeLevels")
  } else if(merging == "MAD") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMADCall,
                            out0,
                            tableArrChrom,
                            cghRDataName,
                            mad.threshold)
    ## nodeWhere("pSegmentCGHseg_MADCall")
  } else if(merging == "none") {
    ## of course, could be done sequentially
    ## but if many arrays and long chromosomes, probably
    ## better over several nodes
    ## BEWARE: the segment "states" (numbers) are per chromosome!!!
    ## so within array we can have several states with same number
    ## that means very different things!!!
    out <- sfClusterApplyLB(1:narrays,
                            puttogetherCGHseg,
                            out0,
                            tableArrChrom)
    ## nodeWhere("pSegmentCGHseg_No_merge")
  } else {
    stop("This merging method not recognized")
  }
  ## nodeWhere("pSegmentCGHseg_1")
  return(outToffdf(out, arrayNames))
}



puttogetherCGHseg <- function(index, out, tableArrChrom) {
  ## could probably be done more efficiently
  return(ffListOut(vectorForArrayL2(tableArrChrom, index, out, 1),
                   vectorForArrayL2(tableArrChrom, index, out, 2)))
}

internalCGHseg <- function(tableIndex, tableArrChrom, cghRDataName, CGHseg.thres,
                           merging) {
  ## the following could be parameters
  
  maxseg <- NULL
  verbose <- FALSE
  maxk <- NULL
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalCGHseg")
  n <- chromPos[2] - chromPos[1] + 1
  y <- getCGHValue(cghRDataName, arrayIndex, chromPos)
  obj1 <- tilingArray:::segment(y,
                                maxseg = ifelse(is.null(maxseg), n/2, maxseg),
                                maxk = ifelse(is.null(maxk), n, maxk))
  optk <- piccardsKO(obj1@logLik, n, CGHseg.thres)
  ## if (verbose) {
  ##   cat("\n Index ", tableIndex, ";  Optimal k ", optk, "\n")
  ## }
  ## nodeWhere("internalCGHseg")

  return(piccardsStretch01(obj1, optk, n, y, merging))

  ## Beware we do not use the original "states" of Piccard
  ## as we always use mergeSegs
  ## segstates <- c(segstates, finalsegm[, 2])
}



piccardsStretch01 <- function(obj, k, n, logratio, merging) {
  ## note return object differs if mergeSegs TRUE or FALSE
    if(k > 1) {
        poss <- obj@breakpoints[[k]]
        start <- c(1, poss)
        end <- c(poss - 1, n)
        smoothedC <- mapply(function(start, end) mean(logratio[start: end]), start, end)
        reps <- diff(c(start, n + 1))
        smoothed <- rep(smoothedC, reps)
        if(merging == "none")
          state <- rep(1:k, reps)
    } else { ## only one segment
        smoothed <- rep(mean(logratio), n)
        if(merging == "none")
          state <- rep(1, n)
    }
    if(merging!= "none")
      return(ffVecOut(smoothed))
    else
      return(list(ffVecOut(smoothed),
                  ffVecOut(state, vmode = "integer")))
}


piccardsKO <- function(loglik, n, s) {
    ## return the optimal number of segments, as in
    ## piccard et al., p. 13. k is number of segments, not breakponts.
    dks <- c(NA, diff(loglik, lag = 1, differences = 2))
    dkthresh <- s * n
    okdk <- which(dks < dkthresh)
    if(length(okdk) > 0) {
        return(max(okdk))
    } else {
        return(1)
    }
  }

#### Choosing a good s for Piccard's approach
####  and collapsing levels


### Verify with Piccard's paper, figure 1.

## coriel.data <- read.table("gm03563.txt", header = TRUE)
## cd3 <- coriel.data[coriel.data$Chromosome == 3, 3]
    

## out.lai <- CGHsegWrapper(cd3, optK = "L")  ## k = 14
## out.our <- CGHsegWrapper(cd3, optK = "O")  ## k = 2

## so our implementation seems correct. look at where the
## breakpoint is located, etc, and it is like figure 1 of
## Picard's paper.


pSegmentWavelets <- function(cghRDataName, chromRDataName, merging = "MAD",
                             mad.threshold = 3, 
                             minDiff = 0.25,
                             minMergeDiff = 0.05,
                             thrLvl = 3, initClusterLevels = 10,
                             ...) {

  tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)

  nameCgh <- getffObj(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  narrays <- ncol(get(nameCgh))
  nvalues <- nrow(get(nameCgh))
  close(get(nameCgh))

  thismdiff <- if(merging == "mergeLevels") minMergeDiff else minDiff

  out0 <- sfClusterApplyLB(tableArrChrom$Index,
                           internalWaveHsu,
                           tableArrChrom,
                           cghRDataName,
                           thrLvl = thrLvl,
                           minDiff = thismdiff,
                           initClusterLevels = initClusterLevels,
                           merging = merging)
  ## nodeWhere("pSegmentWavelets_0")
 ## Parallelized by arr by chrom
  ## if merge != "none", then it returns ONLY the smoothed values
  if(merging == "mergeLevels") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMerge,
                            out0,
                            tableArrChrom,
                            cghRDataName)
    ## nodeWhere("pSegmentWavelets_mergeLevels")
  } else if(merging == "MAD") {
    out <- sfClusterApplyLB(1:narrays,
                            internalMADCall,
                            out0,
                            tableArrChrom,
                            cghRDataName,
                            mad.threshold)
    ## nodeWhere("pSegmentWavelets_MADCall")
  } else if(merging == "none") {
    ## of course, could be done sequentially
    ## but if many arrays and long chromosomes, probably
    ## better over several nodes
    out <- sfClusterApplyLB(1:narrays,
                            puttogetherCGHseg,
                            out0,
                            tableArrChrom)
    ## nodeWhere("pSegmentWavelets_No_merge")
  } else {
    stop("This merging method not recognized")
  }
  ## nodeWhere("pSegmentWavelets_1")
  return(outToffdf(out, arrayNames))
}


internalWaveHsu <- function(tableIndex, tableArrChrom,
                            cghRDataName,
                            thrLvl, minDiff, initClusterLevels,
                            merging) {
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalWaveHsu")
  ratio <- getCGHValue(cghRDataName, arrayIndex, chromPos)
  
  wc   <- modwt(ratio, "haar", n.levels=thrLvl)
  thH  <- our.hybrid(wc, max.level=thrLvl, hard=FALSE)
  recH <- imodwt(thH)
  ## cluster levels
  pred.ij <- segmentW(ratio, recH, minDiff=minDiff,
                      n.levels = initClusterLevels)
  if(merging == "none") {
    labs <- as.character(1:length(unique(pred.ij)))
    state <- as.integer(factor(pred.ij, labels=labs))
  }
  
  if(merging != "none")
    return(ffVecOut(pred.ij))
  else
    return(list(ffVecOut(pred.ij),
                ffVecOut(state, vmode = "integer")))
}





#######################################################
#######################################################
#######################################################
#######################################################
#######################################################
#######################################################
###
###              Plots
###                 
###
#######################################################
#######################################################
#######################################################
#######################################################
#######################################################
#######################################################


pChromPlot <- function(outRDataName,
                       cghRDataName,
                       chromRDataName,
                       probenamesRDataName,
                       posRDataName = NULL,
                       imgheight = 500,
                       pixels.point = 3,
                       pch = 20,
                       colors = c("orange", "red", "green",
                         "blue", "black"),
                       imagemap = FALSE,
                       ...) {

  tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)
  
  null <- sfClusterApplyLB(tableArrChrom$Index,
                           internalChromPlot,
                           tableArrChrom = tableArrChrom,
                           outRDataName = outRDataName,
                           cghRDataName = cghRDataName,
                           chromRDataName = chromRDataName,
                           probenamesRDataName = probenamesRDataName,
                           posRDataName = posRDataName,
                           imgheight = imgheight,
                           pixels.point = pixels.point,
                           pch = pch,
                           colors = colors,
                           imagemap = imagemap,
                           ...)

}

internalChromPlot <- function(tableIndex,
                              tableArrChrom,
                              outRDataName,
                              cghRDataName,
                              chromRDataName,
                              probenamesRDataName,
                              posRDataName,
                              imgheight,
                              pixels.point,
                              pch,
                              colors,
                              imagemap, 
                              ...) {


  ## nodeWhere("starting internalChromPlot")
  
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  cname <- tableArrChrom[tableIndex, "ChromName"]
  arrayName <- tableArrChrom[tableIndex, "ArrayName"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  
  cghdata <- getCGHValue(cghRDataName, arrayIndex, chromPos)
  res <- getOutValue(outRDataName, 3, arrayIndex, chromPos)
   
  ndata <- length(cghdata)
  col <- rep(colors[1], ndata)
  col[which(res[, 2] == -1)] <- colors[3]
  col[which(res[, 2] == 1)] <- colors[2]

  if(is.null(posRDataName)) {
    simplepos <- 1:ndata
  } else simplepos <- getPosValue(posRDataName, chromPos)

  nameChrIm <- paste("Chr", cname, "@", arrayName, sep ="")
  
  ## cat("\n        internalChromPlot: doing array ", arrayIndex,
  ##     " chromosome ", cnum, 
  ##     " positions ", chromPos, "\n")
  
  ccircle <- NULL
  chrwidth <- round(pixels.point * (ndata + .10 * ndata))
  chrwidth <- max(min(chrwidth, 1200), 800)
  im2 <- imagemap3(nameChrIm,
                   height = imgheight, width = chrwidth,
                   ps = 12)
  par(xaxs = "i")
  par(mar = c(5, 5, 5, 5))
  par(oma = c(0, 0, 0, 0))
  
  if(ndata > 50000) {
    this.cex <- 0.1
  } else if (ndata > 10000) {
    this.cex <- 0.5
  } else {
    this.cex <- 1
  }
   
  plot(cghdata ~ simplepos, col=col, cex = this.cex,
       xlab ="Chromosomal location", ylab = "log ratio", axes = FALSE,
       main = nameChrIm,
       pch = pch) ##ylim

  ## nodeWhere("internalChromPlot: right after plot")
  
  box()
  axis(2)
  abline(h = 0, lty = 2, col = colors[5])
  rug(simplepos, ticksize = 0.01)
  lines(res[, 1] ~ simplepos,
        col = colors[4], lwd = 2, type = "l")
  if(imagemap) {
    dummy.coord <- usr2png(cbind(c(2, 0), c(0, 0)), im2)
    cc1.r <- max(abs(dummy.coord[1, 1]  - dummy.coord[2, 1]), 4)
    ccircle <- rbind(t(usr2png(cbind(simplepos, cghdata), im2)),
                     rep(cc1.r, length(simplepos)))
    write(ccircle, file = paste("pngCoord_", nameChrIm, sep = ""),
          sep ="\t", ncolumns = 3)
    probeNames <- getNames(probenamesRDataName, chromPos)
    if ( (ncol(ccircle)/length(probeNames)) != 1)
      stop("Serious problem: number of arrays does not match")
    write(probeNames, 
          file = paste("geneNames_", nameChrIm, sep = ""))
  }
  imClose3(im2)

  rm(cghdata)
  rm(simplepos)
  rm(res)
  rm(probeNames)
  
  ## if(html_js) 
  ##   system(paste(.python.toMap.py, nameChrIm, 
  ##                idtype, organism, sep = " "))

  ## nodeWhere("internalChromPlot: end")

}


#######################################################
#######################################################
#######################################################
###
###         More analysis functions
###         Unlikely to have to touch them   
###
#######################################################
#######################################################
#######################################################


    

internalDNAcopySmooth <- function(acghdata, chrom.numeric,
                              smooth.region = 2, outlier.SD.scale = 4,
                                smooth.SD.scale = 2, trim = 0.025) {
    ## this is just the original smoothCNA funct. adapted to use
    ## a single array and to be parallelized and fed to internalDNAcopy
##     cat("\n DEBUG: STARTING internalDNAcopySmooth \n")
    
    chrom <- chrom.numeric
    uchrom <- unique(chrom)
    genomdat <- acghdata
    ina <- which(!is.na(genomdat) & !(abs(genomdat) == Inf))
    trimmed.SD <- sqrt(adacgh_trimmed.variance(genomdat[ina], trim))
    outlier.SD <- outlier.SD.scale * trimmed.SD
    smooth.SD <- smooth.SD.scale * trimmed.SD
    
    k <- smooth.region
    for (i in uchrom) {
        ina <-
            which(!is.na(genomdat) & !(abs(genomdat) == Inf) & chrom == i)
        n <- length(genomdat[ina])
        smoothed.data <-
            sapply(1:n,
                   function(i, x, n, nbhd, oSD, sSD) {
                       xi <- x[i]
                       nbhd <- i + nbhd
                       xnbhd <- x[nbhd[nbhd > 0 & nbhd <= n]]
                       if (xi > max(xnbhd) + oSD) 
                           xi <- median(c(xi, xnbhd)) + sSD
                       if (xi < min(xnbhd) - oSD) 
                           xi <- median(c(xi, xnbhd)) - sSD
                       xi
                   },
                   genomdat[ina], n, c(-k:-1, 1:k), outlier.SD, smooth.SD)
        acghdata[ina] <- smoothed.data
    }
    acghdata
  }

internalDNAcopySegm <- function(acghdata,
                                chrom.numeric,
                                sbdry,
                                sbn,
                                alpha,
                                nperm,
                                kmax,
                                nmin,
                                trim,
                                undo.prune,
                                undo.SD,
                                p.method,
                                undo.splits,
                                min.width) {
    ## tries to follow the original "segment"

    ## p.method <- "hybrid"
    ## undo.splits <- "none"
    ## min.width <- 2
  
    uchrom <- unique(chrom.numeric)
    data.type <- "logratio"
    genomdati <- acghdata
    ina <- which(!is.na(genomdati) & !(abs(genomdati)==Inf))
    
    ## The code allows for dealing with NA and Inf, but would need to
    ## adjust other functions (as different arrays would have different
    ## length of pos, genenames, etc. So for now stop:
    if (length(ina) != length(genomdati))
        stop("Either an NA or an infinite in the data")

    genomdati <- genomdati[ina]
    trimmed.SD <- sqrt(adacgh_trimmed.variance(genomdati, trim))
    chromi <- chrom.numeric[ina]
    sample.lsegs <- NULL
    sample.segmeans <- NULL
##     cat("\n DEBUG: internalDNAcopySegm: before loop uchrom \n")

    for (ic in uchrom) {
##         cat("\n DEBUG: internalDNAcopySegm: before changepoints \n")
##         browser()
        segci <- adacgh_changepoints(genomdati[chromi==ic],
                              data.type = "logratio",
                              alpha = alpha, sbdry = sbdry, sbn = sbn,
                              nperm = nperm, p.method = p.method,
                              kmax = kmax, nmin = nmin,
                              trimmed.SD = trimmed.SD,
                              undo.splits = undo.splits,
                              undo.prune = undo.prune,
                              undo.SD = undo.SD, verbose = 2,
                              min.width = min.width)
##         cat("\n DEBUG: internalDNAcopySegm: end of changepoints \n")

        sample.lsegs <- c(sample.lsegs, segci$lseg)
        sample.segmeans <- c(sample.segmeans, segci$segmeans)

    }
##     cat("\n DEBUG: internalDNAcopySegm: after loop uchrom \n")

    if(length(sample.lsegs) != length(sample.segmeans))
        stop("Something terribly wrong: length(sample.lsegs) != length(sample.segmeans).")
    stretched.segmeans <- rep(sample.segmeans, sample.lsegs)
    stretched.state    <- rep(1:length(sample.lsegs), sample.lsegs)
    return(cbind(Predicted = stretched.segmeans,
                 State = stretched.state))
  }


ourMerge <- function(observed, predicted,
                     merge.pv.thresh = 1e-04,
                     merge.ansari.sign = 0.05,
                     merge.thresMin = 0.05,
                     merge.thresMax = 0.5) {

    ## cat("\n        Starting merge \n")
    segmentus2 <-
      mergeLevelsB(vecObs  = observed,
                   vecPred = predicted,
                   pv.thres = merge.pv.thresh,
                   ansari.sign = merge.ansari.sign,
                   thresMin = merge.thresMin,
                   thresMax = merge.thresMax,
                   verbose = 0)$vecMerged
    
    classes.ref <- which.min(abs(unique(segmentus2)))
    classes.ref <- unique(segmentus2)[classes.ref]
    ref <- rep(0, length(segmentus2))
    ref[segmentus2 > classes.ref] <- 1
    ref[segmentus2 < classes.ref] <- -1
    ## cat("\n        Done  merge \n")
    ## nodeWhere(" ourMerge")
    return(cbind(MergedMean = segmentus2,
                 Alteration = ref))
}






#######################################################
#######################################################
#######################################################
###
###            Wavelet approach
###            Hsu et al.
###
#######################################################
#######################################################
#######################################################

#### The first part is the code as provided by Hsu and Grove.
####  Below are my (R.D.-U.) modifications

####################################################################
## Thresholding functions (slightly diff. than ones in 'waveslim'
####################################################################


our.sure <- function (wc, max.level = 4, hard = TRUE)
{
    if (hard) { shrink <- function(w,s) w*(abs(w)>s)
    } else shrink <- function(w,s) sign(w)*(abs(w)-s)*(abs(w)>s)

    for (i in 1:max.level) {
        wci <- wc[[i]]
        ni <- length(wci)
        factor <- mad(wci)

        sxi <- sort(abs( wci/factor ))^2
        s <- cumsum(sxi) + ((ni - 1):0) * sxi
        risk <- (ni - (2 * (1:ni)) + s)/ni

        surethresh <- sqrt(sxi[order(risk)[1]])*factor
        wc[[i]] <- shrink(wci,surethresh)
    }
    wc
}


nominal.thresh <- function (wc, max.level = 4, hard = TRUE, sig.lvl=.05)
  ## If you want threshold all but the coefficients significant at 
  ## level .05 (two-sided, and assuming normality) then set sig.lvl=.05
{
     if (hard) { shrink <- function(w,t) w*(abs(w)>t)
     } else shrink <- function(w,t) sign(w)*(abs(w)-t)*(abs(w)>t)

     for (i in 1:max.level) {
         wci <- wc[[i]]
         ni <- length(wci)
         factor <- mad(wci)

         sd.thresh <- qnorm(1-sig.lvl/2)*factor
         wc[[i]] <- shrink(wci,sd.thresh)
     }
     wc
}


our.hybrid <- function (wc, max.level = 4, hard=TRUE)
{
     if (hard) { shrink <- function(w,t) w*(abs(w)>t)
     } else shrink <- function(w,t) sign(w)*(abs(w)-t)*(abs(w)>t)

     for (i in 1:max.level) {
         wci <- wc[[i]]
         ni <- length(wci)
         factor <- mad(wci)

         if ((sum((wci/factor)^2)-ni)/ni <= sqrt(log2(ni)^3/ni)) {
              ## If not enough spread in coefficients, use
              ## 'universal threshold'
              unithresh <- factor*sqrt(2*log(ni))
              wc[[i]] <- shrink(wci,unithresh)
         }
         else
         {
             ## otherwise use sure threshold
             sxi <- sort(abs( wci/factor ))^2
             s <- cumsum(sxi) + ((ni - 1):0) * sxi
             risk <- (ni - (2 * (1:ni)) + s)/ni

             surethresh <- sqrt(sxi[order(risk)[1]])*factor

             wc[[i]] <- shrink(wci,surethresh)
         }
     }
     wc
}
###################################################################
##               End of Thresholding functions                   ##
###################################################################




####################################################################
##  segment() is a function that:
##  (a) clusters the threshheld data, 
##  (b) collapses together clusters "closer" than 'minDiff',
##  (c) return the median value of the cluster to which each data 
##      point was assigned as its predicted value 
## 
####################################################################

## I (RDU) rename segment to segmentW to prevent confussion

segmentW <- function(obs.dat, rec.dat, minDiff=0.25, n.levels=10) {
    ## 'obs.dat' is OBServed DATa
    ## 'rec.dat' is "REConstructed DATa" following wavelet thresholding
    ## 'n.levels' is the initial number of clusters to form 
    ## 'minDiff' is the MINimum (absolute) DIFFerence between the medians
    ##           of two adjacent clusters for them to be considered truly
    ##           different.  Clusters "closer" together than this are
    ##           collapsed together to form a single cluster.

    pam.out <- pam(rec.dat, n.levels)
    clust.indx <- pam.out$clustering
    med <- as.vector(pam.out$medoids)

    ord  <- order(med)
    ord.med  <- med[ord]

    ## ord.lab contains the unique group labels (i.e. if 4 groups then 1:4)
    ## ordered according to the values in 'med'
    ord.lab <- (1:length(med))[ord]

    diff.med   <- diff(ord.med)

    done <- !(min(diff.med) < minDiff)
    while (!done) {
  
        ## get labels of groups that are closest together
        w <- which.min(diff.med)
        grp.1 <- ord.lab[w]
        grp.2 <- ord.lab[w+1]

        ## rename grp.2 to grp.1
        clust.indx[which(clust.indx == grp.2)] <- grp.1
        
        ## delete grp.2 from the vector ord.lab
        ord.lab <- ord.lab[which(ord.lab != grp.2)] 

        ## get new medians
        ord.med <- unlist(lapply(ord.lab, function(x,I,dat) median(dat[I==x]), 
                                 clust.indx, rec.dat))

        ## figure out if we are done or not
        if (length(ord.med)>1) {
            diff.med <- diff(ord.med)
            done <- !(min(diff.med) < minDiff)
        } else done <- TRUE
    }

    ## create and output vector of same length as original data
    new.medians <- integer(length=length(rec.dat))
    for (i in 1:length(ord.lab)){
        ind <- which(clust.indx == ord.lab[i])
        new.medians[ind] <- median(obs.dat[ind])
    }
    return(new.medians)
}
####################################################################



#######################################################
#######################################################
#######################################################
###
###            Printing results and PaLS
###            
###
#######################################################
#######################################################
#######################################################


## writeResults <- function(obj, ...) {
##     UseMethod("writeResults")
## }


## writeResults.CGH.wave <- function(obj, acghdata, commondata,
##                                   file = "wavelet.output.txt", ...) {
##     if(inherits(obj, "CGH.wave.merged")) {pals <- TRUE} else {pals <- FALSE}
##     print.adacgh.generic.results(obj, acghdata, commondata, output = file,
##                                  send_to_pals = pals)
## }

## writeResults.DNAcopy <- function(obj, acghdata, commondata, 
##                                  file = "CBS.output.txt", ...) {
##   print.adacgh.generic.results(obj, acghdata,
##                                commondata, output = file)
## }

## writeResults.CGHseg <- function(obj, acghdata, commondata, 
##                                  file = "CGHseg.output.txt", ...) {
##     print.adacgh.generic.results(obj, acghdata,
##                                 commondata, output = file,
##                                  send_to_pals = FALSE)
## }

## writeResults.adacghHaarSeg <- function(obj, acghdata, commondata, 
##                                  file = "HaarSeg.output.txt", ...) {
##     print.adacgh.generic.results(obj, acghdata,
##                                  commondata, output = file)
## }



## writeResults.mergedHMM <- function(obj, acghdata, commondata, 
##                                  file = "HMM.output.txt", ...) {
##     print.adacgh.generic.results(obj, acghdata,
##                                 commondata, output = file)
## }

## writeResults.adacghGLAD <- function(obj, acghdata, commondata, 
##                                  file = "GLAD.output.txt", ...) {
##     print.adacgh.generic.results(obj, acghdata,
##                                 commondata, output = file)
## }

## writeResults.mergedBioHMM <- function(obj, acghdata, commondata, 
##                                  file = "BioHMM.output.txt", ...) {
##     print.adacgh.generic.results(obj, acghdata,
##                                 commondata, output = file)
## }

## print.adacgh.generic.results <- function(res, xcenter,
##                                  commondata,
##                                  output = "ADaCGH.results.txt",
##                                  send_to_pals = TRUE){

##     out <- data.frame(commondata)
##     if(ncol(out) > 5) {
##         stop("This sucks, but if your commondata has more than 5 columns, this function will blow up.")
##     }

##     for(i in 1:ncol(xcenter)) {
##       out <- cbind(out, res$segm[[i]])
##     }
##     colnames(out)[(ncol(commondata) + 1):(ncol(out))] <-
##         paste(rep(colnames(xcenter),rep(3, ncol(xcenter))),
##               c(".Original", ".Smoothed", ".Status"),
##               sep = "")

##     write.table(out, file = output,
##                 sep = "\t", col.names = NA,
##                 row.names = TRUE, quote = FALSE)

##     if (exists(".__ADaCGH_WEB_APPL", env = .GlobalEnv) & send_to_pals) {
##         cols.look <- seq(from = 8, to = ncol(out), by = 3)

##         Ids <- apply(out[, cols.look, drop = FALSE], 2,
##                      function(z) commondata$ID[which( z == -1)])
##         writeForPaLS(Ids, colnames(xcenter), "Lost_for_PaLS.txt")
        
##         Ids <- apply(out[, cols.look, drop = FALSE], 2,
##                      function(z) commondata$ID[which( z == 1)])
##         writeForPaLS(Ids, colnames(xcenter), "Gained_for_PaLS.txt")

##         Ids <- apply(out[, cols.look, drop = FALSE], 2,
##                      function(z) commondata$ID[which( z != 0)])
##         writeForPaLS(Ids, colnames(xcenter), "Gained_or_Lost_for_PaLS.txt")
##     }

## }

## writeForPaLS <- function(alist, names, outfile) {
##     ## alist: a list with as many lists as subjects; each sublist are the
##     ##        genes of interest.
##     ## names: subject or array names
##     ## outfile: guess what? is the name of the output file

    
##   if(is.array(alist) | is.matrix(alist) )
##     if (dim(alist)[2] == 1) alist <- as.vector(alist)

##     if(!is.list(alist) & is.vector(alist) & (length(names) == 1)) {
##         ## we suppose we are dealing with a one-array data set
##         alist <- list(alist)
##     }
##   if(length(alist) == 0) {
##       write("", file = outfile)
##   } else if(length(names) != length(alist)) {
##       print("names are ")
##       print(names)
##       print("alist is ")
##       print(alist)
##       stop("ERROR in writeForPaLS: names and alist should have the same length")
##   } else {
##       write(
##             unlist(
##                    mapply(function(x, y) return(c(paste("#", y, sep = ""), as.character(x))),
##                           alist, names)
##                    ),
##             file = outfile)
##   }
## }




##################################################
##################################################
##################################################
##################################################


##### Internal stuff, mostly for the web-based part

##### FIXME: this is all VERY ugly. We should not have code here that refers
##    to the web app, because it is a mess to change the web-app behavior, and
##    that should not be retrofitted here.

##    I do not want to break the old stuff for ADaCGH web app. So I call
##    another function for the new server. This will allow smoother changes
##    when we finally finish with the old ADaCGH web app.

caughtOtherError <- function(message) {
    png.height <- 400
    png.width  <- 400
    png.pointsize <- 10

    if(exists(".__ADaCGH_WEB_APPL", env = .GlobalEnv)) {
        png("ErrorFigure.png", width = png.width,
            height = png.height, 
            pointsize = png.pointsize)
        plot(x = c(0, 1), y = c(0, 1),
             type = "n", axes = FALSE, xlab = "", ylab = "")
        box()
        text(0.5, 0.7, "There was a PROBLEM with this run.")
        dev.off()
        sink(file = "results.txt")
        cat(message)
        sink()
        sink(file = "exitStatus")
        cat("Error\n\n")
        cat(message)
        sink()
        quit(save = "no", status = 11, runLast = TRUE)
    } else if(exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv)) {
        caughtOtherError.Web(message)

    } else {
        message <- paste(message, " ", collapse = " ")
        message <- paste("There is a possible problem: ", message)
        stop(message)
    }
}

caughtError <- function(message) {
    png.height <- 400
    png.width  <- 400
    png.pointsize <- 10

    if(exists(".__ADaCGH_WEB_APPL", env = .GlobalEnv)) {
        png("ErrorFigure.png", width = png.width,
            height = png.height, 
            pointsize = png.pointsize)
        plot(x = c(0, 1), y = c(0, 1),
             type = "n", axes = FALSE, xlab = "", ylab = "")
        box()
        text(0.5, 0.7, "There was a PROBLEM with this run.")
        dev.off()
        sink(file = "results.txt")
        cat(message)
        sink()
        sink(file = "exitStatus")
        cat("Error\n\n")
        cat(message)
        sink()
        quit(save = "no", status = 11, runLast = TRUE)
    } else if(exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv)) {
        caughtOtherPackageError.Web(message)
    } else {
        message <- paste("This is a known problem in a package we depend upon. ", message)
        stop(message)
    }
}



## caughtOurError <- function(message) {
##     png.height <- 400
##     png.width  <- 400
##     png.pointsize <- 10

##     if(exists(".__ADaCGH_WEB_APPL", env = .GlobalEnv)) {
##         png("ErrorFigure.png", width = png.width,
##                height = png.height, 
##                pointsize = png.pointsize)
##         plot(x = c(0, 1), y = c(0, 1),
##              type = "n", axes = FALSE, xlab = "", ylab = "")
##         box()
##         text(0.5, 0.7, "There was a PROBLEM with the code.")
##         text(0.5, 0.5,
##              "Please let us know (send us the URL),")
        
##         text(0.5, 0.3, "so that we can fix it.")
##         dev.off()
##         sink(file = "results.txt")
##         cat(message)
##         sink()
##         sink(file = "exitStatus")
##         cat("Error\n\n")
##         cat(message)
##         sink()
##         quit(save = "no", status = 11, runLast = TRUE)
##     } else if(exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv)) {
##         caughtOurError2(message)
##     } else {
##         message <- paste("It looks like you found a bug. Please let us know. ", message)
##         stop(message)
##     }
## }
    



caughtOtherError.Web <- function(message) {
    snowfall.clean.quit.Web()
    sink(file = "R_Error_msg.txt")
    cat(message)
    cat("\n")
    sink()
    sink(file = "R_Status.txt")
    cat("Other Error\n\n")
    sink()
    quit(save = "no", status = 11, runLast = FALSE)
}

caughtOtherPackageError.Web <- function(message) {
    snowfall.clean.quit.Web()
    message <- paste("This is a known problem in a package we depend upon. ",
                     message)
    sink(file = "R_Error_msg.txt")
    cat(message)
    cat("\n")
    sink()
    sink(file = "R_Status.txt")
    cat("Other Error\n\n")
    sink()
    quit(save = "no", status = 11, runLast = FALSE)
}



snowfall.clean.quit.Web <- function() {
  try(sfStop(), silent = TRUE)
}

mpi.clean.quit.Web <- function() {
    if (is.loaded("mpi_initialize")){ 
        if (mpi.comm.size(1) > 0){ 
            try(mpi.close.Rslaves() , silent = TRUE)
        } 
    }
    try(mpi.exit(), silent = TRUE)
}


caughtOurError2 <- function(message) {
  message <- paste("There was a problem with our code. Please let us know.\n", 
                   message)
  if(exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv)) {
    snowfall.clean.quit.Web()
    sink(file = "R_Error_msg.txt")
    cat(message)
    cat("\n")
    sink()
    sink(file = "R_Status.txt")
    cat("Our Error\n\n")
    sink()
    quit(save = "no", status = 11, runLast = FALSE)
  } else {
    stop(message)
  }
}


caughtUserError2 <- function(message) {
  message <- paste("There was a problem with something you did.\n",
                     "Check the error message, your data and options and try again.\n",
                   message, "\n")
  if(exists(".__ADaCGH_SERVER_APPL", env = .GlobalEnv)) {
    snowfall.clean.quit.Web()
    sink(file = "R_Error_msg.txt")
    cat(message)
    cat("\n")
    sink()
    sink(file = "R_Status.txt")
    cat("User Error\n\n")
    sink()
    quit(save = "no", status = 11, runLast = FALSE)
  } else {
    stop(message)
  }
}


## doCheckpoint <- function(num, save = TRUE) {
## ##    checkpoint.num.new <- num
##   if(save) save.image()
## ##    checkpoint.num <<- num
##     sink("checkpoint.num")
##     cat(num)
##     sink()
##     return(num)
## }




## my.html.data.frame <- function (object, first.col = "Name",
##                              file = paste(first.word(deparse(substitute(object))), 
##                              "html", sep = "."), append = FALSE, link = NULL, linkCol = 1, 
##                              linkType = c("href", "name"), ...) 
## {
##     ## modifying html, from Hmisc: Their function always has first column
##     ## named "Name". I allow to pass a name.
   
##     linkType <- match.arg(linkType)
##     x <- format.df(object, numeric.dollar = FALSE, ...)
##     adj <- attr(x, "col.just")
##     if (any(adj == "r")) 
##         for (i in seq(along = adj)[adj == "r"]) x[, i] <- paste("<div align=right>", 
##             x[, i], "</div>", sep = "")
##     if (length(r <- dimnames(x)[[1]])) 
##         x <- cbind(first.col = r, x)
##     colnames(x)[1] <- first.col
##     cat("<TABLE BORDER>\n", file = file, append = append)
##     cat("<tr>", paste("<td>", dimnames(x)[[2]], "</td>", sep = ""), 
##         "</tr>\n", sep = "", file = file, append = file != "")
##     if (length(link)) 
##         x[, linkCol] <- ifelse(link == "", x[, linkCol], paste("<a ", 
##             linkType, "=\"", link, "\">", x[, linkCol], "</a>", 
##             sep = ""))
##     for (i in 1:nrow(x)) cat("<tr>", paste("<td>", x[i, ], "</td>", 
##         sep = ""), "</tr>\n", sep = "", file = file, append = file != 
##         "")
##     cat("</TABLE>\n", file = file, append = file != "")
##     structure(list(file = file), class = "html")
## }






    
######################################################

#########  Imagemap stuff


imClose3 <- function (im) {
    ## prevent all the "Closing PNG device ..."
    dev.off(im$Device)
}

imagemap3 <- function(filename,width=480,height=480,
                      title='Imagemap from R', ps = 12){
## copied from "imagemap" function in imagemap.R from B. Rowlingson
  
    png(file = paste(filename,".png",sep=''),
        width=width,
        height=height,
        pointsize = ps)	  
	  
    im <- list()
    im$Device <- dev.cur()
    im$Filename=filename
    im$Height=height
    im$Width=width
    im$Objects <- list()
    im$HTML <- list()
    im$title <- title
    
    class(im) <- "imagemap"
    im
}

createIM2 <- function(im, file = "", imgTags = list(),
                      title = "Genome View") {
    cat(paste("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n",
              "<html> <head> <title>", title, "</title></head><body>"),
        file = file)
    cat(buildIM(im, imgTags), sep = "\n", file = file, append = TRUE)
    cat("</body></html>", file = file, append = TRUE)
}




###############################################
###############################################
############
############   Ansari test and merge stuff
############
###############################################
###############################################




##### This is straight from aCGH, but fixing the problem of wilcox.text(exact = T)

mergeLevelsB <- function(vecObs, vecPred,
                         pv.thres=0.0001, ansari.sign=0.05, thresMin=0.05,
                         thresMax=0.5,verbose=1,scale=TRUE){

  ## Check if supplied thresholds are valid
  if(thresMin>thresMax){cat("Error, thresMax should be equal to or larger than thresMin\n");return()}


# Initializing threshold and threshold vector for keeping track of thresholds
thresAbs=thresMin
sq<-numeric()

#initializing threshold index (threshold count)
j=0

#initializing ansari p-values to keep track of ansari p-values for each threshold in sq
ansari=numeric()

# Initialize levels count
lv=numeric()

# Set backtracking flag. Start with flag=0 indicating significance not yet reached, backtracking not begun
flag=0

# If thresMin=thresMax, fixed threshold is used and we set flag=2, only one run of the algoritm with initial thresMin
if(thresMin==thresMax){flag=2}

# Evaluate optimum steps for algorithm
else {
 l.step <- signif((thresMax-thresMin)/10,1)
 s.step <- signif((thresMax-thresMin)/200,1)
}

while (1){

  # Print current threshold if verbose is 1 or larger
  if(verbose>=1){cat("\nCurrent thresAbs: ",thresAbs,"\n")}

  j=j+1

  # Save current threshold
  sq[j]<-thresAbs

  # temporary predicted values (to be updated)
  vecPredNow=vecPred

  #unmissing unique segment medians
  mnNow=unique(vecPred)
  mnNow=mnNow[!is.na(mnNow)]

  #continuing indicator otherwise get out of the loop
  cont=0

  while(cont==0 & length(mnNow)>1) {

        mnNow=sort(mnNow)  #currennt sorted vector of means
        n <- length(mnNow)  # number of means in mnNow

        # Print current number of levels (n) if verbose is 2 or larger
        if(verbose>=2){ cat("\r",n,":",length(unique(vecPred)),"\t")}

        # Get distances translated to copy number differences
        # Only distances to closest levels
        if(scale){d<-(2*2^mnNow)[-n]-(2*2^mnNow)[-1]}
        else{d<-(mnNow)[-n]-(mnNow)[-1]}

        #order distance between means with the closest on top and corresponding indices
        dst<-cbind(abs(d)[order(abs(d))],(2:n)[order(abs(d))],(1:(n-1))[order(abs(d))])

        #for each pair of means
        for (i in 1:nrow(dst))  {
                #set continuity index to "NOT continue" (=1)
                cont=1
                #test for combining of the two segment means
                out=combine.funcB(diff=dst[i,1],vecObs, vecPredNow, mnNow, mn1=mnNow[dst[i,2]], mn2=mnNow[dst[i,3]], pv.thres=pv.thres, thresAbs=if(scale){2*2^thresAbs-2}else{thresAbs})
                #if combine?
                if (out$pv > pv.thres) {

                       #set continuity index to "YES" (=0) and break out of the current pairs loop
                       cont=0

                       #update predicted values and segments
                       vecPredNow=out$vecPredNow
                       mnNow=out$mnNow
                       break
                 }                
          }               
 }

### When done merging for a given threshold, test for significance ####
        ansari[j]=my.ansari.test(sort(vecObs-vecPredNow), sort(vecObs-vecPred))$p.value
  if(is.na(ansari[j])){ansari[j]=0} # If too many numbers for test to be performed, a 0 is returned, resulting in no merging (please use fixed threshold to get any merging)
  lv[j]=length(mnNow) # get number of levels

### If backtracking flag=2, the merging is stopped at this thresMax (or fixed threshold) ###
  if(flag==2){ break }

  # If p.value is less than the significance threshold, set backtracking flag=1 (backtracking on)
  if(ansari[j]<ansari.sign){
                        flag=1
  }

        
### If backtracking is on, a smaller threshold is attempted ####
        if (flag){

        # Stop if backtracking is on and p.value is higher than sign threshold or threshold is less or equal to thresMin
        if (ansari[j]>ansari.sign | thresAbs == thresMin){

#        # Don't merge at all if all tested threshold including thresMin is significant
#                         if (ansari[j] <= ansari.sign) {
#                                 vecPredNow=vecPred
#                                 mnNow=unique(vecPred)
#                                 mnNow=mnNow[!is.na(mnNow)]
#                         }
                                                  
        break
        }

      # Attempt smaller threshold
        else {
        thresAbs=signif(thresAbs-s.step,3)

        # Set threshold to thresMin as a minimum
        if (thresAbs <= thresMin){ thresAbs = thresMin }
      }
        }
        

### Increase threshold if backtracking is not on ###
        else {thresAbs=thresAbs+l.step}

#### Control step so function won't keep running, max threshold = thresMax and if sign not reached, threshold = thresMax ###
          if (thresAbs >= thresMax){
        thresAbs=thresMax
                    flag=2
          }

} # End while


# Return list of results
return(list(vecMerged=vecPredNow,mnNow=mnNow,sq=sq,ansari=ansari))
}





my.ansari.test <- function (x, ...) {
UseMethod("ansari.test")
}

my.ansari.test.default <-
function (x, y, alternative = c("two.sided", "less", "greater"),
exact = NULL, conf.int = FALSE, conf.level = 0.95, ...)
{

  ##R_pansari and R_qansari are in stats namespace
  thisR_pansari <- stats:::R_pansari
  thisR_qansari <- stats:::R_qansari
  
 alternative <- match.arg(alternative)
 if (conf.int) {
   if (!((length(conf.level) == 1) && is.finite(conf.level) &&
     (conf.level > 0) && (conf.level < 1)))
     stop("'conf.level' must be a single number between 0 and 1")
 }
 DNAME <- paste(deparse(substitute(x)), "and", deparse(substitute(y)))
 x <- x[complete.cases(x)]
 y <- y[complete.cases(y)]
 m <- length(x)
 if (m < 1)
   stop("not enough 'x' observations")
 n <- length(y)
 if (n < 1)
   stop("not enough 'y' observations")
 N <- m + n
 r <- rank(c(x, y))
 STATISTIC <- sum(pmin(r, N - r + 1)[seq_along(x)])
 TIES <- (length(r) != length(unique(r)))
 if (is.null(exact))
   exact <- ((m < 50) && (n < 50))
 if (exact && !TIES) {
   pansari <- function(q, m, n) {
     .C(thisR_pansari, as.integer(length(q)), p = as.double(q),
       as.integer(m), as.integer(n))$p
   }
   PVAL <- switch(alternative, two.sided = {
     if (STATISTIC > ((m + 1)^2%/%4 + ((m * n)%/%2)/2))
       p <- 1 - pansari(STATISTIC - 1, m, n)
     else p <- pansari(STATISTIC, m, n)
     min(2 * p, 1)
   }, less = 1 - pansari(STATISTIC - 1, m, n), greater =
pansari(STATISTIC,
     m, n))
   if (conf.int) {
     qansari <- function(p, m, n) {
       .C(thisR_qansari, as.integer(length(p)), q = as.double(p),
        as.integer(m), as.integer(n))$q
     }
     alpha <- 1 - conf.level
     x <- sort(x)
     y <- sort(y)
     ab <- function(sig) {
       rab <- rank(c(x/sig, y))
       sum(pmin(rab, N - rab + 1)[seq_along(x)])
     }
     ratio <- outer(x, y, "/")
     aratio <- ratio[ratio >= 0]
     sigma <- sort(aratio)
     cci <- function(alpha) {
       u <- absigma - qansari(alpha/2, m, n)
       l <- absigma - qansari(1 - alpha/2, m, n)
       uci <- NULL
       lci <- NULL
       if (length(u[u >= 0]) == 0 || length(l[l > 0]) ==
        0) {
        warning("samples differ in location: cannot compute
confidence set, returning NA")
        return(c(NA, NA))
       }
       if (is.null(uci)) {
        u[u < 0] <- NA
        uci <- min(sigma[which(u == min(u, na.rm = TRUE))])
       }
       if (is.null(lci)) {
        l[l <= 0] <- NA
        lci <- max(sigma[which(l == min(l, na.rm = TRUE))])
       }
       if (uci > lci) {
        l <- absigma - qansari(alpha/2, m, n)
        u <- absigma - qansari(1 - alpha/2, m, n)
        u[u < 0] <- NA
        uci <- min(sigma[which(u == min(u, na.rm = TRUE))])
        l[l <= 0] <- NA
        lci <- max(sigma[which(l == min(l, na.rm = TRUE))])
       }
       c(uci, lci)
     }
     cint <- if (length(sigma) < 1) {
       warning("cannot compute confidence set, returning NA")
       c(NA, NA)
     }
     else {
       absigma <- sapply(sigma + c(diff(sigma)/2,
sigma[length(sigma)] *
        1.01), ab)
       switch(alternative, two.sided = {
        cci(alpha)
       }, greater = {
        c(cci(alpha * 2)[1], Inf)
       }, less = {
        c(0, cci(alpha * 2)[2])
       })
     }
     attr(cint, "conf.level") <- conf.level
     u <- absigma - qansari(0.5, m, n)
     sgr <- sigma[u <= 0]
     if (length(sgr) == 0)
       sgr <- NA
     else sgr <- max(sgr)
     sle <- sigma[u > 0]
     if (length(sle) == 0)
       sle <- NA
     else sle <- min(sle)
     ESTIMATE <- mean(c(sle, sgr))
   }
 }
 else {
   EVEN <- ((N%%2) == 0)
   normalize <- function(s, r, TIES, m = length(x), n = length(y)) {
##########################################
## Here is the problem: length(x) returns an integer
m <- as.double(m)
n <- as.double(n)
##########################################
     z <- if (EVEN)
       s - m * (N + 2)/4
     else s - m * (N + 1)^2/(4 * N)
     if (!TIES) {
       SIGMA <- if (EVEN)
        sqrt((m * n * (N + 2) * (N - 2))/(48 * (N -
         1)))
       else sqrt((m * n * (N + 1) * (3 + N^2))/(48 *
        N^2))
     }
     else {
       r <- rle(sort(pmin(r, N - r + 1)))
       SIGMA <- if (EVEN)
        sqrt(m * n * (16 * sum(r$lengths * r$values^2) -
         N * (N + 2)^2)/(16 * N * (N - 1)))
       else sqrt(m * n * (16 * N * sum(r$lengths * r$values^2) -
        (N + 1)^4)/(16 * N^2 * (N - 1)))
     }
     z/SIGMA
   }
   p <- pnorm(normalize(STATISTIC, r, TIES))
   PVAL <- switch(alternative, two.sided = 2 * min(p, 1 -
     p), less = 1 - p, greater = p)
   if (conf.int && !exact) {
     alpha <- 1 - conf.level
     ab2 <- function(sig, zq) {
       r <- rank(c(x/sig, y))
       s <- sum(pmin(r, N - r + 1)[seq_along(x)])
       TIES <- (length(r) != length(unique(r)))
       normalize(s, r, TIES, length(x), length(y)) -
        zq
     }
     srangepos <- NULL
     srangeneg <- NULL
     if (length(x[x > 0]) && length(y[y > 0]))
       srangepos <- c(min(x[x > 0], na.rm = TRUE)/max(y[y >
        0], na.rm = TRUE), max(x[x > 0], na.rm = TRUE)/min(y[y >
        0], na.rm = TRUE))
     if (length(x[x <= 0]) && length(y[y < 0]))
       srangeneg <- c(min(x[x <= 0], na.rm = TRUE)/max(y[y <
        0], na.rm = TRUE), max(x[x <= 0], na.rm = TRUE)/min(y[y <
        0], na.rm = TRUE))
     if (any(is.infinite(c(srangepos, srangeneg)))) {
       warning("cannot compute asymptotic confidence set or estimator")
       conf.int <- FALSE
     }
     else {
       ccia <- function(alpha) {
        statu <- ab2(srange[1], zq = qnorm(alpha/2))
        statl <- ab2(srange[2], zq = qnorm(alpha/2,
         lower.tail = FALSE))
        if (statu > 0 || statl < 0) {
         warning("samples differ in location: cannot compute confidence set, returning NA")
         return(c(NA, NA))
        }
        u <- uniroot(ab2, srange, tol = 1e-04, zq =
qnorm(alpha/2))$root
        l <- uniroot(ab2, srange, tol = 1e-04, zq = qnorm(alpha/2,
         lower.tail = FALSE))$root
        sort(c(u, l))
       }
       srange <- range(c(srangepos, srangeneg), na.rm = FALSE)
       cint <- switch(alternative, two.sided = {
        ccia(alpha)
       }, greater = {
        c(ccia(alpha * 2)[1], Inf)
       }, less = {
        c(0, ccia(alpha * 2)[2])
       })
       attr(cint, "conf.level") <- conf.level
       statu <- ab2(srange[1], zq = 0)
       statl <- ab2(srange[2], zq = 0)
       if (statu > 0 || statl < 0) {
        ESTIMATE <- NA
        warning("cannot compute estimate, returning NA")
       }
       else ESTIMATE <- uniroot(ab2, srange, tol = 1e-04,
        zq = 0)$root
     }
   }
   if (exact && TIES) {
     warning("cannot compute exact p-value with ties")
     if (conf.int)
       warning("cannot compute exact confidence intervals with ties")
   }
 }
 names(STATISTIC) <- "AB"
 RVAL <- list(statistic = STATISTIC, p.value = PVAL, null.value =
              c(`ratio of scales` = 1),
   alternative = alternative, method = "Ansari-Bradley test",
   data.name = DNAME)
 if (conf.int)
   RVAL <- c(RVAL, list(conf.int = cint, estimate = c(`ratio of scales` = ESTIMATE)))
 class(RVAL) <- "htest"
 return(RVAL)
}









#################################


combine.funcB <- function(diff,vecObs, vecPredNow, mnNow, mn1, mn2, pv.thres=0.0001, thresAbs=0)
{ 
  #observed values in the first segment
        vec1=vecObs[which(vecPredNow==mn1)]
  #observed values in the second segment
        vec2=vecObs[which(vecPredNow==mn2)]
        
  #if difference between segment medians does not exceed thresAbs, then set pv=1
        if (diff<=thresAbs) {
                pv=1
        }
  #otherwise test for difference in mean based on observed values
        else {
                if((length(vec1) > 10 & length(vec2) > 10) | sum(length(vec1),length(vec2))>100){
                        pv=wilcox.test(vec1,vec2)$p.value
                }
                else{pv=wilcox.test(vec1,vec2,exact=TRUE)$p.value  }       #/10^max(mn1,mn2)
                if(length(vec1) <= 3 | length(vec2) <= 3){pv=0}         
        }
        index.merged<-numeric()
  #if p-value exceeds pv.thres
        if (pv > pv.thres)      {
    #combine observed values
                vec=c(vec1,vec2)
    # Index values to be updated
                index.merged=which((vecPredNow==mn1) | (vecPredNow==mn2))               
    #update predicted values by median of the observed values
                vecPredNow[index.merged]=median(vec, na.rm=TRUE)
    #update segment medians  median of the observed values and remove one of the duplicates
                mnNow[which((mnNow==mn1) | (mnNow==mn2))]=median(vec, na.rm=TRUE)
                mnNow=unique(mnNow)
        }
        list(mnNow=mnNow, vecPredNow=vecPredNow, pv=pv)
}

#########################################



## in find.param.two.R
## Error in matrix(c(1 - p1, p1, p2, 1 - p2), ncol = 2, b = T) : 
##         T used instead of TRUE
## Error in matrix(c(1 - p1, p1, p2, 1 - p2), ncol = 2, b = T) : 
##         recursive default argument reference

## viterbvis
## Error in matrix(nrow = K, ncol = n, b = T) : 
##         T used instead of TRUE
## Error in matrix(nrow = K, ncol = n, b = T) : 
##         recursive default argument reference


## Error in max(-1e+05, log(BFGS.output$prior[i]), na.rm = T) :





### Utility functions

add.names.as.attr <- function(x, anames) {
    if(is.null(anames))
        anames <- paste("sample.", 1:length(x[[1]]), sep = "")
    
    for(i in 1:length(x[[1]])) {
        attributes(x[[1]][[i]]) <- c(attributes(x[[1]][[i]]),
                                     "ArrayName" = anames[i])
    }
    return(x)
}

warn.too.few.in.chrom2 <- function(x, min.num.chrom = 20) {
  if(!inherits(x, "rle"))
    stop("First argument should be of class rle")
  ## if too few samples, somethin funny is going on
  if(any(x$lengths < min.num.chrom))
    warning("There are fewer than ", min.num.chrom, " observations",
            "in some group of ", deparse(substitute(x)),
            "!!!!!!!!!!. \n This is unlikely to make sense.\n",
            "Note that you can get weird errors, or no output at all,", 
            "if you are running parallelized with certaind methods.")
}

warn.too.few.in.chrom <- function(x, min.num.chrom = 20) {
  ## if too few samples, somethin funny is going on
  tt <- table(x)
  if(any(tt < min.num.chrom))
    warning("There are fewer than ", min.num.chrom, " observations",
            "in some group of ", deparse(substitute(x)),
            "!!!!!!!!!!. \n This is unlikely to make sense.\n",
            "Note that you can get weird errors, or no output at all,", 
            "if you are running parallelized with certaind methods.")
}

stop.na.inf <- function(x) {
  ## The code for many functions allows for dealing with NA and Inf, but
  ## would need to adjust other functions (as different arrays would have
  ## different length of pos, genenames, etc. So for now stop
  if(any(is.na(x)) | any(is.infinite(x)))
        stop("Either an NA or an infinite in the data: ",
             deparse(substitute(x)), ".\n",
             "   Eliminate those values or use imputation")
}


### Example of usage. Suppose we create missing values

## cghE1[1:10, 5:7] <- NA
## imputed.x <- my.impute.lowess(cghE1[1:40, 5:7], rep(1, 40))


my.impute.lowess <- function (x,
                              chrom.numeric,
                              Clone = NULL,
                              Pos = NULL,
                              chrominfo = human.chrom.info.Jul03,
                              maxChrom = 23,
                              smooth = 0.1)
{
  ## BEWARE: Pos MUST be in kilobases!!!
  if(is.null(Clone)) Clone <- 1:length(chrom.numeric)
  if(is.null(Pos)) Pos <- Clone
  aCGH.obj <- create.aCGH(data.frame(x),
                          data.frame(Clone = Clone,
                                     Chrom = chrom.numeric,
                                     kb = Pos))
  
    data.imp <- log2.ratios <- log2.ratios(aCGH.obj)
    clones.info <- clones.info(aCGH.obj)
    uniq.chrom <- unique(clones.info$Chrom)
    for (j in uniq.chrom[uniq.chrom <= maxChrom]) {
        cat("Processing chromosome ", j, "\n")
        centr <- chrominfo$centromere[j]
        indl <- which(clones.info$Chrom == j & clones.info$kb <
            centr)
        indr <- which(clones.info$Chrom == j & clones.info$kb >
            centr)
        kbl <- clones.info$kb[indl]
        kbr <- clones.info$kb[indr]
        for (i in 1:ncol(log2.ratios)) {
            if (length(indl) > 0) {
                vecl <- log2.ratios[indl, i]
                ind <- which(!is.na(vecl))
                if (length(ind) > 1)
                  data.imp[indl, i][-ind] <- approx(lowess(kbl[ind],
                    vecl[ind], f = smooth), xout = kbl[-ind])$y
            }
            if (length(indr) > 0) {
                vecr <- log2.ratios[indr, i]
                ind <- which(!is.na(vecr))
                if (length(ind) > 0)
                  data.imp[indr, i][-ind] <- approx(lowess(kbr[ind],
                    vecr[ind], f = smooth), xout = kbr[-ind])$y
            }
        }
    }
    prop.miss <- apply(data.imp, 2, prop.na)
    if (max(prop.miss, na.rm = TRUE) > 0) {
        for (i in 1:ncol(data.imp)) {
            vec <- data.imp[, i]
            ind <- which(is.na(vec))
            if (length(ind) > 0) {
                vec[ind] <- sapply(ind, function(i) {
                  chr <- clones.info$Chrom[i]
                  kb <- clones.info$kb[i]
                  if (kb >= chrominfo$centromere[chr])
                    median(vec[clones.info$Chrom == chr & clones.info$kb >=
                      chrominfo$centromere[chr]], na.rm = TRUE)
                  else median(vec[clones.info$Chrom == chr &
                    clones.info$kb < chrominfo$centromere[chr]],
                    na.rm = TRUE)
                })
                vec[is.na(vec)] <- 0
                data.imp[, i] <- vec
            }
        }
    }
    prop.miss <- apply(data.imp, 2, prop.na)
    if (max(prop.miss) > 0)
        print(paste("Missing values still remain in samples ",
            which(prop.miss > 0)))
    data.imp
}


the.time.with.ms <- function() {
    uu <- as.POSIXlt(Sys.time())
    return(paste(uu$hour, uu$min,
                 paste(unlist(strsplit(as.character(uu$sec), "\\.")),
                       collapse = ""), sep = ""))
}

the.time.with.sec <- function() {
    uu <- as.POSIXlt(Sys.time())
    return(paste(uu$hour, uu$min, round(uu$sec), sep = "."))
}



tempdir2 <- function() {
    direxists <- TRUE
    while(direxists) {
        p1 <-  paste(round(runif(1, 1, 9999)),
                     the.time.with.sec(), sep = "_")
        p1 <- paste(tempfile(pattern = "tmpdir_ADaCGH2_",
                             tmpdir = "."),
                    p1, sep = "_")
        if(!file.exists(p1)) direxists <- FALSE
    }
    dir.create(p1)
    return(p1)
}



### Simple examples of stochasticity of methods and working of SegmentPlotWrite

### library(ADaCGH)
### data(cghE1)
### tmpchr <- sub("chr", "", cghE1$Chromosome)
### chrom.numeric <- as.numeric(as.character(tmpchr))
### chrom.numeric[tmpchr == "X"] <- 23
### chrom.numeric[tmpchr == "Y"] <- 24
### rm(tmpchr)
### ### we need the data ordered
### reorder <- order(chrom.numeric,
###                  cghE1$UG.Start,
###                  cghE1$UG.End,
###                  cghE1$Name)
### cghE1 <- cghE1[reorder, ]
### chrom.numeric <- chrom.numeric[reorder]



### #### DNAcopy: differences between pSegmentDNA and
### ##   SegmentPlotWrite: because DNAcopy is variable
### set.seed(1)
### cna.obj <- CNA(as.matrix(cghE1[, 5:7]),
###               chrom = chrom.numeric,
###               maploc = cghE1$UG.Start,
###               data.type = "logratio")
### smoothed <- smooth.CNA(cna.obj)
### segmented1 <- segment(smoothed, undo.splits = "none", nperm = 10000)
### segmented2 <- segment(smoothed, undo.splits = "none", nperm = 10000)
### segmented3 <- segment(smoothed, undo.splits = "none", nperm = 10000)
### segmented3$output[32:34, ]
### segmented1$output[32:34, ]


### #### HMM: this is highly variable

### Clone <- 1:nrow(cghE1)
### obj <- create.aCGH(data.frame(cghE1[, 5:7]), 
###                    data.frame(Clone = Clone,
###                               Chrom = chrom.numeric,
###                               kb     = cghE1$UG.Start ))
### set.seed(1)
### res <- find.hmm.states(obj, aic = TRUE, bic = FALSE)
### res2 <- find.hmm.states(obj, aic = TRUE, bic = FALSE)

### res$states.hmm[[1]][1334:1342, 2 + 4]
### res2$states.hmm[[1]][1334:1342, 2 + 4]



### ### GLAD: no changes here between SegmentPlotWrite
### ### and pSegmentGLAD
### ## Note also that the testAdacghNum.py, with GALD, shows
### ## perfect 

### oGLAD <- pSegmentGLAD(cghE1[, 5:7],
###                     chrom.numeric)
### setwd("/tmp/mG")
### SegmentPlotWrite(cghE1[, 5:7], chrom.numeric,
###                  Pos = cghE1$UG.Start,
###                  mergeSegs = FALSE,
###                  idtype = "ug", organism = "Hs",
###                  method = "GLAD",
###                  geneNames = cghE1[, 1], commondata = cghE1[, 1:4])

### spw.out <- read.table("/tmp/mG/GLAD.output.txt")

### summary(oGLAD$segm$S1[, 2] - spw.out$S1.Smoothed)
### summary(oGLAD$segm$S2[, 2] - spw.out$S2.Smoothed)
### summary(oGLAD$segm$S3[, 2] - spw.out$S3.Smoothed)
### summary(oGLAD$segm$S1[, 3] - spw.out$S1.Status)
### summary(oGLAD$segm$S2[, 3] - spw.out$S2.Status)
### summary(oGLAD$segm$S3[, 3] - spw.out$S3.Status)


my.usr2png <- function(xy, imWidth, imHeight) {
    dev <- dev.cur()
    xy <- fig2dev(plt2fig(usr2plt(xy,dev),dev),dev)
    cbind(
          ceiling(xy[,1]*imWidth),
          ceiling((1-xy[,2])*imHeight)
          )
}




## convertAndSave <- function(probeNames, chromosome, position, inputData,
##                            ffpattern = paste(getwd(), "/", sep = "")) {


##   if(!(is.data.frame(inputData)))
##     stop("inputData must be a data frame")
##   ## Minimal checking

##   rownames(inputData) <- NULL ## Don't? Takes a lot of memory not recoverd later
##   if(any(is.na(inputData))) 
##     stop(paste("Your aCGH file contains missing values. \n",
##                               "That is not allowed.\n"))
##   if(!is.numeric(chromosome))
##     stop(paste("Chromosome contains non-numeric data.\n",
##                               "That is not allowed.\n"))

##   if(any(table(chromosome) < 10))
##     stop("At least one of your chromosomes has
## less than 10 observations.\n That is not allowed.\n")

##   if(!all(is.wholeposnumber(chromosome)))
##     stop("Chromosome is NOT a positive integer!!\n")
##   if(max(chromosome) > 65000)
##     stop("Chromosome has more than 65000 levels!!\n")
  
##   if(any(!sapply(inputData, is.numeric)))
##     stop(paste("Your aCGH file contains non-numeric data. \n",
##                               "That is not allowed.\n")   )

##   ## Do we have any identical MidPos in the same chromosome??  Just to solve
##   ## it quickly and without nasty downstream consequences, we add a runif to
##   ## midPos. But NO further averaging.
   
##   tmp <- paste(chromosome, position, sep = ".")
##   if (sum(duplicated(tmp))) {
##     cat("\n We have identical MidPos!!! \n")
##     capture.output(print("We have identical MidPos!!!"), file = "WARNING.DUPLICATED")
##     ## add a random variate, to break ties:
##     position <-  positions +  runif(sum(duplicated(tmp)))
##     ## check it worked
##     tmp <- paste(chromosome, position, sep = ".")
##     if (sum(duplicated(tmp)))
##       stop("still duplicated MidPoints; shouldn't happen")
##     rm(tmp)
##     gc()
##     ## Reorder, just in case
##     reorder <- order(chromosome, position)
##     inputData <- inputData[reorder, ]
##     }
  
##   save(file = "probeNames.RData", probeNames, compress = FALSE)

##   chromData <- ff(as.integer(chromosome), vmode = "ushort",
##                   pattern = ffpattern)
##   close(chromData)
##   save(file = "chromData.RData", chromData, compress = FALSE)
##   rm(chromData)
##   posData <- ff(position, vmode = "double",
##                   pattern = ffpattern)
##   close(posData)
##   save(file = "posData.RData", posData, compress = FALSE)
##   rm(posData)
##   if(is.null(colnames(inputData))) {
##     narr <- ncol(inputData)
##     colnames(inputData) <- paste("A", 1:narr, sep = "")
##   }

##   if( packageDescription("ff")$Version >= "2.1-2" )
##     cghData <- as.ffdf(inputData, col_args=list(pattern = ffpattern))
##   else
##     cghData <- as.ffdf(inputData, pattern = ffpattern)

##   close(cghData)
##   rm(inputData)
##   save(file = "cghData.RData", cghData, compress = FALSE)
##   rm(cghData)

##   cat("\n Files saved in current directory \n", getwd(),
##       " with names :\n",
##       "chromData.RData, posData.RData, cghData.RData, probeNames.RData \n")

## }








### For inputDataToADaCGHData check what is better if eval((substitute or get(


## ## f0 <- function(z) get(z, inherits = FALSE)

## f1 <- function(x) {
##   nmobj <- load(x)
##   any(is.na(get(nmobj, inherits = FALSE)))
##   print(gc())
##   tmp <- get(nmobj, inherits = FALSE)[, 1]
##   print(gc())
##   tmp2 <- get(nmobj, inherits = FALSE)[, 2]
##   print(gc())
## }

## f2 <- function(x) {
##   nmobj <- load(x)
##   eval(substitute(any(is.na(x)), list(x = as.name(nmobj))))
##   print(gc())
##   eval(substitute(tmp <- x[, 1], list(x = as.name(nmobj))))
##   print(gc())
##   eval(substitute(tmp2 <- x[, 2], list(x = as.name(nmobj))))
##   print(gc())
## }

## ## d1 and d2 are very large
## gc(reset = TRUE)
## unix.time(f1("d1.RData"))
## gc()
## gc(reset = TRUE)
## unix.time(f2("d1.RData"))


## gc(reset = TRUE)
## unix.time(f2("d2.RData"))
## gc()
## gc(reset = TRUE)
## unix.time(f1("d2.RData"))

## ## There are no significant differences between the two.
## ## what is memory consuming is the "load" No further increases.
