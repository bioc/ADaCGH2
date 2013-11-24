### R code from vignette source '/home/ramon/Proyectos/ADaCGH2-devel/ADaCGH2/inst/sources-tex-Rnw-other/ADaCGH2-long-examples.Rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: ADaCGH2-long-examples.Rnw:112-113
###################################################
try(setwd("~/tmp"))


###################################################
### code chunk number 2: ADaCGH2-long-examples.Rnw:116-156
###################################################
library(ADaCGH2)
 
## loading in-RAM objects
data(inputEx)
summary(inputEx)
head(inputEx)
cgh.dat <- inputEx[, -c(1, 2, 3)]
chrom.dat <- as.integer(inputEx[, 2])
pos.dat <- inputEx[, 3]


## choosing working dir for cluster
originalDir <- getwd()
if(!file.exists("ADaCGH2_vignette_tmp_dir"))
  dir.create("ADaCGH2_vignette_tmp_dir")
setwd("ADaCGH2_vignette_tmp_dir")

## creating ff objects
fnameRdata <- list.files(path = system.file("data", package = "ADaCGH2"),
                     full.names = TRUE, pattern = "inputEx.RData")
inputToADaCGH(ff.or.RAM = "ff",
                      RDatafilename = fnameRdata)

## setting random number generator for forking
RNGkind("L'Ecuyer-CMRG")

## initializing cluster and setting up random number generator
number.of.nodes <- detectCores()
cl2 <- parallel::makeCluster(number.of.nodes,"PSOCK")
parallel::clusterSetRNGStream(cl2)
parallel::setDefaultCluster(cl2) 
parallel::clusterEvalQ(NULL, library("ADaCGH2"))
## verify we are using the right version of ADaCGH2
parallel::clusterEvalQ(NULL, 
                       library(help = ADaCGH2)$info[[1]][[2]])

wdir <- getwd()
parallel::clusterExport(NULL, "wdir")
parallel::clusterEvalQ(NULL, setwd(wdir))



###################################################
### code chunk number 3: ADaCGH2-long-examples.Rnw:181-232
###################################################
cbs.mergel.RAM.fork <- pSegmentDNAcopy(cgh.dat, chrom.dat, 
                                            merging = "mergeLevels")
cbs.mad.RAM.fork <- pSegmentDNAcopy(cgh.dat, chrom.dat,merging = "MAD")
cbs.none.RAM.fork <- pSegmentDNAcopy(cgh.dat, chrom.dat, merging = "none")

hmm.mergel.RAM.fork <- pSegmentHMM(cgh.dat, chrom.dat, merging = "mergeLevels")
hmm.mad.RAM.fork <- pSegmentHMM(cgh.dat, chrom.dat, merging = "MAD")

hs.mergel.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat, 
                             merging = "mergeLevels")
hs.mad.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat, 
                             merging = "MAD")
hs.none.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat, 
                             merging = "none")

glad.RAM.fork <- pSegmentGLAD(cgh.dat, chrom.dat)

biohmm.mergel.RAM.fork <- pSegmentBioHMM(cgh.dat,
                                chrom.dat,
                                pos.dat,
                                merging = "mergeLevels")
biohmm.mad.RAM.fork <- pSegmentBioHMM(cgh.dat,
                                        chrom.dat,
                                        pos.dat,
                                        merging = "MAD")
biohmm.mad.bic.RAM.fork <- pSegmentBioHMM(cgh.dat,
                                            chrom.dat,
                                            pos.dat,
                                            merging = "MAD",
                                            aic.or.bic = "BIC")

cghseg.mergel.RAM.fork <- pSegmentCGHseg(cgh.dat,
                                          chrom.dat,
                                          merging = "mergeLevels")

cghseg.mad.RAM.fork <- pSegmentCGHseg(cgh.dat,
                                        chrom.dat,
                                        merging = "MAD")

cghseg.none.RAM.fork <- pSegmentCGHseg(cgh.dat,
                                         chrom.dat,
                                         merging = "none")


waves.mergel.RAM.fork <- pSegmentWavelets(cgh.dat,
                           chrom.dat, merging = "mergeLevels")
