
/* Code from version Version 1.0. June, 2008. */
/* Downloaded from http://www.ee.technion.ac.il/people/YoninaEldar/Info/software/HaarSeg.htm */
/* I place r_haarseg.c and HaarSeg.c in this single file */
/* I rename routines adding a "ad_" to avoid ambiguities in compiled code */


/* #include <R.h> */
/* #include "HaarSeg.c" */

/*   What follows is HaarSeg.c  */

/* 
 *    Copyright (C) 2008  Erez Ben-Yaacov
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *    <http://www.gnu.org/licenses/>
 *
 */

/* #include "HaarSeg.h" /\*FIXME: I think I do not need it for anything*\/ */

#include <math.h>
#include <stdlib.h>

/* #include <R.h> */
#include <Rinternals.h>
#include <R_ext/Rdynload.h>  /* For R registration */

#define OK 0
#define ERROR -1
#define NOT_VALID -1
#define min(X, Y)  ((X) < (Y) ? (X) : (Y))
#define abs(X)  ((X) > 0 ? (X) : -(X))
#define MAXINT 2147483647

/*
 * HaarConv : convolve haar wavelet function with a signal, 
 * applying circular padding to the signal.
 * supports weights when weight pointer is not NULL.
 */
 int ad_HaarConv(const double * signal,
              const double * weight,
		 	  int signalSize, 
		 	  int stepHalfSize, 
		 	  double * result)
 {
	int k;
	int highEnd, lowEnd;
	double stepNorm;
    double lowWeightSum;
    double highWeightSum;
    double lowSquareSum;
    double highSquareSum;
    double lowNonNormed;
    double highNonNormed;
    double totalNorm;

	if (stepHalfSize > signalSize) {
		return ERROR; /* TODO: handle this endcase */
	}
    result[0] = 0;
    if (weight != NULL) {
        /* init weight sums */
        highWeightSum = 0;
        highSquareSum = 0;
        highNonNormed = 0;
        for (k = 0; k < stepHalfSize; k++) {
            highWeightSum += weight[k];
            highSquareSum += weight[k]*weight[k]; 
            highNonNormed += weight[k]*signal[k];
        }
	/* circular padding */
        lowWeightSum = highWeightSum; 
        lowSquareSum = highSquareSum;
        lowNonNormed = -highNonNormed;
    }/*if (weight != NULL) */
    for (k = 1; k < signalSize; k++) {
        highEnd = k + stepHalfSize - 1;
        if (highEnd >= signalSize) {
            highEnd = signalSize - 1 - (highEnd - signalSize);
        }
        lowEnd = k - stepHalfSize - 1;
        if (lowEnd < 0) {
            lowEnd = - lowEnd - 1; 
        }
        if (weight != NULL) {
            lowNonNormed += signal[lowEnd]*weight[lowEnd] - signal[k-1]*weight[k-1];
            highNonNormed += signal[highEnd]*weight[highEnd] - signal[k-1]*weight[k-1]; 
            lowWeightSum += weight[k-1] - weight[lowEnd];
            highWeightSum += weight[highEnd] - weight[k-1];
            lowSquareSum += weight[k-1]*weight[k-1] - weight[lowEnd]*weight[lowEnd];
            highSquareSum += weight[highEnd]*weight[highEnd] - weight[k-1]*weight[k-1];
            result[k] = (lowNonNormed / lowWeightSum + highNonNormed / highWeightSum) * sqrt(stepHalfSize/2);            
/*            totalNorm = lowSquareSum / (lowWeightSum*lowWeightSum) + highSquareSum / (highWeightSum*highWeightSum); */
/*            result[k] = (lowNonNormed / lowWeightSum + highNonNormed / highWeightSum) / sqrt(totalNorm); */
        }/*if (weight != NULL) */
        else {
            result[k] = result[k-1] + signal[highEnd] + signal[lowEnd] - 2*signal[k-1];
        }
    }/* for k */
    
    if (weight == NULL) {
        stepNorm = sqrt((double)(2*stepHalfSize));
        for (k = 1; k < signalSize; k++) {
            result[k] /= stepNorm;
        }
    }

	return OK;
 }/* int HaarConv */
 
