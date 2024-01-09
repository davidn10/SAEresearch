cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global currdata "$data\BRA\"
global samples "$currdata\samples\"
global census "$currdata\census_proc_BRA_2010.dta"
global simcensus "D:\SAE_project\BRA\2010\"
global results "$currdata\results_fh\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit context models
global myfh  aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun  hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun  
*income_hh_mun

set seed 648743

forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$simcensus\samples\sample_R_1.dta", clear
direct fgt0_m [aw=FACTOR], by(mun_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep mun_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(mun_id) 

tempfile direct
save `direct'

/*=========================================
Creating survey data for unit-context models
*=========================================*/
use "$simcensus\samples\sample_R_1.dta", clear
keep  mun_id 
duplicates drop 
merge 1:1 mun_id using "$currdata\census_mundata_BRA_2010.dta", keepusing($myfh)
keep if _merge==3
drop _merge
merge 1:1 mun_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
 set seed 648743
*lasso linear poor_direct $myfh  [iw=FACTOR], nolog rseed(648743)
*lasso linear poor_direct $myfh  [iw=FACTOR], nolog rseed(648743) selection(adaptive)
*lasso linear poor_direct $myfh  [iw=FACTOR], selection(bic, postselection) 
lasso linear poor_direct $myfh  [iw=FACTOR], select(plugin, het)
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

lasso linear poor_direct $myfh  [iw=FACTOR_res], select(plugin, het)
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'

lasso linear poor_direct $myfh  [iw=FACTOR_res2], select(plugin, het)
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres2=e(allvars_sel) //best model
global postlassores2 `hhvarsres2'

/*=========================================
Fay-Harriot models
*=========================================*/
preserve
use  "$simcensus\samples\sample_R_`i'.dta", clear
keep mun_id 
g insample=1
duplicates drop
merge 1:m mun_id using "$simcensus\census\census.dta"
drop _merge
replace insample=0 if insample==.
keep mun_id insample
duplicates drop
merge 1:1 mun_id using "$currdata\census_mundata_BRA_2010.dta", keepusing($myfh)
keep if _merge==3
drop _merge
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

preserve
fhsae poor_direct $postlassores, revar(poor_direct_var) method(reml) fh(fh_fgt0) ///
fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out
keep poor_direct poor_direct_var mun_id fh_fgt0_se fh_fgt0 fh_fgt0_cv

use `forpredict', clear
predict sim_fgt0 
keep mun_id sim_fgt0 insample

save "$results\myFHres_`i'.dta", replace
restore

preserve
fhsae poor_direct $postlassores2, revar(poor_direct_var) method(reml) fh(fh_fgt0) ///
fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out
keep poor_direct poor_direct_var mun_id fh_fgt0_se fh_fgt0 fh_fgt0_cv

use `forpredict', clear
predict sim_fgt0 
keep mun_id sim_fgt0 insample

save "$results\myFHres2_`i'.dta", replace
restore 
} 
