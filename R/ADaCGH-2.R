## For GLAD: add verbose option, and turn the cat("\DEBUG) into something
## more useful such as cat("pSegment verbose output: )
## So replace the cat(whatever by if(verbose) cat(whatever-new


## TO-DO: If we knew there are no NAs, we could make things a lot faster
## eliminating all calls to expungeNA and impunge.

## based on snapCGH, modfied by Oscar Rueda
## imputeMissing <- function(log2r, chrominfo = chrominfo.Mb,
##                                   clones.info, maxChrom=24, smooth=0.1) {
## 	    data.imp <- log2ratios <- log2r
## 	    uniq.chrom <- unique(clones.info$Chr)
##         	for (j in uniq.chrom[uniq.chrom <= maxChrom]) {
## 	        cat("Processing chromosome ", j, "\n")
## 	        centr <- chrominfo$centromere[j]
##         	indl <- which(clones.info$Chr == j & clones.info$Position <
## 	            centr)
##         	indr <- which(clones.info$Chr == j & clones.info$Position >
## 	            centr)
## 	        kbl <- clones.info$Position[indl]
## 	        kbr <- clones.info$Position[indr]
## 	        for (i in 1:ncol(log2ratios)) {
##         	    if (length(indl) > 0) {
## 	                vecl <- log2ratios[indl, i]
## 	                if (length(vecl[!is.na(vecl) == TRUE]) != 0)
## 	                  ind <- which(!is.na(vecl))
## 	                else {
##         	          ind <- 0
## 	                }
##         	        if (length(ind) > 2) {
##                 	  data.imp[indl, i][-ind] <- approx(lowess(kbl[ind],
## 	                    vecl[ind], f = smooth), xout = kbl[-ind])$y
##         	        }
## 	            }
## 	        }
## 	    }
## 	    prop.miss <- apply(data.imp, 2, prop.na)
## 	    if (max(prop.miss, na.rm = TRUE) > 0) {
## 	        for (i in 1:ncol(data.imp)) {
## 	            vec <- data.imp[, i]
## 	            ind <- which(is.na(vec))
## 	            if (length(ind) > 0) {
##         	        vec[ind] <- sapply(ind, function(i) {
## 	                  chr <- clones.info$Chr[i]
## 	                  kb <- clones.info$Position[i]
## 	                  if (kb >= chrominfo$centromere[chr])
## 	                    median(vec[clones.info$Chr == chr & clones.info$Position >=
##         	              chrominfo$centromere[chr]], na.rm = TRUE)
##                 	  else median(vec[clones.info$Chr == chr &
## clones.info$Position <
## 	                    chrominfo$centromere[chr]], na.rm = TRUE)
##         	        })
## 	                vec[is.na(vec)] <- 0
## 	                data.imp[, i] <- vec
## 	            }
## 	        }
## 	    }
## 	    prop.miss <- apply(data.imp, 2, prop.na)
## 	    if (max(prop.miss) > 0)
## 	        print(paste("Missing values still remain in samples ",
## 	            which(prop.miss > 0)))
## 	    data.frame(clones.info, data.imp)
## 	}






### examples: verify typeParall = "cluster" breaks if no cluster set up.

### Does R CMD check runs the demo examples?

### or move a lot of the example code to the vignette


### Do I want put.part.rdata.together in the package?? Probably not.

### FIXME: if using fork or parallel, probably don't want
##  to call quit.


## .__ADaCGH_WEB_APPL <- TRUE in web appl!
## As far as I can tell, warningsForUsers is no longer used anywhere
## not even in Wavy code now
## if(exists(".__ADaCGH_WEB_APPL", envir = .GlobalEnv))
## {
##   warningsForUsers <- vector()
## #  running.as.web.adacgh <- TRUE
## } else if (exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv)) {
##   warningsForUsers <- vector()
## #  running.as.web.adacgh <- FALSE
## } else {
## #  running.as.web.adacgh <- FALSE
##   warningsForUsers <- warning
## }