/*
 * FindLocalPeaks: find local maxima on positive values,
 * and local minima on negative values.
 * First and last index are never considered extramum.
 */
 int ad_FindLocalPeaks(const double * signal, int signalSize, int * peakLoc)
 {
	 int k,j;
	 int maxSuspect, minSuspect;
	 int peakLocInd;
	 
	 maxSuspect = NOT_VALID;
	 minSuspect = NOT_VALID;
	 peakLocInd = 0;
	 for (k = 1; k < signalSize-1; k++) {
		 if (signal[k] > 0) {
			 if ((signal[k] > signal[k-1]) && (signal[k] > signal[k+1])) {
				 peakLoc[peakLocInd] = k;
				 peakLocInd++;
			 }
			 else if ((signal[k] > signal[k-1]) && (signal[k] == signal[k+1])) {
				 maxSuspect = k;
			 }
			 else if (signal[k] == signal[k-1] && (signal[k] > signal[k+1])) {
				 if (maxSuspect != NOT_VALID) {
                     peakLoc[peakLocInd] = maxSuspect;
                     peakLocInd++;
                     /*
					 for (j = maxSuspect; j <= k; j++) {
						 peakLoc[peakLocInd] = j;
						 peakLocInd++;
					 }/* for j */
					 maxSuspect = NOT_VALID;					 
				 }
			 }
			 else if ((signal[k] == signal[k-1]) && (signal[k] < signal[k+1])) {
				 maxSuspect = NOT_VALID;
			 }
		 }/* if (signal[k] > 0) */
		 else if (signal[k] < 0) {
			 if ((signal[k] < signal[k-1]) && (signal[k] < signal[k+1])) {
				 peakLoc[peakLocInd] = k;
				 peakLocInd++;
			 }
			 else if ((signal[k] < signal[k-1]) && (signal[k] == signal[k+1])) {
				 minSuspect = k;
			 }
			 else if ((signal[k] == signal[k-1]) && (signal[k] < signal[k+1])) {
				 if(minSuspect != NOT_VALID) {
                     peakLoc[peakLocInd] = minSuspect;
                     peakLocInd++;
                     /*
					 for (j = minSuspect; j <= k; j++) {
						 peakLoc[peakLocInd] = j;
						 peakLocInd++;
					 }/* for j */
					 minSuspect = NOT_VALID;					 
				 }
			 }
			 else if ((signal[k] == signal[k-1]) && (signal[k] > signal[k+1])) {
				 minSuspect = NOT_VALID;
			 }
		 }/* else if (signal[k] < 0) */
	 }/* for k */
	 
	 peakLoc[peakLocInd] = NOT_VALID;
	 
	 return OK;
 }/* int FindLocalPeaks */
 
 /*
  * HardThreshold: Apply hard thresholding
  */
 int ad_HardThreshold(const double * signal, 
		 		   double threshold,
		 		   int * peakLoc) 
 {
	 int k,l;
	 
     k = 0;
     l = 0;
     while (peakLoc[k] != NOT_VALID) {
		 if ((signal[peakLoc[k]] >= threshold) || (signal[peakLoc[k]] <= -threshold)) {
			 /* peak is over the threshold */
             peakLoc[l] = peakLoc[k];
             l++;
		 }
         k++;
     }
     peakLoc[l] = NOT_VALID;
     
	 return OK;
 }/* int HardThreshold */
 
 /*
  * UnifyLevels: Unify several decomposition levels
  */
 int ad_UnifyLevels(const int * baseLevel,
		 		 const int * addonLevel,
		 		 int windowSize,
		 		 int signalSize,
		 		 int * joinedLevel) 
 {
	 int baseInd,addonInd,joinedInd;
	 	 
	 baseInd = 0;
	 addonInd = 0;
	 joinedInd = 0;
     
	 /* going over all base */
	 while (baseLevel[baseInd] != NOT_VALID) {
		 while ((addonLevel[addonInd] != NOT_VALID) && 
				(addonLevel[addonInd] <= (baseLevel[baseInd] + windowSize))) {
			 if (addonLevel[addonInd] < (baseLevel[baseInd] - windowSize)) {
				 joinedLevel[joinedInd] = addonLevel[addonInd];
				 joinedInd++;
			 }
			 addonInd++;
		 }/* while ((addonLevel[addonInd] ... */
		 joinedLevel[joinedInd] = baseLevel[baseInd];
		 joinedInd++;
		 baseInd++;
	 }/* while (baseLevel[baseInd] */
	 
	 /* insert remaining indexes in addon to joined */
	 while (addonLevel[addonInd] != NOT_VALID) {
		 joinedLevel[joinedInd] = addonLevel[addonInd];
		 joinedInd++;
		 addonInd++;
	 }
	 joinedLevel[joinedInd] = NOT_VALID;
	 
	 return OK;
 }/* int UnifyLevels */
 
 /*
  * CopyLocVec: copy source index vector to target index vector
  FIXME: (RDU): it seems this is never used!!!*/

 int ad_CopyLocVec(const int * source, int * target) {
     int k;
     k = 0;
     while (source[k] != NOT_VALID) {
         target[k] = source[k];
         k++;
     }
/*      mexPrintf("CopyLocVec: copied %d elements\n",k); */
     target[k] = NOT_VALID;
     
     return OK;
 }/* int CopyLocVec */
 