waves.mad.RAM.fork <- pSegmentWavelets(cgh.dat,
                                         chrom.dat, merging = "MAD")
waves.none.RAM.fork <- pSegmentWavelets(cgh.dat,
                                          chrom.dat, merging = "none")



###################################################
### code chunk number 4: ADaCGH2-long-examples.Rnw:254-332
###################################################

cbs.mergel.ff.cluster <- pSegmentDNAcopy("cghData.RData", "chromData.RData", 
                                  merging = "mergeLevels",
                                  typeParall = "cluster")
cbs.mad.ff.cluster <- pSegmentDNAcopy("cghData.RData", "chromData.RData",
                                      merging = "MAD",
                                      typeParall = "cluster")
cbs.none.ff.cluster <- pSegmentDNAcopy("cghData.RData", "chromData.RData", 
                                       merging = "none", 
                                       typeParall = "cluster")

hmm.mergel.ff.cluster <- pSegmentHMM("cghData.RData", "chromData.RData", 
                              merging = "mergeLevels", 
                              typeParall = "cluster")
hmm.mad.ff.cluster <- pSegmentHMM("cghData.RData", "chromData.RData", 
                                  merging = "MAD", 
                                  typeParall = "cluster")


hs.mergel.ff.cluster <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "mergeLevels", 
                                    typeParall = "cluster")
hs.mad.ff.cluster <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "MAD", typeParall = "cluster")
hs.none.ff.cluster <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "none", typeParall = "cluster")


glad.ff.cluster <- pSegmentGLAD("cghData.RData", "chromData.RData", 
                                typeParall = "cluster")


biohmm.mergel.ff.cluster <- pSegmentBioHMM("cghData.RData",
                                "chromData.RData",
                                "posData.RData",
                                merging = "mergeLevels", 
                                    typeParall = "cluster")
biohmm.mad.ff.cluster <- pSegmentBioHMM("cghData.RData",
                                        "chromData.RData",
                                        "posData.RData",
                                        merging = "MAD", 
                                        typeParall = "cluster")
biohmm.mad.bic.ff.cluster <- pSegmentBioHMM("cghData.RData",
                                            "chromData.RData",
                                            "posData.RData",
                                            merging = "MAD",
                                            aic.or.bic = "BIC", 
                                            typeParall = "cluster")

cghseg.mergel.ff.cluster <- pSegmentCGHseg("cghData.RData",
                                          "chromData.RData",
                                          merging = "mergeLevels", 
                                          typeParall = "cluster")

cghseg.mad.ff.cluster <- pSegmentCGHseg("cghData.RData",
                                        "chromData.RData",
                                        merging = "MAD", 
                                        typeParall = "cluster")

cghseg.none.ff.cluster <- pSegmentCGHseg("cghData.RData",
                                         "chromData.RData",
                                         merging = "none", 
                                         typeParall = "cluster")


waves.mergel.ff.cluster <- pSegmentWavelets("cghData.RData",
                                           "chromData.RData", 
                                           merging = "mergeLevels", 
                                           typeParall = "cluster")
waves.mad.ff.cluster <- pSegmentWavelets("cghData.RData",
                                         "chromData.RData", 
                                         merging = "MAD", 
                                         typeParall = "cluster")
waves.none.ff.cluster <- pSegmentWavelets("cghData.RData",
                                          "chromData.RData", 
                                          merging = "none", 
                                          typeParall = "cluster")



###################################################
### code chunk number 5: ADaCGH2-long-examples.Rnw:352-425
###################################################

cbs.mergel.ff.fork <- pSegmentDNAcopy("cghData.RData", "chromData.RData", 
                                      merging = "mergeLevels",
                                  typeParall = "fork")
cbs.mad.ff.fork <- pSegmentDNAcopy("cghData.RData", "chromData.RData",
                                   merging = "MAD",
                                      typeParall = "fork")
cbs.none.ff.fork <- pSegmentDNAcopy("cghData.RData", "chromData.RData", 
                                    merging = "none", typeParall = "fork")

