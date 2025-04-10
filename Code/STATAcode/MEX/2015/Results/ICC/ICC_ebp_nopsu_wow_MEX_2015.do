cd "D:\david\SAE\SAE_research_with_Melany\MEX"


clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\results_ebp" 
global simcensus "$currdata\simcensus\"

set seed 648743



/*===================================
=====================================
Unit-context models
=====================================
===================================*/
putexcel set "$results\ICC_ebp_context_nopsu_wow", replace

forvalues i=1(1)100{
*	forvalues i=1(1)1 {
*foreach i of numlist 100 1/20 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/


/*=========================================
Correlation
*=========================================*/
import excel using "$results\context\model_nopsu_wow\model_sample_`i'.dta.xlsx", cellrange(C20:D21) clear
local sigma2_eta_`i'=D[2]
local sigma2_eps_`i'=D[1]
local ICC_`i'=`sigma2_eta_`i''/(`sigma2_eps_`i''+`sigma2_eta_`i'')


***Pearson correlations


putexcel A`i'=`sigma2_eta_`i''
putexcel B`i'=`sigma2_eps_`i''
putexcel C`i'=`ICC_`i''





di "`i'"
}