### Some of the following are functions useful for debugging.
namesff <- function(x) {
  nmobj <- load(x)
  return(filename(get(nmobj)))
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

names.formals.changepoints <- names.formals.changepoints.1.18

## cat("Setting adacgh_changepoints to DNAcopy:::changepoints\n")
adacgh_changepoints <- DNAcopy:::changepoints
## cat("Setting adacgh_trimmed.variance to DNAcopy:::trimmed.variance\n")
adacgh_trimmed.variance <- DNAcopy:::trimmed.variance

## in v.1.18.0 we take advantage weights has default of NULL in changepoints

### this no longer makes sense, as always version is >= 1.17
vDNAcopy <- package_version(packageDescription("DNAcopy")$Version)
## if (vDNAcopy >= "1.17.1")
##   {
##     cat("Setting adacgh_changepoints to DNAcopy:::changepoints\n")
##     adacgh_changepoints <- DNAcopy:::changepoints
##     cat("Setting adacgh_trimmed.variance to DNAcopy:::trimmed.variance\n")
##     adacgh_trimmed.variance <- DNAcopy:::trimmed.variance
##   } else {
##     cat("Setting adacgh_changepoints to changepoints\n")
##     adacgh_changepoints <- changepoints
##     cat("Setting adacgh_trimmed.variance to trimmed.variance\n")
##     adacgh_trimmed.variance <- trimmed.variance
##   }


if(!identical(names.formals.changepoints, names(formals(adacgh_changepoints)))) {
  m1 <- "Arguments to DNAcopy function changepoints have changed.\n"
  m2 <- "Either your version of DNAcopy is newer than ours, or older.\n"
  m3 <- "If your version is different from 1.18.0 to 1.35.0\n please let us know of this problem.\n"
  m4 <- "We are assuming you are using DNAcopy version from 1.18.0 to 1.35.0,\n"
  m6 <- paste("Your version of DNAcopy is ", packageDescription("DNAcopy")$Version, ".\n")
  mm <- paste(m1, m2, m3, m4, m5, m6)
  stop(mm)
}


## As of v. 1.12 at least snapCGH finally has a namespace. So now we do
## myfit.model <- snapCGH::fit.model
## but use the call explicitly below.

## No longer needed, as at least using v. 1.31.0

## if(package_version(packageDescription("snapCGH")$Version) > "1.11") {
##   myfit.model <- snapCGH::fit.model
## } else {
##   myfit.model <- fit.model
## }


## becasue even if fit.model is documented, it is NOT exported.
## Well, they get away with it because there are no executable examples
## in the help for fit.model.

  



cutFile <- function(filename,
                    id.col,
                    chrom.col,
                    pos.col,
                    sep = "\t",
                    cols = NULL, 
                    mc.cores = detectCores(),
                    delete.columns = NULL,
                    fork = FALSE) {

  colsep <- sep ## for my own sanity

  if(colsep == "") {
    awksep <- "{FS = \" \"} "
    warning('When sep = \"\" multiple consecutive field separators are taken as one')
  } else if(colsep == " "){
    awksep <- "{FS = \"[ ]\"} "
  } else {
    awksep <- paste("{FS = \"", colsep, "\"}", sep = "")
  }
  
  if(is.null(cols)) {
    awkline <- paste("awk 'BEGIN ", awksep, " ; {print NF}'")
    cols <- as.numeric(system(paste("head -n 1 ", filename, " | ",
                                    awkline, sep = ""), intern = TRUE))
    warning("Number of columns not specified. We guess they are ", cols)
  }
  
  if(cols <= mc.cores) {
    start <- end <- 1:cols
  } else {
    d1 <- cols %/% mc.cores
    rr <- cols %% mc.cores
    
    num.per.cores <- rep(d1, mc.cores)
    num.per.cores[1:rr] <- num.per.cores[1:rr] + 1
    
    end <- cumsum(num.per.cores)
    start <- cumsum(c(1, num.per.cores[-mc.cores]))
  }
  
  awkline <- paste("awk -v pos=\"$i\" 'BEGIN ", awksep,
                   "; {print $pos > (\"col_\"pos\".txt\")}' ", sep = "")
  
  commands <- paste(
    "for i in $(seq ", start, " ", end, "); do ",
    awkline, filename, " ; done", sep = ""
    )

  if(fork) {
    tmp <- mclapply(commands, function(x) system(x), mc.cores = mc.cores)
  } else {
    commands <- paste(commands, "&")
    sapply(commands, function(x) system(x, ignore.stdout = TRUE))
    final.files <- paste("col_", end, ".txt", sep = "")
    while(TRUE) {
      Sys.sleep(0.5)
      if(all(file.exists(final.files))) { 
        Sys.sleep(0.5) ## allow I/O to finish
        break
      }
    }
  }
  ## delete indiv.colums
  if(!is.null(delete.columns)) {
    delc <- paste("rm col_", delete.columns, ".txt", sep = "")
    sapply(delc, function(x) system(x, ignore.stdout = TRUE))
  }
  ## assign ID, Chrom, Pos
  asc <- paste("mv col_", c(id.col, chrom.col, pos.col), ".txt ",
               c("ID.txt", "Chrom.txt", "Pos.txt"), sep = "")
  sapply(asc, function(x) system(x, ignore.stdout = TRUE))
  
  ##  cat("You can now call 'inputToADaCGH' as follows")
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
  l1 <- ls(envir = parent.frame(n = n))
  if(length(l1) > 0) {
   
    ## The following does not work reliably, probably because
    ## of name passing issues in sapply, function(x) etc
    ## r1 <- sapply(l1,
    ##              function(x)
    ##              object.size(get(x, envir = parent.frame(n = n + 2))))

    sizes <- rep(NA, length(l1))
    for(i in 1:length(l1)) sizes[i] <- object.size(get(l1[i],
                                                       envir = parent.frame(n = n)))
    names(sizes) <- l1
    sizes <- sort(sizes, decreasing = TRUE)
    sizes <- round(as.matrix(sizes/10^6), 1)
    sizes <- sizes[sizes >= minsizeshow, , drop = FALSE]
    colnames(sizes) <- "Size(MB)"
    print(sizes)
  }
}

## distribute2 <- function(type, mc.cores, X, FUN, ...) {
##   if(type == "fork") {
##     mclapply(X, FUN, ..., 
##              mc.cores = mc.cores, mc.silent = FALSE)
##   } else if(type == "cluster") {
##     ## we might need to do list(...)
##     clusterApply(NULL, X, FUN, ...)
##   } else stop("distribute does not know this type")
## }


## distribute <- function(type, mc.cores, X, FUN, ..., silent = FALSE) {
##   if(type == "fork") {
##     if(.Platform$OS.type == "windows") {
##       warning("You are running Windows. Setting mc.cores = 1")
##       mc.cores <- 1
##     }
##     ## should we allow a mc.preschedule argument?
##     ## initial testing showed TRUE to be better
##     ## but MPI is a lot faster with load balancing so maybe ...
##     mclapply(X, FUN, ..., mc.preschedule = FALSE,
##              mc.cores = mc.cores, mc.silent = silent)
##   } else if(type == "cluster") {
##     ## we might need to do list(...)
## ##      parallel::clusterApply(NULL, X, FUN, ...)
##       clusterApplyLB(NULL, X, FUN, ...)
##   } else stop("distribute does not know this type")
## }



distribute <- function(type, mc.cores, X, FUN, ..., silent = FALSE,
                       loadBalance = TRUE) {
  if(type == "fork") {
    if(.Platform$OS.type == "windows") {
      warning("You are running Windows. Setting mc.cores = 1")
      mc.cores <- 1
    }
    ## should we allow a mc.preschedule argument?
    ## initial testing showed TRUE to be better
    ## but MPI is a lot faster with load balancing so maybe ...
    if(loadBalance) {
        mclapply(X, FUN, ..., mc.preschedule = FALSE,
                    mc.cores = mc.cores, mc.silent = silent)
    } else {
        mclapply(X, FUN, ..., mc.preschedule = TRUE,
                 mc.cores = mc.cores, mc.silent = silent)
    }
  } else if(type == "cluster") {
    ## we might need to do list(...)
##      parallel::clusterApply(NULL, X, FUN, ...)
      if(loadBalance) {
          clusterApplyLB(NULL, X, FUN, ...)
      } else {
          clusterApply(NULL, X, FUN, ...)
      }
  } else stop("distribute does not know this type")
}




mcc <- function(reading.cores) {
  ## Return the number of cores, unless in windows;
  ## used inside inputToADaCGH.
  ## In function distribute there is a similar check
  if(.Platform$OS.type == "windows") {
    warning("You are running Windows. Setting mc.cores = 1")
    return(1)
  } else {
    return(reading.cores)
  } 
}

## rdata.or.dataframe <- function(x) {
##   tryfile <- try(file_test(op = "-f", x), silent = TRUE) 
##   if(inherits(tryfile, "try-error")) {
##     if( exists(deparse(substitute(x)),
##                where = parent.frame())) { 
##       return("local.df")
##     } else {
##       stop(paste("There is neither a file named ",
##                  x, "nor a data frame named ",
##                  x, " in the current environment"))
##     }
##   } else {
##     return("rdata")
##   }
## }

RAM.or.ff <- function(x) {
  ## Find out if x is a RAM object or an ff object on disk
  tryfile <- try(file_test(op = "-f", x), silent = TRUE) 
  if(inherits(tryfile, "try-error")) {
    if( exists(deparse(substitute(x)),
               where = parent.frame())) { ## parent.env(envir = environment()))) {
      if(is.ffdf(x)) stop("Do not pass an ffdf object as regular R object")
      else return("RAM")
    }
    else stop(paste(deparse(substitute(x)),
                    "is neither a file nor a RAM object") )
  } else {
    nmobj <- load(x)
    if(is.ff(get(nmobj, inherits = FALSE))) return("ff")
    else if(is.ffdf(get(nmobj, inherits = FALSE))) return("ff")
    else if(is.ffdf(get(nmobj, inherits = FALSE)[[1]])) return("ff")
    else stop(paste(x, " must be an RData with an object of class ff or ffdf"))
  }
}

getOutValueRAM3 <- function(outRDataName, components = 3, array, posInitEnd = NULL) {
  ## Like getOutValueRAM3, but specialized for components 3
  if(components != 3) stop("components must be equal to 3")

  if(is.null(posInitEnd)) {
    tmp1 <- outRDataName[[1]][, array]
    tmp2 <- outRDataName[[2]][, array]
  } else {
    tmp1 <- outRDataName[[1]][[array]][seq.int(from = posInitEnd[1],
                                               to = posInitEnd[2])]
    tmp2 <- outRDataName[[2]][[array]][seq.int(from = posInitEnd[1],
                                               to = posInitEnd[2])]
  }
  return(cbind(tmp1, tmp2))
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



## getCGHValue.ff.and.RAM <- function(cghData, array, posInitEnd = NULL) {

##   ## NOOO!!! this is way too slow. We cannot try to open the file from each node.
##   ## this is silly.
##   tryfile <- try(file_test(op = "-f", cghData), silent = TRUE)
##   if(inherits(tryfile, "try-error")) {
##     cghData
##   }
  
##   nmobj <- load(cghRDataName)
##   if(!inherits(get(nmobj, inherits = FALSE), "ffdf"))
##     stop("cghRDataName must be of class ffdf")
##   open(get(nmobj, inherits = FALSE), readonly = TRUE)
##   if(is.null(posInitEnd))
##     tmp <- get(nmobj, inherits = FALSE)[, array]
##   else
##     tmp <- get(nmobj, inherits = FALSE)[[array]][ri(posInitEnd[1], posInitEnd[2])]
##   close(get(nmobj, inherits = FALSE))
##   return(tmp)
## }



getCGHValue <- function(cghRDataName, array, posInitEnd = NULL) {
  nmobj <- load(cghRDataName)
  if(!inherits(get(nmobj, inherits = FALSE), "ffdf"))
    stop("cghRDataName must be of class ffdf")
  ## open only the needed file!!
  open(get(nmobj, inherits = FALSE)[array], readonly = TRUE)
  if(is.null(posInitEnd))
    tmp <- get(nmobj, inherits = FALSE)[, array]
  else
    tmp <- get(nmobj, inherits = FALSE)[[array]][ri(posInitEnd[1], posInitEnd[2])]
  close(get(nmobj, inherits = FALSE)[array])
  return(tmp)
}


## getCGHValueNA <- function(cghRDataName, array, posInitEnd = NULL) {
##   ## modified the above, to call expungeNA, etc
##   nmobj <- load(cghRDataName)
##   if(!inherits(get(nmobj, inherits = FALSE), "ffdf"))
##     stop("cghRDataName must be of class ffdf")
##   ## open only the needed file!!
##   open(get(nmobj, inherits = FALSE)[array], readonly = TRUE)
##   if(is.null(posInitEnd))
##     tmp <- get(nmobj, inherits = FALSE)[, array]
##   else
##     tmp <- get(nmobj, inherits = FALSE)[[array]][ri(posInitEnd[1], posInitEnd[2])]
##   close(get(nmobj, inherits = FALSE)[array])
##   return(expungeNA(tmp)) ## so: xclean, cleanpos, lx
## }





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
  ## It can also be a RAM object.

  tryfile <- try(nmobj <- load(namesRDataName))
  if(inherits(tryfile, "try-error")) { ## assuming RAM object
    if(is.null(posInitEnd)) {
      tmp <- namesRDataName
    } else {
      tmp <- namesRDataName[posInitEnd[1]:posInitEnd[2]]
    }
  } else { ## we are assuming it is a file
    if(is.null(posInitEnd)) {
      tmp <- get(nmobj, inherits = FALSE)
    } else {
      tmp <- get(nmobj, inherits = FALSE)[posInitEnd[1]:posInitEnd[2]]
    }
    rm(list = nmobj)
  }
  if(is.factor(tmp)) {
    warning("getNames operating on a factor object")
    tmp <- as.character(tmp)
  }
  return(tmp)
}
  

getffObj <- function(RDataName, silent = FALSE) {
  nmobj <- load(RDataName, envir = parent.frame())
    if(!silent) {
      cat("\n Making an assignment in the calling environment!!! \n")
      cat("We just created (or overwrote)", nmobj, "\n")
      cat("Don't forget to close", nmobj, "\n")
    }
  open(get(nmobj, inherits = FALSE, envir = parent.frame()), readonly = TRUE)
  return(nmobj)
}

getffObjNoOpen <- function(RDataName, silent = FALSE) {
  ## Like getffObj, but without opening file
  ## should be called "get the name of the ff object"
  ## but we leave it like this, for historical reasons
  nmobj <- load(RDataName, envir = parent.frame())
    if(!silent) {
      cat("\n Making an assignment in the calling environment!!! \n")
      cat("We just created (or overwrote)", nmobj, "\n")
      cat("Don't forget to close", nmobj, "\n")
    }
##  open(get(nmobj, inherits = FALSE, envir = parent.frame()), readonly = TRUE)
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


## ffListOut2 <- function(smoothedVal, stateVal, ff.out = TRUE) {
##   ## this is silly: a function that just returns its arguments in one
##   ## case. Nope
  
##   pattern <- paste(getwd(), paste(sample(letters, 4), collapse = ""),
##                    sep = "/")
##   if(ff.out) {
##     smoothed <- ff(smoothedVal,
##                    vmode = "double",
##                    pattern = pattern)
##     state <- ff(stateVal,
##                 vmode = "integer", ## could be short but allow pathological cases
##                 pattern = pattern)
##     close(smoothed)
##     close(state)
##     return(list(smoothed = smoothed,
##                 state = state))

##   } else {
##     return(list(smoothed = smoothedVal,
##                 state = as.integert(stateVal)))
##   }
## }

## FIXME!! But are the elements below vectors or ff objects!!! Nope, ffobjects.
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

outToffdf2 <- function(out, arrayNames, ff.out = TRUE) {
  ## based on outToffdf2, but outputs either ff or plain R object
  nelem <- length(out)
  if(is.null(arrayNames))
    arrayNames <- paste("A", 1:nelem, sep = "")
  ## this is horrible, but I can't get it to work otherwise
  if(ff.out) {
    p1 <- paste("outSmoothed <- ffdf(",
                paste(arrayNames, " = out[[", 1:nelem, "]]$smoothed", sep = "",
                      collapse = ", "),
                ")")
    p2 <- paste("outState <- ffdf(",
                paste(arrayNames, "= out", "[[", 1:nelem, "]]$state", sep = "",
                      collapse = ", "),
                ")")
  } else {
    p1 <- paste("outSmoothed <- data.frame(",
                paste(arrayNames, " = out[[", 1:nelem, "]]$smoothed", sep = "",
                      collapse = ", "),
                ")")
    p2 <- paste("outState <- data.frame(",
                paste(arrayNames, "= out", "[[", 1:nelem, "]]$state", sep = "",
                      collapse = ", "),
                ")")
    
  }
  
  eval(parse(text = p1))
  eval(parse(text = p2))
  colnames(outSmoothed) <- colnames(outState) <- arrayNames

  if(ff.out) {
    close(outSmoothed)
    close(outState)
  }

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

vectorForArrayRAM <- function(t1, array, listofRAM) {
  ## like vectorForArray, but not for ff objects, but a list
  indices <- t1$Index[t1$ArrayNum == array]
  ## Note: it is key that t1 is ordered by position for
  ##       a sequence of increasing indices.
  unlist(listofRAM[indices])
}


vectorForArrayRAM2 <- function(t1, array, listofff, element){
  ## like cectorForArrayL2, but for RAM objects
  indices <- t1$Index[t1$ArrayNum == array]
  unlist(lapply(listofff[indices], function(x) x[[element]]))
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


wrapCreateTableArrChr <- function(cghRDataName, chromRDataName, load.balance = FALSE) {
  ## SPEED: if you are using this function, you do not really need it.
  ## The table is created somewhere else
  ## and cghdata is read at other places, likewise with chrom
  ## But with 30 arrays of 10^6 probes each, it takes
  ## less than 0.020 seconds and is light on memory.
  nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
  arrayNames <- colnames(get(nameCgh))
  if(is.null(arrayNames)) {
    narr <- ncol(get(nameCgh))
    arrayNames <- paste("A", 1:narr, sep = "")
  }
  ## close(get(nameCgh))
  createTableArrChrom(arrayNames, getChromValue(chromRDataName), load.balance)
}

createTableArrChrom <- function(arraynames, chrom, load.balance = FALSE) {
  rle.chr <- intrle(as.integer(chrom))
  if(is.null(rle.chr)) rle.chr <- rle(as.integer(chrom))
  chr.end <- cumsum(rle.chr$lengths)
  chr.start <- c(1, chr.end[-length(chr.end)] + 1)
  ncrom <- length(chr.start)
  narrays <- length(arraynames)
  if(load.balance) {
    rrc <- rep(narrays, ncrom)
    return(data.frame(Index = 1:(narrays * ncrom),
                    ArrayNum = rep(1:narrays, ncrom),
                    ArrayName = rep(arraynames, ncrom),
                    ChromNum = rep(1:ncrom, rrc),
                    ChromName = rep(rle.chr$values, rrc),
                    posInit = rep(chr.start, rrc),
                    posEnd  = rep(chr.end, rrc)))
  } else {
    rrc2 <- rep(ncrom, narrays)
    return(data.frame(Index = 1:(narrays * ncrom),
                    ArrayNum = rep(1:narrays, rrc2),
                    ArrayName = rep(arraynames, rrc2),
                    ChromNum = rep(1:ncrom, narrays),
                    ChromName = rep(rle.chr$values, narrays),
                    posInit = rep(chr.start, narrays),
                    posEnd  = rep(chr.end, narrays)))


  }
}

is.wholeposnumber <- function(x, tol = .Machine$double.eps^0.5) {
  ## from "is.integer" help, modified
  abs(abs(x) - round(x)) < tol
}

na.handle.ff <- function(x) {
  if(any(is.na(x)))
    warning("Removing missing values with na.handle.ff when",
            " reading text file into ffdf file")
  return(na.omit(x))
}


nfields.one.line <- function(x) {
  ## count.fields does this for the complete file.
  ## I do not want that with very large files.
  ## As soon as not a commnet (or blank)
  ## count and bail out
    nline <- 1
    while(TRUE) {
      nf <- length(scan(x, nlines = nline,
                        what = "character", sep = "\t",
                        comment.char = "#", quiet = TRUE))
      nline <- nline + 1
      if(nf > 0) break
    }
    return(nf)
}

## nlines.to.skip.and.nf <- function(x) {
##   ## to use scan, need to know how many to skip
##   nline <- 0
##     while(TRUE) {
##       nline <- nline + 1
##       nf <- length(scan(x, nlines = nline,
##                         what = "character", sep = "\t",
##                         comment.char = "#", quiet = TRUE))
##       if(nf > 0) break
##     }
##     return(c(nline, nf))
## }



nlines.to.skip.and.nf <- function(x) {
  ## to use scan, need to know how many to skip
  nline <- 0
    while(TRUE) {
      nline <- nline + 1
      cnames <- scan(x, nlines = nline,
                        what = "character", sep = "\t",
                        comment.char = "#", quiet = TRUE)
      nf <- length(cnames)
      if(nf > 0) break
    }
    return(list(nline, nf, cnames))
}



read.data.column <- function(fname, path, ffpattern) {
  return(ff(scan(file = file.path(path, fname),
                 what = double(),
                 skip = 1),
            vmode = "double",
            pattern = ffpattern))
  
}

read.this.column <- function(i, fname, fields, skip,
                             ffpattern) {
  list.to.read <- vector("list", fields)
  list.to.read[[i]] <- double()
  
  return(ff(scan(file = fname,
                 what = list.to.read,
                 comment.char = "#",
                 sep = "\t",
                 skip = skip)[[i]],
            vmode = "double",
            pattern = ffpattern))
  
}

## first is a factor

## read by column? or read by row, skiping the first two positions?
## scan? readLines?
## is transpose fast? yes, with vt, on an ff.matrix matrix
## this is not used. Code expanded below
## read.to.ff.parallel <- function(fname) {
##   ffpattern <- paste(getwd(), "/", sep = "")

##   skip.and.fields <- nlines.to.skip.and.nf(fname)
##   skip <- skip.and.fields[[1]]
##   fields <- skip.and.fields[[2]]

##   ## YES, we do expect a colnames
##   colnames <- skip.and.fields[[3]][-c(1:3)] ## only array names

##   ## list.to.read <- vector("list", fields)
##   ## list.to.read[1] <- "character"
##   ## id <- ff(as.factor(scan(file  = fname,
##   ##                         what = list.to.read,
##   ##                         comment.char = "#",
##   ##                         sep = "\t",
##   ##                         skip = skip)[[1]]),
##   ##          pattern = ffpattern)

##   list.to.read <- vector("list", fields)
##   list.to.read[[2]] <- integer()
  
##   chrom <- ff(scan(file  = fname, 
##                    what = list.to.read,
##                    comment.char = "#",
##                    sep = "\t",
##                    skip = skip)[[2]],
##               vmode = "ushort",
##               pattern = ffpattern)

##   list.of.ff <- mclapply(3:fields,
##                          read.this.column,
##                          fname = fname,
##                          fields = fields,
##                          skip = skip,
##                          ffpattern = ffpattern,
##                          mc.cores = detectCores())

##   ## we do as in outToffdf2 to return an ffdf.
##   ## Why an ffdf and not a list of ffs? Because
##   ## simpler for accessing and reordering

##   ## we only return the data, not chrom or pos
##   nelem <- length(list.of.ff)
##   p1 <- paste("inputData <- ffdf(",
##               paste(colnames, " = list.of.ff[[", 2:nelem, "]]", sep = "",
##                     collapse = ", "),
##               ")")
##   eval(parse(text = p1))

##   close(inputData)

##   ## we have inputData, chrom, id, position
##   ## position is the first in list.of.ff
## }




## Memory per case not bad:
## ff1 <- ff(scan(file = textfilename, what = lista, skip = 1, comment.char = "#", sep = "\t")[[4]])
## with 111 MB for 6 million records

## 
## ffwhich(x1, is.na(x1))
## ## is it faster than a proper version of:?
## which(is.na.ff(x1))
## the above is VERY fast!

## then use ffappend and unique.ff??
## they are very fast
## or use intersect, create an ff object,
## and subset the ffdf data frame
## or maybe subset each indiv ff before creating
## data frame

## with append, will need a loop. in each, append and get unique,
## so thing is small



setColClasses <- function(x) {
  ## specific for our files, of course
  nf <- nfields.one.line(x)
  return(c("factor", "integer", "numeric", rep("numeric", nf - 3)))
}





inputToADaCGH <- function(ff.or.RAM = "RAM",
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
                          mc.cores = floor(detectCores()/2)) {
    ## to make it simpler down below
    reading.cores <- mc.cores
    ## We could use eval(substitute or get(
    ## but we modify the object for sure when eliminating rownames
    ## and possibly when reordering. So might as well just load, copy,
    ## remove, and gc.


    ## When susing mclapply, we might want to set mc.preschedule =FALSE?
    ## Not clear in this case?
    
  if(! ff.or.RAM %in% c("ff", "RAM") )
    stop("ff.or.RAM can only take values ff or RAM")
  
  if(any(sapply(robjnames, function(x) exists(x,
                                              where = parent.frame(),
                                              inherits = FALSE))))
    stop("One or more objects with names as those in robjnames",
         "already exist. Please use other names.")

  ## if(!is.null(RDatafilename) & !is.null(MAList))
  ##   stop("You must provide only one of RDatafilename OR MAList")
  ## if(is.null(RDatafilename) & is.null(MAList))
  ##   stop("You must provide exactly one of RDatafilename OR MAList")

  nullinputs <- sapply(list(dataframe, RDatafilename, MAList, textfilename, path),
                           is.null)
  if(sum(nullinputs) != 4)
    stop("You must provide exactly one of",
         "RDatafilename XOR MAList XOR textfilename ",
         "XOR path XOR dataframe")

  
  ## There is a subtle diff in behavior of inherits between R 2.11 and R 2.12.
  ## The "any" after inherits would not be needed in R-2.12

  if(!is.null(path)) {

    list.of.files <- list.files(path, all.files = FALSE, include.dirs = FALSE)
    to.exclude <- c("ID.txt", "Chrom.txt", "Pos.txt")

    if(!is.null(excludefiles))
      to.exclude <- c(to.exclude, excludefiles)
    list.of.files <- setdiff(list.of.files,
                             to.exclude)

    cat(paste("\n Note: Directory reading: we will be reading ",
              length(list.of.files),
              "\n files, not including ID, Chrom, and Pos. \n",
              "If this is not the correct number of files, \n",
              "stop this process, verify why  (did cutFiles \n",
              "work correctly? are you using a directory with\n",
              "other files?, etc), and run again.\n"))
    if(verbose) {
      cat("\n      These are the files we will try to read:\n")
      cat(paste(list.of.files, collapse = "\n"))
      cat("\n")

      ## If we really need info, do this
      ## file.info(list.files(path, full.names = TRUE, all.files = TRUE,
      ##      include.dirs = TRUE, recursive = TRUE))
    }
    
    cat("\n   ...  directory reading: reading the ID file \n")
    probeNames <- scan(file  = file.path(path, "ID.txt"),
               what = "character", skip = 1)

    cat("\n   ...  directory reading: reading the chromosome file \n")
    chromData <- ff(scan(file  = file.path(path, "Chrom.txt"),
                     what = integer(), skip = 1),
                vmode = "short",
                pattern = ffpattern)

    cat("\n   ...  directory reading: reading the Positions file \n")
    posData <- ff(scan(file  = file.path(path, "Pos.txt"),
                       what = double(), skip = 1),
                  vmode = "double",
                  pattern = ffpattern)
    
    cat("\n   ...  directory reading: parallel reading of column names \n")
    
    colnames <- unlist(mclapply(list.of.files,
                         function(x)
                                scan(file.path(path, x),
                                     n = 1, what = "character"),
                                mc.cores = mcc(reading.cores)))

    cat("\n   ...  directory reading: parallel reading of data columns \n")
    ## list.of.ff <- mclapply(list.of.files,
    ##                        read.data.column,
    ##                        path = path, 
    ##                        ffpattern = ffpattern,
    ##                        mc.cores = detectCores())

    ## minimize function call overhead
    list.of.ff <- mclapply(list.of.files,
                           function(x)
                           ff(scan(file = file.path(path, x),
                                   what = double(),
                                   skip = 1),
                              vmode = "double",
                              pattern = ffpattern),
                           mc.cores = mcc(reading.cores)) ## detectCores())
    
    ## we do as in outToffdf2 to return an ffdf.
    ## Why an ffdf and not a list of ffs? Because
    ## simpler for accessing and reordering

    tmpsilent <- open(list.of.ff[[1]])

    ## we only return the data
    nelem <- length(list.of.ff)
    p1 <- paste("inputData <- ffdf(",
                paste(colnames, " = list.of.ff[[", seq_len(nelem), "]]",
                      sep = "",
                      collapse = ", "),
                ")")
    eval(parse(text = p1))
    
    close(inputData)
    usingfftmp <- TRUE
    open(chromData)
    open(posData)    
    
  } else if(!is.null(textfilename)) {
    ## FIXME: do we need the full path? Probably
    ## read.to.ff.parallel(textfilename)

    ## all the functionality is in read.to.ff.parallel,
    ## but we do not want ANY extra overhead from returning huge objects so ...
    ## extend the code here. Macros would be great ...

    skip.and.fields <- nlines.to.skip.and.nf(textfilename)
    skip <- skip.and.fields[[1]]
    fields <- skip.and.fields[[2]]
    
    ## YES, we do expect a colnames
    colnames <- skip.and.fields[[3]][-c(1:3)] ## only array names
    
    cat("\n   ...  textfile reading: reading the ID column \n")
    list.to.read <- vector("list", fields)
    list.to.read[1] <- "character"

    probeNames <- scan(file  = textfilename,
               what = list.to.read,
               comment.char = "#",
               sep = "\t",
               skip = skip)[[1]]

    cat("\n   ...  textfile reading: reading the chrom column \n")
    
    list.to.read <- vector("list", fields)
    list.to.read[[2]] <- integer()
    
    chromData <- ff(scan(file  = textfilename, 
                     what = list.to.read,
                     comment.char = "#",
                     sep = "\t",
                     skip = skip)[[2]],
                vmode = "short",
                pattern = ffpattern)

    cat("\n   ...  textfile reading: (parallel) reading of remaining columns \n")
    ## FIXME: does this make sense? I mean,
    ## try to do parallel reading vs. just a single process?
    ## verify what is faster by running a single process or many
    ## with detectCores
    ## And compare with a scan of just the data file.
    ## Just a scan
    list.of.ff <- mclapply(3:fields,
                           read.this.column,
                           fname = textfilename,
                           fields = fields,
                           skip = skip,
                           ffpattern = ffpattern,
                           mc.cores = mcc(reading.cores)) ##detectCores())
    
    ## we do as in outToffdf2 to return an ffdf.
    ## Why an ffdf and not a list of ffs? Because
    ## simpler for accessing and reordering

    tmpsilent <- open(list.of.ff[[1]])
    posData <- list.of.ff[[1]]
    ## we only return the data, not chrom or pos
    nelem <- length(list.of.ff)
    p1 <- paste("inputData <- ffdf(",
                paste(colnames, " = list.of.ff[[", 2:nelem, "]]", sep = "",
                      collapse = ", "),
                ")")
    eval(parse(text = p1))
    
    close(inputData)
    close(list.of.ff[[1]])
    usingfftmp <- TRUE
    ## we check them later, so open them to avoid warnings
    open(chromData)
    open(posData)
  } else { ## either MAList or RData
    usingfftmp <- FALSE
    if(!is.null(MAList)) {
      if(!(any(inherits(MAList, c("SegList", "MAList")))))
        stop("MAList must be an object of class SegList (as produced by snapCGH) ",
             "or of class MAList (as produced by limma)")
      
      if((!all(c("Position", "Chr") %in% colnames(MAList$genes))) &
         is.null(cloneinfo))
        stop("If your MAList object does not have Position and Chr columns ",
             "you must provide a cloneinfo argument with the name of an object with them")
      
      if(is.null(cloneinfo)) {
        inputData <- data.frame(ID = MAList$genes$ID,
                                Chr = MAList$genes$Chr,
                                Pos = MAList$genes$Position,
                                MAList$M)
      } else {
                                        #what is clone info?
        if(typeof(cloneinfo) == "character") {## we assume path to a file
          cat("Assuming cloneinfo is a file (possibly with full path)  ")
          Table <- read.table(cloneinfo, sep = cloneinfosep,
                              quote = cloneinfoquote,
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
    } else if(!is.null(RDatafilename)) {
        nmobj <- load(RDatafilename)
        inputData <- get(nmobj, inherits = FALSE)
        if(nmobj != "inputData")
            rm(list = nmobj)
        rm(nmobj)
        gc()

    } else if(!is.null(dataframe)) {
      inputData <- dataframe
    } else {
      caughtUserError2("how did we ever get here??!!")
    }

    ## We will remove NAs in Position or Chromosome, if those exist.
    ## NOTE: we never check NAs in Position or Chromosome if reading from txt file
    na.remove <- which(is.na(inputData[ , 3]) | is.na(inputData[, 2]))
    if(length(na.remove)) {
      cat("\n   ... missing values in Position or Chromosome; removing those rows \n")
      inputData <- inputData[-na.remove, ]
    }
    ## We only get here via MAList or RDatafilename
    ## We no longer check nor remove NAs here

    ## if(na.omit) {
    ##   if(any(is.na(inputData))) {
    ##     ## this will break with very large files, I think
    ##     warning("Eliminating all rows with missing values")
    ##     inputData <- na.omit(inputData)
    ##   }
    ## } else {
    ##   if(any(is.na(inputData))) 
    ##     caughtUserError2(paste("Your aCGH file contains missing values. \n",
    ##                            "That is not allowed.\n"))
    ## }

    rownames(inputData) <- NULL
  } ## done reading input of MAList or RData

  cat("\n   ... done reading; starting checks \n")


  ## When we use ff for input, inputData only contains the CGHdata, and we
  ## have a an ID, a chrom, and a pos objects. With other methods of
  ## input, all is still part of inputData. That kind of sucks, but is
  ## much more efficient than any alternative I can think of.

  
  
  ## we no longer deal with NAs
  ## if(any(is.na(inputData))) 
  ##   caughtUserError2(paste("Your aCGH file contains missing values. \n",
  ##                             "That is not allowed.\n"))
  ## gc(); gc() ## why two? just one

  gc()

  if(usingfftmp) {
    ## when using read.table.ff, char. data are converted to factor
    ## Note: reading with ffdf might fail before, if the non-numeric
    ## appears in one of the later chuncks. That is OK
    if(is.factor(chromData))
      caughtUserError2(paste("Chromosome contains non-numeric data.\n",
                             "That is not allowed.\n"))
  } else{
    if(!is.numeric(inputData[, 2]))
      caughtUserError2(paste("Chromosome contains non-numeric data.\n",
                             "That is not allowed.\n"))
  }

  ## the next should be doable in a better way... especially with ff objects
  if(usingfftmp) {
    if(any(table(chromData[]) < minNumPerChrom))
      caughtUserError2(paste("At least one of your chromosomes has less than ",
                             minNumPerChrom, " observations.\n That is not allowed.\n"))
  } else {
    if(any(table(inputData[, 2]) < minNumPerChrom))
      caughtUserError2(paste("At least one of your chromosomes has less than ",
                             minNumPerChrom, " observations.\n That is not allowed.\n"))
  }
  if(usingfftmp) {
    ## this should be unneeded, and caught when reading?
      ## we will catch non-numeric; but > 32768 will just flip around
      ## and become negative
      if(min.ff(chromData) < 1 ) ## min.ff is from ffbase
          caughtUserError2("Chromosome is NOT a positive integer (or has values > 32000) \n")
      if(max.ff(chromData)> 30000) ## max.ff is from ffbase
          caughtUserError2("Chromosome has more than 30000 levels!!\n")
  } else {  
    if(!all(is.wholeposnumber(inputData[, 2])))
      caughtUserError2("Chromosome is NOT a positive integer!!\n")
    if(max(inputData[, 2]) > 30000)
      caughtUserError2("Chromosome has more than 30000 levels!!\n")
  }


  ## if(usingfftmp) {
  ##   ## yes, no lapply, etc, will work
  ##   ## but we should never fail here, since we check this with read.table.ffdf
  ##   if(any(sapply(2:(ncol(inputData)), function(i) is.factor(inputData[[i]]))))
  ##     caughtUserError2(paste("Your aCGH or position data contains non-numeric data. \n",
  ##                            "That is not allowed.\n")   )
  ## } else {
  if(!usingfftmp) {
    if(!is.numeric(inputData[, 2]))
      caughtUserError2("Your position column contains non-numeric data.\n")
    if(any(!sapply(inputData[, -c(1, 2, 3)], is.numeric)))
      caughtUserError2(paste("Your aCGH file contains non-numeric data. \n",
                             "That is not allowed.\n")   )
  }

  gc()

  ## Do we have any identical MidPos in the same chromosome??  Just to solve
  ## it quickly and without nasty downstream consequences, we add a runif to
  ## midPos. But NO further averaging.

  ## would there be a way to do this efficiently in ff??

  cat("\n      ... checking identical MidPos \n")
  if(usingfftmp) {
    tmp <- paste(chromData[], posData[], sep = ".")
  } else {
    tmp <- paste(inputData[, 2], inputData[, 3], sep = ".")
  }
  if (sum(duplicated(tmp))) {
    cat("\n We have identical MidPos!!! \n")
    if(exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv))
      capture.output(print("We have identical MidPos!!!"),
                     file = "WARNING.DUPLICATED")

    if(usingfftmp) {
      pos.random <- posData[] + runif(length(posData))
      tmp <-  paste(chromData[], pos.random, sep = ".")
    } else {
    ## add a random variate, to break ties:
      inputData[duplicated(tmp), 3] <-
        inputData[duplicated(tmp), 3] +
          runif(sum(duplicated(tmp)))
      ## check it worked
      tmp <- paste(inputData[, 2], inputData[, 3], sep = ".")
    }
    if (sum(duplicated(tmp)))
      caughtOurError2("still duplicated MidPoints; shouldn't happen")
    else{
      if(usingfftmp) {
        delete(posData)
        rm(posData)
        posData <- ff(pos.random, pattern = ffpattern, vmode = "double")
        rm(pos.random)
        gc()
      }
    }
    rm(tmp)
    gc()
  }
  
  ## Check if we need to reorder, and if we need to, do it.
  ## If using a data.frame (not so much with ffdf), reordering sucks.
  if(usingfftmp) {
    cat("\n      ... checking need to reorder inputData, ff version \n")
    reorder <- fforder(chromData, posData, use.index = FALSE)
    
    if(!(identical(reorder[], seq_len(nrow(inputData))))) {
      cat("\n         ... reordering inputData, ff version \n")
      ## I do it in two steps, just in case
      inputDatasort <- inputData[reorder, , drop = FALSE]
      close(inputData)
      delete(inputData)
      rm(inputData)
      inputData <- inputDatasort
      close(inputDatasort)
      rm(inputDatasort)

      ## and do the same with chromData, posData, and ID, but is cleaner?
      update(posData, posData[reorder])
      update(chromData, chromData[reorder])
      ## the next one will use a lot of memory
      ## it might be faster if using ff, but then writing would probably
      ## be much slower, as we need to unfactor it, etc?
      probeNames <- probeNames[reorder]
    }
    close(reorder)
    delete(reorder)
    rm(reorder)
  } else  { ## regular data frame
    cat("\n      ... checking need to reorder inputData, data.frame version \n")
    reorder <- as.integer(order(inputData[, 2],
                                inputData[, 3]))
    ## we only do it if required, but if we do it, it really sucks!!
    if(!(identical(reorder, seq_len(nrow(inputData))))) {
      cat("\n         ... reordering inputData, data.frame version \n")
      inputData <- inputData[reorder, ]
    }
  }


  cat("\n   ... done with checks; starting writing \n")

  ## FIXME: why are we doing this when inputData is ff? What
  ## are the costs of using an ff object with factor or character?
  ## There was a reason, but cannot remember it ;-(
  ## If we change it, remember we have a
  ##       delete(inputData[1])
  ## below
  if(!usingfftmp) {
    ## this would be silly if inputData is huge, but then you should be using ff
    probeNames <- inputData[, 1]
    if(is.factor(probeNames)) probeNames <- as.character(probeNames)
  }
  if(ff.or.RAM == "ff") {
    save(file = "probeNames.RData", probeNames, compress = FALSE)
  } else {
    assign(robjnames[4], probeNames, envir = parent.frame())
  }
  rm(probeNames)



##   gcmessage("after rm probeNames")

  cat("\n   ... done writing/saving probeNames \n")

  if(ff.or.RAM == "ff") {
    ## if(usingfftmp) {
    ##   chromData <- inputData[[2]]
    ## } else {
    if(!usingfftmp) {
      chromData <- ff(as.integer(inputData[, 2]), vmode = "short",
                      pattern = ffpattern)
    }
    close(chromData)
    save(file = "chromData.RData", chromData, compress = FALSE)
    rm(chromData)
  } else {
    if(!usingfftmp) {
      assign(robjnames[2], as.integer(inputData[, 2]),
             envir = parent.frame())
    } else {
      ## by doing as.integer, we get rid of the ushort vmode attribute
      assign(robjnames[2], as.integer(chromData[]), 
             envir = parent.frame())
      close(chromData)
      rm(chromData)
    }
  }

  cat("\n   ... done writing/saving chromData \n")

  
  if(ff.or.RAM == "ff") {
    ## if(usingfftmp) {
    ##  posData <- inputData[[3]] 
    ## } else {
    if(!usingfftmp) {
      posData <- ff(inputData[, 3], vmode = "double",
                    pattern = ffpattern)
    }
    close(posData)
    save(file = "posData.RData", posData, compress = FALSE)
    rm(posData)
  } else {
    if(!usingfftmp) {
      assign(robjnames[3], inputData[, 3],
             envir = parent.frame())
    } else {
      assign(robjnames[3], posData[],
             envir = parent.frame())
    close(posData)
    rm(posData)
    }
  }

  cat("\n   ... done writing/saving posData \n")

##   gcmessage("after rm posData and chromData")

  ## Rembmer: when usingfftmp, there are always colnames, and inputData
  ## ONLY contain the data, not ID, chrom, or pos.
  if(is.null(colnames(inputData))) {
    narr <- ncol(inputData) - 3
    colnames(inputData) <- c("1", "2", "3", paste("A", 1:narr, sep = ""))
  }

  ## We do not use this for anything, so don't create it
  ## if(usingfftmp) {
  ##   ## for this to work, posData should not have been deleted
  ##   tableArrChr <- createTableArrChrom(colnames(inputData),
  ##                                      posData)
  ##   rm(posData)
  ## } else {
  ##   tableArrChr <- createTableArrChrom(colnames(inputData)[-c(1, 2, 3)],
  ##                                      inputData[, 2])
  ## }

  
  ## not needed here; can be done inside as.ffdf
  ## inputData <- inputData[, -c(1, 2, 3), drop = FALSE]


  if(ff.or.RAM == "ff") {
    if(usingfftmp) { ## since we have the ffdf object, use it
      ## this is cheap
      cghData <- inputData
      close(inputData)
      close(cghData) ## not needed?
    } else {
      if( packageDescription("ff")$Version >= "2.1-2" )
        cghData <- as.ffdf(inputData[, -c(1, 2, 3), drop = FALSE],
                           col_args=list(pattern = ffpattern))
      else
        cghData <- as.ffdf(inputData[, -c(1, 2, 3), drop = FALSE],
                           pattern = ffpattern)
    }
    rm(inputData)
    save(file = "cghData.RData", cghData, compress = FALSE)
    rm(cghData)
  } else {
    if(usingfftmp) {
      open(inputData)
      assign(robjnames[1], inputData[ , , drop = FALSE],
             envir = parent.frame())
      close(inputData)
      rm(inputData)
    } else {
      assign(robjnames[1], inputData[ , -c(1, 2, 3), drop = FALSE],
             envir = parent.frame())
      rm(inputData)
    }
  }

  cat("\n   ... done writing/saving cghData \n")
  
  ### FIXME: Remove this gc?
  gcmessage("\n Calling gc at end \n")

  if(ff.or.RAM == "ff") {
    cat("\n Files saved in current directory \n", getwd(),
        "\n with names :\n",
        "chromData.RData, posData.RData, cghData.RData, probeNames.RData. \n")
  } else {
    cat("\n Saved objects with names \n", robjnames,
        "\n for CGH data, chromosomal data, position data, and probe names,\n",
        "respectively, in environment\n",
        environmentName(parent.frame()), ".\n")
  }

  ## return(NULL)
  ## return(tableArrChr)
}



outputToCGHregions <- function(ffoutput = NULL,
                               directory = getwd(),
                               output.dat = NULL,
                               chrom.dat = NULL,
                               pos.dat = NULL,
                               probenames.dat = NULL) {

  if(is.null(ffoutput)) {
    null1 <- sapply(list(output.dat, chrom.dat, pos.dat, probenames.dat),
                    is.null)
    if(any(null1))
      stop("You are not using an ff object. ",
           "You must provide the names of the R objects",
           "with the output from ADaCGH, chromosome info,",
           "position info, and probe names.")
  }

  if(!is.null(ffoutput)) {
    null1 <- sapply(list(output.dat, chrom.dat, pos.dat, probenames.dat),
                    is.null)
    if(sum(!null1))
      stop("You must provide either the name of an ff object OR ",
           "the names of the RAM R objects, not both.")
  }

  
  if(!is.null(ffoutput)) {
    the.former.dir <- getwd()
    setwd(directory)
    probeNames <- get(load("probeNames.RData"), inherits = FALSE)
    posData <- get(load("posData.RData"), inherits = FALSE)
    chromData <- get(load("chromData.RData"), inherits = FALSE)
    open(posData)
    open(chromData)
    open(ffoutput[["outState"]])

    out <- data.frame(probes = probeNames, 
                      chrom = chromData[],
                      pos1 = posData[],
                      pos2 = posData[],
                      as.data.frame(ffoutput[["outState"]]))

    setwd(the.former.dir)
    close(posData)
    close(chromData)
    close(ffoutput[["outState"]])

  } else {
    out <- data.frame(probes = probenames.dat, 
                      chrom = chrom.dat,
                      pos1 = pos.dat,
                      pos2 = pos.dat,
                      as.data.frame(output.dat[["outState"]]))
  }
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

## for NAs
## clean
expungeNA <- function(x) {
  naspos <- which(is.na(x))
  lx <- length(x)
  if(length(naspos)) {
    ## pos_clean <- seq_len(lx)[-naspos]
    ## xclean <- x[-naspos]
    gc()
    return(list(x_clean = x[-naspos],
                pos_clean = seq_len(lx)[-naspos],
                lx = lx,
                nas = TRUE))
  } else{
    gc()
    return(list(x_clean = x,
                pos_clean = seq_len(lx),
                lx = lx,
                nas = FALSE))
  }
}

inpungeNA <- function(x, lx, pos_clean, nas) {
  ## sure enough, inpunge is a nonexisting word. So? ;-)
#na.together <- function(x, lx, naspos, pos_clean) {
  ## I think the commented out code is slower, as another
  ## object copy and creation
  ## ret.obj <- vector(mode = "numeric", length = lx)
  ## ret.obj[naspos] <- NA
  if(nas) {
    ret.obj <- rep(NA, lx)
    ret.obj[pos_clean] <- x
    gc()
    return(ret.obj)
  } else{
    return(x)
  }
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
                         amplicon = 1,
                         typeParall = "fork",
                         mc.cores = detectCores(),
                         certain_noNA = FALSE,
                         GLADdetails = FALSE,
                         loadBalance = TRUE,
                         ...) {

  ## check appropriate class of objects
  
  ## stop.na.inf(x)
  ## stop.na.inf(chrom.numeric)
  ## warn.too.few.in.chrom(chrom.numeric)

##  require("GLAD") || stop("Package not loaded: GLAD")


  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  if(type.of.data != type.of.chrom)
    stop("The cgh and chrom data should be of the same type:",
         "both RAM objects, or both RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)
  
  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("RAM objects in RAM (non ff objects) can only be used",
         "if you are using forking")
  if(ff.object){
    nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
    arrayNames <- colnames(get(nameCgh))
    narrays <- ncol(get(nameCgh))
  } else {
    arrayNames <- colnames(cghRDataName)
    narrays <- ncol(cghRDataName)
  }


  ## coco <- internalGLAD(1, 
  ##                      cghRDataName,
  ##                      chromRDataName,
  ##                      nvalues,
  ##                      deltaN,
  ##                      forceGL,
  ##                      deletion,
  ##                      amplicon,
  ##                      ff.object)

  
  outsf <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalGLAD,
                      cghRDataName,
                      chromRDataName,
##                      nvalues,
                      deltaN,
                      forceGL,
                      deletion,
                      amplicon,
                      ff.object,
                      certain_noNA,
                      GLADdetails,
                      loadBalance = loadBalance)
  
  ## a hack to avoid cluster code from catching the error and aborting
  te <- unlist(unlist(lapply(outsf, function(x) inherits(x, "my-try-error"))))
  if(any(te)) {
    m1 <- "The GLAD code occassionally crashes (don't blame us!)."
    m2 <- "This often happens in function DelRegionTooSmal."
    m3 <- "You might want to use another method"
    mm <- paste(m1, m2, m3)
    caughtError(mm)
  }
  
  ## nodeWhere("pSegmentGLAD")
  return(outToffdf2(outsf, arrayNames, ff.out = ff.object))
}

internalGLAD <- function(index, cghRDataName, chromRDataName,
##                         nvalues,
                         deltaN,
                         forceGL,
                         deletion,
                         amplicon,
                         ff.object,
                         certain_noNA,
                         GLADdetails) {
##  cghvalues <- getCGHval(cghRDataName, index)
##  chromvalues <- getChromval(chromRDataName)

  ff.out <- ff.object ## for now, leave like this

##  require("GLAD")

  if(ff.object) {
    lrv <- getCGHValue(cghRDataName, index)
    Chromosome <- getChromValue(chromRDataName)
  } else {
    lrv <- cghRDataName[, index]
    Chromosome <- chromRDataName
  }

  
  ## if(certain_noNA) {
  ##     cat("\n Using certain_noNA \n")
  ##     LogRatio <- lrv
  ## } else {
  ##     cleanDataList <- expungeNA(lrv)
  ##     LogRatio <- cleanDataList$x_clean
  ## }
  if(!certain_noNA) {
      cleanDataList <- expungeNA(lrv)
      lrv <- cleanDataList$x_clean
      Chromosome <- Chromosome[cleanDataList$pos_clean]
  }

  ## cat("\n  GLAD details: creating profileCGH \n")
  ## tmpf <- list(profileValues = data.frame(
  ##                  LogRatio = LogRatio,
  ##                  PosOrder = seq_len(length(LogRatio)),
  ##                  Chromosome = Chromosome[cleanDataList$pos_clean]))
  tmpf <- list(profileValues = data.frame(
                   LogRatio = lrv,
                   PosOrder = seq_len(length(lrv)),
                   Chromosome = Chromosome))


  
  ## if(ff.object) {
  ##   ## NAsIssue: get the NA and clean pos here
  ##   tmpf <- list(profileValues = data.frame(
  ##                  LogRatio = getCGHValue(cghRDataName, index),
  ##                  PosOrder = 1:nvalues,
  ##                  Chromosome = getChromValue(chromRDataName)))
  ## } else {
  ##   tmpf <- list(profileValues = data.frame(
  ##                  LogRatio = cghRDataName[, index],
  ##                  PosOrder = 1:nvalues,
  ##                  Chromosome = chromRDataName))
  ## }

  ## rm(LogRatio)
  gc()
  class(tmpf) <- "profileCGH"


  if(GLADdetails) cat("\n  GLAD details: finished creating profileCGH \n")
  
  ## GLAD produces lots of gratuitous output. Capture it
  ## to ignore it
  ## We use daglad.  It seems the recommended one, as seen from the message when loading it.
  ## tmp <- capture.output(
  ##     ## outglad <- try(daglad.profileCGH(tmpf, deltaN = deltaN,
  ##     ##                                  forceGL = forceGL,
  ##     ##                                  deletion = deletion,
  ##     ##                                  amplicon = amplicon,
  ##     ##                                  verbose = FALSE,
  ##     ##                                  smoothfunc = "haarseg"))
  ##     outglad <- try(daglad.ADa.1(tmpf, deltaN = deltaN,
  ##                                 forceGL = forceGL,
  ##                                 deletion = deletion,
  ##                                 amplicon = amplicon,
  ##                                 verbose = FALSE,
  ##                                 smoothfunc = "haarseg"))

  ##     )


  if(GLADdetails) cat("\n  GLAD details: ****** calling daglad \n")

  tmp <- capture.output(
      outglad <- try(daglad.ADa.1(tmpf, deltaN = deltaN,
                                  forceGL = forceGL,
                                  deletion = deletion,
                                  amplicon = amplicon,
                                  verbose = FALSE,
                                  smoothfunc = "haarseg",
                                  GLADdetails = GLADdetails))
      )

  if(GLADdetails) cat("\n  GLAD details: ***** finished calling daglad \n")

  
  rm(tmpf)
  rm(tmp)
  ##   rm(tmp) ## FIXME: put back in place and all the capturing output if
  ##   not using verbose option

  
  gc()

  ## nodeWhere("internalGLAD")
  if(inherits(outglad, "try-error")) {
      ## a hack to avoid cluster code from catching the error and aborting
      class(outglad) <- "my-try-error"
      return(outglad)
  } else { ## no errors.
      if(GLADdetails) cat("\n  GLAD details: creating return objects \n")
      if(certain_noNA) {
          if(ff.out) {
              return(ffListOut(outglad$profileValues$Smoothing,
                               outglad$profileValues$ZoneGNL))
          } else {
              return(list(smoothed = outglad$profileValues$Smoothing,
                          state = as.integer(outglad$profileValues$ZoneGNL)))
          }
      } else {
          smoothed <- local(inpungeNA(outglad$profileValues$Smoothing,
                                      cleanDataList$lx, cleanDataList$pos_clean,
                                      cleanDataList$nas))
          state <- local(inpungeNA(outglad$profileValues$ZoneGNL,
                                   cleanDataList$lx, cleanDataList$pos_clean,
                                   cleanDataList$nas))
          gc()
          if(ff.out) {
              return(ffListOut(smoothed, state))
          } else {
              return(list(smoothed = smoothed,
                          state = as.integer(state)))
          }
      }
  }
}

daglad.ADa.1 <- function (profileCGH, mediancenter = FALSE, normalrefcenter = FALSE, 
                       genomestep = FALSE, OnlySmoothing = FALSE, OnlyOptimCall = FALSE, 
                       smoothfunc = "lawsglad", lkern = "Exponential", model = "Gaussian", 
                       qlambda = 0.999, bandwidth = 10, sigma = NULL, base = FALSE, 
                       round = 2, lambdabreak = 8, lambdaclusterGen = 40, param = c(d = 6), 
                       alpha = 0.001, msize = 2, method = "centroid", nmin = 1, 
                       nmax = 8, region.size = 2, amplicon = 1, deletion = -5, deltaN = 0.1, 
                       forceGL = c(-0.15, 0.15), nbsigma = 3, MinBkpWeight = 0.35, 
                       DelBkpInAmp = TRUE, DelBkpInDel = TRUE, CheckBkpPos = TRUE, 
                       assignGNLOut = TRUE, breaksFdrQ = 1e-04, haarStartLevel = 1, 
                       haarEndLevel = 5, weights.name = NULL, verbose = FALSE, GLADdetails = TRUE, ...) 
{

    ### Most code removals are really inocuous if not removed; they do
    ### nothing. The possible exception is the reordering of probes.

    if(GLADdetails) cat("\n GLAD details: starting daglad \n")
    IQRdiff <- function(y) IQR(diff(y))/1.908
    profileCGH$alpha <- alpha
    profileCGH$msize <- msize
    profileCGH$amplicon <- amplicon
    profileCGH$deletion <- deletion
    profileCGH$deltaN <- deltaN
    profileCGH$method <- method
    profileCGH$lambdaclusterGen <- lambdaclusterGen
    profileCGH$nmax <- nmax
    profileCGH$nmin <- nmin
    profileCGH$forceGL <- forceGL
    profileCGH$nbsigma <- nbsigma
    profileCGH$smoothfunc <- smoothfunc
    profileCGH$lambdabreak <- lambdabreak
    profileCGH$param <- param
    profileCGH$NbProbes <- length(profileCGH$profileValues[["PosOrder"]])
    profileCGH$TooSmall <- FALSE
    ## if (verbose) 
    ##     print("daglad - step CheckData")
    ## CheckData(profileCGH, bandwidth = bandwidth, smoothfunc = smoothfunc, 
    ##     weights.name = weights.name, OnlyOptimCall = OnlyOptimCall)
    ## if (base == TRUE) {
    ##     if (!require(aws)) {
    ##         stop("Error in daglad: the aws package is required to use these function. The aws package can be installed from http://www.r-project.org")
    ##     }
    ## }
    ## if ((msize > region.size) & (region.size != 0)) 
    ##     stop("Error in daglad: msize must be lower than region.size")
    ## if (smoothfunc == "lawsglad" & model != "Gaussian") 
    ##     stop("Error in daglad: for lawsglad, only Gaussian model is available")
    ## if (smoothfunc == "lawsglad" & base == TRUE)
    ##        stop("Error in daglad: for lawsglad it is not possible to use the option base=TRUE. Choose laws smoothfunc instead.")
    ## if (smoothfunc != "lawsglad" && smoothfunc != "haarseg") {
    ##     print(paste("You have chosen smoothfunc=", smoothfunc))
    ##     print(paste("Choose smoothfunc=lawsglad or smoothfunc=haarseg if you want the process runs faster"))
    ## }

    if(GLADdetails) cat("\n GLAD details: bebore inputfields \n")

    inputfields <- names(profileCGH$profileValues)
##    if (!OnlyOptimCall) {
        excdudefields <- c("Level", "OutliersAws", "OutliersMad", 
            "OutliersTot", "Breakpoints", "Smoothing", "NormalRef", 
            "ZoneGNL")
    ## }
    ## else {
    ##     excdudefields <- c("Level", "OutliersAws", "OutliersMad", 
    ##         "OutliersTot", "Breakpoints", "Region", "NormalRef", 
    ##         "ZoneGNL")
    ## }
    fieldstodel <- intersect(inputfields, excdudefields)
    ## if (length(fieldstodel) > 0) {
    ##     print("Error in daglad: the following fields must be removed from profileValues before starting the function:")
    ##     print(fieldstodel)
    ##     stop()
    ## }

    ## We have the data already ordered!!!
    ## Doing this could lead to a huge speed penalty!!!
    ## profileCGH$profileValues <- profileCGH$profileValues[order(profileCGH$profileValues[["Chromosome"]], 
    ##     profileCGH$profileValues[["PosOrder"]]), ]
    ## if (OnlyOptimCall) {
    ##     new.fields <- c("NewPosOrder", "OutliersAws", "Region", 
    ##         "Level", "Breakpoints", "MinPosOrder", "MaxPosOrder", 
    ##         "OutliersMad", "OutliersTot", "NextLogRatio", "NormalRange", 
    ##         "ZoneGen", "ZoneGNL")
    ##     smoothfunc <- "haarseg"
    ## }
    ## else {

    
    new.fields <- c("NewPosOrder", "Smoothing", "OutliersAws", 
                    "Region", "Level", "Breakpoints", "MinPosOrder", 
                    "MaxPosOrder", "OutliersMad", "OutliersTot", "NextLogRatio", 
                    "NormalRange", "ZoneGen", "ZoneGNL")
    ##    }
    nb.new.fields <- length(new.fields)
    ## if (smoothfunc == "haarseg") {
    profileCGH$profileValues <- as.list(profileCGH$profileValues)
    profileCGH$profileValues[new.fields] <- lapply(as.list(rep(profileCGH$NbProbes, 
                                                               nb.new.fields)), numeric)
    ## }
    ## else {
    ##     profileCGH$profileValues[new.fields] <- 0
    ## }

    if(GLADdetails) cat("\n GLAD details: NewPosOrder et al \n")

    profileCGH$profileValues[["NewPosOrder"]] <- profileCGH$profileValues[["PosOrder"]]
    profileCGH$profileValues[["PosOrder"]] <- 1:profileCGH$NbProbes
    ## if (mediancenter) {
    ##     med <- median(profileCGH$profileValues[["LogRatio"]])
    ##     profileCGH$profileValues[["LogRatio"]] <- profileCGH$profileValues[["LogRatio"]] - 
    ##         med
    ## }

    if(GLADdetails) cat("\n GLAD details: before chrBreakpoints \n")

    ## print("Smoothing for each Chromosome")
    profileCGH <- chrBreakpoints(profileCGH, smoothfunc = smoothfunc, 
                                 OnlyOptimCall = OnlyOptimCall, base = base, sigma = sigma, 
                                 bandwidth = bandwidth, lkern = lkern, model = model, 
                                 qlambda = qlambda, round = round, verbose = verbose, 
                                 breaksFdrQ = breaksFdrQ, haarStartLevel = haarStartLevel, 
                                 haarEndLevel = haarEndLevel, weights.name = weights.name)
    profileCGH$SigmaC <- profileCGH$Sigma
    profileCGH$Sigma <- NULL
    ## if (OnlySmoothing) {
    ##     junk.fields <- c("NewPosOrder", "OutliersAws", "MinPosOrder", 
    ##         "MaxPosOrder", "OutliersMad", "OutliersTot", "NextLogRatio", 
    ##         "NormalRange", "ZoneGen", "ZoneGNL")
    ##     profileCGH$profileValues <- as.data.frame(profileCGH$profileValues[setdiff(names(profileCGH$profileValues), 
    ##         junk.fields)])
    ##     return(profileCGH)
    ## }
    ## if (genomestep) {
    ##     profileCGH <- dogenomestep(profileCGH, nb.new.fields = nb.new.fields, 
    ##         new.fields = new.fields, smoothfunc = smoothfunc, 
    ##         lkern = lkern, model = model, qlambda = qlambda, 
    ##         bandwidth = bandwidth, sigma = sigma, base = FALSE, 
    ##         round = round, lambdabreak = lambdabreak, lambdaclusterGen = lambdaclusterGen, 
    ##         param = param, alpha = alpha, msize = msize, method = method, 
    ##         nmin = nmin, nmax = nmax, amplicon = amplicon, deletion = deletion, 
    ##         deltaN = deltaN, forceGL = forceGL, nbsigma = nbsigma, 
    ##         MinBkpWeight = MinBkpWeight, DelBkpInAmp = DelBkpInAmp, 
    ##         DelBkpInDel = DelBkpInDel, CheckBkpPos = CheckBkpPos, 
    ##         assignGNLOut = assignGNLOut, breaksFdrQ = breaksFdrQ, 
    ##         haarStartLevel = haarStartLevel, haarEndLevel = haarEndLevel, 
    ##         weights.name = weights.name, verbose = verbose)
    ## }
    ## else {

    if(GLADdetails) cat("\n GLAD details: after chrBreakpoints \n")
    
    
    profileCGH$NormalRef <- 0
    if (is.null(sigma)) {
        IQRinfoG <- IQRdiff(profileCGH$profileValues[["LogRatio"]])
    }
    else {
        IQRinfoG <- sigma
    }

    if(GLADdetails) cat("\n GLAD details: starting IQRdiff \n")

    profileCGH$SigmaG <- data.frame(Chromosome = 0, Value = IQRinfoG)
    profileCGH$findClusterSigma <- profileCGH$SigmaG$Value[1]
    ##    }
    FieldOrder <- names(profileCGH$profileValues)
    profileCGH$AbsoluteBkp <- data.frame(Chromosome = c(0, profileCGH$PosOrderRange$Chromosome), 
        PosOrder = c(0, profileCGH$PosOrderRange$MaxPosOrder), 
        AbsoluteBkp = 1)

    if(GLADdetails) cat("\n GLAD details: before OptimBkpFindCluster \n")

    print("Optimization of the Breakpoints and DNA copy number calling")
    profileCGH <- OptimBkpFindCluster(profileCGH)
    profileCGH$BkpInfo <- BkpInfo(profileCGH)
    if (verbose) 
        print("daglad - step filterBkpStep (pass 0)")

    if(GLADdetails) cat("\n GLAD details: before filterBkpStep 0 \n")

    profileCGH <- filterBkpStep(profileCGH, MinBkpWeight = MinBkpWeight, 
        DelBkpInAmp = DelBkpInAmp, DelBkpInDel = DelBkpInDel, 
        assignGNLOut = assignGNLOut, verbose = verbose)

    if(GLADdetails) cat("\n GLAD details: before DelRegionTooSmall \n")

    profileCGH <- DelRegionTooSmall(profileCGH, region.size = region.size)
    profileCGH <- DelRegionTooSmall(profileCGH, region.size = region.size)

    if(GLADdetails) cat("\n GLAD details: before BkpInfo \n")

    if (verbose) 
        print("daglad - step BkpInfo")
    profileCGH$BkpInfo <- BkpInfo(profileCGH)
    if (verbose) 
        print("daglad - step OutliersGNL")

    if(GLADdetails) cat("\n GLAD details: before OutliersGNL \n")

    profileCGH <- OutliersGNL(profileCGH, alpha = alpha, sigma = profileCGH$SigmaG$Value[1], 
        NormalRef = profileCGH$NormalRef, amplicon = amplicon, 
        deletion = deletion, assignGNLOut = assignGNLOut)
    if (verbose) 
        print("daglad - step filterBkpStep (pass 1)")

    if(GLADdetails) cat("\n GLAD details: before filterBkpStep 1 \n")
    
    profileCGH <- filterBkpStep(profileCGH, MinBkpWeight = MinBkpWeight, 
        DelBkpInAmp = DelBkpInAmp, DelBkpInDel = DelBkpInDel, 
        assignGNLOut = assignGNLOut, verbose = verbose)
    if (CheckBkpPos) {
        if (verbose) 
            print("daglad - step MoveBkpStep")

        if(GLADdetails) cat("\n GLAD details: before MoveBkpStep \n")

        profileCGH <- MoveBkpStep(profileCGH, assignGNLOut = assignGNLOut)
    }
    if (verbose) 
        print("daglad - step filterBkpStep (pass 2)")

    if(GLADdetails) cat("\n GLAD details: before filterBkpStep \n")

    profileCGH <- filterBkpStep(profileCGH, MinBkpWeight = MinBkpWeight, 
        DelBkpInAmp = DelBkpInAmp, DelBkpInDel = DelBkpInDel, 
        assignGNLOut = assignGNLOut, verbose = verbose)
    ## print("Results Preparation")

    if(GLADdetails) cat("\n GLAD details: before prepare.output.daglad \n")

    profileCGH <- prepare.output.daglad(profileCGH = profileCGH, 
        genomestep = genomestep, normalrefcenter = normalrefcenter, 
        inputfields = inputfields)
    if(GLADdetails) cat("\n GLAD details: before returning from daglad \n")

    return(profileCGH)
}



## the following removes a lot of unneeded, but not executed, code.
## And if I use it, then I get the
## * checking foreign function calls ... NOTE
## Foreign function call to a different package:
##   .C("chrBreakpoints_haarseg", ..., PACKAGE = "GLAD")

## So I won't use it.
## chrBreakpoints.ADa1 <- function (profileCGH, smoothfunc = "lawsglad", OnlyOptimCall = FALSE, 
##                                  base = FALSE, sigma = NULL, model = "Gaussian", bandwidth = 10, 
##                                  round = 1.5, verbose = FALSE, breaksFdrQ = 1e-04, haarStartLevel = 1, 
##                                  haarEndLevel = 5, weights.name = NULL, ...) 
## {
##     if (verbose) {
##         print("chrBreakpoints: starting function")
##         call <- match.call()
##         print(paste("Call function:", call))
##     }
##     ## if (smoothfunc != "laws" && smoothfunc != "aws" && smoothfunc != 
##     ##     "lawsglad" && smoothfunc != "haarseg" && smoothfunc != 
##     ##     "haarsegbychr") {
##     ##     stop("Choose either aws, laws or haarseg for smoothfunc")
##     ## }
##     ## if (base == TRUE) {
##     ##     if (smoothfunc != "lawsglad" && smoothfunc != "haarseg") {
##     ##         stop("Choose either aws, or laws when base=TRUE")
##     ##     }
##     ## }
##     ## if (is.null(sigma)) {
##         resetsigma <- TRUE
##     ## }
##     ## else {
##     ##     resetsigma <- FALSE
##     ## }
##     ## IQRdiff <- function(y) IQR(diff(y))/1.908
##     ## roundglad <- function(x, digits = 2) {
##     ##     dec <- (digits - trunc(digits))
##     ##     if (dec == 0) 
##     ##         dec <- 1
##     ##     r <- 10^(-trunc(digits)) * dec
##     ##     x <- r * round(x/r)
##     ##     return(x)
##     ## }
##     ## if (smoothfunc != "haarseg") {
##     ##     indice <- 1:length(profileCGH$profileValues[[1]])
##     ##     ChrIndice <- split(indice, profileCGH$profileValues[["Chromosome"]])
##     ##     ChrName <- names(ChrIndice)
##     ##     if (is.numeric(profileCGH$profileValues[["Chromosome"]][1])) {
##     ##         labelChr <- as.numeric(ChrName)
##     ##     }
##     ##     else {
##     ##         labelChr <- as.character(ChrName)
##     ##     }
##     ##     NbChr <- length(labelChr)
##     ##     lg <- rep(0, NbChr)
##     ##     PosOrderRange <- data.frame(Chromosome = lg, MinPosOrder = lg, 
##     ##         MaxPosOrder = lg)
##     ##     nbregion <- 0
##     ##     nblevel <- 0
##     ##     profileCGH$BkpDetected <- data.frame(Chromosome = as.integer(labelChr), 
##     ##         BkpDetected = 0)
##     ##     IQRvalue <- IQRChr <- NULL
##     ##     for (i in 1:NbChr) {
##     ##         if (verbose) 
##     ##             print(paste("chrBreakpoints: starting chromosome", 
##     ##               labelChr[i]))
##     ##         indexChr <- ChrIndice[[i]]
##     ##         subsetdata <- profileCGH$profileValues[indexChr, 
##     ##             ]
##     ##         PosOrderRange$Chromosome[i] <- labelChr[i]
##     ##         rangePos <- range(subsetdata[["PosOrder"]])
##     ##         subsetdata[["MinPosOrder"]] <- PosOrderRange$MinPosOrder[i] <- rangePos[1]
##     ##         subsetdata[["MaxPosOrder"]] <- PosOrderRange$MaxPosOrder[i] <- rangePos[2]
##     ##         if (length(indexChr) > 1) {
##     ##             if (resetsigma) {
##     ##               sigma <- IQRdiff(subsetdata[["LogRatio"]])^2
##     ##               IQRvalue[i] <- sigma^(0.5)
##     ##               IQRChr[i] <- labelChr[i]
##     ##             }
##     ##             else {
##     ##               IQRvalue[i] <- sigma^0.5
##     ##               IQRChr[i] <- labelChr[i]
##     ##             }
##     ##             if (sigma == 0) {
##     ##               print("Warnings: sigma equal 0")
##     ##               print("Number of probes:", length(indexChr))
##     ##               print("sigma was automatically set to 1")
##     ##               sigma <- 1
##     ##             }
##     ##             if (base == TRUE) {
##     ##               x <- subsetdata[["PosBase"]]
##     ##               datarange <- range(x)
##     ##               hmax <- diff(datarange) * bandwidth
##     ##               hinit <- median(diff(x))
##     ##               if (smoothfunc == "laws") {
##     ##                 dim(x) <- c(1, length(x))
##     ##                 awsres <- laws(y = subsetdata[["LogRatio"]], 
##     ##                   x = x, hinit = hinit, hmax = hmax, shape = sigma, 
##     ##                   NN = FALSE, symmetric = TRUE, model = model, 
##     ##                   ...)$theta
##     ##                 if (is.null(awsres) == FALSE) {
##     ##                   subsetdata[["Smoothing"]] <- roundglad(awsres, 
##     ##                     round)
##     ##                 }
##     ##                 else {
##     ##                   subsetdata[["Smoothing"]] <- 99999
##     ##                 }
##     ##               }
##     ##               if (smoothfunc == "aws") {
##     ##                 awsres <- aws(y = subsetdata[["LogRatio"]], 
##     ##                   x = x, hinit = hinit, hmax = hmax, sigma2 = sigma, 
##     ##                   NN = FALSE, symmetric = TRUE, ...)$theta
##     ##                 if (is.null(awsres) == FALSE) {
##     ##                   subsetdata[["Smoothing"]] <- roundglad(awsres, 
##     ##                     round)
##     ##                 }
##     ##                 else {
##     ##                   subsetdata[["Smoothing"]] <- 99999
##     ##                 }
##     ##               }
##     ##             }
##     ##             else {
##     ##               hinit <- 1
##     ##               hmax <- length(subsetdata[["PosOrder"]]) * 
##     ##                 bandwidth
##     ##               if (smoothfunc == "lawsglad") {
##     ##                 awsres <- lawsglad(y = subsetdata[["LogRatio"]], 
##     ##                   hinit = hinit, hmax = hmax, shape = sigma, 
##     ##                   model = model, ...)
##     ##                 if (is.null(awsres) == FALSE) {
##     ##                   subsetdata[["Smoothing"]] <- roundglad(awsres, 
##     ##                     round)
##     ##                 }
##     ##                 else {
##     ##                   subsetdata[["Smoothing"]] <- 99999
##     ##                 }
##     ##               }
##     ##               if (smoothfunc == "laws") {
##     ##                 awsres <- laws(y = subsetdata[["LogRatio"]], 
##     ##                   hinit = hinit, hmax = hmax, shape = sigma, 
##     ##                   symmetric = TRUE, model = model, ...)$theta
##     ##                 if (is.null(awsres) == FALSE) {
##     ##                   subsetdata[["Smoothing"]] <- roundglad(awsres, 
##     ##                     round)
##     ##                 }
##     ##                 else {
##     ##                   subsetdata[["Smoothing"]] <- 99999
##     ##                 }
##     ##               }
##     ##               if (smoothfunc == "aws") {
##     ##                 awsres <- aws(y = subsetdata[["LogRatio"]], 
##     ##                   hinit = hinit, hmax = hmax, sigma2 = sigma, 
##     ##                   symmetric = TRUE, ...)$theta
##     ##                 if (is.null(awsres) == FALSE) {
##     ##                   subsetdata[["Smoothing"]] <- roundglad(awsres, 
##     ##                     round)
##     ##                 }
##     ##                 else {
##     ##                   subsetdata[["Smoothing"]] <- 99999
##     ##                 }
##     ##               }
##     ##               if (smoothfunc == "haarsegbychr") {
##     ##                 awsres <- HaarSegGLADCPP(subsetdata[["LogRatio"]], 
##     ##                   breaksFdrQ = breaksFdrQ, haarStartLevel = haarStartLevel, 
##     ##                   haarEndLevel = haarEndLevel)
##     ##                 if (is.null(awsres) == FALSE) {
##     ##                   subsetdata[["Smoothing"]] <- awsres
##     ##                 }
##     ##                 else {
##     ##                   subsetdata[["Smoothing"]] <- 99999
##     ##                 }
##     ##               }
##     ##             }
##     ##             nbregion <- nbregion + 1
##     ##             l <- length(subsetdata[["Smoothing"]])
##     ##             putLevel <- .C("putLevel_awsBkp", Smoothing = as.double(subsetdata[["Smoothing"]]), 
##     ##               as.double(subsetdata[["LogRatio"]]), Level = integer(l), 
##     ##               nblevel = as.integer(nblevel), as.integer(l), 
##     ##               OutliersAws = integer(l), nbregion = as.integer(nbregion), 
##     ##               regionChr = integer(l), Breakpoints = integer(l), 
##     ##               BkpDetected = integer(1), PACKAGE = "GLAD")
##     ##             subsetdata[c("Smoothing", "Level", "Region", 
##     ##               "OutliersAws", "Breakpoints")] <- putLevel[c("Smoothing", 
##     ##               "Level", "regionChr", "OutliersAws", "Breakpoints")]
##     ##             nblevel <- putLevel$nblevel
##     ##             profileCGH$BkpDetected$BkpDetected[i] <- putLevel$BkpDetected
##     ##             nbregion <- putLevel$nbregion
##     ##         }
##     ##         else {
##     ##             subsetdata[["Region"]] <- -1
##     ##             subsetdata[["Level"]] <- -1
##     ##             subsetdata[["Breakpoints"]] <- 0
##     ##             IQRvalue[i] <- 0
##     ##             IQRChr[i] <- labelChr[i]
##     ##         }
##     ##         profileCGH$profileValues[indexChr, ] <- subsetdata
##     ##         if (verbose) 
##     ##             print(paste("chrBreakpoints: ending chromosome", 
##     ##               labelChr[i]))
##     ##     }
##     ##     profileCGH$Sigma <- data.frame(Chromosome = IQRChr, Value = IQRvalue)
##     ##     profileCGH$PosOrderRange <- PosOrderRange
##     ## }
##     ## else {
##         if (!is.null(weights.name)) {
##             W <- profileCGH$profileValues[[weights.name]]
##         }
##         else {
##             W <- NULL
##         }
##         NbChr <- length(unique(profileCGH$profileValues[["Chromosome"]]))
##         l <- length(profileCGH$profileValues[["LogRatio"]])
##         res <- .C("chrBreakpoints_haarseg", as.double(profileCGH$profileValues[["LogRatio"]]), 
##             as.integer(profileCGH$profileValues[["Chromosome"]]), 
##             Smoothing = as.double(profileCGH$profileValues[["Smoothing"]]), 
##             Level = integer(l), OutliersAws = integer(l), regionChr = integer(l), 
##             Breakpoints = integer(l), sizeChr = integer(NbChr), 
##             startChr = integer(NbChr), IQRChr = integer(NbChr), 
##             IQRValue = double(NbChr), BkpDetected = integer(NbChr), 
##             as.double(breaksFdrQ), as.integer(haarStartLevel), 
##             as.integer(haarEndLevel), as.integer(NbChr), as.integer(l), 
##             as.double(W), as.integer(OnlyOptimCall), PACKAGE = "GLAD")
##         MinPosOrder <- res[["startChr"]] + 1
##         MaxPosOrder <- res[["sizeChr"]] + MinPosOrder - 1
##         profileCGH$PosOrderRange <- data.frame(Chromosome = res[["IQRChr"]], 
##             MinPosOrder = MinPosOrder, MaxPosOrder = MaxPosOrder)
##         profileCGH$Sigma <- data.frame(Chromosome = res[["IQRChr"]], 
##             Value = res[["IQRValue"]])
##         profileCGH$BkpDetected <- data.frame(Chromosome = res[["IQRChr"]], 
##             BkpDetected = res[["BkpDetected"]])
##         profileCGH$profileValues[c("Smoothing", "Level", "Region", 
##             "OutliersAws", "Breakpoints")] <- res[c("Smoothing", 
##             "Level", "regionChr", "OutliersAws", "Breakpoints")]
## ##    }
##     if (verbose) 
##         print("chrBreakpoints: ending function")
##     return(profileCGH)
## }





pSegmentDNAcopy <- function(cghRDataName, chromRDataName,
                            merging = "MAD", ## used to be "mergeLevels",
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
                            typeParall = "fork",
                            mc.cores = detectCores(),
                            certain_noNA = FALSE,
                            loadBalance = TRUE,
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
  
##  getbdry <- DNAcopy::getbdry

  ## taken directly from DNAcopy::segment
  ## except no DNAcopy::default.DNAcopy.bdry
  ## but direct assignment of object
  if (nperm == 10000 & alpha == 0.01 & eta == 0.05) {
      if (!exists("default.DNAcopy.bdry")) 
          dfdbd <- data(default.DNAcopy.bdry, package = "DNAcopy", 
                        envir = environment())
      ## sbdry <- default.DNAcopy.bdry
      sbdry <- get(dfdbd)
  } else {
    max.ones <- floor(nperm * alpha) + 1
##    sbdry <- DNAcopy::getbdry(eta, nperm, max.ones)
    sbdry <- getbdry(eta, nperm, max.ones)
  }
  sbn <- length(sbdry)


  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  if(type.of.data != type.of.chrom)
    stop("The cgh and chrom data should be of the same type:",
         "both RAM objects, or both RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)

  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("regular R objects in RAM (non ff objects) can only be used",
         "if you are using forking")
  if(ff.object){
    nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
    arrayNames <- colnames(get(nameCgh))
    narrays <- ncol(get(nameCgh))
##    nvalues <- nrow(get(nameCgh))
    ## close(get(nameCgh))
    ## nameChrom <- getffObj(chromRDataName, silent = TRUE)
    ## rle.chr <- intrle(as.integer(get(nameChrom)[]))
    ## close(get(nameChrom)) 

  } else {
    arrayNames <- colnames(cghRDataName)
    narrays <- ncol(cghRDataName)
##    nvalues <- nrow(cghRDataName)
    ## rle.chr <- intrle(as.integer(chromRDataName))
  }
  ## chr.end <- cumsum(rle.chr$lengths)
  ## chr.start <- c(1, chr.end[-length(chr.end)] + 1)
  ## chromPos <- cbind(chr.start, chr.end)

  outsf <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
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
                      mad.threshold = mad.threshold,
                      ff.object,
                      certain_noNA,
                      loadBalance = loadBalance)
  
  ## nodeWhere("pSegmentDNAcopy")
  ## FIXME: classes!! for all output!!
  ## class(out) <- c("adacgh.generic.out", "adacghHaarSeg")
  return(outToffdf2(outsf, arrayNames, ff.out = ff.object))
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
                            mad.threshold,
                            ff.object,
                            certain_noNA) {
  ff.out <- ff.object
  
  if(ff.object) {
    cghdata <- getCGHValue(cghRDataName, index)
    chrom.numeric <- getChromValue(chromRDataName)
  } else {
    cghdata <- cghRDataName[, index]
    chrom.numeric <- chromRDataName
  }

  if(!certain_noNA) {
      cleanDataList <- expungeNA(cghdata)
      cghdata <- cleanDataList$x_clean
      chrom.numeric <- chrom.numeric[cleanDataList$pos_clean]
  }
  
  ## cghdata <- getCGHValue(cghRDataName, index)
  ## chrom.numeric <- getChromValue(chromRDataName)
  if(smooth)
    cghdata <- local(internalDNAcopySmooth(cghdata,
                                chrom.numeric = chrom.numeric,
                                smooth.region = 2, outlier.SD.scale = 4,
                                smooth.SD.scale = 2, trim = 0.025))
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


  if(certain_noNA) {
      if(ff.out) {
          return(ffListOut(outseg[, 1], outseg[, 2]))
      } else {
          return(list(smoothed = outseg[, 1], 
                      state = as.integer(outseg[, 2])))
      }
  } else {
      smoothed <- local(inpungeNA(outseg[, 1],
                                  cleanDataList$lx,
                                  cleanDataList$pos_clean,
                                  cleanDataList$nas))
      state <- local(inpungeNA(outseg[, 2], 
                               cleanDataList$lx,
                               cleanDataList$pos_clean,
                               cleanDataList$nas))
      gc()
      
      if(ff.out) {
          return(ffListOut(smoothed, state))
      } else {
          return(list(smoothed = smoothed, 
                      state = as.integer(state)))
      }
  }
}


pSegmentHaarSeg <- function(cghRDataName, chromRDataName,
                            merging = "MAD",
                            mad.threshold = 3,
                            W = vector(),
                            rawI = vector(), 
                            breaksFdrQ = 0.001,			  
                            haarStartLevel = 1,
                            haarEndLevel = 5,
                            typeParall = "fork",
                            mc.cores = detectCores(),
                            certain_noNA = FALSE,
                            loadBalance = FALSE,                            
                            ...) {

  ### Here we find out if RAMl object, regular RData on disk, or ff
  ### object on disk.  Dealing with usual, regular, RDatas on disk I want
  ### to load them in the overall session, no inside function calls, to
  ### preserve memory. So we do not deal with that case.

  #### All of this should go to a function?
  #### return arrayNames, etc, and type of object
  #### that is a complicated mess. This should be a macro ;-)
  
  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  if(type.of.data != type.of.chrom)
    stop("The cgh and chrom data should be of the same type:",
         "both RAM objects, or both RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)

  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("regular R objects in RAM (non ff objects) can only be used",
         "if you are using forking")
  if(ff.object){
    nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
    arrayNames <- colnames(get(nameCgh))
    narrays <- ncol(get(nameCgh))
##    nvalues <- nrow(get(nameCgh))
    ## close(get(nameCgh))

    ## nameChrom <- getffObj(chromRDataName, silent = TRUE)
    ## rle.chr <- intrle(as.integer(get(nameChrom)[]))
    ## close(get(nameChrom)) 
    
  } else {
    arrayNames <- colnames(cghRDataName)
    narrays <- ncol(cghRDataName)
    ##    nvalues <- nrow(cghRDataName)
    ##    rle.chr <- intrle(as.integer(chromRDataName))
  }
  ## chr.end <- cumsum(rle.chr$lengths)
  ## chr.start <- c(1, chr.end[-length(chr.end)] + 1)
  ## chromPos <- cbind(chr.start, chr.end)

  outsf <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalHaarSeg,
                      cghRDataName = cghRDataName,
                      mad.threshold = mad.threshold,
                      chromRDataName = chromRDataName,
                      W, rawI,
                      breaksFdrQ,
                      haarStartLevel,
                      haarEndLevel,
                      merging,
                      ff.object,
                      certain_noNA,
                      loadBalance = loadBalance)


  return(outToffdf2(outsf, arrayNames, ff.out = ff.object))
}




internalHaarSeg <- function(index,
                            cghRDataName,
                            mad.threshold,
                            chromRDataName,
                            W, rawI,
                            breaksFdrQ,
                            haarStartLevel,
                            haarEndLevel,
                            merging,
                            ff.object,
                            certain_noNA) {

  ff.out <- ff.object ## for now, leave like this
  if(ff.object) {
    xvalue <- getCGHValue(cghRDataName, index)

  } else {
    xvalue <- cghRDataName[, index]
  }
  if(!certain_noNA) {
      cleanDataList <- expungeNA(xvalue)
      xvalue <- local(cleanDataList$x_clean)
  }
  
  ## We need to deal with each chromPos individually, because
  ## of missings. And yes, we repeat code, to minimize temporaries.

  if(certain_noNA) {
      if(ff.object){
          nameChrom <- getffObj(chromRDataName, silent = TRUE)
          rle.chr <- intrle(as.integer(get(nameChrom)[]))
          close(get(nameChrom)) 
          
      } else {
          rle.chr <- intrle(as.integer(chromRDataName))
      }
  } else {
      if(ff.object){
          nameChrom <- getffObj(chromRDataName, silent = TRUE)
          rle.chr <- intrle(as.integer(get(nameChrom)[cleanDataList$pos_clean]))
          close(get(nameChrom)) 
          
      } else {
          rle.chr <- intrle(as.integer(chromRDataName[cleanDataList$pos_clean]))
      }
  }
  chr.end <- cumsum(rle.chr$lengths)
  chr.start <- c(1, chr.end[-length(chr.end)] + 1)
  chromPos <- cbind(chr.start, chr.end)
  rm(rle.chr)
  
  ##   chrom.numeric <- chrom.numeric[cleanDataList$pos_clean]


  
  ## the next won't work, as it returns only the first element!!!
  ## xvalue <- ifelse(ff.object,
  ##                  getCGHValue(cghRDataName, index),
  ##                  cghRDataName[, index]
  ##                  )
  
  
  haarout <- local(ad_HaarSeg(I = xvalue,
                              chromPos = chromPos,
                              W = W, rawI = rawI,
                              breaksFdrQ = breaksFdrQ,
                              haarStartLevel = haarStartLevel,
                              haarEndLevel = haarEndLevel)[[2]])
  rm(chr.end)
  rm(chr.start)
  rm(chromPos)
  gc()
  if(merging == "none") {
      if(certain_noNA) {
          state <- rep.int(0L, length(haarout))
      } else {
          haarout <- local(inpungeNA(haarout,
                                     cleanDataList$lx,
                                     cleanDataList$pos_clean,
                                     cleanDataList$nas))
          state <- rep.int(0L, cleanDataList$lx)
          rm(cleanDataList)
          gc()
      }
    if(ff.out) {
      gc()
      return(ffListOut(haarout,
                       state))
    } else {
      gc()
      return(list(smoothed = haarout,
                       state = state))
    }
  } else if(merging == "MAD") {
      mad.subj <- local(median(abs(xvalue - haarout))/0.6745)
      rm(xvalue)
      thresh <- mad.threshold * mad.subj
      ## nodeWhere("internalHaarSeg")
      if(!certain_noNA) {
          haarout <- local(inpungeNA(haarout,
                                     cleanDataList$lx,
                                     cleanDataList$pos_clean,
                                     cleanDataList$nas))
          
          rm(cleanDataList)
          ## gc()
      }
      state <- local(ifelse( (abs(haarout) > thresh), 1, 0) *
                     sign(haarout))
      if (ff.out) {
          gc()
          return(ffListOut(haarout, state))
      } else {
          gc()
          return(list(smoothed = haarout,
                      state = as.integer(state)))
      }
  } else if(merging == "mergeLevels") {
      outseg <- ourMerge(xvalue, haarout)
      if(certain_noNA) {
          if(ff.out) {
              gc()
              return(ffListOut(outseg[, 1],
                               outseg[, 2]))
          } else {
              gc()
              return(list(smoothed = outseg[, 1],
                          state = as.integer(outseg[, 2])))
          }   
      } else {
          haarout <- local(inpungeNA(outseg[, 1],
                                     cleanDataList$lx,
                                     cleanDataList$pos_clean,
                                     cleanDataList$nas))
          
          state <- local(inpungeNA(outseg[ , 2],
                                   cleanDataList$lx,
                                   cleanDataList$pos_clean,
                                   cleanDataList$nas))
          rm(outseg)
          rm(cleanDataList)
          ## gc()
          if(ff.out) {
              gc()
              return(ffListOut(haarout,
                               state))
          } else {
              gc()
              return(list(smoothed = haarout,
                          state = as.integer(state)))
          }
      }
  } else {
      rm(haarout)
      rm(cleanDataList)
      gc()
      stop("This merging method not recognized")
  }
}


pSegmentHMM <- function(cghRDataName, chromRDataName,
                        merging = "mergeLevels", mad.threshold = 3,
                        aic.or.bic = "AIC",
                        typeParall = "fork",
                        mc.cores = detectCores(),
                        certain_noNA = FALSE,
                        loadBalance = TRUE,                        
                        ...) {

  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  if(type.of.data != type.of.chrom)
    stop("The cgh and chrom data should be of the same type:",
         "both RAM objects, or both RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)

  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("regular R objects in RAM (non ff objects) can only be used",
         "if you are using forking")

  
  ## The table exists. No need to re-create if
  ## really paranoid about speed

  ## Time this thing! FIXME!!!
  if (ff.object)
    tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)
  else
    tableArrChrom <- createTableArrChrom(colnames(cghRDataName),
                                                  chromRDataName)

  if(ff.object){
    nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
    arrayNames <- colnames(get(nameCgh))
    narrays <- ncol(get(nameCgh))
##    nvalues <- nrow(get(nameCgh))
    ## close(get(nameCgh))
  } else {
    arrayNames <- colnames(cghRDataName)
    narrays <- ncol(cghRDataName)
##    nvalues <- nrow(cghRDataName)
  }
  
  
  ## Parallelized by arr by chrom

  ## FIXME: look at index and how are jobs sent to nodes.
  ## I do not want all chrom 1 in in CPU and all chrom 20 in another!
  ## FIXME (DOING NOW): by not using LB, and changing createTableArrCHrom,
  ## have I screwed out the out0 structure?
  ## Nope: internalMADcall and internalMerge use vectorForArray, that
  ## correctly prepares the object.



  ## internalHMM(1, tableArrChrom,
  ##             cghRDataName,
  ##             aic.or.bic,
  ##             ff.object)
  
  ## coco <- lapply(tableArrChrom$Index,
  ##                  internalHMM,
  ##                  tableArrChrom,
  ##                  cghRDataName,
  ##                  aic.or.bic,
  ##                  ff.object)
  
  ## coco <- mclapply(tableArrChrom$Index,
  ##                  internalHMM,
  ##                  tableArrChrom,
  ##                  cghRDataName,
  ##                  aic.or.bic,
  ##                  ff.object, mc.cores = 4)

  
  out0 <- distribute(type = typeParall,
                     mc.cores = mc.cores,
                     tableArrChrom$Index,
                     internalHMM,
                     tableArrChrom,
                     cghRDataName,
                     aic.or.bic,
                     ff.object,
                     silent = TRUE,
                     certain_noNA,
                     loadBalance = loadBalance) ## silly messages returned
  ## nodeWhere("pSegmentHMM_0")
  ## Parallelized by array. Really???
  if(merging == "mergeLevels") {
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalMerge,
                      out0,
                      tableArrChrom,
                      cghRDataName,
                      ff.object, certain_noNA,
                      loadBalance = loadBalance)
  } else if(merging == "MAD") {
    out <- distribute(type = typeParall,
                     mc.cores = mc.cores,
                      1:narrays,
                      internalMADCall,
                      out0,
                      tableArrChrom,
                      cghRDataName,
                      mad.threshold,
                      ff.object, certain_noNA,
                      loadBalance = loadBalance)
  } else {
    stop("This merging method not recognized")
  }

  ## Clean up ff files
  if(ff.object) lapply(out0, delete)
  rm(out0)
  gc()
  ## nodeWhere("pSegmentHMM_1")
  return(outToffdf2(out, arrayNames, ff.out = ff.object))
}

internalHMM <- function(tableIndex, tableArrChrom, cghRDataName, aic.or.bic, ff.object,
                        certain_noNA) {
  ff.out <- ff.object
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalHMM")
  if(ff.object) {
    return(hmmWrapper(getCGHValue(cghRDataName, arrayIndex, chromPos),
                      aic.or.bic, ff.out, certain_noNA))
  } else {
    return(hmmWrapper(cghRDataName[seq.int(from = chromPos[1], to = chromPos[2]),
                                   arrayIndex],
                      aic.or.bic, ff.out, certain_noNA))
  }
}

hmmWrapper <- function(logratio, aic.or.bic, ff.out, certain_noNA) {
  ## Fit HMM, and return the predicted
  ## we do not pass Chrom since we only fit by Chrom.
  ##  cat("\n Disregard the 'sample is  1 	Chromosomes: 1' messages!!!\n")

    if(!certain_noNA) {
        cleanDataList <- expungeNA(logratio)
        logratio <- local(cleanDataList$x_clean)
    }
##  Pos <- Clone <- seq_along(logratio)
    Clone <- seq_along(logratio)
    Chrom <- rep(1, length(logratio))
    obj.aCGH <- create.aCGH(data.frame(logratio),
                            data.frame(Clone = Clone,
                                       Chrom = Chrom,
                                       kb = Clone ## used to be Pos
                                     ))
  ## we could wrap this in "capture.output"
  if(aic.or.bic == "AIC")
    silentout <-
      capture.output(res <- find.hmm.states(obj.aCGH,
                                            aic = TRUE, bic = FALSE))
  else
    silentout <-
      capture.output(res <- find.hmm.states(obj.aCGH,
                                            aic = FALSE, bic = TRUE))
  hmm(obj.aCGH) <- res
  ## nodeWhere("hmmWrapper")

  ## yes, it sucks composing the object again, to later remove NAs again
  ## but otherwise, I'd need to pass around the NA info.
  ## Cumbersome and CPU and memory consuming

    if(certain_noNA) {
        rm(res)
        rm(logratio)
        rm(Clone) ## rm(Pos)
        rm(Chrom)
        gc()
        if(ff.out) {
            return(ffVecOut(obj.aCGH$hmm$states.hmm[[1]][, 6]))
        } else {
            return(obj.aCGH$hmm$states.hmm[[1]][, 6])
        }
    } else {
        smoothed <- local(inpungeNA(obj.aCGH$hmm$states.hmm[[1]][, 6],
                                    cleanDataList$lx,
                                    cleanDataList$pos_clean,
                                    cleanDataList$nas))
        rm(cleanDataList)
        rm(obj.aCGH)
        rm(res)
        rm(logratio)
        rm(Clone) ## rm(Pos)
        rm(Chrom)
        gc()
        if(ff.out) {
            return(ffVecOut(smoothed))
        } else {
            return(smoothed)
        }
    }
}

internalMADCall <- function(index, smoothedff, tableArrChrom, cghRDataName,
                            mad.threshold, ff.out,
                            certain_noNA) {
  ## calling via MAD, as in HaarSeg


  if(ff.out) {
    values <- getCGHValue(cghRDataName, index)
    smoothed <- vectorForArray(tableArrChrom, index, smoothedff)

  } else {
    values <- cghRDataName[, index]
    smoothed <- vectorForArrayRAM(tableArrChrom, index, smoothedff)

  }
  if(!certain_noNA) {
      cleanDataList <- expungeNA(smoothed)
      smoothed <- local(cleanDataList$x_clean)
      values <- values[cleanDataList$pos_clean]
  }
  mad.subj <- median(abs(values - smoothed))/0.6745
  thresh <- mad.threshold * mad.subj


  if(!certain_noNA) {
      smoothed <- local(inpungeNA(smoothed,
                                  cleanDataList$lx,
                                  cleanDataList$pos_clean,
                                  cleanDataList$nas))
      rm(cleanDataList)
  }
  state <- local(ifelse( (abs(smoothed) > thresh), 1, 0) * sign(smoothed))

  rm(values)
  gc()
  
  if(ff.out) {
    return(ffListOut(smoothed, state))
  } else {
    return(list(smoothed = smoothed,
                state = as.integer(state)))
  }
}

## simpleMADCall <- function(original, smoothed, mad.threshold) {
##   ## Like internal MADCall, but when you have the vectors already
##   ## Unlikely it makes sense to use it, because of duplication.
##   ## See what we do in internalDNAcopy
##   mad.subj <- median(abs(original - smoothed))/0.6745
##   thresh <- mad.threshold * mad.subj
##   return(cbind(smoothed, ifelse( (abs(smoothed) > thresh), 1, 0) * sign(smoothed)))
## }


internalMerge <- function(index, smoothedff, tableArrChrom, cghRDataName,
                          ff.out,
                          certain_noNA) {

  if(ff.out) {
    values <- getCGHValue(cghRDataName, index)
    smoothed <- vectorForArray(tableArrChrom, index, smoothedff)
  } else {
    values <- cghRDataName[, index]
    smoothed <- vectorForArrayRAM(tableArrChrom, index, smoothedff)
  }

  if(!certain_noNA) {
      cleanDataList <- expungeNA(smoothed)
      smoothed <- local(cleanDataList$x_clean)
      values <- local(values[cleanDataList$pos_clean])
  }
  outseg <- ourMerge(values, smoothed)

  rm(values)

  if(certain_noNA) {
      if(ff.out) {
          return(ffListOut(outseg[, 1], outseg[, 2]))
      } else {
          return(list(smoothed = outseg[, 1],
                      state = as.integer(outseg[, 2])))
      }   
  } else {
      smoothed <- local(inpungeNA(outseg[, 1],
                                  cleanDataList$lx,
                                  cleanDataList$pos_clean,
                                  cleanDataList$nas))
      state <- local(inpungeNA(outseg[, 2],
                               cleanDataList$lx,
                               cleanDataList$pos_clean,
                               cleanDataList$nas))
      rm(cleanDataList)
      rm(outseg)
      gc()
      if(ff.out) {
          return(ffListOut(smoothed, state))
      } else {
          return(list(smoothed = smoothed, state = as.integer(state)))
      }
  }
}


pSegmentCGHseg <- function(cghRDataName, chromRDataName, CGHseg.thres = -0.05,
                           merging = "MAD", mad.threshold = 3,
                           typeParall = "fork",
                           mc.cores = detectCores(),
                           certain_noNA = FALSE,
                           loadBalance = TRUE,                           
                           ...) {
  ## merge: "MAD", "mergeLevels", "none"
  ## We always use mergeSegs. OK for gain/loss/no-change,
  ## but it breaks the underlying segments


  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  if(type.of.data != type.of.chrom)
    stop("The cgh and chrom data should be of the same type:",
         "both RAM objects, or both RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)

  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("regular R objects in RAM (non ff objects) can only be used",
         "if you are using forking")

  
  ## The table exists. No need to re-create if
  ## really paranoid about speed
  
  if (ff.object)
    tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)
  else
    tableArrChrom <- createTableArrChrom(colnames(cghRDataName),
                                         chromRDataName)

  if(ff.object){
    nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
    arrayNames <- colnames(get(nameCgh))
    narrays <- ncol(get(nameCgh))
    ##    nvalues <- nrow(get(nameCgh))
    ## close(get(nameCgh))
  } else {
    arrayNames <- colnames(cghRDataName)
    narrays <- ncol(cghRDataName)
    ##    nvalues <- nrow(cghRDataName)
  }

  


  ## Parallelized by arr by chrom
  ## if merge != "none", then it returns ONLY the smoothed values
  out0 <- distribute(type = typeParall,
                     mc.cores = mc.cores,
                     tableArrChrom$Index,
                     internalCGHseg,
                     tableArrChrom,
                     cghRDataName,
                     CGHseg.thres,
                     merging,
                     ff.object,
                     certain_noNA,
                     loadBalance = loadBalance)
  ## nodeWhere("pSegmentCGHseg_0")

  ## Parallelized by array
  if(merging == "mergeLevels") {
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalMerge,
                      out0,
                      tableArrChrom,
                      cghRDataName,
                      ff.object,
                      certain_noNA,
                      loadBalance = loadBalance)
  } else if(merging == "MAD") {
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalMADCall,
                      out0,
                      tableArrChrom,
                      cghRDataName,
                      mad.threshold,
                      ff.object,
                      certain_noNA,
                      loadBalance = loadBalance)
  } else if(merging == "none") {
    ## of course, could be done sequentially
    ## but if many arrays and long chromosomes, probably
    ## better over several nodes
    ## BEWARE: the segment "states" (numbers) are per chromosome!!!
    ## so within array we can have several states with same number
    ## that means very different things!!!

    ## browser()
    ## coco <- puttogetherCGHseg(2, out0, tableArrChrom, ff.object)
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      puttogetherCGHseg,
                      out0,
                      tableArrChrom,
                      ff.object,
                      loadBalance = loadBalance)
    ## nodeWhere("pSegmentCGHseg_No_merge")
  } else {
    stop("This merging method not recognized")
  }

  ## Clean up ff files. The structure is different if merging or not
  if(ff.object) {
    if(merging == "none") {
      lapply(out0, function(x) lapply(x, delete))
    } else {
      lapply(out0, delete)
    }
  }
  rm(out0)
  gc()
  ## nodeWhere("pSegmentCGHseg_1")
  return(outToffdf2(out, arrayNames, ff.out = ff.object))
}



puttogetherCGHseg <- function(index, out, tableArrChrom, ff.out) {
  ## could probably be done more efficiently
  if(ff.out) {
    return(ffListOut(vectorForArrayL2(tableArrChrom, index, out, 1),
                     vectorForArrayL2(tableArrChrom, index, out, 2)))
  } else {
    return(list(smoothed = vectorForArrayRAM2(tableArrChrom, index, out, 1),
                state = as.integer(vectorForArrayRAM2(tableArrChrom, index, out, 2))))
  }
}

internalCGHseg <- function(tableIndex, tableArrChrom, cghRDataName, CGHseg.thres,
                           merging, ff.object, certain_noNA) {
  ## the following could be parameters
  ff.out <- ff.object
  maxseg <- NULL
  verbose <- FALSE
  maxk <- NULL
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalCGHseg")
  ## n <- chromPos[2] - chromPos[1] + 1
  if(ff.object) {
    y <- getCGHValue(cghRDataName, arrayIndex, chromPos)
  } else {
    y <- cghRDataName[seq.int(from = chromPos[1], to = chromPos[2]),
                      arrayIndex]
  }
  if(!certain_noNA) {
    cleanDataList <- expungeNA(y)
    y <- cleanDataList$x_clean
  }
  
  n <- length(y)
  ## obj1 <- tilingArray:::segment(y,
  ##                               maxseg = ifelse(is.null(maxseg), n/2, maxseg),
  ##                               maxk = ifelse(is.null(maxk), n, maxk))

  ## now using ::, not :::
  ## Nope, now in importFrom
  obj1 <- segment(y,
                  maxseg = n/2,
                  maxk = n)

  optk <- piccardsKO(obj1@logLik, n, CGHseg.thres)
  ## if (verbose) {
  ##   cat("\n Index ", tableIndex, ";  Optimal k ", optk, "\n")
  ## }
  ## nodeWhere("internalCGHseg")

  if(certain_noNA) {
    return(piccardsStretch01(obj1, optk, n, y, merging, ff.out,
                             lx = NA,
                             pos_clean = NA,
                             nas = NA,
                             certain_noNA = TRUE))
  } else {
    return(piccardsStretch01(obj1, optk, n, y, merging, ff.out,
                             lx = cleanDataList$lx,
                             pos_clean = cleanDataList$pos_clean,
                             nas = cleanDataList$nas,
                             certain_noNA = FALSE))
  }
  ## return(piccardsStretch01(obj1, optk, n, y, merging, ff.out))

  ## Beware we do not use the original "states" of Piccard
  ## as we always use mergeSegs
  ## segstates <- c(segstates, finalsegm[, 2])
}



piccardsStretch01 <- function(obj, k, n, logratio, merging, ff.out,
                              lx, pos_clean, nas,
                              certain_noNA) {
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
        rm(smoothedC)
        rm(start)
        rm(end)
        rm(poss)
        rm(reps)
        rm(logratio)
    } else { ## only one segment
        smoothed <- rep(mean(logratio), n)
        if(merging == "none") 
          state <- rep(1, n)
    }
    if(!certain_noNA) {
        smoothed <- local(inpungeNA(smoothed,
                                    lx,
                                    pos_clean,
                                    nas))
    }
    gc()
    if(merging!= "none") {
      if(ff.out) {
        return(ffVecOut(smoothed))
      } else {
        return(smoothed)
      }
    } else {
        if(!certain_noNA) {
            state <- local(inpungeNA(state,
                                     lx,
                                     pos_clean,
                                     nas))
        }
        gc()
        if(ff.out) {
            return(list(ffVecOut(smoothed),
                        ffVecOut(state, vmode = "integer")))
        } else {
            return(list(smoothed, as.integer(state)))
        }
    }
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
                             typeParall = "fork",
                             mc.cores = detectCores(),
                             certain_noNA = FALSE,
                             loadBalance = TRUE,                             
                             ...) {

  ## tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)

  ## nameCgh <- getffObj(cghRDataName, silent = TRUE)
  ## arrayNames <- colnames(get(nameCgh))
  ## narrays <- ncol(get(nameCgh))
  ## nvalues <- nrow(get(nameCgh))
  ## close(get(nameCgh))

  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  if(type.of.data != type.of.chrom)
    stop("The cgh and chrom data should be of the same type:",
         "both RAM objects, or both RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)

  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("regular R objects in RAM (non ff objects) can only be used",
         "if you are using forking")

  
  ## The table exists. No need to re-create if
  ## really paranoid about speed
  
  if (ff.object)
    tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)
  else
    tableArrChrom <- createTableArrChrom(colnames(cghRDataName),
                                                  chromRDataName)

  if(ff.object){
    nameCgh <- getffObjNoOpen(cghRDataName, silent = TRUE)
    arrayNames <- colnames(get(nameCgh))
    narrays <- ncol(get(nameCgh))
##    nvalues <- nrow(get(nameCgh))
    ## close(get(nameCgh))
  } else {
    arrayNames <- colnames(cghRDataName)
    narrays <- ncol(cghRDataName)
##    nvalues <- nrow(cghRDataName)
  }

  thismdiff <- if(merging == "mergeLevels") minMergeDiff else minDiff

  out0 <- distribute(type = typeParall,
                     mc.cores = mc.cores,
                     tableArrChrom$Index,
                     internalWaveHsu,
                     tableArrChrom,
                     cghRDataName,
                     thrLvl = thrLvl,
                     minDiff = thismdiff,
                     initClusterLevels = initClusterLevels,
                     merging = merging,
                     ff.object,
                     certain_noNA,
                     loadBalance = loadBalance)
  ## nodeWhere("pSegmentWavelets_0")
 ## Parallelized by arr by chrom
  ## if merge != "none", then it returns ONLY the smoothed values
  if(merging == "mergeLevels") {
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalMerge,
                      out0,
                      tableArrChrom,
                      cghRDataName,
                      ff.object,
                      certain_noNA,
                      loadBalance = loadBalance)
    ## nodeWhere("pSegmentWavelets_mergeLevels")
  } else if(merging == "MAD") {
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      internalMADCall,
                      out0,
                      tableArrChrom,
                      cghRDataName,
                      mad.threshold,
                      ff.object,
                      certain_noNA,
                      loadBalance = loadBalance)
    ## nodeWhere("pSegmentWavelets_MADCall")
  } else if(merging == "none") {
    ## of course, could be done sequentially
    ## but if many arrays and long chromosomes, probably
    ## better over several nodes
    out <- distribute(type = typeParall,
                      mc.cores = mc.cores,
                      1:narrays,
                      puttogetherCGHseg,
                      out0,
                      tableArrChrom,
                      ff.object,
                      loadBalance = loadBalance)
    ## nodeWhere("pSegmentWavelets_No_merge")
  } else {
    stop("This merging method not recognized")
  }

  ## Clean up ff files. The structure is different if merging or not
  if(ff.object) {
    if(merging == "none") {
      lapply(out0, function(x) lapply(x, delete))
    } else {
      lapply(out0, delete)
    }
  }
 
  rm(out0)
 
  ## nodeWhere("pSegmentWavelets_1")
  return(outToffdf2(out, arrayNames, ff.out = ff.object))
}