hmm.mergel.ff.fork <- pSegmentHMM("cghData.RData", "chromData.RData", 
                           merging = "mergeLevels", typeParall = "fork")

hmm.mad.ff.fork <- pSegmentHMM("cghData.RData", "chromData.RData", 
                               merging = "MAD", typeParall = "fork")


hs.mergel.ff.fork <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "mergeLevels", typeParall = "fork")
hs.mad.ff.fork <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "MAD", typeParall = "fork")
hs.none.ff.fork <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "none", typeParall = "fork")

glad.ff.fork <- pSegmentGLAD("cghData.RData", "chromData.RData", 
                             typeParall = "fork")


biohmm.mergel.ff.fork <- pSegmentBioHMM("cghData.RData",
                                "chromData.RData",
                                "posData.RData",
                                merging = "mergeLevels", 
                                 typeParall = "fork")
biohmm.mad.ff.fork <- pSegmentBioHMM("cghData.RData",
                                        "chromData.RData",
                                        "posData.RData",
                                        merging = "MAD", 
                                     typeParall = "fork")
biohmm.mad.bic.ff.fork <- pSegmentBioHMM("cghData.RData",
                                            "chromData.RData",
                                            "posData.RData",
                                            merging = "MAD",
                                            aic.or.bic = "BIC", 
                                         typeParall = "fork")

cghseg.mergel.ff.fork <- pSegmentCGHseg("cghData.RData",
                                          "chromData.RData",
                                          merging = "mergeLevels", 
                                       typeParall = "fork")

cghseg.mad.ff.fork <- pSegmentCGHseg("cghData.RData",
                                        "chromData.RData",
                                        merging = "MAD", typeParall = "fork")

cghseg.none.ff.fork <- pSegmentCGHseg("cghData.RData",
                                         "chromData.RData",
                                         merging = "none", typeParall = "fork")


waves.merge.ff.fork <- pSegmentWavelets("cghData.RData",
                                        "chromData.RData", 
                                        merging = "mergeLevels", 
                                        typeParall = "fork")
waves.mad.ff.fork <- pSegmentWavelets("cghData.RData",
                                         "chromData.RData", 
                                      merging = "MAD", 
                                      typeParall = "fork")
waves.none.ff.fork <- pSegmentWavelets("cghData.RData",
                                       "chromData.RData", 
                                       merging = "none", 
                                       typeParall = "fork")




###################################################
### code chunk number 6: ADaCGH2-long-examples.Rnw:443-444
###################################################
ff.cluster.obj <- ls(pattern = "*.ff.cluster")


###################################################
### code chunk number 7: ADaCGH2-long-examples.Rnw:448-452
###################################################
tmpout <- 
  capture.output(
    lapply(ff.cluster.obj, function(x) lapply(get(x), open))
    )


###################################################
### code chunk number 8: ADaCGH2-long-examples.Rnw:458-464
###################################################
ff.fork.obj <- ls(pattern = "*.ff.fork")
tmpout <- 
  capture.output(
    lapply(ff.fork.obj, function(x) lapply(get(x), open))
    )



###################################################
### code chunk number 9: ADaCGH2-long-examples.Rnw:472-473
###################################################
RAM.fork.obj <- ls(pattern = "*.RAM.fork")


###################################################
### code chunk number 10: ADaCGH2-long-examples.Rnw:534-552
###################################################
identical3 <- function(x, y, z) {
  comp1 <- all.equal(get(x)$outSmoothed[ , ], get(y)$outSmoothed[ , ])
  comp2 <- all.equal(get(y)$outSmoothed[ , ], get(z)$outSmoothed[ , ])
  comp3 <- identical(get(x)$outState[ , ], get(y)$outState[ , ])
  comp4 <- identical(get(y)$outState[ , ], get(z)$outState[ , ])  
  if (!all(isTRUE(comp1), isTRUE(comp2), comp3, comp4)) {
    cat(paste("Comparing ", x, y, z, "\n",
          "not equal: some info from comparisons.\n",
              "\n comp1 = ", paste(comp1, sep = " ", collapse = "\n    "),
              "\n comp2 = ", paste(comp2, sep = " ", collapse = "\n    "),
              "\n comp3 = ", paste(comp3, sep = " ", collapse = "\n    "),
              "\n comp4 = ", paste(comp4, sep = " ", collapse = "\n    "),
              "\n\n"))
    return(FALSE)
  } else {
    TRUE
  }
}