/*
 *  AdjustBreaks: improving localization of breaks by using a suboptimal,
 *  linear complexity procedure. We try to move each break 1 sample 
 *  left/right, choosing the offset which leads to minimum data error. 	
 */
 int ad_AdjustBreaks(const double * signal,
                  int signalSize,
                  const int * peakLoc,
                  int * newPeakLoc) {
    int k,m,p;
    int n1,n2;
    int bestOffset;
    double s1, s2, ss1, ss2;
    double score, bestScore;
    
    k = 0;
    while (peakLoc[k] != NOT_VALID) {
        newPeakLoc[k] = peakLoc[k];
        k++;
    }
    newPeakLoc[k] = NOT_VALID;
    
    k = 0;
    n1 = 0;
    n2 = 0;
    while (newPeakLoc[k] != NOT_VALID) {
        /* calculating width of segments around the breakpoint */
        if (k == 0) {
            n1 = newPeakLoc[k];
        }
        else {
            n1 = newPeakLoc[k] - newPeakLoc[k-1];
        }
        if (newPeakLoc[k+1] == NOT_VALID) {
            n2 = signalSize - newPeakLoc[k];
        }
        else {
            n2 = newPeakLoc[k+1] - newPeakLoc[k];
        }
        
        /* finding the best offset for current breakpoint, trying only 1 sample offset */
        bestScore = MAXINT;
        bestOffset = 0;
        for (p = -1; p <= 1; p++) {
            /* pointless to try and remove single sample segments */
            if ((n1 == 1) && (p == -1)) {
                continue;
            }
            if ((n2 == 1) && (p == 1)) {
                continue;
            }
                
            s1 = 0;
            for (m = (newPeakLoc[k] - n1); m <= (newPeakLoc[k] + p - 1); m++) {
                s1 += signal[m];
            }
            s1 = s1 / (n1 + p);
            s2 = 0;
            for (m = (newPeakLoc[k] + p); m <= (newPeakLoc[k] + n2 - 1); m++) {
                s2 += signal[m];
            }
            s2 = s2 / (n2 - p);
            
            ss1 = 0;
            for (m = (newPeakLoc[k] - n1); m <= (newPeakLoc[k] + p - 1); m++) {
                ss1 += (signal[m] - s1)*(signal[m] - s1);
            }
            ss2 = 0;
            for (m = (newPeakLoc[k] + p); m <= (newPeakLoc[k] + n2 - 1); m++) {
                ss2 += (signal[m] - s2)*(signal[m] - s2);
            }
            score = ss1 + ss2;
            if (score < bestScore) {
                bestScore = score;
                bestOffset = p;
            }
        }/* for p */
        newPeakLoc[k] += bestOffset; 
        k++;
    }/* while newPeakLoc */
    
    return OK;
 }/* int AdjustBreaks */
 
/*
 * StepConv : convolve a pulse function with a signal, 
 * applying circular padding to the signal.
 */
 int ad_PulseConv(const double * signal,
		 	  int signalSize, 
		 	  int pulseSize,
        double pulseHeight, 
		 	  double * result)
 {
	int k, n, tail, head;

	if (pulseSize > signalSize) {
		return ERROR; /* TODO: handle this endcase */
	}
  /* circular padding init */
  result[0] = 0;
  for (k = 0; k < ((pulseSize + 1)/2); k++) {
    result[0] += signal[k];
  }
  for (k = 0; k < (pulseSize/2); k++) {
    result[0] += signal[k];
  }  
  result[0] *= pulseHeight;  
  n = 1;
  for (k = (pulseSize/2); k < signalSize + (pulseSize/2) - 1; k++) {
        tail = k - pulseSize;
        if (tail < 0) {
            tail = -tail - 1; 
        }
        head = k;
        if (head >= signalSize) {
          head = signalSize - 1 - (head - signalSize);
        }
        result[n] = result[n-1] + ((signal[head] - signal[tail]) * pulseHeight);
        n++;
    }/* for k */
    
	return OK;
 }/* int PulseConv */                 

/*   Ended HaarSeg.c  */