internalWaveHsu <- function(tableIndex, tableArrChrom,
                            cghRDataName,
                            thrLvl, minDiff, initClusterLevels,
                            merging, ff.object,
                            certain_noNA) {
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])
  ## nodeWhere("internalWaveHsu")
  if(ff.object)
    ratio <- getCGHValue(cghRDataName, arrayIndex, chromPos)
  else
    ratio <- cghRDataName[seq.int(from = chromPos[1], to = chromPos[2]),
                                   arrayIndex]

  if(!certain_noNA) {
      cleanDataList <- expungeNA(ratio)
      ratio <- local(cleanDataList$x_clean)
  }
  
  wc   <- modwt(ratio, "haar", n.levels=thrLvl)
  thH  <- our.hybrid(wc, max.level=thrLvl, hard=FALSE)
  recH <- imodwt(thH)
  ## cluster levels
  pred.ij <- local(segmentW(ratio, recH, minDiff=minDiff,
                            n.levels = initClusterLevels))
  rm(ratio)

  ## the logic here could be clearer!
  if(merging == "none") {
    labs <- as.character(1:length(unique(pred.ij)))
    state <- as.integer(factor(pred.ij, labels=labs))
  }

  if(!certain_noNA) {
      pred.ij <- local(inpungeNA(pred.ij,
                                 cleanDataList$lx,
                                 cleanDataList$pos_clean,
                                 cleanDataList$nas))

      gc()
  } 
  if(merging != "none") {
      if(ff.object) {
          return(ffVecOut(pred.ij))
      } else {
          return(pred.ij)
      }
  } else {
      if(!certain_noNA) {
          state <- local(inpungeNA(state,
                                   cleanDataList$lx,
                                   cleanDataList$pos_clean,
                                   cleanDataList$nas))
          rm(cleanDataList)
          gc()
      }
    if(ff.object) {
      return(list(ffVecOut(pred.ij),
                  ffVecOut(state, vmode = "integer")))
    } else{
     return(list(pred.ij, as.integer(state))) 
    }
  }
}


