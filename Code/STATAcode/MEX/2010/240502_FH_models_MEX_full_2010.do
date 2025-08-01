* cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_full\"
global census "$data\census_proc_MEX_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results"
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
use "$rawsamples\selected\sample_`i'.dta", clear
keep  mun_id $myfh state_*
duplicates drop 
merge 1:1 mun_id using `direct' 
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
merge 1:1 mun_id using `census'
drop _merge
replace insample=0 if insample==.

fayherriot poor_direct $postlasso, variance(poor_direct_var) sigmamethod(ampl) gamma  mse(mse_fh_sim)
est store fhmodel

***Predictions
predict sim_fgt0, eblup
keep mun_id sim_fgt0 insample

save "$results\results_fh\myFH_`i'.dta", replace

} 
