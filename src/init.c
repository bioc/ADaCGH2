/* Common code for registration of routines */

#include <Rinternals.h>
#include <R_ext/Rdynload.h>  /* For R registration */
#include "all_headers.h"
#include <R.h>
#include <Rmath.h> /* Is this needed ?*/



/* R registration code */

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
/* From aCGH */
/* static R_NativePrimitiveArgType ad_calc_observed_likelihood_t[12] = {INTSXP, REALSXP, */
/* 								    INTSXP, REALSXP, */
/* 								    REALSXP, REALSXP, REALSXP, INTSXP, */
/* 								    REALSXP, REALSXP, REALSXP, */
/* 								     INTSXP}; //, LGLSXP}; */

/* // From snapCGH */
/* static R_NativePrimitiveArgType ad_runNelderMead_t[14] = {INTSXP, REALSXP, */
/* 							  REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, REALSXP, */
/* 							  INTSXP, INTSXP,  REALSXP,  */
/* 							  INTSXP, INTSXP, INTSXP}; */

static const R_CMethodDef cMethods[] = {
  {"ad_rConvAndPeak", (DL_FUNC) &ad_rConvAndPeak, 5,  ad_rConvAndPeak_t},
  {"ad_rPulseConv", (DL_FUNC) &ad_rPulseConv, 5, ad_rPulseConv_t},
  {"ad_rWConvAndPeak", (DL_FUNC) &ad_rWConvAndPeak, 6, ad_rWConvAndPeak_t},
  {"ad_rThresAndUnify", (DL_FUNC) &ad_rThresAndUnify, 7, ad_rThresAndUnify_t},
  /* {"ad_calc_observed_likelihood_t", (DL_FUNC) &ad_calc_observed_likelihood_t, 12, ad_calc_observed_likelihood_t}, */
  /* {"ad_runNelderMead_t", (DL_FUNC) &ad_runNelderMead_t, 14, ad_runNelderMead_t}, */
  {NULL, NULL, 0}
};




void
R_init_ADaCGH2(DllInfo *info)
{
  R_registerRoutines(info, cMethods, NULL, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
  R_forceSymbols(info, TRUE);
}







