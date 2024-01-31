cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\MEX\2015\full_census_new"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples\"
global census "$data\census_proc_MEX_2015.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\results_ell\"

//global with candidate variables for unit level models
global myvar wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old  aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu

*income_hh
*income_hh_mun
*income_hh_psu

set seed 648743

use "$census", clear

***Correct weights
g popwt=FACTOR*hhsize

***Logaritm of per capita income
g ln_pchinc=ln(pchinc)

***Squared household size
g hhsize2=hhsize*hhsize

***Number of HH per UPM
g aux=1
bys psu_id: egen numberhh_upm=sum(aux)
drop aux*

***Generate state dummy variables
tab ENT, g(state_)

keep $myvar popwt psu_id* mun_id* hid* strata* pchinc ln_pchinc povline fgt* ENT state_*

save "$currdata\census\census.dta", replace

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensus\true_fg0_full.dta", replace

/*=========================================
Saving census in mata format
*=========================================*/

use "$currdata\census\census.dta", clear
tempfile census
save `census'
// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($myvar popwt state_1 state_2 state_3 state_4 state_5 state_6 state_7 state_8 state_9 state_10 state_11 state_12 state_13 state_14 state_15 state_16 state_17 state_18 state_19 state_20 state_21 state_22 state_23 state_24 state_25 state_26 state_27 state_28 state_29 state_30 state_31 state_32) area(mun_id) uniqid(hid) dataout("$currdata\census\census_mata") 

/*=========================================
Creating simulates surveys
*=========================================*/
putexcel set "$results\model_metrics", replace


forvalues i=1(1)100 {

use "$rawsamples\sample_`i'.dta", clear

merge 1:1 hid using `census'
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $myvar ln_pchinc povline fgt* FACTOR FACTOR_res FACTOR_res2 ENT state_*

tempfile sample`i'_complete
save `sample`i'_complete'


/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models
use `sample`i'_complete', clear

***Lasso models

lasso linear ln_pchinc (state_1-state_31) $myvar  [iw=FACTOR_res], selection(bic, postselection) 
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


***Trying a model
*set seed 648743
*sae model ell ln_pchinc $postlasso [aw=FACTOR],  area(mun_id) 
*sae model ell ln_pchinc $postlassores [aw=FACTOR_res2],  area(mun_id) 

***Selecting the alpha model
***Using rescaled weights
sae model ell ln_pchinc $postlassores [aw=FACTOR_res], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa2
rename residual_xb residual_xb2

// Macro holding all eligible vars
unab allvars : $myvar
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

***Save samples and variables post lasso to run EBP in R
preserve
use `sample`i'_complete', clear
keep $postlassores /*$alfa*/ FACTOR_res2 FACTOR_res FACTOR mun_id hid psu_id pchinc ln_pchinc povline fgt* ENT state_*
save "$currdata\samples\sample_R_`i'.dta", replace
restore

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================

set seed 648743
sae model ell ln_pchinc $postlassores [aw=FACTOR_res], area(mun_id) zvar($alfares)
local r2_`i'=e(r2_beta)
local rmse_`i'=e(rmse_beta)
putexcel A`i'=`r2_`i''
putexcel E`i'=`rmse_`i''
outreg2 using  $results\unit\model\model_`i'.xls, replace ctitle(Model) adds("R-squared", `r2_`i'', "RMSE", `rmse_`i'') tex(pretty landscape)  dec(3) nocons label
char _dta[rhs] $postlassores
char _dta[alpha] $alfares
save "$currdata\mysvy.dta", replace


*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================

***Unisg rescaled weights
use "$currdata\mysvy.dta", clear
global hhmodelres: char _dta[rhs] 
global alphares  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres [w=FACTOR_res], area(mun_id) uniqid(hid) eta(nonnormal) epsilon(nonnormal) rep(100) matin($currdata\census\census_mata) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alphares) seed(`seed')  lny plines(1236.4632) allmata /* ydump($results\unit\predictions\yhat_`i') */ 
save "$results\unit\output\mySAE_`i'.dta", replace

}


