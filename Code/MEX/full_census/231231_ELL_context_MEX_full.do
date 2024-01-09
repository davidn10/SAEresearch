cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\census_2010\"
global currdata "$data\MEX\census_2010\full_census\"
global samples "$mdata\samples\"
global census "$mdata\census_proc_MEX_2010.dta"
global simcensus "D:\SAE_project\MEX\2010\"
global results "$currdata\results_ell\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit context models
global mycontextmun aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun 
*income_hh_mun
global mycontextpsu aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu
*income_hh_psu

set seed 648743

putexcel set "$results\model_metrics_context", replace

/*=========================================
Saving census in mata format
*=========================================*/
use "$simcensus\full_census\census\census.dta", clear

keep hid mun_id psu_id popwt pchinc ln_pchinc

merge m:1 mun_id using "$mdata\census_mundata_MEX_2010.dta", keepusing($mycontextmun)
keep if _merge==3
drop _merge
merge m:1 psu_id using "$mdata\census_psudata_MEX_2010.dta", keepusing($mycontextpsu)
keep if _merge==3
drop _merge

keep hid mun_id popwt pchinc ln_pchinc  $mycontextmun $mycontextpsu
tempfile states
save `states'

save "$simcensus\full_census\context\census\census_full.dta", replace

// Create data ready for SAE - optimized dataset
sae data import, datain(`states') varlist($mycontextmun $mycontextpsu popwt) area(mun_id) uniqid(hid) dataout("$currdata\census_mata_context") 

/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$simcensus\full_census\samples\sample_R_`i'.dta", clear
keep hid mun_id psu_id FACTOR pchinc ln_pchinc FACTOR_res FACTOR FACTOR_res2
merge m:1 mun_id using "$mdata\census_mundata_MEX_2010.dta", keepusing($mycontextmun)
keep if _merge==3
drop _merge
merge m:1 psu_id using "$mdata\census_psudata_MEX_2010.dta", keepusing($mycontextpsu)
keep if _merge==3
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743
*lasso linear ln_pchinc $mycontextmun $mycontextpsu [iw=FACTOR2], nolog rseed(648743)
*lasso linear ln_pchinc $mycontextmun $mycontextpsu [iw=FACTOR2], nolog rseed(648743) selection(adaptive)
*lasso linear ln_pchinc $mycontextmun $mycontextpsu [iw=FACTOR2], selection(plugin) 
lasso linear ln_pchinc $mycontextmun $mycontextpsu [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

lasso linear ln_pchinc $mycontextmun $mycontextpsu [iw=FACTOR_res], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'

lasso linear ln_pchinc $mycontextmun $mycontextpsu [iw=FACTOR_res2], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvarsres2=e(allvars_sel) //best model
global postlassores2 `hhvarsres2'

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)
preserve
keep mun_id hid psu_id ln_pchinc pchinc $postlasso FACTOR_res FACTOR FACTOR_res2
save "$simcensus\full_census\context\samples\sample_R_`i'.dta", replace
restore

preserve
keep mun_id hid psu_id ln_pchinc pchinc $postlassores FACTOR_res FACTOR FACTOR_res2
save "$simcensus\full_census\context\samplesres\sample_R_`i'.dta", replace
restore

preserve
keep mun_id hid psu_id ln_pchinc pchinc $postlassores2 FACTOR_res FACTOR FACTOR_res2
save "$simcensus\full_census\context\samplesres2\sample_R_`i'.dta", replace
restore


/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/

***Trying a model
*set seed 648743
*sae model ell ln_pchinc $postlasso [aw=FACTOR],  area(mun_id) 
*sae model ell ln_pchinc $postlassores [aw=FACTOR_res2],  area(mun_id) 

***Selecting the alpha model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR], area(mun_id) alfatest(residual) zvar(hhsize_mun) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa1
rename residual_xb residual_xb1

// Macro holding all eligible vars
unab allvars : $mycontextmun $mycontexpsu
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
lasso linear residual_alfa1 `A' [iw=FACTOR], selection(bic, postselection) 
local alfa=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfa `alfa'