void ad_rConvAndPeak(const double * signal,
                  const int * signalSize,
                  const int * stepHalfSize,
                  double * convResult,
                  int * peakLoc) {
    ad_HaarConv(signal, NULL, *signalSize, *stepHalfSize, convResult);
    ad_FindLocalPeaks(convResult, *signalSize, peakLoc);                     
}//rConvAndPeak

void ad_rWConvAndPeak(const double * signal,
                  const double * weight,
                  const int * signalSize,
                  const int * stepHalfSize,
                  double * convResult,
                  int * peakLoc) {
    ad_HaarConv(signal, weight, *signalSize, *stepHalfSize, convResult);
    ad_FindLocalPeaks(convResult, *signalSize, peakLoc);                     
}//rWConvAndPeak


void ad_rThresAndUnify(const double * addon,
                    const int * signalSize,
                    int * addonPeaks,
                    const int * basePeaks,
                    const double * threshold,
                    const int * windowSize,
                    int * uniPeaks) {
    ad_HardThreshold(addon, *threshold, addonPeaks);
    ad_UnifyLevels(basePeaks, addonPeaks, *windowSize, *signalSize, uniPeaks);
}//rThresAndUnify

void ad_rAdjustBreaks(const double * signal,
		   const int * signalSize,
		   const int * peakLoc,
		   int * newPeakLoc) {
    ad_AdjustBreaks(signal, *signalSize, peakLoc, newPeakLoc);
}//rAdjustBreaks

void ad_rPulseConv(const double * signal,
		   const int * signalSize, 
		   const int * pulseSize,
		   const double * pulseHeight, 
		   double * result) {
   ad_PulseConv(signal, *signalSize, *pulseSize, *pulseHeight, result);
}//rPulseConv





/* R registration code */


/* static const R_CMethodDef cMethods[] = { */
/*   {"ad_rConvAndPeak", (DL_FUNC) &ad_rConvAndPeak, 5, {REALSXP, INTSXP, INTSXP, REALSXP, INTSXP}}, */
/*   {NULL, NULL, 0} */
/* }; */



/* static const R_CMethodDef cMethods[] = { */
/*   {"ad_rConvAndPeak", (DL_FUNC) &ad_rConvAndPeak, 5,   */
/*    { REALSXP, INTSXP, INTSXP, REALSXP, INTSXP } }, */
/*   {NULL, NULL, 0} */
/* }; */


static R_NativePrimitiveArgType ad_rConvAndPeak_t[5] = { REALSXP, INTSXP, 
							 INTSXP, REALSXP, 
							 INTSXP };
static R_NativePrimitiveArgType ad_rPulseConv_t[5] = {REALSXP, INTSXP, 
						      INTSXP, REALSXP, 
						      REALSXP};
static R_NativePrimitiveArgType ad_rWConvAndPeak_t[6] = {REALSXP, REALSXP, 
							 INTSXP, INTSXP, 
							 REALSXP, INTSXP};
static R_NativePrimitiveArgType ad_rThresAndUnify_t[7] = {REALSXP, INTSXP, 
							  INTSXP, INTSXP, 
							  REALSXP, INTSXP, 
							  INTSXP};

static const R_CMethodDef cMethods[] = {
  {"ad_rConvAndPeak", (DL_FUNC) &ad_rConvAndPeak, 5,  ad_rConvAndPeak_t},
  {"ad_rPulseConv", (DL_FUNC) &ad_rPulseConv, 5, ad_rPulseConv_t},
  {"ad_rWConvAndPeak", (DL_FUNC) &ad_rWConvAndPeak, 6, ad_rWConvAndPeak_t},
  {"ad_rThresAndUnify", (DL_FUNC) &ad_rThresAndUnify, 7, ad_rThresAndUnify_t},
  {NULL, NULL, 0}
};




void
R_init_ADaCGH2(DllInfo *info)
{
  R_registerRoutines(info, cMethods, NULL, NULL, NULL);
}


  /* {"ad_rPulseConv", (DL_FUNC) &ad_rPulseConv, 5, */
  /*  {REALSXP, INTSXP, INTSXP, REALSXP, REALSXP}}, */
  /* {"ad_rWConvAndPeak", (DL_FUNC) &ad_rWConvAndPeak, 6, */
  /*  {REALSXP, REALSXP, INTSXP, INTSXP, REALSXP, INTSXP}}, */
  /* {"ad_rThresAndUnify", (DL_FUNC) &ad_rThresAndUnify, 7, */
  /*  {REALSXP, INTSXP, INTSXP, INTSXP, REALSXP, INTSXP, INTSXP}}, */
