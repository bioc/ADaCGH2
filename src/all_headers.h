/* #include <R.h> */
/* #include <Rmath.h> */


void ad_rConvAndPeak(const double * signal,
                  const int * signalSize,
                  const int * stepHalfSize,
                  double * convResult,
		     int * peakLoc);

void ad_rPulseConv(const double * signal,
		   const int * signalSize, 
		   const int * pulseSize,
		   const double * pulseHeight, 
		   double * result);

void ad_rWConvAndPeak(const double * signal,
		      const double * weight,
		      const int * signalSize,
		      const int * stepHalfSize,
		      double * convResult,
		      int * peakLoc);

void ad_rThresAndUnify(const double * addon,
		       const int * signalSize,
		       int * addonPeaks,
		       const int * basePeaks,
		       const double * threshold,
		       const int * windowSize,
		       int * uniPeaks);


// Not needed, as those packages work again in BioC devel
/* void */
/* ad_calc_observed_likelihood(int *seq_len, double *_y, int *_k, double *means, */
/* 			    double *sigma, double *TPM, double *pi, int *maxiter, */
/* 			    double *eps, double *_log_lik, double *filter, */
/* 			    int *hidden_states); //, bool *print_info); */




/* ///////////////////////    From header.h in snapCGH */
/* void ad_runNelderMead(int*, double*, double*, double*, double*,  */
/* 		      double*, double*, double*, int*, int*, double*, int*, int*, int*); */








