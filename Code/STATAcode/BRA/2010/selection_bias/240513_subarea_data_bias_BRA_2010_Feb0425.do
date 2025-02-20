*cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"
*global currdata "D:\SAE_Project\BRA\BRA_2000\2000\full_census"
global rawsamples "$currdata\rawsamples_bias\"
global census "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census\rawdata\census_proc_BRA_2010.dta"

global mysubarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu water_improved_psu electri_psu sewage_psu own_house_psu good_house_psu over_crowding_psu over_crowding_ext_psu motorcy_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu

set seed 648743


/*=========================================
Saving census in mata format
*=========================================*/
use "$currdata\census\census_bias.dta", clear
keep psu_id weight mun_id state_*
collapse (mean) mun_id state_* (rawsum) weights, by(psu_id)
merge 1:m psu_id using "$census", keepusing($mysubarea)
keep if _merge==3
duplicates drop
drop _merge
gen popwt=weights 
save "$currdata\census\census_subarea_bias.dta", replace



/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$rawsamples\bias11b11\selected\sample_`i'.dta", clear
drop if weights<=1

direct fgt0_m [aw=weights], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 


keep psu_id poor_direct poor_direct_var weights FACTOR_res FACTOR_res2 mun_id state_*

collapse (mean) poor_direct poor_direct_var mun_id state_* (rawsum) weights FACTOR_res FACTOR_res2 [aw=weights] , by(psu_id) 
merge 1:1 psu_id using "$currdata\census\census_subarea_bias.dta", keepusing($mysubarea)
keep if _merge==3
drop _merge
*duplicates drop

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743


lasso linear poor_direct (state_1-state_26) $mysubarea [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)

preserve
keep psu_id mun_id $postlassores weights poor_direct
order psu_id weights 
 

save "$currdata\subarea\bias11b11\sample_`i'.dta", replace
restore

}

/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$rawsamples\nobias\selected\sample_`i'.dta", clear
drop if weights<=1

direct fgt0_m [aw=weights], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep psu_id poor_direct poor_direct_var weights FACTOR_res FACTOR_res2 mun_id state_*

collapse (mean) poor_direct poor_direct_var mun_id state_* (rawsum) weights FACTOR_res FACTOR_res2 [aw=weights] , by(psu_id) 
merge 1:1 psu_id using "$currdata\census\census_subarea_bias.dta", keepusing($mysubarea)
keep if _merge==3
drop _merge
*duplicates drop

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743


lasso linear poor_direct (state_1-state_26) $mysubarea [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)

preserve
keep psu_id mun_id $postlassores weights poor_direct
order psu_id weights 
 

save "$currdata\subarea\nobias\sample_`i'.dta", replace
restore

}