***Using rescaled weights
set seed 648743
sae model ell ln_pchinc $postlassores [aw=FACTOR_res], area(mun_id) alfatest(residual) zvar(hhsize_mun) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa2
rename residual_xb residual_xb2

// Macro holding all eligible vars
unab allvars : $mycontextmun $mycontexpsu
//Macro with current variables
local nogo $postlassores
//We want to only use variables not used
foreach x of local allvars{
local in = 0
foreach y of local nogo{
if ("`x'"=="`y'") local in=1
}
if (`in'==0) local B `B' `x'
}
global B `B' //macro holding eligible variables for alpha model

set seed 648743
lasso linear residual_alfa2 `B' [iw=FACTOR_res], selection(bic, postselection) 
local alfares=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfares `alfares'

***Using rescaled weights
set seed 648743
sae model ell ln_pchinc $postlassores2 [aw=FACTOR_res2], area(mun_id) alfatest(residual) zvar(hhsize_mun) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa3
rename residual_xb residual_xb3

// Macro holding all eligible vars
unab allvars : $mycontextmun $mycontexpsu
//Macro with current variables
local nogo $postlassores2
//We want to only use variables not used
foreach x of local allvars{
local in = 0
foreach y of local nogo{
if ("`x'"=="`y'") local in=1
}
if (`in'==0) local B `B' `x'
}
global B `B' //macro holding eligible variables for alpha model

set seed 648743
lasso linear residual_alfa3 `B' [iw=FACTOR_res2], selection(bic, postselection) 
local alfares2=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfares2 `alfares2'

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================
preserve
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR], area(mun_id) zvar($alfa)  
local r2_`i'=e(r2_beta)
local rmse_`i'=e(rmse_beta)
putexcel A`i'=`r2_`i''
putexcel E`i'=`rmse_`i''
char _dta[rhs] $postlasso
char _dta[alpha] $alfa
save "$currdata\mysvy_context.dta", replace
restore

preserve
set seed 648743
sae model ell ln_pchinc $postlassores [aw=FACTOR_res], area(mun_id) zvar($alfares)  
local r2_res_`i'=e(r2_beta)
local rmse_res_`i'=e(rmse_beta)  
putexcel B`i'=`r2_res_`i''
putexcel F`i'=`rmse_res_`i''
char _dta[rhs] $postlassores
char _dta[alpha] $alfares
save "$currdata\mysvyres_context.dta", replace
restore

preserve
set seed 648743
sae model ell ln_pchinc $postlassores2 [aw=FACTOR_res2], area(mun_id) zvar($alfares2)  
local r2_res2_`i'=e(r2_beta)
local rmse_res2_`i'=e(rmse_beta) 
putexcel C`i'=`r2_res2_`i'' 
putexcel G`i'=`rmse_res2_`i''
char _dta[rhs] $postlassores2
char _dta[alpha] $alfares2
save "$currdata\mysvyres2_context.dta", replace
restore

*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================

***ELL models
use "$currdata\mysvy_context.dta", clear
global hhmodel: char _dta[rhs] 
global alpha  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodel [w=FACTOR], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata_context) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(962.769947) allmata /* ydump($results\test_`i') */ 
save "$results\context\mySAE_context_`i'.dta", replace

***Rescaleing weights
use "$currdata\mysvyres_context.dta", clear
global hhmodelres: char _dta[rhs] 
global alphares  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres [w=FACTOR_res], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata_context) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alphares) seed(`seed')  lny plines(962.769947) allmata /* ydump($results\test_`i') */ 
save "$results\context\mySAEres_context_`i'.dta", replace

***Rescaleing weights
use "$currdata\mysvyres2_context.dta", clear
global hhmodelres2: char _dta[rhs] 
global alphares2  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres2 [w=FACTOR_res2], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata_context) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alphares2) seed(`seed')  lny plines(962.769947) allmata /* ydump($results\test_`i') */ 
save "$results\context\mySAEres2_context_`i'.dta", replace

}


