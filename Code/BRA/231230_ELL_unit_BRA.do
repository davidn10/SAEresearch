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
global simcensus "D:\SAE_project\BRA\2010\"
global results "$currdata\results_ell\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit level models
global myvar over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet urban hhsize hhsize2  female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun  hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun

*income_hh income_hh_mun

set seed 648743

use "$census", clear

***Correct weights
g popwt=weights*hhsize

***Logaritm of per capita income
g ln_pchinc=ln(pchinc)

***Squared household size
g hhsize2=hhsize*hhsize

keep $myvar popwt mun_id* hid* pchinc ln_pchinc fgt* 

*keep if ENT=="20" | ENT=="14" | ENT=="07" //Oaxaca, Jalisco, Chiapas
tempfile states
save `states'
save "$simcensus\census\census.dta", replace

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensuslocal\true_fg0_full.dta", replace

/*=========================================
Saving census in mata format
*=========================================*/
use "$simcensus\census\census.dta", clear
tempfile census
save `census'

// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($myvar popwt) area(mun_id) uniqid(hid) dataout("$currdata\census_mata")

/*=========================================
Creating simulates surveys
*=========================================*/
putexcel set "$results\model_metrics", replace

forvalues i=1(1)100 {
//Create survey data

use "$simcensus\census\census.dta", clear

merge 1:1 hid using "$samples\sample_`i'.dta", keepusing(hid mun_id FACTOR FACTOR_res FACTOR_res2)
keep if _merge==3
drop _merge

keep  mun_id*  hid* pchinc $myvar ln_pchinc  fgt* FACTOR FACTOR_res FACTOR_res2
tempfile sample`i'_complete
save `sample`i'_complete'

preserve
use `sample`i'_complete', clear
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR], by(mun_id)
save "$simcensuslocal\direct_fg0_`i'.dta", replace
restore
preserve
use `sample`i'_complete', clear
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensuslocal\direct_resc_fg0_`i'.dta", replace
restore
preserve
use `sample`i'_complete', clear
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensuslocal\direct_resc2_fg0_`i'.dta", replace
restore

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
lasso linear ln_pchinc $myvar [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

set seed 648743
lasso linear ln_pchinc $myvar [iw=FACTOR_res], selection(bic, postselection) 
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'

set seed 648743
lasso linear ln_pchinc $myvar [iw=FACTOR_res2], selection(bic, postselection) 
estimates store bicmodel3
di "`e(allvars_sel)'"
local hhvarsres2=e(allvars_sel) //best model
global postlassores2 `hhvarsres2'

***Trying a model
*set seed 648743
*sae model ell ln_pchinc $postlasso [aw=FACTOR],  area(mun_id) 
*sae model ell ln_pchinc $postlassores [aw=FACTOR_res],  area(mun_id) 

***Selecting the alpha model
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa1
rename residual_xb residual_xb1

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
lasso linear residual_alfa1 `A' [iw=FACTOR], selection(bic, postselection) 
local alfa=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfa `alfa'

***rescaled weights*hhsize
set seed 648743
sae model ell ln_pchinc $postlassores [aw=FACTOR_res], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa2
rename residual_xb residual_xb2

// Macro holding all eligible vars
unab allvars : $myvar
//Macro with current variables
local nogo $postlassores
//We want to only use variables not used
foreach x of local allvars{
local in = 0
foreach y of local nogo{
if ("`x'"=="`y'") local in=1
}
if (`in'==0) local B `B' `x'
}
global B `B' //macro holding eligible variables for alpha model

set seed 648743
lasso linear residual_alfa2 `B' [iw=FACTOR_res], selection(bic, postselection) 
local alfares=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfares `alfares'

***rescaled weights*hhsize
set seed 648743
sae model ell ln_pchinc $postlassores2 [aw=FACTOR_res2], area(mun_id) alfatest(residual) zvar(hhsize) 
des residual_alfa //The dependent variable for the alfa model
rename residual_alfa residual_alfa3
rename residual_xb residual_xb3

// Macro holding all eligible vars
unab allvars : $myvar
//Macro with current variables
local nogo $postlassores2
//We want to only use variables not used
foreach x of local allvars{
local in = 0
foreach y of local nogo{
if ("`x'"=="`y'") local in=1
}
if (`in'==0) local B `B' `x'
}
global B `B' //macro holding eligible variables for alpha model

set seed 648743
lasso linear residual_alfa3 `B' [iw=FACTOR_res2], selection(bic, postselection) 
local alfares2=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfares2 `alfares2'

***Save samples and variables post lasso to run EBP in R
preserve
use `sample`i'_complete', clear
keep $postlasso /*$alfa*/ FACTOR_res FACTOR_res2 FACTOR mun_id hid pchinc ln_pchinc  fgt*
save "$simcensus\samples\sample_R_`i'.dta", replace

