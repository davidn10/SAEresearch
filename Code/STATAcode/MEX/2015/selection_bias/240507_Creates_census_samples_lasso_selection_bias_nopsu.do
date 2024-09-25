


clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"


global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_bias\"
global census "$data\census_proc_MEX_2010.dta"
global simcensus "$currdata\simcensus\bias"




/*============================

   Unit-context models with area level aggregates only  
   
============================*/
//global with candidate variables for unit context models
global mycontextmun aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun 
*income_hh_mun

*global mycontextpsu aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu
*income_hh_psu


/*=========================================
Biased samples
*=========================================*/

set seed 648743

forvalues i=1(1)100 {

use "$rawsamples\bias55\selected\sample_`i'.dta", clear
keep psu_id* mun_id*   hid* pchinc $mycontextmun  ln_pchinc FACTOR FACTOR_res FACTOR_res2 ENT state_*
tempfile sample`i'_complete
save `sample`i'_complete'

***Model selection using LASSO
set seed 648743

lasso linear ln_pchinc (state_1-state_31) $mycontextmun [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars_context=e(allvars_sel) //best model
global postlasso_context `hhvars_context'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso_context [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $mycontextmun [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
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

save "$currdata\vars_selected_bias\nopsu\bias55\betavars_selected_bias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\vars_selected_bias\nopsu\bias55\alphavars_selected_bias\beta_`i'.dta", replace
restore
}

set seed 648743

forvalues i=1(1)100 {

use "$rawsamples\bias11b11\selected\sample_`i'.dta", clear
keep psu_id* mun_id*   hid* pchinc $mycontextmun $mycontextpsu ln_pchinc FACTOR FACTOR_res FACTOR_res2 ENT state_*
tempfile sample`i'_complete
save `sample`i'_complete'

***Model selection using LASSO
set seed 648743

lasso linear ln_pchinc (state_1-state_31) $mycontextmun $mycontextpsu [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars_context=e(allvars_sel) //best model
global postlasso_context `hhvars_context'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso_context [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $mycontextmun $mycontextpsu [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
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

save "$currdata\vars_selected_bias\nopsu\bias11b11\betavars_selected_bias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\vars_selected_bias\nopsu\bias11b11\alphavars_selected_bias\beta_`i'.dta", replace
restore
}




/*=========================================
Unbiased samples
*=========================================*/

set seed 648743

forvalues i=1(1)100 {

use "$rawsamples\nobias\selected\sample_`i'.dta", clear
keep psu_id* mun_id*   hid* pchinc $mycontextmun ln_pchinc FACTOR FACTOR_res FACTOR_res2 ENT state_*
tempfile sample`i'_complete
save `sample`i'_complete'

***Model selection using LASSO
set seed 648743

lasso linear ln_pchinc (state_1-state_31) $mycontextmun [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars_context=e(allvars_sel) //best model
global postlasso_context `hhvars_context'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso_context [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $mycontextmun [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
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

save "$currdata\vars_selected_bias\nopsu\nobias\betavars_selected_nobias\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\vars_selected_bias\context\nobias\alphavars_selected_nobias\beta_`i'.dta", replace
restore
}
