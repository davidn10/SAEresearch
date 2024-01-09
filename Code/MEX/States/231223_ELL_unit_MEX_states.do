cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\census_2010\"
global currdata "$data\MEX\census_2010\states\"
global samples "$mdata\samples\"
global census "$mdata\census_proc_MEX_2010.dta"
global simcensus "D:\SAE_project\MEX\2010\"
global results "$currdata\results_ell\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit level models
global myvar wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu educ_hh_psu age_hh_psu female_hh_psu
*income_hh
*income_hh_mun
*income_hh_psu

set seed 648743

use "$census", clear

***Correct weights
g popwt=FACTOR*hhsize

***Logaritm of per capita income
g ln_pchinc=ln(pchinc)

***Squared household size
g hhsize2=hhsize*hhsize

***Number of HH per UPM
g aux=1
bys psu_id: egen numberhh_upm=sum(aux)
drop aux*

***Generate state dummy variables
tab ENT, g(state_)

keep $myvar popwt psu_id* mun_id* hid* strata* pchinc ln_pchinc povline fgt* ENT state_*

keep if ENT=="20" | ENT=="14" | ENT=="07" //Oaxaca, Jalisco, Chiapas
tempfile states
save `states'
save "$simcensus\states\census\census_states.dta", replace

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensuslocal\true_states_fg0.dta", replace

/*=========================================
Saving census in mata format
*=========================================*/
use `states', clear
tempfile census
save `census'
// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($myvar popwt) area(mun_id) uniqid(hid) dataout("$currdata\census_mata") 


/*=========================================
Creating simulates surveys
*=========================================*/
putexcel set "$results\model_metrics", replace


forvalues i=1(1)100 {

use "$simcensus\full_census\rawsamples\sample_`i'.dta", clear

merge 1:1 hid using `states'
keep if _merge==3

keep psu_id* mun_id*  strata*  hid* pchinc $myvar ln_pchinc povline fgt* FACTOR FACTOR_res FACTOR_res2 ENT state_*

tempfile sample`i'_complete
save `sample`i'_complete'


/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models
*use "$samples\sample1_complete.dta", clear
use `sample`i'_complete', clear

***Lasso models
/*
set seed 648743
lasso linear ln_pchinc $myvar [iw=FACTOR], nolog rseed(648743)
estimates store cvmodel
di "`e(allvars_sel)'"
local cvmodel=e(allvars_sel) 

lasso linear ln_pchinc $myvar [iw=FACTOR], nolog rseed(648743) selection(adaptive)
estimates store adapmodel
di "`e(allvars_sel)'"
local adapmodel=e(allvars_sel) 

lasso linear ln_pchinc $myvar [iw=FACTOR], selection(plugin) 
estimates store plugmodel
di "`e(allvars_sel)'"
local pluginmodel=e(allvars_sel) 
lassocoef cvmodel adapmodel plugmodel bicmodel, display(coef, postselection)
*/
lasso linear ln_pchinc $myvar  [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

lasso linear ln_pchinc $myvar  [iw=FACTOR_res], selection(bic, postselection) 
estimates store bicmodel2
di "`e(allvars_sel)'"
local hhvarsres=e(allvars_sel) //best model
global postlassores `hhvarsres'

lasso linear ln_pchinc $myvar  [iw=FACTOR_res2], selection(bic, postselection) 
estimates store model2
di "`e(allvars_sel)'"
local hhvarsres2=e(allvars_sel) //best model
global postlassores2 `hhvarsres2'

***Trying a model
*set seed 648743
*sae model ell ln_pchinc $postlasso [aw=FACTOR],  area(mun_id) 
*sae model ell ln_pchinc $postlassores [aw=FACTOR_res2],  area(mun_id) 

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

***Using rescaled weights
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

***Using rescaled weights
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
keep $postlasso /*$alfa*/ FACTOR_res2 FACTOR_res FACTOR mun_id hid psu_id pchinc ln_pchinc povline fgt* ENT state_*
save "$simcensus\states\samples\sample_R_`i'.dta", replace

use `sample`i'_complete', clear
keep $postlassores /*$alfa*/ FACTOR_res2 FACTOR_res FACTOR mun_id hid psu_id pchinc ln_pchinc povline fgt* ENT state_*
save "$simcensus\states\samplesres\sample_R_`i'.dta", replace

use `sample`i'_complete', clear
keep $postlassores2 /*$alfa*/ FACTOR_res2 FACTOR_res FACTOR mun_id hid psu_id pchinc ln_pchinc povline fgt* ENT state_*
save "$simcensus\states\samplesres2\sample_R_`i'.dta", replace

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
sae sim ell ln_pchinc $hhmodel [w=FACTOR], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(962.769947) allmata /* ydump($results\test_`i') */ 
save "$results\unit\mySAE_`i'.dta", replace

***Unisg rescaled weights
use "$currdata\mysvyres.dta", clear
global hhmodelres: char _dta[rhs] 
global alphares  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres [w=FACTOR_res], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alphares) seed(`seed')  lny plines(962.769947) allmata /* ydump($results\test_`i') */ 
save "$results\unit\mySAEres_`i'.dta", replace


***Unisg rescaled weights
use "$currdata\mysvyres2.dta", clear
global hhmodelres2: char _dta[rhs] 
global alphares2  : char _dta[alpha] 

drop if ln_pchinc==.
bys mun_id: g obs=_N
drop if obs<4
sae sim ell ln_pchinc $hhmodelres2 [w=FACTOR_res2], area(mun_id) uniqid(hid) eta(normal) epsilon(normal) rep(100) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alphares2) seed(`seed')  lny plines(962.769947) allmata /* ydump($results\test_`i') */ 
save "$results\unit\mySAEres2_`i'.dta", replace
}


