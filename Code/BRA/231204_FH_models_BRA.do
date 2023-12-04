** Do Fay-Herriot samples 

cd "C:\Users\melyg\Desktop\SAE_Project\data\BRA"

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
global simcensus "E:\SAE_project\BRA\2010\"
global results "$currdata\results_fh\"
global simcensuslocal "$currdata\simcensus\"

set seed 648743

//global with candidate variables for unit context models
global mycontext aux_sh_primedu aux_sh_secedu aux_sh_supedu aux_sh_noedu aux_sh_literate unemp informal hhsize income_hh hh_primedu hh_secondedu hh_superior age_hh female_hh depen_ch depen_old wall_improved water_improved electri sewage own_house good_house over_crowding over_crowding_ext motorcy radio tele fridge washing auto compu cell internet

forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$simcensus\samples\sample_R_`i'.dta", clear
keep hid mun_id FACTOR FACTOR2 pchinc ln_pchinc fgt0_m
collapse (mean) poor_dir=fgt0_m (sd)stdev=fgt0 [w=FACTOR2], by(mun_id)
g var_dir=stdev^2
tempfile direct
save `direct'

/*=========================================
Creating survey data for unit-context models
*=========================================*/


use "$simcensus\samples\sample_R_`i'.dta", clear
keep mun_id /*FACTOR FACTOR2*/
duplicates drop 
merge 1:1 mun_id using "$currdata\census_mundata_BRA_2010.dta", keepusing($mycontext)
keep if _merge==3
drop _merge
merge 1:1 mun_id using `direct' 
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
 set seed 648743
lasso linear poor_dir $mycontext , nolog rseed(12345) selection(adaptive)
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

/*=========================================
Fay-Harriot models
*=========================================*/

*fayherriot fgt0 $postlasso, variance(var_dir) sigmamethod(reml) gamma  mse(mse_fh_sim)
*predict fgt0_fh_sim, eblup 

fhsae poor_dir $postlasso, revar(var_dir) method(reml) fh(fh_fgt0) ///
fhse(fh_fgt0_se) fhcv(fh_fgt0_cv) gamma(fh_fgt0_gamma) out

keep poor_dir var_dir mun_id fh_fgt0_se fh_fgt0 fh_fgt0_cv

save "$results\myFH_`i'.dta", replace
} 