###################################################
### code chunk number 11: ADaCGH2-long-examples.Rnw:582-585
###################################################
mapply(identical3, RAM.fork.obj, 
           ff.fork.obj, ff.cluster.obj)



###################################################
### code chunk number 12: ADaCGH2-long-examples.Rnw:651-708
###################################################
hs.none.RAM.fork <- pSegmentHaarSeg(cgh.dat, chrom.dat, 
                             merging = "none")
hs.none.RAM.fork.lb <- pSegmentHaarSeg(cgh.dat, chrom.dat, 
                             merging = "none", loadBalance = TRUE)
hs.none.RAM.fork.nlb <- pSegmentHaarSeg(cgh.dat, chrom.dat, 
                             merging = "none", loadBalance = FALSE)
identical3("hs.none.RAM.fork", "hs.none.RAM.fork.lb", "hs.none.RAM.fork.nlb")


hs.none.ff.cluster <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                                      merging = "none", typeParall = "cluster")
hs.none.ff.cluster.lb <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                                      merging = "none", typeParall = "cluster",
                                      loadBalance = TRUE)
hs.none.ff.cluster.nlb <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                                      merging = "none", typeParall = "cluster",
                                      loadBalance = FALSE)
## do not show all the opening ... messages
tmpout <- 
  capture.output(
    lapply("hs.none.ff.cluster", function(x) lapply(get(x), open))
    )
tmpout <- 
  capture.output(
    lapply("hs.none.ff.cluster.lb", function(x) lapply(get(x), open))
    )
tmpout <- 
  capture.output(
    lapply("hs.none.ff.cluster.nlb", function(x) lapply(get(x), open))
    )

identical3("hs.none.ff.cluster", "hs.none.ff.cluster.lb", 
           "hs.none.ff.cluster.nlb")


hs.none.ff.fork <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                             merging = "none", typeParall = "fork")
hs.none.ff.fork.lb <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                                   merging = "none", typeParall = "fork",
                                   loadBalance = TRUE)
hs.none.ff.fork.nlb <- pSegmentHaarSeg("cghData.RData", "chromData.RData", 
                                   merging = "none", typeParall = "fork",
                                   loadBalance = FALSE)
tmpout <- 
  capture.output(
    lapply("hs.none.ff.fork", function(x) lapply(get(x), open))
    )
tmpout <- 
  capture.output(
    lapply("hs.none.ff.fork.lb", function(x) lapply(get(x), open))
    )
tmpout <- 
  capture.output(
    lapply("hs.none.ff.fork.nlb", function(x) lapply(get(x), open))
    )
identical3("hs.none.ff.fork", "hs.none.ff.fork.lb", "hs.none.ff.fork.nlb")



###################################################
### code chunk number 13: ADaCGH2-long-examples.Rnw:731-732
###################################################
parallel::stopCluster(cl2)


###################################################
### code chunk number 14: ADaCGH2-long-examples.Rnw:735-765 (eval = FALSE)
###################################################
## ## This is the code to remove all the files we created
## ## and the temporary directory.
## ## We are not executing it!
## 
## load("chromData.RData")
## load("posData.RData")
## load("cghData.RData")
## 
## delete(cghData); rm(cghData)
## delete(posData); rm(posData)
## delete(chromData); rm(chromData)
## 
## tmpout <- 
##   capture.output(
##     lapply(ff.fork.obj, function(x) {
##       lapply(get(x), delete)}))
## 
## rm(list = ff.fork.obj)
## 
## tmpout <- 
##   capture.output(
##     lapply(ff.cluster.obj, function(x) {
##       lapply(get(x), delete)}))
## rm(list = ff.cluster.obj)
## 
## setwd(originalDir)
## print(getwd())
## Sys.sleep(3)
## unlink("ADaCGH2_vignette_tmp_dir", recursive = TRUE)
## Sys.sleep(3)


