clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\BRA\2010\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples\"
global census "$data\census_proc_BRA_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\results_fh\"

set seed 648743


//global with candidate variables for unit context models
global myfh aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun  hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun 

*income_hh_mun

set seed 648743

forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$rawsamples\sample_`i'.dta", clear
merge 1:1 hid using "$currdata\census\census.dta"
keep if _merge==3

keep mun_id*  hid* pchinc $myfh ln_pchinc fgt* FACTOR*

direct fgt0_m [aw=FACTOR_2], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR_2 FACTOR_res_2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR_2 FACTOR_res_2 [aw=FACTOR_2] , by(mun_id) 

tempfile direct
save `direct'

/*=========================================
Creating survey data for unit-context models
*=========================================*/
use "$rawsamples\sample_`i'.dta", clear
merge 1:1 hid using "$currdata\census\census.dta"
keep if _merge==3
keep  mun_id  $myfh state_*
duplicates drop

merge 1:1 mun_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
 set seed 648743

lasso linear poor_direct  $myfh  [iw=FACTOR_2], select(plugin, het)
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

/*=========================================
Fay-Harriot models
*=========================================*/
preserve
use "$rawsamples\sample_`i'.dta", clear
keep mun_id 
g insample=1
duplicates drop
merge 1:m mun_id using "$currdata\census\census.dta", keepusing($myfh)
*keep if _merge==3
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

save "$results\myFH_`i'.dta", replace
restore

} 
