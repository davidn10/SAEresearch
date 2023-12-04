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
global results "$currdata\results_ell\"
global simcensuslocal "$currdata\simcensus\"

//global with candidate variables for unit level models
global myvar hhsize female_hh educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding stove shower radio tele fridge washing auto compu cell internet hhsize2 educ_mun unemp_mun informal_mun hhsize_mun incomehh_mun educhh_mun agehh_mun educ_psu unemp_psu informal_psu hhsize_psu incomehh_psu educhh_psu agehh_psu



set seed 648743

/*=========================================
Creating simulates surveys
*=========================================*/
forvalues i=50(1)100 {
//Create survey data
use "$census", clear

keep psu_id hid TAM_LOC

merge m:1 psu_id using "$samples\sample_`i'.dta"
keep if _merge==3
drop _merge

***Selection of HH
preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
set sortseed 54321
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_upm
tempfile sample_20
save `sample_20'
restore

preserve
keep if TAM_LOC==4
set sortseed 54321
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_upm
tempfile sample_5
save `sample_5'
restore

/*==============================
Create samples
===============================*/
use `sample_20', clear
append using `sample_5'

merge 1:1 hid using "$census"

***Correct weights
g popwt=FACTOR*hhsize

***Logaritm of per capita income
*drop if pchinc<1 //Remove small incomes affecting model
g ln_pchinc=ln(pchinc)
*lnskew0 double tr_pchinc = exp(pchinc) //Log shift transformation to approximate normality

***Squared household size
g hhsize2=hhsize*hhsize

***Number of HH per UPM
g aux=1
bys psu_id: egen numberhh_upm=sum(aux)
drop aux*

***Separating sample and census
preserve

keep if _merge==3

***Probability of HH being selected
g aux=1
bys psu_id: egen num_hh_select=sum(aux)
drop aux

g prob_select_hh= num_hh_select/numberhh_upm
*sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_upm
*sum prob_select
gen factor_sample=(1/prob_select)

g factor_total=factor_sample*popwt
/*
egen test=sum(factor_sample)
sum test
egen test2=sum(factor_total)
sum test2
*/ 
***Generating a rescaled weights
***Total weights
bys mun_id: egen totw=sum(factor_total)
g factor2=factor_total/totw
rename factor2 FACTOR2
keep psu_id* mun_id*  strata* factor_total hid* pchinc $myvar ln_pchinc povline fgt* FACTOR2
rename factor_total FACTOR
*sum wall_improved roof_improved floor_improved hhsize pchinc female_hh

tempfile sample`i'_complete
save `sample`i'_complete'
*save "$samples\sample1_complete.dta", replace
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

keep if _merge==2

keep psu_id* mun_id*  strata* popwt hid* pchinc $myvar ln_pchinc  povline fgt*
*sum pchinc hhsize wall_improved roof_improved floor_improved

tempfile census`i'_complete
save `census`i'_complete'

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensuslocal\true_fg0_`i'.dta", replace


/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models
*use "$samples\sample1_complete.dta", clear
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
keep $postlasso /*$alfa*/ popwt mun_id hid psu_id pchinc ln_pchinc povline fgt*
save "$simcensus\census\census_R_`i'.dta", replace

use `sample`i'_complete', clear
keep $postlasso /*$alfa*/ FACTOR2 mun_id hid psu_id pchinc ln_pchinc povline fgt*
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

use `census`i'_complete', clear
tempfile census
save `census'

// Create data ready for SAE - optimized dataset
sae data import, datain(`census') varlist($hhmodel $alpha popwt) area(mun_id) uniqid(hid) dataout("$currdata\census_mata")


use "$currdata\mysvy.dta", clear

sae sim elleb ln_pchinc $hhmodel [w=FACTOR2], area(mun_id) uniqid(hid) mcrep(100) bsrep(0) matin($currdata\census_mata) indicators(fgt0 fgt1) aggids(3 0 6) pwcensus(popwt) zvar($alpha) seed(`seed')  lny plines(962.769947) /* ydump($results\test_`i') */
save "$results\unit\mySAE_`i'.dta", replace

**link poverty line calculations: https://www.coneval.org.mx/Medicion/Paginas/Pobreza-2010.aspx#:~:text=Derivado%20de%20lo%20anterior%2C%20la,personas%20entre%202008%20y%202010.
}

*https://www.coneval.org.mx/Medicion/Paginas/ITLP-IS_pobreza_laboral.aspx#:~:text=El%20porcentaje%20de%20la%20poblaci%C3%B3n%20con%20ingreso%20laboral%20inferior%20al,%25%20a%2037.8%25%2C%20respectivamente.

*sae proc indicator, matasource($results\test_1) aggids(3 0 6)

*GRF "https://grf-labs.github.io/grf/"
