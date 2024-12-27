clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
* global currdata "D:\SAE_project\BRA\2000\full_census"
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples_new\"
global census "$data\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\"
set seed 648743


global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu water_improved_psu electri_psu sewage_psu own_house_psu good_house_psu over_crowding_psu over_crowding_ext_psu motorcy_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu


forvalues x=1(1)3 {
forvalues i=1(1)100 {
/*=========================================
Direct estimates 
*=========================================*/
use "$currdata\rawsamples_new\sample`x'\selected\sample_`i'.dta", clear
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
use "$currdata\rawsamples_new\sample`x'\selected\sample_`i'.dta", clear
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
lasso linear poor_direct (state_1-state_26) $mysubarea  [iw=FACTOR_res], selection(bic, postselection) cluster(mun_id)
estimates store model
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Save samples and variables post lasso to run ELL and EBP
sort psu_id
keep $postlasso FACTOR mun_id psu_id poor_direct

save "$currdata\subarea_ebp\sample`x'\subebp_`i'.dta", replace


} 
}