use `sample`i'_complete', clear
keep $postlassores /*$alfa*/ FACTOR_res FACTOR_res2 FACTOR mun_id hid pchinc ln_pchinc  fgt*
save "$simcensus\samplesres\sample_R_`i'.dta", replace

use `sample`i'_complete', clear
keep $postlassores2 /*$alfa*/ FACTOR_res FACTOR_res2 FACTOR mun_id hid pchinc ln_pchinc  fgt*
save "$simcensus\samplesres2\sample_R_`i'.dta", replace

restore

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================

preserve
set seed 648743
sae model ell ln_pchinc $postlasso [aw=FACTOR], area(mun_id) zvar($alfa)  
local r2_`i'=e(r2_beta)
local rmse_`i'=e(rmse_beta)
putexcel A`i'=`r2_`i''
putexcel E`i'=`rmse_`i''
char _dta[rhs] $postlasso
char _dta[alpha] $alfa
save "$currdata\mysvy.dta", replace
restore

preserve
set seed 648743
sae model ell ln_pchinc $postlassores [aw=FACTOR_res], area(mun_id) zvar($alfares)
local r2_res_`i'=e(r2_beta)
local rmse_res_`i'=e(rmse_beta)  
putexcel B`i'=`r2_res_`i''
putexcel F`i'=`rmse_res_`i''
char _dta[rhs] $postlassores
char _dta[alpha] $alfares
save "$currdata\mysvyres.dta", replace
restore

preserve
set seed 648743
sae model ell ln_pchinc $postlassores2 [aw=FACTOR_res2], area(mun_id) zvar($alfares2)
local r2_res2_`i'=e(r2_beta)
local rmse_res2_`i'=e(rmse_beta) 
putexcel C`i'=`r2_res2_`i'' 
putexcel G`i'=`rmse_res2_`i''
char _dta[rhs] $postlassores2
char _dta[alpha] $alfares2
save "$currdata\mysvyres2.dta", replace
restore

*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================

use "$currdata\mysvy.dta", clear
global hhmodel: char _dta[rhs] 
global alpha  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodel [w=FACTOR], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(0 7) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(163.8265625) allmata /* ydump($results\test_`i') */ 
save "$results\unit\mySAE_`i'.dta", replace


***Unisg rescaled weights
use "$currdata\mysvyres.dta", clear
global hhmodelres: char _dta[rhs] 
global alphares  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres [w=FACTOR_res], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(0 7) pwcensus(popwt) zvar($alphares) seed(`seed')  lny plines(163.8265625) allmata /* ydump($results\test_`i') */ 
save "$results\unit\mySAEres_`i'.dta", replace


***Unisg rescaled weights
use "$currdata\mysvyres2.dta", clear
global hhmodelres2: char _dta[rhs] 
global alphares2  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres2 [w=FACTOR_res2], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(0 7) pwcensus(popwt) zvar($alphares2) seed(`seed')  lny plines(163.8265625) allmata /* ydump($results\test_`i') */ 
save "$results\unit\mySAEres2_`i'.dta", replace
}


