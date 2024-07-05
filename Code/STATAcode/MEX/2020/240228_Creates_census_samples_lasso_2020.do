cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2020\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_full\"
global census "$data\census_proc_MEX_2020.dta"
global simcensus "$currdata\simcensus\"


//global with candidate variables for unit level models
set seed 648743

global all_var wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old  aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu

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

keep $all_var popwt psu_id* mun_id* hid* strata* pchinc ln_pchinc povline fgt* ENT state_*
save "$currdata\census\census.dta", replace

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensus\true_fg0_full.dta", replace

/*=========================================
Creating simulates surveys
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\selected\sample_`i'.dta", clear

preserve
drop psu_id hid ENT mun_id FACTOR FACTOR_res FACTOR_res2 state_* ln_pchinc pchinc psu_id2 hid2 mun_id2 povline fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m

ds
local myvar=r(varlist)
global myvar `myvar'
restore

tempfile sample`i'_complete
save `sample`i'_complete'


/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models
use `sample`i'_complete', clear

***Lasso models
set seed 648743
lasso linear ln_pchinc (state_1-state_31) $myvar [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


***Save samples and variables post lasso to run ELL and EBP
preserve
use `sample`i'_complete', clear
keep $postlassores FACTOR_res2 FACTOR_res FACTOR mun_id hid psu_id pchinc ln_pchinc povline fgt0_m fgt1_m ENT state_*
save "$currdata\samples_selected\sample_R_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
drop $postlassores
save "$currdata\samples_notselected\sample_no_`i'.dta", replace
restore

}

***Unit-context models

//global with candidate variables for unit context models
global mycontextmun aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun 
*income_hh_mun

global mycontextpsu aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu
*income_hh_psu




/*=========================================
Saving census context
*=========================================*/
use "$currdata\census\census.dta", clear
keep hid mun_id psu_id popwt pchinc ln_pchinc  $mycontextmun $mycontextpsu state_*
save "$currdata\census\census_context.dta", replace

set seed 648743
/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$rawsamples\selected\sample_`i'.dta", clear

keep psu_id* mun_id*   hid* pchinc $mycontextmun $mycontextpsu ln_pchinc FACTOR FACTOR_res FACTOR_res2 ENT state_*

tempfile sample`i'_complete
save `sample`i'_complete'

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743

lasso linear ln_pchinc (state_1-state_31) $mycontextmun $mycontextpsu [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvarsres_context=e(allvars_sel) //best model
global postlassores_context `hhvarsres_context'

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)
preserve
keep mun_id hid psu_id ln_pchinc pchinc $postlassores_context FACTOR_res FACTOR FACTOR_res2 state_*
save "$currdata\context\samples_selected\sample_R_`i'.dta", replace
restore

preserve
drop $postlassores_context
save "$currdata\context\samples_notselected\sample_R_`i'.dta", replace
restore
}

