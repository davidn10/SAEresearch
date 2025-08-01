*cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "H:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new"
global data "$currdata\rawdata\"
global rawsamples "H:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\rawsamples_new"
global census "$data\census_proc_MEX_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\"
set seed 648743


//global with candidate variables for unit context models

global myfh aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun  water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun  radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun 

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
use "$rawsamples\sample1\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2
gen Nmun=1
collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 Nmun [aw=FACTOR] , by(mun_id) 
gen ln_poor_direct_var=log(poor_direct_var)
regress ln_poor_direct_var Nmun 

predict yhat, xb 
local rmse=e(rmse)
gen smooth_var=exp(yhat+(`rmse'^2/2))

tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$rawsamples\sample1\selected\sample_`i'.dta", clear
keep  mun_id $myfh state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_26) $myfh  [iw=FACTOR_res], selection(bic, postselection) /*cluster(mun_id)*/
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

fayherriot poor_direct $postlasso, variance(smooth_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh_smooth\sample1\myFH_`i'.dta", replace

} 


forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\sample2\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2
gen Nmun=1

collapse (mean) poor_direct poor_direct_var (rawsum) Nmun FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 
gen ln_poor_direct_var=log(poor_direct_var)
regress ln_poor_direct_var Nmun 
predict yhat, xb 
local rmse=e(rmse)
gen smooth_var=exp(yhat+(`rmse'^2/2))

tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$rawsamples\sample2\selected\sample_`i'.dta", clear
keep  mun_id $myfh state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_26) $myfh  [iw=FACTOR_res], selection(bic, postselection) /*cluster(mun_id)*/
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

fayherriot poor_direct $postlasso, variance(smooth_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh_smooth\sample2\myFH_`i'.dta", replace

} 


forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\sample3\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2
gen Nmun=1
collapse (mean) poor_direct poor_direct_var (rawsum) Nmun FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 
gen ln_poor_direct_var=log(poor_direct_var)
regress ln_poor_direct_var Nmun
predict yhat, xb 
local rmse=e(rmse)
gen smooth_var=exp(yhat+(`rmse'^2/2))


tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$rawsamples\sample3\selected\sample_`i'.dta", clear
keep  mun_id $myfh state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_26) $myfh  [iw=FACTOR_res], selection(bic, postselection) /*cluster(mun_id)*/
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

fayherriot poor_direct $postlasso, variance(smooth_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh_smooth\sample3\myFH_`i'.dta", replace

} 
