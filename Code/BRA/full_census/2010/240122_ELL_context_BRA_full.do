cd "C:\Users\melyg\Desktop\SAE_Project\data\BRA"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global main "C:\Users\melyg\Desktop\SAE_Project"

global currdata "D:\SAE_project\BRA\2010\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples\"
global census "$data\census_proc_BRA_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\results_ell\"

//global with candidate variables for unit level models
global mycontext aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun

/*=========================================
Saving census in mata format
*=========================================*/
use "$currdata\census\census.dta", clear
tempfile census
save `census'

// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($mycontext popwt state_1 state_2 state_3 state_4 state_5 state_6 state_7 state_8 state_9 state_10 state_11 state_12 state_13 state_14 state_15 state_16 state_17 state_18 state_19 state_20 state_21 state_22 state_23 state_24 state_25 state_26 state_27) area(mun_id) uniqid(hid) dataout("$currdata\census\census_mata_context")

/*=========================================
Creating simulates surveys
*=========================================*/
putexcel set "$results\model_metrics_context", replace

forvalues i=1(1)100 {

//Create survey data
use "$rawsamples\sample_`i'.dta", clear

merge 1:1 hid using `census', keepusing($mycontext popwt mun_id* hid* pchinc ln_pchinc fgt* state_*)
keep if _merge==3

keep $mycontext popwt mun_id* hid* pchinc ln_pchinc fgt* state_* FACTOR FACTOR_2 FACTOR_res FACTOR_res2 FACTOR_res_2 FACTOR_res2_2 

tempfile sample`i'_complete
save `sample`i'_complete'

/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models
use `sample`i'_complete', clear

***Lasso models
set seed 648743
lasso linear ln_pchinc (state_1-state_26) $mycontext [iw=FACTOR_res_2], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Trying a model
*set seed 648743
*sae model ell ln_pchinc $postlasso [aw=FACTOR],  area(mun_id) 
*sae model ell ln_pchinc $postlassores [aw=FACTOR_res],  area(mun_id) 

***Selecting the alpha model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR_res_2], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa1
rename residual_xb residual_xb1

// Macro holding all eligible vars
unab allvars : $mycontext
//Macro with current variables
local nogo $postlasso
//We want to only use variables not used
foreach x of local allvars{
local in = 0
foreach y of local nogo{
if ("`x'"=="`y'") local in=1
}
if (`in'==0) local A `A' `x'
}
global A `A' //macro holding eligible variables for alpha model

set seed 648743
lasso linear residual_alfa1 `A' [iw=FACTOR_res_2], selection(bic, postselection) 
local alfa=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfa `alfa'

***Save samples and variables post lasso to run EBP in R
preserve
use `sample`i'_complete', clear
keep $postlasso /*$alfa*/ FACTOR FACTOR_2 FACTOR_res FACTOR_res2 FACTOR_res_2  mun_id hid pchinc ln_pchinc  fgt* state_*
save "$currdata\samples_context\sample_R_`i'.dta", replace
restore

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================
preserve
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR_res_2], area(mun_id) zvar($alfa)  
local r2_`i'=e(r2_beta)
local rmse_`i'=e(rmse_beta)
putexcel A`i'=`r2_`i''
putexcel E`i'=`rmse_`i''
outreg2 using  $results\context\model\model_`i'.xls, replace ctitle(Model) adds("R-squared", `r2_`i'', "RMSE", `rmse_`i'') tex(pretty landscape)  dec(3) nocons label
char _dta[rhs] $postlasso
char _dta[alpha] $alfa
save "$currdata\mysvy_context.dta", replace
restore

*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================

use "$currdata\mysvy_context.dta", clear
global hhmodel: char _dta[rhs] 
global alpha  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodel [w=FACTOR_res_2], area(mun_id) uniqid(hid) eta(nonnormal) epsilon(nonnormal) rep(100) matin($currdata\census\census_mata_context) indicators(fgt0 fgt1) aggids(0 7) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(163.8265625) allmata ydump($results\context\predictions\yhat_`i')  
save "$results\context\output\mySAE_`i'.dta", replace
}

/*
sae data export, matasource($results\unit\predictions\yhat_1) numfiles(1)  saveold datasave($results\unit\predictions\yhat_1)