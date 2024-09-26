clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_error\"
global census "$data\census_proc_MEX_2015.dta"



/*============================

   Unit-level models
   
============================*/

//global with candidate variables for unit level models
set seed 648743

global all_var wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old  aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu


/*=========================================
Large error
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\selected_high\sample_`i'.dta", clear

preserve
drop psu_id hid mun_id FACTOR FACTOR_res FACTOR_res2 state_* ln_pchinc pchinc fgt*

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
lasso linear ln_pchinc (state_1-state_31) $myvar [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
*predict y_hat

bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $myvar [iw=FACTOR], selection(bic, postselection) cluster(mun_id) 
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

save "$currdata\vars_selected_error\high\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\vars_selected_error\high\alphavars_selected\alpha_`i'.dta", replace
restore

}

/*=========================================
Smaller error
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\selected_low\sample_`i'.dta", clear

preserve
drop psu_id hid mun_id FACTOR FACTOR_res FACTOR_res2 state_* ln_pchinc pchinc fgt*

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
lasso linear ln_pchinc (state_1-state_31) $myvar [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
*predict y_hat

bys mun_id: egen resid_mun=mean(resid)
g stdev_sq=(resid-resid_mun)^2
egen max_stdev=max(stdev_sq)
g A=1.05*max_stdev
g trans_stdev=log(stdev_sq/(A-stdev_sq))
replace trans_stdev=0 if stdev_sq==0

lasso linear trans_stdev $myvar [iw=FACTOR], selection(bic, postselection) cluster(mun_id) 
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

save "$currdata\vars_selected_error\low\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\vars_selected_error\low\alphavars_selected\alpha_`i'.dta", replace
restore

}


