cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2010\full_census_new\"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\rawdata\census_proc_MEX_2010.dta"


*income_hh_mun
global mysubarea aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu

*income_hh_psu

set seed 648743


forvalues x=1(1)3 {
/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$rawsamples\sample`x'\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep psu_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2 mun_id state_*

collapse (mean) poor_direct poor_direct_var mun_id state_* (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(psu_id) 
merge 1:1 psu_id using "$currdata\census\census_subarea.dta", keepusing($mysubarea)
keep if _merge==3
drop _merge
*duplicates drop

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743


lasso linear poor_direct (state_1-state_31) $mysubarea [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)

preserve
keep psu_id mun_id $postlassores FACTOR_res FACTOR FACTOR_res2 poor_direct
order psu_id FACTOR_res FACTOR FACTOR_res2

save "$currdata\subarea\sample`x'\sample_`i'.dta", replace
restore


}
}