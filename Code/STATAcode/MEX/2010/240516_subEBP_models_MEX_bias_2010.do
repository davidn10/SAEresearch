clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2010\full_census_new"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_bias\"
global census "$data\census_proc_MEX_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\"
set seed 648743


global myarea aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu


***Census data
use "$currdata\census\census_bias.dta", clear
keep psu_id popwt mun_id state_*
collapse (mean) mun_id state_* (rawsum) popwt, by(psu_id)
merge 1:m psu_id using "$census", keepusing($myarea)
keep if _merge==3
duplicates drop
drop _merge
save "$currdata\census\census_subebp_bias.dta", replace



forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$currdata\rawsamples_bias\bias55\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep psu_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(psu_id) 

tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$currdata\rawsamples_bias\bias55\selected\sample_`i'.dta", clear
*drop fgt0_psu fgt0_m_psu fgt0_mun fgt0_m_mun

preserve
keep *_psu *_mun
ds
local mysubarea=r(varlist)
global mysubarea `mysubarea'
restore

keep  psu_id mun_id *_psu state_* *_mun
duplicates drop 
merge 1:1 psu_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $mysubarea  [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Save samples and variables post lasso to run ELL and EBP
sort psu_id
keep $postlasso FACTOR mun_id psu_id poor_direct

save "$currdata\subarea_ebp\bias55\subebp_`i'.dta", replace


} 


forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$currdata\rawsamples_bias\bias11b11\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep psu_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(psu_id) 

tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$currdata\rawsamples_bias\bias11b11\selected\sample_`i'.dta", clear
*drop fgt0_psu fgt0_m_psu fgt0_mun fgt0_m_mun

preserve
keep *_psu *_mun
ds
local mysubarea=r(varlist)
global mysubarea `mysubarea'
restore

keep  psu_id mun_id *_psu state_* *_mun
duplicates drop 
merge 1:1 psu_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $mysubarea  [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Save samples and variables post lasso to run ELL and EBP
sort psu_id
keep $postlasso FACTOR mun_id psu_id poor_direct

save "$currdata\subarea_ebp\bias11b11\subebp_`i'.dta", replace


} 

forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$currdata\rawsamples_bias\nobias\selected\sample_`i'.dta", clear
drop if FACTOR<=1

direct fgt0_m [aw=FACTOR], by(psu_id) gen(poor_direct)
gen poor_direct_var=poor_direct_SD^2 

keep psu_id poor_direct poor_direct_var FACTOR FACTOR_res FACTOR_res2

collapse (mean) poor_direct poor_direct_var (rawsum) FACTOR FACTOR_res FACTOR_res2 [aw=FACTOR] , by(psu_id) 

tempfile direct
save `direct'

/*=========================================
Merging data
*=========================================*/
use "$currdata\rawsamples_bias\nobias\selected\sample_`i'.dta", clear
*drop fgt0_psu fgt0_m_psu fgt0_mun fgt0_m_mun

preserve
keep *_psu *_mun
ds
local mysubarea=r(varlist)
global mysubarea `mysubarea'
restore

keep  psu_id mun_id *_psu state_* *_mun
duplicates drop 
merge 1:1 psu_id using `direct' 
drop _merge


/*=========================================
Model selection using LASSO
*=========================================*/
set seed 648743
lasso linear poor_direct (state_1-state_31) $mysubarea  [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Save samples and variables post lasso to run ELL and EBP
sort psu_id
keep $postlasso FACTOR mun_id psu_id poor_direct

save "$currdata\subarea_ebp\nobias\subebp_`i'.dta", replace


} 

