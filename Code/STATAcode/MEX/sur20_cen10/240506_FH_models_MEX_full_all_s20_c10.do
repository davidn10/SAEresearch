* cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\s20_c10\full_census"
global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\s20_c10"
global rawsamples "$currdata\rawsamples_full\"
global simcensus10 "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\"
global results "$currdata\results\"
set seed 648743


//global with candidate variables for unit context models

***area data
use "$simcensus10\census\census.dta", clear
keep mun_id *_mun state_* 
duplicates drop

preserve
keep *_mun
ds
local myfh=r(varlist)
global myfh `myfh'
restore

tempfile area_data
save `area_data'

forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\selected\sample_`i'.dta", clear

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

tempfile direct
save `direct'


/*=========================================
Merging data
*=========================================*/
use `direct', clear
merge 1:1 mun_id using `area_data'
keep if _merge==3
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $myfh  [iw=FACTOR_res], selection(bic, postselection) /*cluster(mun_id)*/
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

 
/*=========================================
Fay-Harriot models
*=========================================*/
g insample=1
merge 1:1 mun_id using `area_data'
drop _merge
replace insample=0 if insample==.

fayherriot poor_direct $postlasso, variance(poor_direct_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh\myFH_`i'.dta", replace


} 
