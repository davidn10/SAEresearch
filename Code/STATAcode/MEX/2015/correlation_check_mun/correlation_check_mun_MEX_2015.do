cd "D:\david\SAE\SAE_research_with_Melany\MEX"


clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\corr_check_mun\"
global simcensus "$currdata\simcensus\"


set seed 648743


/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\corr_check_mun", replace

forvalues i=1(1)100{
*	forvalues i=1(1)1 {
*foreach i of numlist 100 1/20 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/


/*=========================================
Correlation
*=========================================*/

use "$rawsamples\selected\sample_`i'.dta", replace 
gen ones=1 
collapse (sum) ones FACTOR FACTOR_res2, by(mun_id)
* assert abs(ones-FACTOR_res2)<0.0001
correlate FACTOR FACTOR_res2 
local rho_`i'=r(rho)

***Pearson correlations


putexcel A`i'=`rho_`i''






di "`i'"
}

