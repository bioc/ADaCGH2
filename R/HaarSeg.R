### Code from version Version 1.0. June, 2008.
### Downloaded from http://www.ee.technion.ac.il/people/YoninaEldar/Info/software/HaarSeg.htm
### I (RDU) rename all C functions to "ad_" to avoid ambiguities
### I do the same with the R functions. Yes, not needed since in namespace
### but I want to avoid mistakes from casually inspecting the functions.




 # HaarSeg performs segmentation according to the HaarSeg algorithm. 
 # This is the main segmentation script.
 # This script includes several optional extentions, supporting weights 
 # (also known as quality of measurments) and raw measurments
 # 
 # Input:
 # I:  a single array of log(R/G) measurments, sorted according to their genomic location.
 # W:  Weight matrix, corresponding to quality of measurment. 
 #     Insert 1/(sigma^2) as weights if your platform output sigma as
 #     the quality of measurment. W must have the same size as I.
 # rawI: Mininum of the raw red and raw green measurment, before the log.
 #      rawI is used for the non-stationary variance compensation. 
 #      rawI must have the same size as I. 
 # chromPos: A matrix of two columns. The first column is the start index 
 #      of each chromosome. The second column is the end index of each chromosome.
 # breaksFdrQ: The FDR q parameter. Common used values are 0.05, 0.01, 0.001.
 #      Default value is 0.001.
 # haarStartLevel: The detail subband from which we start to detect peaks. The higher
 #      this value is, the less sensitive we are to short segments. 
 #      The default is value is 1, corresponding to segments of 2 probes.
 # haarEndLevel: The detail subband until which we use to detect peaks. The higher
 #      this value is, the more sensitive we are to large trends in the data. This value
 #      DOES NOT indicate the largest possible segment that can be detected.
 #      The default is value is 5, corresponding to step of 32 probes in each direction.
 #
 # Output:
 # a list containing two objects:
 # output$SegmentsTable : Segments result table: | segment start index | segment size | segment value |
 # output$Segmented : The complete segmented signal (same size as I).
 #
