cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\"
global currdata "$data\MEX\census_2010\"
global samples "$currdata\samples\"
global census "$currdata\census_proc_MEX_2010.dta"
global simcensus "E:\SAE_project\MEX\2010\"
global results "$currdata\results_ell\context\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit context models
global mycontext aaux_sh_educ0_8 aaux_sh_educ9_13 aaux_sh_educ14_plus ALFABET ESCOACUM unemp informal hhsize income_hh educ_hh age_hh female_hh depen_ch depen_old wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet


set seed 648743

/*=========================================
Creating survey data for unit-context models
*=========================================*/
forvalues i=51(1)100 {

use "$simcensus\samples\sample_R_`i'.dta", clear
keep hid mun_id FACTOR pchinc FACTOR2
merge m:1 mun_id using "$currdata\census_mundata_MEX_2010.dta", keepusing($mycontext)
keep if _merge==3
drop _merge

/*=========================================
Model selection using LASSO
*=========================================*/
***Generating log per capita household income
g ln_pchinc=ln(pchinc)

 ***LASSO models to select variables for the models
set seed 648743
lasso linear ln_pchinc $mycontext [iw=FACTOR2], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/
***Saving selected variables for EBP models in R (BREAK)
preserve
keep mun_id hid ln_pchinc pchinc $postlasso FACTOR FACTOR2 
save "$simcensus\context\samples\sample_R_`i'.dta", replace
restore
preserve
use "$simcensus\census\census_R_`i'.dta", clear
keep hid mun_id popwt pchinc
***Generating log per capita household income
g ln_pchinc=ln(pchinc)
merge m:1 mun_id using "$currdata\census_mundata_MEX_2010.dta", keepusing($postlasso)
keep if _merge==3
drop _merge
save "$simcensus\context\census\census_R_`i'.dta", replace
restore
/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/

***Trying a model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR2],  area(mun_id) 

***Selecting the alpha model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR2], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model

// Macro holding all eligible vars
unab allvars : $mycontext
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

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR2], area(mun_id) zvar($alfa)  

char _dta[rhs] $postlasso
char _dta[alpha] $alfa
save "$currdata\mysvy_context.dta", replace

*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================
use "$currdata\mysvy_context.dta", clear
global hhmodel: char _dta[rhs] 
global alpha  : char _dta[alpha] 

use "$simcensus\census\census_R_`i'.dta", clear
keep hid mun_id popwt pchinc
merge m:1 mun_id using "$currdata\census_mundata_MEX_2010.dta", keepusing($mycontext)
keep if _merge==3
drop _merge
tempfile census
save `census'

// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($hhmodel $alpha popwt) area(mun_id) uniqid(hid) dataout("$currdata\census_mata_context")


use "$currdata\mysvy_context.dta", clear

sae sim elleb ln_pchinc $hhmodel [w=FACTOR2], area(mun_id) uniqid(hid) mcrep(100) bsrep(0) matin($currdata\census_mata_context) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(962.769947) /* ydump($results\test_`i') */
save "$results\mySAE_context_`i'.dta", replace

}


