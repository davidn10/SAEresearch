
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
* global currdata "D:\SAE_project\MEX\2010\full_census_new"
global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_bias\"
global census "$data\census_proc_MEX_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\bias"
set seed 648743


//global with candidate variables for unit context models


global myfh aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun

use "$currdata\census\census.dta", clear
keep mun_id state_* $myfh
duplicates drop
tempfile census 
save `census'

set seed 648743


forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\bias55\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

gen Nmun=1 

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 Nmun [aw=FACTOR] , by(mun_id) 
gen ln_poor_direct_var=log(poor_direct_var)
gen lnNmun=ln(Nmun)
regress ln_poor_direct_var lnNmun 

predict yhat, xb 
local rmse=e(rmse)
gen smooth_var=exp(yhat+(`rmse'^2/2))


tempfile direct
save `direct'
/*
/*=========================================
Merging data
*=========================================*/
use "$rawsamples\bias55\selected\sample_`i'.dta", clear
*drop fgt0_m_mun fgt0_mun

preserve
keep *_mun
ds
local myfh=r(varlist)
global myfh `myfh'
restore

keep  mun_id *_mun state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $myfh  [iw=FACTOR], selection(bic, postselection) /*cluster(mun_id)*/
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

 
/*=========================================
Fay-Harriot models
*=========================================*/
preserve
use "$rawsamples\bias55\selected\sample_`i'.dta", clear
keep  mun_id
g insample=1
duplicates drop
merge 1:m mun_id using "$currdata\census\census_bias.dta", keepusing($myfh state_*)
drop _merge
replace insample=0 if insample==.
duplicates drop
tempfile forpredict
save `forpredict'
restore

preserve
fhsae poor_direct $postlasso, revar(poor_direct_var) method(reml) fh(fh_fgt0) ///
fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out
keep poor_direct poor_direct_var mun_id fh_fgt0_se fh_fgt0 fh_fgt0_cv

use `forpredict', clear
predict sim_fgt0 
keep mun_id sim_fgt0 insample

save "$results\results_fh_smooth\output_bias55\myFH_`i'.dta", replace
restore

} 


forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\bias11b11\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

tempfile direct
save `direct'
*/
/*=========================================
Merging data
*=========================================*/
use "$rawsamples\bias11b11\selected\sample_`i'.dta", clear
*drop fgt0_m_mun fgt0_mun

preserve
keep *_mun
ds
local myfh=r(varlist)
global myfh `myfh'
restore

keep  mun_id *_mun state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $myfh  [iw=FACTOR], selection(bic, postselection) /*cluster(mun_id)*/
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

 
/*=========================================
Fay-Harriot models
*=========================================*/
g insample=1
merge 1:1 mun_id using `census'
drop _merge
replace insample=0 if insample==.
*fhsae poor_direct $postlasso, revar(poor_direct_var) method(reml) fh(fh_fgt0) ///
fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out

fayherriot poor_direct $postlasso, variance(smooth_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
predict sim_fgt0, eblup


keep mun_id sim_fgt0 insample



save "$results\results_fh_smooth\output_bias11b11\myFH_`i'.dta", replace

} 

/*
forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\nobias\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$rawsamples\nobias\selected\sample_`i'.dta", clear
*drop fgt0_m_mun fgt0_mun

preserve
keep *_mun
ds
local myfh=r(varlist)
global myfh `myfh'
restore

keep  mun_id *_mun state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $myfh  [iw=FACTOR], selection(bic, postselection) /*cluster(mun_id)*/
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

 
/*=========================================
Fay-Harriot models
*=========================================*/
preserve
use "$rawsamples\nobias\selected\sample_`i'.dta", clear
keep  mun_id
g insample=1
duplicates drop
merge 1:m mun_id using "$currdata\census\census_bias.dta", keepusing($myfh state_*)
drop _merge
replace insample=0 if insample==.
duplicates drop
tempfile forpredict
save `forpredict'
restore

preserve
fhsae poor_direct $postlasso, revar(poor_direct_var) method(reml) fh(fh_fgt0) ///
fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out
keep poor_direct poor_direct_var mun_id fh_fgt0_se fh_fgt0 fh_fgt0_cv

use `forpredict', clear
predict sim_fgt0 
keep mun_id sim_fgt0 insample

save "$results\results_fh\output_nobias\myFH_`i'.dta", replace
restore

} 
*/ 