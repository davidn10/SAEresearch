cd "C:\Users\melyg\Desktop\SAE_Project\data\BRA"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global currdata "$data\BRA\"
global samples "$currdata\samples\"
global census "$currdata\census_proc_BRA_2010.dta"
global simcensus "E:\SAE_project\BRA\2010\"
global results "$currdata\results_ell\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit level models
global myvar over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet urban hhsize hhsize2 income_hh female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old sh_primedu_mun sh_secedu_mun sh_supedu_mun sh_noedu_mun sh_literate_mun unemp_mun informal_mun hhsize_mun incomehh_mun agehh_mun femalehh_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun



set seed 648743

/*=========================================
Creating simulates surveys
*=========================================*/
forvalues i=1(1)100 {
//Create survey data
use "$census", clear

merge m:1 hid using "$samples\sample_`i'.dta", keepusing(hid mun_id factor_total)
*drop _merge

***Correct weights
g popwt=weights*hhsize

***Logaritm of per capita income
g ln_pchinc=ln(pchinc)

***Squared household size
g hhsize2=hhsize*hhsize


***Separating sample and census
preserve
keep if _merge==3

***Generating a rescaled weights
***Total weights
bys mun_id: egen totw=sum(factor_total)
g factor2=factor_total/totw
rename factor2 FACTOR2
rename factor_total FACTOR

keep  mun_id*  hid* pchinc $myvar ln_pchinc povline* fgt* FACTOR FACTOR2
tempfile sample`i'_complete
save `sample`i'_complete'
restore

preserve
use `sample`i'_complete', clear
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR], by(mun_id)
save "$simcensuslocal\direct_fg0_`i'.dta", replace
restore
preserve
use `sample`i'_complete', clear
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR2], by(mun_id)
save "$simcensuslocal\direct_resc_fg0_`i'.dta", replace
restore

keep if _merge==1

keep mun_id*  popwt hid* pchinc $myvar ln_pchinc  povline* fgt*

tempfile census`i'_complete
save `census`i'_complete'

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensuslocal\true_fg0_`i'.dta", replace


/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models
use `sample`i'_complete', clear

***Lasso models
/*
lasso linear ln_pchinc $myvar [iw=FACTOR], nolog rseed(12345)
estimates store cvmodel
di "`e(allvars_sel)'"
local cvmodel=e(allvars_sel) 

lasso linear ln_pchinc $myvar [iw=FACTOR], nolog rseed(12345) selection(adaptive)
estimates store adapmodel
di "`e(allvars_sel)'"
local adapmodel=e(allvars_sel) 

lasso linear ln_pchinc $myvar [iw=FACTOR], selection(plugin) 
estimates store plugmodel
di "`e(allvars_sel)'"
local pluginmodel=e(allvars_sel) 
lassocoef cvmodel adapmodel plugmodel bicmodel, display(coef, postselection)
*/
set seed 648743
lasso linear ln_pchinc $myvar [iw=FACTOR2], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Trying a model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR2],  area(mun_id) 

***Selecting the alpha model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR2], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model

// Macro holding all eligible vars
unab allvars : $myvar
//Macro with current variables
local nogo $postlasso
//We want to only use variables not used
foreach x of local allvars{
local in = 0
foreach y of local nogo{
if ("`x'"=="`y'") local in=1
}
if (`in'==0) local A `A' `x'
}
global A `A' //macro holding eligible variables for alpha model

set seed 648743
lasso linear residual_alfa `A' [iw=FACTOR2], selection(bic, postselection) 
local alfa=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfa `alfa'

***Save samples and variables post lasso to run EBP in R
preserve
use `census`i'_complete', clear
keep $postlasso /*$alfa*/ popwt mun_id hid pchinc ln_pchinc povline* fgt*
save "$simcensus\census\census_R_`i'.dta", replace

use `sample`i'_complete', clear
keep $postlasso /*$alfa*/ FACTOR2 FACTOR mun_id hid pchinc ln_pchinc povline* fgt*
save "$simcensus\samples\sample_R_`i'.dta", replace
restore

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR2], area(mun_id) zvar($alfa)  

char _dta[rhs] $postlasso
char _dta[alpha] $alfa
save "$currdata\mysvy.dta", replace

*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================
use "$currdata\mysvy.dta", clear
global hhmodel: char _dta[rhs] 
global alpha  : char _dta[alpha] 

use `census1_complete', clear
tempfile census
save `census'

// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($hhmodel $alpha popwt) area(mun_id) uniqid(hid) dataout("$currdata\census_mata")


use "$currdata\mysvy.dta", clear

sae sim elleb ln_pchinc $hhmodel [w=FACTOR2], area(mun_id) uniqid(hid) mcrep(100) bsrep(0) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(0 7) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(163.8265625) /* ydump($results\test_`i') */
save "$results\unit\mySAE_`i'.dta", replace


}

