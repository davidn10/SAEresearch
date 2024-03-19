cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\s10_c15\full_census"
global rawsamples "$currdata\rawsamples\"


//global with candidate variables for unit level models
set seed 648743

/*=========================================
Creating simulates surveys
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\selected\sample_`i'.dta", clear

preserve
drop psu_id hid ENT mun_id FACTOR FACTOR_res FACTOR_res2 state_* ln_pchinc pchinc psu_id2 hid2 mun_id2 povline fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m /*fgt0_mun fgt0_m_mun fgt0_psu fgt0_m_psu*/

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
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=FACTOR], r
predict resid, residuals
*predict y_hat

bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $myvar [iw=FACTOR], selection(bic, postselection) 
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

save "$currdata\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\alphavars_selected\alpha_`i'.dta", replace
restore

}



***Unit-context models

//global with candidate variables for unit context models
global mycontextmun aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun 
*income_hh_mun

set seed 648743
/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$rawsamples\selected\sample_`i'.dta", clear

keep psu_id* mun_id*   hid* pchinc $mycontextmun ln_pchinc FACTOR FACTOR_res FACTOR_res2 ENT state_*

tempfile sample`i'_complete
save `sample`i'_complete'

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743

lasso linear ln_pchinc (state_1-state_31) $mycontextmun [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars_context=e(allvars_sel) //best model
global postlasso_context `hhvars_context'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso_context [iw=FACTOR], r
predict resid, residuals
bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $mycontextmun  [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel_res
di "`e(allvars_sel)'"
local hhvarsres_context=e(allvars_sel) //best model
global postlassores_context `hhvarsres_context'


/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)
***Save samples and variables post lasso to run ELL and EBP
preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlasso_context 

save "$currdata\context\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\context\alphavars_selected\alpha_`i'.dta", replace
restore
}

