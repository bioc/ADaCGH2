## Here, we include min.ff and max.ff, and additional needed code
## from ffbase.
## https://github.com/edwindj/ffbase

## On 2022-04-04, ffbase was removed from the CRAN repository: 
##   https://cran.r-project.org/web/packages/ffbase/index.html

## From the DESCRIPTION file of ffbase
## (https://github.com/edwindj/ffbase/blob/master/pkg/DESCRIPTION)

## Package: ffbase
## Maintainer: Edwin de Jonge <edwindjonge@gmail.com>
## License: GPL-3
## Title: Basic Statistical Functions for Package 'ff'
## Type: Package
## LazyLoad: yes
## Author: Edwin de Jonge, Jan Wijffels, Jan van der Laan
## Description: Extends the out of memory vectors of 'ff' with
##     statistical functions and other utilities to ease their usage.
## Version: 0.13.2
## URL: https://github.com/edwindj/ffbase

## ffbase is, thus, licensed under GPL-3 and thus its code
## can be combined with the code of ADaCGH2.

## From file auxilary.R
checkRange <- function(range, x){
    
    if (is.null(range)){
       return(ri(1,length(x)))
    }
     
    #TODO add checks
    range
}



## From file Summary_ff.R

## #' Minimum, maximum and range of ff vector
## #'
## #' default behaviour of \code{\link{min}},\code{\link{max}} and \code{\link{range}}
## #' @method min ff
## #' @method max ff
## #' @method range ff
## #' @example ../examples/minmaxrange.R
## #' @export
## #' @export min.ff
## #' @aliases min.ff max.ff range.ff
## #' @param x a \code{ff} object
## #' @param ... optional other (\code{ff}) objects
## #' @param na.rm should \code{NA} be removed?
## #' @param range a \code{ri} or an \code{integer} vector of \code{length==2} giving a range restriction for chunked processing
## #' @return minimun, maximum or range values
min.ff <- function(x, ..., na.rm=FALSE, range=NULL){
   r <- checkRange(range, x)
   
	min( ...    #for all other ff's?
      , sapply( chunk(x, from=min(r), to=max(r))
	           , function(i){
                  #print(x[i])
                  min(x[i], na.rm=na.rm)
	             }
	           )
	   )
}

## #' @export
## #' @export max.ff
max.ff <- function(x, ..., na.rm=FALSE, range=NULL){
   r <- checkRange(range, x)
   
	max( ...    #for all other ff's?
      , sapply( chunk(x, from=min(r), to=max(r))
	           , function(i){
                  max(x[i], na.rm=na.rm)
	             }
	           )
	   )
}

## ## #' @export
## ## #' @export range.ff
## range.ff <- function(x, ..., na.rm=FALSE, range=NULL){
##   r <- checkRange(range, x)
## 	range( ...    #for all other ff's?
##       , sapply( chunk(x, from=min(r), to=max(r))
## 	           , function(i){
##                   #print(x[i])
##                   range(x[i], na.rm=na.rm)
## 	             }
## 	           )
## 	   )
## }
