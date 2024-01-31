cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\intercensal_2015\"
global currdata "$data\MEX\intercensal_2015\full_census\"
global samples "$mdata\samples\"
global census "$mdata\census_proc_MEX_2015.dta"
global simcensus "D:\SAE_project\MEX\2015\"


*income_hh_mun
global mysubarea aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu
*income_hh_psu

set seed 648743


/*=========================================
Saving census in mata format
*=========================================*/
use "$simcensus\full_census\census\census.dta", clear

keep psu_id popwt mun_id state_*
collapse (mean) mun_id state_* (rawsum) popwt, by(psu_id)
merge 1:1 psu_id using "$mdata\census_psudata_MEX_2015.dta", keepusing($mysubarea)
keep if _merge==3
drop _merge
save "$simcensus\full_census\subarea\census\census_subarea.dta", replace



/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$simcensus\full_census\samplesres\sample_R_1.dta", clear
direct fgt0_m [aw=FACTOR], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep psu_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2 mun_id state_*

collapse (mean) poor_direct poor_direct_var mun_id state_* (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(psu_id) 
merge 1:1 psu_id using "$mdata\census_psudata_MEX_2015.dta", keepusing($mysubarea)
keep if _merge==3
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743
*lasso linear poor_direct $mysubarea [iw=FACTOR], nolog rseed(648743)
*lasso linear poor_direct $mysubarea [iw=FACTOR], nolog rseed(648743) selection(adaptive)
*lasso linear poor_direct $mysubarea [iw=FACTOR], selection(bic, postselection)  
lasso linear poor_direct (state_1-state_31) $mysubarea  [iw=FACTOR], select(plugin, het)
estimates store model1
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

lasso linear poor_direct (state_1-state_31) $mysubarea [iw=FACTOR_res], select(plugin, het)
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'

lasso linear poor_direct (state_1-state_31) $mysubarea [iw=FACTOR_res2], select(plugin, het)
estimates store model3
di "`e(allvars_sel)'"
local hhvarsres2=e(allvars_sel) //best model
global postlassores2 `hhvarsres2'

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)
preserve
keep psu_id mun_id $postlasso FACTOR_res FACTOR FACTOR_res2 poor_direct
order psu_id FACTOR_res FACTOR FACTOR_res2
save "$simcensus\full_census\subarea\samples\sample_R_`i'.dta", replace
restore

preserve
keep psu_id mun_id $postlassores FACTOR_res FACTOR FACTOR_res2 poor_direct
order psu_id FACTOR_res FACTOR FACTOR_res2

save "$simcensus\full_census\subarea\samplesres\sample_R_`i'.dta", replace
restore

preserve
keep psu_id mun_id $postlassores2 FACTOR_res FACTOR FACTOR_res2 poor_direct
order psu_id FACTOR_res FACTOR FACTOR_res2

save "$simcensus\full_census\subarea\samplesres2\sample_R_`i'.dta", replace
restore


}