ad_HaarSeg <- function(I, 
                       W = vector(),
                       rawI = vector(), 
                       chromPos = matrix(c(1,length(I)),1,2),
                       breaksFdrQ = 0.001,			  
                       haarStartLevel = 1,
                       haarEndLevel = 5)
{

ProbeNum = length(I);
weightsFlag = length(W);
nsvFlag = length(rawI);

if (nsvFlag) {
  # non stationary variance empirical threshold set to 50
  NSV_TH = 50;
  varMask = (rawI < NSV_TH);
}

S = I;
allSt = vector();
allSize = vector();
allVal = vector();
CFun = .C("ad_rConvAndPeak", 
		as.double(I), 
  	as.integer(ProbeNum), 
		as.integer(1), 
		convResult = double(ProbeNum), 
		peakLoc = integer(ProbeNum) );
diffI = CFun$convResult;
if (nsvFlag) {
  pulseSize = 2;
  CFun = .C("ad_rPulseConv",
            as.double(varMask),
					  as.integer(ProbeNum),
					  as.integer(pulseSize),
 					  as.double(1/pulseSize),
					  res = double(ProbeNum));
  diffMask = (CFun$res >= 0.5);

  peakSigmaEst = median(abs(diffI[!diffMask])) / 0.6745;
  noisySigmaEst = median(abs(diffI[diffMask])) / 0.6745;
  
  if (is.na(peakSigmaEst)) {  peakSigmaEst = 0; }
  if (is.na(noisySigmaEst)) {  noisySigmaEst = 0; }  
} else {
  peakSigmaEst = median(abs(diffI)) / 0.6745;
}

# segmentation is done on each chromosome seperatly
for (chr in 1:nrow(chromPos)) {
	y = I[chromPos[chr,1]:chromPos[chr,2]];
  if (nsvFlag) {
    yVarMask = varMask[chromPos[chr,1]:chromPos[chr,2]];
  }
  if (weightsFlag) {
    wei = W[chromPos[chr,1]:chromPos[chr,2]];
  }
	uniPeakLoc = as.integer(-1);
	for (level in haarStartLevel:haarEndLevel) {
		stepHalfSize = 2^(level);
    if (weightsFlag) {
     	CFun = .C("ad_rWConvAndPeak",
            as.double(y),
				    as.double(wei),
					  as.integer(length(y)),
					  as.integer(stepHalfSize),
					  convResult = double(length(y)),
					  peakLoc = integer(length(y)) );
   	} else {
      CFun = .C("ad_rConvAndPeak",
					  as.double(y),
					  as.integer(length(y)),
					  as.integer(stepHalfSize),
					  convResult = double(length(y)),
					  peakLoc = integer(length(y)) );
    }
    convRes = CFun$convResult;
    peakLocForC = CFun$peakLoc;
    peakLoc = peakLocForC[1:match(-1,peakLocForC)-1]+1;

		if (nsvFlag) {
      pulseSize = 2*stepHalfSize;
      CFun = .C("ad_rPulseConv",
            as.double(yVarMask),
					  as.integer(length(yVarMask)),
					  as.integer(pulseSize),
 					  as.double(1/pulseSize),
					  res = double(length(yVarMask)));
      convMask = as.double(CFun$res >= 0.5);
      sigmaEst = (1-convMask)*peakSigmaEst + convMask*noisySigmaEst;
      T = ad_FDRThres(convRes[peakLoc] / sigmaEst[peakLoc], breaksFdrQ, 1);
		} else {
		  T = ad_FDRThres(convRes[peakLoc], breaksFdrQ, peakSigmaEst);
		}

	  unifyWin = as.integer(2^(level - 1));
    tmpPeakLoc = uniPeakLoc;

    if (nsvFlag) {
      convRes = convRes / sigmaEst;
    } 
 		CThres <- .C("ad_rThresAndUnify", 
  					as.double(convRes), 
  					as.integer(length(y)), 
  					peakLocForC,
  					tmpPeakLoc,
  					as.double(T),
  					as.integer(unifyWin),
  					uniPeakLoc = integer(length(y)) );
		uniPeakLoc = CThres$uniPeakLoc;
	}# for level
	breakpoints = uniPeakLoc[1:match(-1,uniPeakLoc)-1] + 1;
	
	if (weightsFlag) {
		segs = ad_SegmentByPeaks(y, breakpoints, wei);
	} else {
		segs = ad_SegmentByPeaks(y, breakpoints);
	}
		
	dsegs = which(diff(segs) != 0);
	segSt = c(1,dsegs + 1);
	segEd = c(dsegs,length(segs));
	segSize = segEd - segSt + 1;
	allSt = c(allSt,(segSt + chromPos[chr,1] - 1));
	allSize = c(allSize,segSize);
	allVal = c(allVal,segs[segSt]);
  S[chromPos[chr,1]:chromPos[chr,2]] = segs;

}#for chr

segTable = matrix(c(allSt,allSize,allVal),length(allSt),3);
return(list(SegmentsTable = segTable, Segmented = S));
}#HaarSeg

ad_FDRThres <- function(x, q, sdev) {
	M = length(x);
	if (M < 2) { 
		T = 0;
	} else {
		m = (1:M) / M;
		sortedX = sort(abs(x),decreasing = TRUE);	
		p = 2*(1 - pnorm(sortedX, sd = sdev));
		k = which(p <= m*q);
		k = k[length(k)];
		if (length(k) == 0) {
			T = sortedX[1] + 1e-16;  #2^-52 is like MATLAB "eps"
		} else {
			T = sortedX[k];
		}
	}
}#FDRThres

ad_SegmentByPeaks <- function(data, peaks, weights = 0) {
	st = c(1,peaks);
	ed = c(peaks-1,length(data));

	segs = data;
	for (k in 1:length(st)) {
		if (length(weights) > 1) {
			segs[st[k]:ed[k]] = sum(weights[st[k]:ed[k]] * data[st[k]:ed[k]]) / sum(weights[st[k]:ed[k]]);
		} else {
			segs[st[k]:ed[k]] = mean(data[st[k]:ed[k]]);
		}
	}#for k
	return (segs);
}#SegmentByPeaks 
