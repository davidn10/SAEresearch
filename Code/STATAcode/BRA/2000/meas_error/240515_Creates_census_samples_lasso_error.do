* BRA 2000 version 
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
* global currdata "D:\SAE_project\MEX\2010\full_census_new"
global currdata "H:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_error\"
global census0 "$currdata\census\census.dta"



/*============================

   Unit-level models
   
============================*/

//global with candidate variables for unit level models
set seed 648743

global all_var over_crowding over_crowding_ext water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC hhsize female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old hhsize2 aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu


/*=========================================
Large error
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\selected_high\sample_`i'.dta", clear

preserve
drop hid mun_id psu_id FACTOR hid2 pchinc ln_pchinc fgt0_m  state_* 
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
lasso linear ln_pchinc (state_1-state_26) $myvar [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
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
drop hid mun_id psu_id FACTOR hid2 pchinc ln_pchinc fgt0_m  state_* 
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
lasso linear ln_pchinc (state_1-state_26) $myvar [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***OLS and LASSO to get variables for alpha model in ELL
reg ln_pchinc $postlasso [iw=FACTOR], r cluster(mun_id)
predict resid, residuals
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


