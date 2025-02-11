


clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
 *global currdata "D:\SAE_project\BRA\BRA_2000\2000\full_census"
* global currdata "C:\DavidNewhouse2024\BRA\BRA_2000\2000\full_census"
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_bias\"
global census "$data\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus\bias"


/*============================

   Unit-level models
   
============================*/

//global with candidate variables for unit level models
set seed 648743
/*
global all_var wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old  aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu
*/

global all_var over_crowding over_crowding_ext water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC hhsize female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old hhsize2 aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu


/*=========================================
Biased samples
*=========================================*/


set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\bias11b11\selected\sample_`i'.dta", clear

preserve
drop psu_id* hid* mun_id* weights FACTOR_res FACTOR_res2 state_* ln_pchinc pchinc fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m

ds
local myvar=r(varlist)
global myvar `myvar'
restore

tempfile sample`i'_complete
save `sample`i'_complete'

*** Model selection using LASSO
use `sample`i'_complete', clear

***Lasso models
set seed 648743
lasso linear ln_pchinc (state_1-state_26) $myvar [iw=weights], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=weights], r cluster(mun_id)
predict resid, residuals
*predict y_hat

bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $myvar [iw=weights], selection(bic, postselection) cluster(mun_id) 
estimates store bicmodel_res
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


***Save samples and variables post lasso to run ELL and EBP
preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlasso 

save "$currdata\vars_selected_bias\bias11b11\betavars_selected_bias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\vars_selected_bias\bias11b11\alphavars_selected_bias\alpha_`i'.dta", replace
restore

}




/*=========================================
Unbiased samples
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\nobias\selected\sample_`i'.dta", clear
 
preserve
drop psu_id* hid* mun_id* weights FACTOR_res FACTOR_res2 state_* ln_pchinc pchinc fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m

ds
local myvar=r(varlist)
global myvar `myvar'
restore

tempfile sample`i'_complete
save `sample`i'_complete'

*** Model selection using LASSO
use `sample`i'_complete', clear

***Lasso models
set seed 648743
lasso linear ln_pchinc (state_1-state_26) $myvar [iw=weights], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=weights], r cluster(mun_id)
predict resid, residuals
*predict y_hat

bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $myvar [iw=weights], selection(bic, postselection) cluster(mun_id) 
estimates store bicmodel_res
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'


***Save samples and variables post lasso to run ELL and EBP
preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlasso 

save "$currdata\vars_selected_bias\nobias\betavars_selected_nobias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\vars_selected_bias\nobias\alphavars_selected_nobias\alpha_`i'.dta", replace
restore

}

/*============================

   Unit-context models
   
============================*/
//global with candidate variables for unit context models

/*
global mycontextmun aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun 
*income_hh_mun

global mycontextpsu aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psuhh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu
*income_hh_psu
*/
global mycontextmun aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun 
*income_hh_mun

global mycontextpsu aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu

/*=========================================
Biased samples
*=========================================*/


set seed 648743

forvalues i=1(1)100 {

use "$rawsamples\bias11b11\selected\sample_`i'.dta", clear
keep psu_id* mun_id*   hid* pchinc $mycontextmun $mycontextpsu ln_pchinc weights FACTOR_res FACTOR_res2 state_*
tempfile sample`i'_complete
save `sample`i'_complete'

***Model selection using LASSO
set seed 648743

lasso linear ln_pchinc (state_1-state_26) $mycontextmun $mycontextpsu [iw=weights], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars_context=e(allvars_sel) //best model
global postlasso_context `hhvars_context'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso_context [iw=weights], r cluster(mun_id)
predict resid, residuals
bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $mycontextmun $mycontextpsu [iw=weights], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel_res
di "`e(allvars_sel)'"
local hhvarsres_context=e(allvars_sel) //best model
global postlassores_context `hhvarsres_context'


***Save samples and variables post lasso to run ELL and EBP
preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlasso_context 

save "$currdata\vars_selected_bias\context\bias11b11\betavars_selected_bias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\vars_selected_bias\context\bias11b11\alphavars_selected_bias\beta_`i'.dta", replace
restore
}




/*=========================================
Unbiased samples
*=========================================*/

set seed 648743

forvalues i=1(1)100 {

use "$rawsamples\nobias\selected\sample_`i'.dta", clear
keep psu_id* mun_id*   hid* pchinc $mycontextmun $mycontextpsu ln_pchinc weights FACTOR_res FACTOR_res2  state_*
tempfile sample`i'_complete
save `sample`i'_complete'

***Model selection using LASSO
set seed 648743

lasso linear ln_pchinc (state_1-state_26) $mycontextmun $mycontextpsu [iw=weights], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars_context=e(allvars_sel) //best model
global postlasso_context `hhvars_context'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso_context [iw=weights], r cluster(mun_id)
predict resid, residuals
bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $mycontextmun $mycontextpsu [iw=weights], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel_res
di "`e(allvars_sel)'"
local hhvarsres_context=e(allvars_sel) //best model
global postlassores_context `hhvarsres_context'


***Save samples and variables post lasso to run ELL and EBP
preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlasso_context 

save "$currdata\vars_selected_bias\context\nobias\betavars_selected_nobias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\vars_selected_bias\context\nobias\alphavars_selected_nobias\beta_`i'.dta", replace
restore
}
