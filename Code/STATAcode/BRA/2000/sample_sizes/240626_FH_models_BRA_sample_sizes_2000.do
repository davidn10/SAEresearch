
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\BRA\2000\full_census"
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_new\"
global census "$data\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus_new\"
global results "$currdata\results\"
set seed 648743


//global with candidate variables for unit context models
* internet_mun wall_improved_mun motorcy_mun
global myfh aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun  water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun  radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun 

use "$currdata\census\census.dta", clear
keep mun_id state_* $myfh
duplicates drop
tempfile census 
save `census'

set seed 648743
***Samples 1,2; ampl
***Sample 7, 18,25,28,31,33,35,38, 43-44;47;49;53;55,57,60,64,68,71-72,74,76,82,88-91;93-96;98-100 do not converge
***Samples 3-6;8-17;19-24;26-27;29-30;32;34;36,37;39-42;45-46;48;50-52;54;56;58,59;61-63;65-67;73;75;77-81;83-87;92;97;99: reml
forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\sample1\selected\sample_`i'.dta", clear

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

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

fayherriot poor_direct $postlasso, variance(poor_direct_var) sigmamethod(ampl) gamma  mse(mse_fh_sim) initialvalue(0.01)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh\sample1\myFH_`i'.dta", replace

} 


forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\sample2\selected\sample_`i'.dta", clear

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

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

fayherriot poor_direct $postlasso, variance(poor_direct_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh\sample2\myFH_`i'.dta", replace

} 


use "$currdata\census\census.dta", clear
keep mun_id state_* $myfh
duplicates drop
tempfile census 
save `census'
forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\sample3\selected\sample_`i'.dta", clear

direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

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

fayherriot poor_direct $postlasso, variance(poor_direct_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh\sample3\myFH_`i'.dta", replace

} 