###################################################################
###################################################################
####################                          #####################
####################          GLAD            #####################
####################                          #####################
###################################################################
###################################################################




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
                       probenamesRDataName = NULL,
                       posRDataName = NULL,
                       imgheight = 500,
                       pixels.point = 3,
                       pch = 20,
                       colors = c("orange", "red", "green",
                         "blue", "black"),
                       imagemap = FALSE,
                       typeParall = "fork",
                       mc.cores = detectCores(),
                       typedev = "default",
                       certain_noNA = FALSE,
                       loadBalance = TRUE,
                       ...) {

    if(imagemap && (is.null(probenamesRDataName)))
        stop("With imagemap you must provide probenamesRDataName")
  type.of.data <- RAM.or.ff(cghRDataName)
  type.of.chrom <- RAM.or.ff(chromRDataName)
  type.of.output <- RAM.or.ff(outRDataName)

  if((type.of.data != type.of.chrom) | (type.of.data != type.of.output)
     | (type.of.chrom != type.of.output))
    stop("The cgh, chrom, and output data should be of the same type:",
         "all RAM objects, or all RData with an ff",
         "object inside.")

  ff.object <- ifelse(type.of.data == "ff", TRUE, FALSE)
  
  if((FALSE == ff.object) && ("cluster" == typeParall))
    stop("regular R objects in RAM (non ff objects) can only be used",
         "if you are using forking")
    
  if (ff.object) {
    tableArrChrom <- wrapCreateTableArrChr(cghRDataName, chromRDataName)
  } else {
    tableArrChrom <- createTableArrChrom(colnames(cghRDataName),
                                         chromRDataName)
  }

  ## for debugging
 ## null <- internalChromPlot(1,
 ##                           tableArrChrom = tableArrChrom,
 ##                           outRDataName = outRDataName,
 ##                           cghRDataName = cghRDataName,
 ##                           chromRDataName = chromRDataName,
 ##                           probenamesRDataName = probenamesRDataName,
 ##                           posRDataName = posRDataName,
 ##                           imgheight = imgheight,
 ##                           pixels.point = pixels.point,
 ##                           pch = pch,
 ##                           colors = colors,
 ##                           imagemap = imagemap,
 ##                           ff.object,
 ##                           ...)

  if(! typedev %in% c("default", "cairo", "cairo-png", "Cairo") )
    stop(" typedev not supporter")

  if(typedev == "default") {
    if(Sys.info()['sysname'] == "Darwin")
      typedev <- "Cairo"
    else
      typedev <- "cairo"
  }
  if( (typedev == "Cairo") && !requireNamespace("Cairo", quietly = TRUE) )
    stop("You selected Cairo as typedev, or you used default",
         " in Mac OS, but the Cairo package is not available.")

  null <- distribute(type = typeParall,
                     mc.cores = mc.cores,
                     tableArrChrom$Index,
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
                     ff.object,
                     typedev,
                     certain_noNA,
                     loadBalance = loadBalance,
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
                              ff.object,
                              typedev,
                              certain_noNA,
                              ...) {
  ## nodeWhere("starting internalChromPlot")
  
  arrayIndex <- tableArrChrom[tableIndex, "ArrayNum"]
  cname <- tableArrChrom[tableIndex, "ChromName"]
  arrayName <- tableArrChrom[tableIndex, "ArrayName"]
  chromPos <- unlist(tableArrChrom[tableIndex, c("posInit", "posEnd")])

  if(ff.object) {
    cghdata <- getCGHValue(cghRDataName, arrayIndex, chromPos)
    res <- getOutValue(outRDataName, 3, arrayIndex, chromPos)
  } else {
   cghdata <- cghRDataName[seq.int(from = chromPos[1], to = chromPos[2]),
                           arrayIndex]
   res <- getOutValueRAM3(outRDataName, 3, arrayIndex, chromPos)
  }

  if(!certain_noNA) {
      cleanDataList <- expungeNA(cghdata)
      cghdata <- cleanDataList$x_clean
      res <- res[cleanDataList$pos_clean, , drop = FALSE]
  }
  
  ndata <- length(cghdata)
  col <- rep(colors[1], ndata)
  col[which(res[, 2] == -1)] <- colors[3]
  col[which(res[, 2] == 1)] <- colors[2]


  if(is.null(posRDataName)) {
    simplepos <- 1:ndata
  } else {
    if(ff.object) {
      simplepos <- getPosValue(posRDataName, chromPos)
    } else {
      simplepos <- posRDataName[seq.int(from = chromPos[1],
                                        to = chromPos[2])]
    }
    if(!certain_noNA) {
        simplepos <- simplepos[cleanDataList$pos_clean]
    }
  }
  
  nameChrIm <- paste("Chr", cname, "@", arrayName, sep ="")
  
  ## cat("\n        internalChromPlot: doing array ", arrayIndex,
  ##     " chromosome ", cnum, 
  ##     " positions ", chromPos, "\n")
  
  ccircle <- NULL
  chrwidth <- round(pixels.point * (ndata + .10 * ndata))
  chrwidth <- max(min(chrwidth, 1200), 800)
  ## Moved inside imagemap3
  ## op <- par(xaxs = "i",
  ##           mar = c(5, 5, 5, 5), 
  ##           oma = c(0, 0, 0, 0),
  ##           ask = FALSE)  
  im2 <- imagemap3(nameChrIm,
                   height = imgheight, width = chrwidth,
                   type = typedev,
                   ps = 12)

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
    if(!certain_noNA) {
        probeNames <- probeNames[cleanDataList$pos_clean]
    }
    if ( (ncol(ccircle)/length(probeNames)) != 1)
      stop("Serious problem: number of arrays does not match")
    write(probeNames, 
          file = paste("geneNames_", nameChrIm, sep = ""))
  }
  
  imClose3(im2)
  ## par(op). ## Nope. This is a png, and we always close it.
  rm(cghdata)
  rm(simplepos)
  rm(res)

  if(!certain_noNA) {
      rm(cleanDataList)
  }
  ## rm(probeNames)
  ## trythis <- try(rm(probeNames), silent = TRUE)
  
  ## if(html_js) 
  ##   system(paste(.python.toMap.py, nameChrIm, 
  ##                idtype, organism, sep = " "))

  ## nodeWhere("internalChromPlot: end")

}

