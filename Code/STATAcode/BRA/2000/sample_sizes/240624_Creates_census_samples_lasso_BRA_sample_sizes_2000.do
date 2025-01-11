
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
* global currdata "D:\SAE_project\BRA\2010\full_census"

global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_new\"
global census "$data\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus_new\"


//global with candidate variables for unit level models
set seed 648743

* wall_improved wall_improved_mun wall_improved_psu motorcy motorcy_mun internet internet_mun  internet_psu motorcy_psu
 
global all_var over_crowding over_crowding_ext water_improved electri sewage own_house good_house  radio tele fridge washing auto compu cell  urban hhsize hhsize2  female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old aux_sh_primedu_mun  water_improved_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun  electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun  radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun  aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu  water_improved_psu electri_psu sewage_psu own_house_psu good_house_psu over_crowding_psu over_crowding_ext_psu  radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu 

/*=========================================
Creating simulates surveys
*=========================================*/

set sortseed 648743

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\sample1\selected\sample_`i'.dta", clear

preserve
drop hid mun_id psu_id FACTOR FACTOR_res FACTOR_res2 hid2 pchinc ln_pchinc fgt*  state_* 
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

save "$currdata\sample1\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\sample1\alphavars_selected\alpha_`i'.dta", replace
restore

}

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\sample2\selected\sample_`i'.dta", clear

preserve
drop hid mun_id psu_id FACTOR FACTOR_res FACTOR_res2 hid2 pchinc ln_pchinc fgt*  state_* 
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

save "$currdata\sample2\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\sample2\alphavars_selected\alpha_`i'.dta", replace
restore

}

forvalues i=1(1)100 {
***To select variables with same distribution in survey and census
use "$rawsamples\sample3\selected\sample_`i'.dta", clear

preserve
drop hid mun_id psu_id FACTOR FACTOR_res FACTOR_res2 hid2 pchinc ln_pchinc fgt*  state_* 
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

save "$currdata\sample3\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores
save "$currdata\sample3\alphavars_selected\alpha_`i'.dta", replace
restore

}

***Unit-context models
* wall_improved_mun wall_improved_psu internet_mun internet_psu motorcy_mun motorcy_psu
//global with candidate variables for unit context models 
global mycontextmun aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun  radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun  aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu  water_improved_psu electri_psu sewage_psu own_house_psu good_house_psu over_crowding_psu over_crowding_ext_psu  radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu 


set seed 648743
/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=1(1)100 {

use "$rawsamples\sample1\selected\sample_`i'.dta", clear

keep mun_id* psu_id  hid* pchinc $mycontextmun  ln_pchinc FACTOR FACTOR_res FACTOR_res2 state_*

tempfile sample`i'_complete
save `sample`i'_complete'

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743

lasso linear ln_pchinc (state_1-state_26) $mycontextmun  [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
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

lasso linear trans_stdev $mycontextmun [iw=FACTOR], selection(bic, postselection)  cluster(mun_id)
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

save "$currdata\sample1\context\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\sample1\context\alphavars_selected\alpha_`i'.dta", replace
restore
}

forvalues i=1(1)100 {

use "$rawsamples\sample2\selected\sample_`i'.dta", clear

keep mun_id* psu_id  hid* pchinc $mycontextmun  ln_pchinc FACTOR FACTOR_res FACTOR_res2 state_*

tempfile sample`i'_complete
save `sample`i'_complete'

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743

lasso linear ln_pchinc (state_1-state_26) $mycontextmun  [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
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

lasso linear trans_stdev $mycontextmun [iw=FACTOR], selection(bic, postselection)  cluster(mun_id)
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

save "$currdata\sample2\context\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\sample2\context\alphavars_selected\alpha_`i'.dta", replace
restore
}


forvalues i=1(1)100 {

use "$rawsamples\sample3\selected\sample_`i'.dta", clear

keep mun_id* psu_id  hid* pchinc $mycontextmun  ln_pchinc FACTOR FACTOR_res FACTOR_res2 state_*

tempfile sample`i'_complete
save `sample`i'_complete'

/*=========================================
Model selection using LASSO
*=========================================*/
 ***LASSO models to select variables for the models
set seed 648743

lasso linear ln_pchinc (state_1-state_26) $mycontextmun  [iw=FACTOR], selection(bic, postselection) cluster(mun_id)
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

lasso linear trans_stdev $mycontextmun [iw=FACTOR], selection(bic, postselection)  cluster(mun_id)
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

save "$currdata\sample3\context\betavars_selected\beta_`i'.dta", replace
restore

preserve
use `sample`i'_complete', clear
sort mun_id
keep if _n==1
keep $postlassores_context
save "$currdata\sample3\context\alphavars_selected\alpha_`i'.dta", replace
restore
}