## The Python stuff. We used to have a call to .python.toMap.py.
## For instance, see in 
## ~/bzr-local-repos/adacgh-old/R-packages/ADaCGH/R/ADaCGH.R
## but this is a mess with different OSs, etc.




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
    ## We used to use mergeLevelsB, but no longer necessary
    segmentus2 <-
      mergeLevels(vecObs  = observed,
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

##     if (exists(".__ADaCGH_WEB_APPL", envir = .GlobalEnv) & send_to_pals) {
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

    if(exists(".__ADaCGH_WEB_APPL", envir = .GlobalEnv)) {
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
    } else if(exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv)) {
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

    if(exists(".__ADaCGH_WEB_APPL", envir = .GlobalEnv)) {
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
    } else if(exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv)) {
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

##     if(exists(".__ADaCGH_WEB_APPL", envir = .GlobalEnv)) {
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
##     } else if(exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv)) {
##         caughtOurError2(message)
##     } else {
##         message <- paste("It looks like you found a bug. Please let us know. ", message)
##         stop(message)
##     }
## }
    



caughtOtherError.Web <- function(message) {
    cluster.clean.quit.Web()
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
    cluster.clean.quit.Web()
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


## the next one substitutes snowfall.clean.quit.Web
cluster.clean.quit.Web <- function() {
##  try(parallel::stopCluster(), silent = TRUE)
  try(stopCluster(), silent = TRUE)
}


## mpi.clean.quit.Web <- function() {
##     if (is.loaded("mpi_initialize")){ 
##         if (mpi.comm.size(1) > 0){ 
##             try(mpi.close.Rslaves() , silent = TRUE)
##         } 
##     }
##     try(mpi.exit(), silent = TRUE)
## }


caughtOurError2 <- function(message) {
  message <- paste("There was a problem with our code. Please let us know.\n", 
                   message)
  if(exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv)) {
    cluster.clean.quit.Web()
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
  if(exists(".__ADaCGH_SERVER_APPL", envir = .GlobalEnv)) {
    cluster.clean.quit.Web()
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
                      type,
                      title='Imagemap from R', ps = 12){
  ## copied from "imagemap" function in imagemap.R from B. Rowlingson
  ## with added modification
    if(type == "Cairo") {
        requireNamespace("Cairo", quietly = TRUE)
    ## require(Cairo) ## in case we are running in a cluster
    Cairo::CairoPNG(filename = paste(filename, ".png", sep=''),
             width=width,
             height=height,
             pointsize = ps)
  } else {
    png(filename = paste(filename, ".png", sep=''),
        width=width,
        height=height,
        type = type,
        pointsize = ps)
  }
  op <- par(xaxs = "i")
  ## No, we do not restore this. This is a png
  ## that will be closed.
  
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




##### This is straight from package aCGH, but fixing the problem of wilcox.text(exact = T)

## mergeLevelsB <- function(vecObs, vecPred,
##                          pv.thres=0.0001, ansari.sign=0.05, thresMin=0.05,
##                          thresMax=0.5,verbose=1,scale=TRUE){

##   ## Check if supplied thresholds are valid
##   if(thresMin>thresMax){cat("Error, thresMax should be equal to or larger than thresMin\n");return()}


## # Initializing threshold and threshold vector for keeping track of thresholds
## thresAbs=thresMin
## sq<-numeric()

## #initializing threshold index (threshold count)
## j=0

## #initializing ansari p-values to keep track of ansari p-values for each threshold in sq
## ansari=numeric()

## # Initialize levels count
## lv=numeric()

## # Set backtracking flag. Start with flag=0 indicating significance not yet reached, backtracking not begun
## flag=0

## # If thresMin=thresMax, fixed threshold is used and we set flag=2, only one run of the algoritm with initial thresMin
## if(thresMin==thresMax){flag=2}

## # Evaluate optimum steps for algorithm
## else {
##  l.step <- signif((thresMax-thresMin)/10,1)
##  s.step <- signif((thresMax-thresMin)/200,1)
## }

## while (1){

##   # Print current threshold if verbose is 1 or larger
##   if(verbose>=1){cat("\nCurrent thresAbs: ",thresAbs,"\n")}

##   j=j+1

##   # Save current threshold
##   sq[j]<-thresAbs

##   # temporary predicted values (to be updated)
##   vecPredNow=vecPred

##   #unmissing unique segment medians
##   mnNow=unique(vecPred)
##   mnNow=mnNow[!is.na(mnNow)]

##   #continuing indicator otherwise get out of the loop
##   cont=0

##   while(cont==0 & length(mnNow)>1) {

##         mnNow=sort(mnNow)  #currennt sorted vector of means
##         n <- length(mnNow)  # number of means in mnNow

##         # Print current number of levels (n) if verbose is 2 or larger
##         if(verbose>=2){ cat("\r",n,":",length(unique(vecPred)),"\t")}

##         # Get distances translated to copy number differences
##         # Only distances to closest levels
##         if(scale){d<-(2*2^mnNow)[-n]-(2*2^mnNow)[-1]}
##         else{d<-(mnNow)[-n]-(mnNow)[-1]}

##         #order distance between means with the closest on top and corresponding indices
##         dst<-cbind(abs(d)[order(abs(d))],(2:n)[order(abs(d))],(1:(n-1))[order(abs(d))])

##         #for each pair of means
##         for (i in 1:nrow(dst))  {
##                 #set continuity index to "NOT continue" (=1)
##                 cont=1
##                 #test for combining of the two segment means
##                 out=combine.funcB(diff=dst[i,1],vecObs, vecPredNow, mnNow, mn1=mnNow[dst[i,2]], mn2=mnNow[dst[i,3]], pv.thres=pv.thres, thresAbs=if(scale){2*2^thresAbs-2}else{thresAbs})
##                 #if combine?
##                 if (out$pv > pv.thres) {

##                        #set continuity index to "YES" (=0) and break out of the current pairs loop
##                        cont=0

##                        #update predicted values and segments
##                        vecPredNow=out$vecPredNow
##                        mnNow=out$mnNow
##                        break
##                  }                
##           }               
##  }

## ### When done merging for a given threshold, test for significance ####
##         ansari[j]=ansari.test(sort(vecObs-vecPredNow), sort(vecObs-vecPred))$p.value
##   if(is.na(ansari[j])){ansari[j]=0} # If too many numbers for test to be performed, a 0 is returned, resulting in no merging (please use fixed threshold to get any merging)
##   lv[j]=length(mnNow) # get number of levels

## ### If backtracking flag=2, the merging is stopped at this thresMax (or fixed threshold) ###
##   if(flag==2){ break }

##   # If p.value is less than the significance threshold, set backtracking flag=1 (backtracking on)
##   if(ansari[j]<ansari.sign){
##                         flag=1
##   }

        
## ### If backtracking is on, a smaller threshold is attempted ####
##         if (flag){

##         # Stop if backtracking is on and p.value is higher than sign threshold or threshold is less or equal to thresMin
##         if (ansari[j]>ansari.sign | thresAbs == thresMin){

## #        # Don't merge at all if all tested threshold including thresMin is significant
## #                         if (ansari[j] <= ansari.sign) {
## #                                 vecPredNow=vecPred
## #                                 mnNow=unique(vecPred)
## #                                 mnNow=mnNow[!is.na(mnNow)]
## #                         }
                                                  
##         break
##         }

##       # Attempt smaller threshold
##         else {
##         thresAbs=signif(thresAbs-s.step,3)

##         # Set threshold to thresMin as a minimum
##         if (thresAbs <= thresMin){ thresAbs = thresMin }
##       }
##         }
        

## ### Increase threshold if backtracking is not on ###
##         else {thresAbs=thresAbs+l.step}

## #### Control step so function won't keep running, max threshold = thresMax and if sign not reached, threshold = thresMax ###
##           if (thresAbs >= thresMax){
##         thresAbs=thresMax
##                     flag=2
##           }

## } # End while


## # Return list of results
## return(list(vecMerged=vecPredNow,mnNow=mnNow,sq=sq,ansari=ansari))
## }












#################################

## was called by mergeLevelsB. No longer needed
## combine.funcB <- function(diff,vecObs, vecPredNow, mnNow, mn1, mn2, pv.thres=0.0001, thresAbs=0)
## { 
##   #observed values in the first segment
##         vec1=vecObs[which(vecPredNow==mn1)]
##   #observed values in the second segment
##         vec2=vecObs[which(vecPredNow==mn2)]
        
##   #if difference between segment medians does not exceed thresAbs, then set pv=1
##         if (diff<=thresAbs) {
##                 pv=1
##         }
##   #otherwise test for difference in mean based on observed values
##         else {
##                 if((length(vec1) > 10 & length(vec2) > 10) | sum(length(vec1),length(vec2))>100){
##                         pv=wilcox.test(vec1,vec2)$p.value
##                 }
##                 else{pv=wilcox.test(vec1,vec2,exact=TRUE)$p.value  }       #/10^max(mn1,mn2)
##                 if(length(vec1) <= 3 | length(vec2) <= 3){pv=0}         
##         }
##         index.merged<-numeric()
##   #if p-value exceeds pv.thres
##         if (pv > pv.thres)      {
##     #combine observed values
##                 vec=c(vec1,vec2)
##     # Index values to be updated
##                 index.merged=which((vecPredNow==mn1) | (vecPredNow==mn2))               
##     #update predicted values by median of the observed values
##                 vecPredNow[index.merged]=median(vec, na.rm=TRUE)
##     #update segment medians  median of the observed values and remove one of the duplicates
##                 mnNow[which((mnNow==mn1) | (mnNow==mn2))]=median(vec, na.rm=TRUE)
##                 mnNow=unique(mnNow)
##         }
##         list(mnNow=mnNow, vecPredNow=vecPredNow, pv=pv)
## }

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

  
  ## if(any(is.na(x)) | any(is.infinite(x)))
  ## Improved as per Duncan Murdoch's suggestion, email 2011-05-28
  if(any(is.na(x)) || any(is.infinite(x)) || any(is.nan(x)))
        stop("Either an NA or an infinite in the data: ",
             deparse(substitute(x)), ".\n",
             "   Eliminate those values or use imputation")
}


### Example of usage. Suppose we create missing values

## cghE1[1:10, 5:7] <- NA
## imputed.x <- my.impute.lowess(cghE1[1:40, 5:7], rep(1, 40))

## This function has not been used in years
## my.impute.lowess <- function (x,
##                               chrom.numeric,
##                               Clone = NULL,
##                               Pos = NULL,
##                               chrominfo = human.chrom.info.Jul03,
##                               maxChrom = 23,
##                               smooth = 0.1)
## {
##   ## BEWARE: Pos MUST be in kilobases!!!
##   if(is.null(Clone)) Clone <- 1:length(chrom.numeric)
##   if(is.null(Pos)) Pos <- Clone
##   aCGH.obj <- create.aCGH(data.frame(x),
##                           data.frame(Clone = Clone,
##                                      Chrom = chrom.numeric,
##                                      kb = Pos))
  
##     data.imp <- log2.ratios <- log2.ratios(aCGH.obj)
##     clones.info <- clones.info(aCGH.obj)
##     uniq.chrom <- unique(clones.info$Chrom)
##     for (j in uniq.chrom[uniq.chrom <= maxChrom]) {
##         cat("Processing chromosome ", j, "\n")
##         centr <- chrominfo$centromere[j]
##         indl <- which(clones.info$Chrom == j & clones.info$kb <
##             centr)
##         indr <- which(clones.info$Chrom == j & clones.info$kb >
##             centr)
##         kbl <- clones.info$kb[indl]
##         kbr <- clones.info$kb[indr]
##         for (i in 1:ncol(log2.ratios)) {
##             if (length(indl) > 0) {
##                 vecl <- log2.ratios[indl, i]
##                 ind <- which(!is.na(vecl))
##                 if (length(ind) > 1)
##                   data.imp[indl, i][-ind] <- approx(lowess(kbl[ind],
##                     vecl[ind], f = smooth), xout = kbl[-ind])$y
##             }
##             if (length(indr) > 0) {
##                 vecr <- log2.ratios[indr, i]
##                 ind <- which(!is.na(vecr))
##                 if (length(ind) > 0)
##                   data.imp[indr, i][-ind] <- approx(lowess(kbr[ind],
##                     vecr[ind], f = smooth), xout = kbr[-ind])$y
##             }
##         }
##     }
##     prop.miss <- apply(data.imp, 2, prop.na)
##     if (max(prop.miss, na.rm = TRUE) > 0) {
##         for (i in 1:ncol(data.imp)) {
##             vec <- data.imp[, i]
##             ind <- which(is.na(vec))
##             if (length(ind) > 0) {
##                 vec[ind] <- sapply(ind, function(i) {
##                   chr <- clones.info$Chrom[i]
##                   kb <- clones.info$kb[i]
##                   if (kb >= chrominfo$centromere[chr])
##                     median(vec[clones.info$Chrom == chr & clones.info$kb >=
##                       chrominfo$centromere[chr]], na.rm = TRUE)
##                   else median(vec[clones.info$Chrom == chr &
##                     clones.info$kb < chrominfo$centromere[chr]],
##                     na.rm = TRUE)
##                 })
##                 vec[is.na(vec)] <- 0
##                 data.imp[, i] <- vec
##             }
##         }
##     }
##     prop.miss <- apply(data.imp, 2, prop.na)
##     if (max(prop.miss) > 0)
##         print(paste("Missing values still remain in samples ",
##             which(prop.miss > 0)))
##     data.imp
## }


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


## my.usr2png <- function(xy, imWidth, imHeight) {
##     dev <- dev.cur()
##     xy <- fig2dev(plt2fig(usr2plt(xy,dev),dev),dev)
##     cbind(
##           ceiling(xy[,1]*imWidth),
##           ceiling((1-xy[,2])*imHeight)
##           )
## }




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








### For inputToADaCGH check what is better if eval((substitute or get(


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




## ## Passing data to the function called by mclapply.
## ## It turns out the two basic ways are similar in memory
## ## and speed. See this:

## f1 <- function(i, z) {
##   tmp <- sum(z[, i])
##   return(c(tmp, sum(gc()[, 6])))
## }



## f3 <- function(x) {
##   mclapply(1:4, f1, x, mc.cores = 4)
## }

## f4 <- function(x) {
##   finternal <- function(i) f1(i, x)
##   mclapply(1:4, finternal, mc.cores = 4)
## }

## f3(X)
## f4(X)


## Y <- matrix(rnorm(1e6), ncol = 4)
## YYY <- rbind(Y,Y,Y,Y,Y,Y,Y)
## YYYYY <- rbind(YYY, YYY, YYY, YYY, YYY, YYY, YYY,
##                YYY, YYY, YYY, YYY, YYY, YYY, YYY,
##                YYY, YYY, YYY, YYY, YYY, YYY, YYY,
##                YYY, YYY, YYY, YYY, YYY, YYY, YYY,
##                YYY, YYY, YYY, YYY, YYY, YYY, YYY,
##                YYY, YYY, YYY, YYY, YYY, YYY, YYY)


## object.size(YYY)/1e6
## object.size(YYYYY)/1e6


## f3(YYY)
## f4(YYY)

## f3(YYYYY)
## f4(YYYYY)

## ## This matters for how we use my distribute function:

## distribute0 <- function(type, ...) {
##   ## for cluster might need to transfer the objects
##   ## need to check if windows
##   if(type == "fork") {
##     mclapply(...,
##              mc.cores = detectCores())
##     ## and how about, so we do not pass anything else?
##     mclapply(list(...)[[1]],list(...)[[2]],
##              mc.cores = detectCores())
##   } else if(type == "cluster") {
##     clusterApply(NULL, ...)
##   } else stop("my.distribute does not know this type")
## }


## distribute <- function(type, X, FUN, ...) {
##   ## for cluster might need to transfer the objects
##   ## need to check if windows
##   if(type == "fork") {
##     mclapply(X, FUN, 
##              mc.cores = detectCores())
##   } else if(type == "cluster") {
##     ## we might need to do list(...)
##     clusterApply(NULL, X, FUN, ...)
##   } else stop("my.distribute does not know this type")
## }




### debugging stuff

## ii1.for.debug <- function(index, cghRDataName, mad.threshold,
##                 chromPos,
##                 W, rawI,
##                 breaksFdrQ,
##                 haarStartLevel,
##                 haarEndLevel,
##                 merging,
##                 ff.object) {
##   ## return(getwd())
##   ## return(cghRDataName)
##   return(namesff(cghRDataName))

##   ff.out <- ff.object ## for now, leave like this
##   if(ff.object) {
##     xvalue <- getCGHValue(cghRDataName, index)
##   } else {
##     xvalue <- cghRDataName[, index]
##   }
## ##  return(chromPos)

##   return(c(xvalue[1:5]))
##   crpos <- cbind(c(1, 219, 308, 396, 439), c(218, 307, 395, 438, 500))
##   crpos <- matrix(c(1,length(xvalue)),1,2)
## ##  crpos <- chromPos
##   return(crpos)
##   return(ad_HaarSeg(I = xvalue, W = W,
##                     rawI = rawI,
##                     chromPos = crpos,
## ##                    chromPos = crpos,
##                     breaksFdrQ = breaksFdrQ,
##                     haarStartLevel = haarStartLevel,
##                     haarEndLevel = haarEndLevel ))
##                         ## chromPos = chromPos))


  
##   ## return(ad_HaarSeg(I = xvalue))

##   ## return(list(I = xvalue,
##   ##                       chromPos = chromPos,
##   ##                       W = W, rawI = rawI,
##   ##                       breaksFdrQ = breaksFdrQ,
##   ##                       haarStartLevel = haarStartLevel,
##   ##                       haarEndLevel = haarEndLevel))
  
##   ## haarout <- ad_HaarSeg(I = xvalue,
##   ##                       chromPos = chromPos,
##   ##                       W = W, rawI = rawI,
##   ##                       breaksFdrQ = breaksFdrQ,
##   ##                       haarStartLevel = haarStartLevel,
##   ##                       haarEndLevel = haarEndLevel)[[2]]
  
##   return(99)
## }


## internalHaarSeg(1, mad.threshold = mad.threshold,
##                             cghRDataName = cghRDataName,
##                             chromPos,
##                             W, rawI,
##                             breaksFdrQ,
##                             haarStartLevel,
##                             haarEndLevel,
##                             merging,
##                             ff.object)

## cucu <- internalHaarSeg(3, cghRDataName, mad.threshold, chromRDataName, W, rawI, breaksFdrQ, haarStartLevel, haarStartLevel, merging, ff.object)


##   coco <- internalHaarSeg(51,
##                            mad.threshold = mad.threshold,
##                            cghRDataName = cghRDataName,
##                            chromPos,
##                            W, rawI,
##                            breaksFdrQ,
##                            haarStartLevel,
##                            haarEndLevel,
##                            merging,
##                            ff.object)
  
##   ## ## debug: use calls to lapply
##   ## ## use typeParall = cluster

##   ## ## browser()

##   coco2 <- lapply(1:14,
##                       internalHaarSeg,
##                   mad.threshold = mad.threshold,
##                       cghRDataName = cghRDataName,
##                       chromPos,
##                       W, rawI,
##                       breaksFdrQ,
##                       haarStartLevel,
##                       haarEndLevel,
##                       merging,
##                       ff.object)


##   ## coco2 <- lapply(1:narrays,
##   ##                     ii1,
##   ##                     cghRDataName = cghRDataName,
##   ##                 mad.threshold = mad.threshold,
##   ##                 chromPos = chromPos,
##   ##                     W, rawI,
##   ##                     breaksFdrQ,
##   ##                     haarStartLevel,
##   ##                     haarEndLevel,
##   ##                     merging,
##   ##                     ff.object)

  
##     coco3 <- mclapply(1:11,   ## 1:narrays,
##                      internalHaarSeg,
##                      mad.threshold = mad.threshold,
##                      cghRDataName = cghRDataName,
##                      chromPos,
##                      W, rawI,
##                      breaksFdrQ,
##                      haarStartLevel,
##                      haarEndLevel,
##                      merging,
##                      ff.object,
##                      mc.cores = 64) # detectCores())





## ii1.for.debug <- function(index, cghRDataName, mad.threshold,
##                 chromPos,
##                 W, rawI,
##                 breaksFdrQ,
##                 haarStartLevel,
##                 haarEndLevel,
##                 merging,
##                 ff.object) {
##    ff.out <- ff.object ## for now, leave like this

##    ## nmobj <- load(cghRDataName)
##    ## open(get(nmobj, inherits = FALSE), readonly = TRUE)

##    load(cghRDataName)
##    open(get("cghData", inherits = FALSE), readonly = TRUE)

## ##   load(cghRDataName)
## ##   nmobj <- load(cghRDataName)
## ##   open("cghData", readonly = TRUE)
   
##    ## tmp <- get(nmobj, inherits = FALSE)[, index]
##    ## return(tmp[1])
   
##   ## if(ff.object) {
##   ##   xvalue <- getCGHValue(cghRDataName, index)
##   ## } else {
##   ##   xvalue <- cghRDataName[, index]
##   ## }

 
##   ## haarout <- ad_HaarSeg(I = xvalue,
##   ##                       chromPos = chromPos,
##   ##                       W = W, rawI = rawI,
##   ##                       breaksFdrQ = breaksFdrQ,
##   ##                       haarStartLevel = haarStartLevel,
##   ##                       haarEndLevel = haarEndLevel)[[2]]



## ii2 <- function(index,
##                 cghRDataName,
##                 mad.threshold,
##                 chromRDataName,
##                 W, rawI,
##                 breaksFdrQ,
##                 haarStartLevel,
##                 haarEndLevel,
##                 merging,
##                 ff.object) {
  
##   ff.out <- ff.object ## for now, leave like this
##   if(ff.object) {
##     xvalue <- getCGHValue(cghRDataName, index)

##   } else {
##     xvalue <- cghRDataName[, index]
##   } ## up to here, we are OK

##   cleanDataList <- expungeNA(xvalue)
##   ## up to here, we are OK
##    xvalue <- cleanDataList$x_clean

##   rle.chr <- intrle(as.integer(chromRDataName[cleanDataList$pos_clean]))

##   chr.end <- cumsum(rle.chr$lengths)
##   chr.start <- c(1, chr.end[-length(chr.end)] + 1)
##   chromPos <- cbind(chr.start, chr.end)
##   rm(rle.chr)
##   haarout <- local(ad_HaarSeg(I = xvalue,
##                               chromPos = chromPos,
##                               W = W, rawI = rawI,
##                               breaksFdrQ = breaksFdrQ,
##                               haarStartLevel = haarStartLevel,
##                               haarEndLevel = haarEndLevel)[[2]])
##   rm(chr.end)
##   rm(chr.start)
##   rm(chromPos)
##   gc()
  
  
##   mad.subj <- median(abs(xvalue - haarout))/0.6745
##   rm(xvalue)
##   thresh <- mad.threshold * mad.subj
##   ## nodeWhere("internalHaarSeg")
  
##   haarout <- local(inpungeNA(haarout,
##                              cleanDataList$lx,
##                              cleanDataList$pos_clean,
##                              cleanDataList$nas))
  
##   rm(cleanDataList)
##   gc()
  
##   state <- local(ifelse( (abs(haarout) > thresh), 1, 0) *
##     sign(haarout))
  
##   ## if (ff.out) {
##   ##   gc()
##   ##   return(ffListOut(haarout, state))
    
##   ## } else {
##     gc()
##     return(list(smoothed = haarout,
##                 state = as.integer(state)))
##   ## }
## }


## ii2 <- internalHaarSeg


## coco4 <- distribute(type = typeParall,
##                     mc.cores = mc.cores,
##                     1:narrays,
##                     ii2,
##                     cghRDataName = cghRDataName,
##                     mad.threshold = mad.threshold,
##                     chromRDataName = chromRDataName,
##                     W, rawI,
##                     breaksFdrQ,
##                     haarStartLevel,
##                     haarEndLevel,
##                     merging,
##                     ff.object)

## coco3a <- mclapply(1:75,   ## 1:narrays,
##                   ii2,
##                   cghRDataName = cghRDataName,
##                   mad.threshold = mad.threshold,
##                   chromRDataName = chromRDataName,
##                   W, rawI,
##                   breaksFdrQ,
##                   haarStartLevel,
##                   haarEndLevel,
##                   merging,
##                   ff.object,
##                   mc.cores = 64)

## coco3b <- mclapply(36:70,   ## 1:narrays,
##                   ii2,
##                   cghRDataName = cghRDataName,
##                   mad.threshold = mad.threshold,
##                   chromRDataName = chromRDataName,
##                   W, rawI,
##                   breaksFdrQ,
##                   haarStartLevel,
##                   haarEndLevel,
##                   merging,
##                   ff.object,
##                   mc.cores = 64)

## coco3c <- mclapply(71:100,   ## 1:narrays,
##                   ii2,
##                   cghRDataName = cghRDataName,
##                   mad.threshold = mad.threshold,
##                   chromRDataName = chromRDataName,
##                   W, rawI,
##                   breaksFdrQ,
##                   haarStartLevel,
##                   haarEndLevel,
##                   merging,
##                   ff.object,
##                   mc.cores = 64)

## coco3d <- mclapply(101:136,   ## 1:narrays,
##                   ii2,
##                   cghRDataName = cghRDataName,
##                   mad.threshold = mad.threshold,
##                   chromRDataName = chromRDataName,
##                   W, rawI,
##                   breaksFdrQ,
##                   haarStartLevel,
##                   haarEndLevel,
##                   merging,
##                   ff.object,
##                   mc.cores = 64)
## coco3e <- mclapply(137:170,   ## 1:narrays,
##                   ii2,
##                   cghRDataName = cghRDataName,
##                   mad.threshold = mad.threshold,
##                   chromRDataName = chromRDataName,
##                   W, rawI,
##                   breaksFdrQ,
##                   haarStartLevel,
##                   haarEndLevel,
##                   merging,
##                   ff.object,
##                   mc.cores = 64)
## coco3f <- mclapply(171:200,   ## 1:narrays,
##                   ii2,
##                   cghRDataName = cghRDataName,
##                   mad.threshold = mad.threshold,
##                   chromRDataName = chromRDataName,
##                   W, rawI,
##                   breaksFdrQ,
##                   haarStartLevel,
##                   haarEndLevel,
##                   merging,
##                   ff.object,
##                   mc.cores = 64)








  ## coco4 <- clusterApply(NULL, 1:14, ##1:narrays,
  ##                    internalHaarSeg,
  ##                    mad.threshold = mad.threshold,
  ##                    cghRDataName = cghRDataName,
  ##                    chromPos,
  ##                    W, rawI,
  ##                    breaksFdrQ,
  ##                    haarStartLevel,
  ##                    haarEndLevel,
  ##                    merging,
  ##                    ff.object)


  ## coco4 <- clusterApply(NULL,1:narrays,
  ##                       ii1.for.debug,
  ##                       cghRDataName = cghRDataName,
  ##                       mad.threshold = mad.threshold,
  ##                       chromPos = chromPos,
  ##                       W, rawI,
  ##                       breaksFdrQ,
  ##                       haarStartLevel,
  ##                       haarEndLevel,
  ##                       merging,
  ##                       ff.object)

  
  ##   coco5 <- parLapply(cl2,1:narrays,
  ##                    ii1,
  ##                    mad.threshold = mad.threshold,
  ##                    cghRDataName = cghRDataName,
  ##                    chromPos,
  ##                    W, rawI,
  ##                    breaksFdrQ,
  ##                    haarStartLevel,
  ##                    haarEndLevel,
  ##                    merging,
  ##                    ff.object)
  

## oo <- distribute2(type = typeParall,
##                       mc.cores = mc.cores,
##                       1:narrays,
##                       internalHaarSeg,
##                       mad.threshold = mad.threshold,
##                       cghRDataName = cghRDataName,
##                       chromPos,
##                       W, rawI,
##                       breaksFdrQ,
##                       haarStartLevel,
##                       haarEndLevel,
##                       merging,
##                       ff.object)


## converting all; change 4 by something else.
## for i in {4..6}; do cut -f$i inputEx.txt > col_$i.txt; done
## of course, cut can be run in parallel to break the 1000 cols file.



## data.500 <- matrix(1.1, nrow = 3*10^6, ncol = 500)
## print(object.size(data.500), units = "Mb")

## f1 <- function(index, data) {
##   x <- data[, index]
##   u <- 2 * x
##   return(u)
## }

## ## fails
## tmp1 <- mclapply(1:500, f1, data.500,
##                  mc.cores = detectCores())

## ## works
## tmp1a <- mclapply(1:100, f1, data.500,
##                  mc.cores = detectCores())
## tmp1b <- mclapply(101:200, f1, data.500,
##                  mc.cores = detectCores())
## tmp1c <- mclapply(201:300, f1, data.500,
##                  mc.cores = detectCores())
## tmp1d <- mclapply(301:400, f1, data.500,
##                  mc.cores = detectCores())
## tmp1e <- mclapply(401:500, f1, data.500,
##                  mc.cores = detectCores())







## library(parallel)

## # data.500 <- matrix(1.1, nrow = 3*10^6, ncol = 500)
## data.1000 <- matrix(1.1, nrow = 2*10^6, ncol = 1000)

## ## print(object.size(data.500), units = "Mb")
## print(object.size(data.1000), units = "Mb")

## f1 <- function(index, data) {
##   x <- data[, index]
##   z <- 3 * x
##   z2 <- 4 * z
##   z3 <- 9 * z
##   v <- 4 * x
##   u <- 2 * x
##   return(cbind(u, v))
## }

## tmp1 <- mclapply(1:1000, f1, data.1000,
##                  mc.cores = detectCores())




## data.320 <- matrix(seq(from = 1.1, to = (6*10^6 * 320) + .1), ncol = 320)

## ## print(object.size(data.500), units = "Mb")
## print(object.size(data.320), units = "Mb")

## f1 <- function(index, data) {
##   x <- data[, index]
##   ## keep them busy, and have them use memory
##   z <- runif(length(x))
##   z2 <- exp(z)
##   z3 <- log10(x)
##   z4 <- runif(length(x))
##   z5 <- exp(z4)
##   z6 <- log(z5)
##   z7 <- runif(length(x))
##   z8 <- exp(z7)
##   z9 <- log(z8)
  
##   v <- rnorm(length(x))
##   u <- log(x)
  
##   return(cbind(u, v))
## }

## tmp1 <- mclapply(1:320, f1, data.320,
##                  mc.cores = 64)

## tmpa <- mclapply(1:100, f1, data.320,
##                  mc.cores = 64)
## tmpb <- mclapply(101:200, f1, data.320,
##                  mc.cores = 64)
## tmpc <- mclapply(201:320, f1, data.320,
##                  mc.cores = 64)






### Getting all to do something in cluster
## x <- matrix(1.1, nrow = 20000, ncol = 10000)

## f2 <- function(index, data) {
##   x1 <- data[, index]
##   x2 <- runif(length(x1))
##   x3 <- 10 * x1 + x2
##   x4 <- exp(x3)
##   x5 <- log(x4)
##   x6 <- x3 + x4 + x5
##   x7 <- rnorm(length(x1))
##   x2 <- runif(length(x1))
##   x3 <- 10 * x1 + x2
##   x4 <- exp(x3)
##   x5 <- log(x4)
##   x6 <- x3 + x4 + x5
##   x7 <- rnorm(length(x1))
##   x2 <- runif(length(x1))
##   x3 <- 10 * x1 + x2
##   x4 <- exp(x3)
##   x5 <- log(x4)
##   x6 <- x3 + x4 + x5
##   x7 <- rnorm(length(x1))
##   return(log(x3))
## }

## unix.time(tmp <- mclapply(1:10000, f2, x, mc.cores = 64 ))

## unix.time(tmp <- mclapply(1:10000, f2, x, mc.cores = 10 )) 

## Note: VanLoo et al., 2010, use a variant of CGHexplorer.



### Geting the lines with NAs in the text files
## sed -n '/pattern/=' filename
## awk '/textstring/ {print FNR}' textfile


## tests for noNA:
## - when running the data with NA and the option noNA it should fail

## - when running the data without NA and the option noNA should not fail

## - when running the data without NA and option noNA should not fail and
##    be identical to above.

## Prepare directories with ff files
