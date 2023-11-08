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
global simcensus "$currdata\simcensus\"

//global with candidate variables.
global myvar hhsize female_hh educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding stove shower radio tele fridge washing auto compu cell internet *_mun educ_psu unemp_psu informal_psu hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu hhsize2

set seed 648743

/*=========================================
Creating simulates surveys
*=========================================*/

//Create survey data
use "$census", clear

***Logaritm of per capita income
*drop if pchinc<1 //Remove small incomes affecting model
g ln_pchinc=ln(pchinc)
*lnskew0 double tr_pchinc = exp(pchinc) //Log shift transformation to approximate normality

***Squared household size
g hhsize2=hhsize*hhsize

***Number of HH per UPM
g aux=1
bys psu_id: egen numberhh_upm=sum(aux)
drop aux

merge m:1 psu_id using "$samples\sample_1.dta"

***Selection of HH
preserve
keep if _merge==3
keep if TAM_LOC>=1 & TAM_LOC<=3
set sortseed 54321
sample 24, count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh
tempfile sample_24
save `sample_24'
restore

preserve
keep if _merge==3
keep if TAM_LOC==4
set sortseed 54321
sample 6, count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh
tempfile sample_6
save `sample_6'
restore

preserve
use `sample_24', clear
append using `sample_6'
tempfile sample_hh
save `sample_hh'
restore

rename _merge merge_psu

merge m:1 hid using `sample_hh'

preserve
keep if _merge==3

***Probability of HH being selected
g aux=1
bys psu_id: egen num_hh_select=sum(aux)
drop aux

g prob_select_hh= num_hh_select/numberhh_upm
sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_upm
sum prob_select
gen factor_sample=(1/prob_select)

g factor_total=factor_sample*FACTOR


egen test=sum(factor_sample)
sum test
egen test2=sum(factor_total)
sum test2

keep psu_id* mun_id*  strata* factor_total hid* pchinc $myvar ln_pchinc 
rename factor_total FACTOR

tempfile sample1_complete
save `sample1_complete'
save "$samples\sample1_complete.dta", replace
restore

keep if _merge==1
keep psu_id* mun_id*  strata* FACTOR hid* pchinc $myvar ln_pchinc 
tempfile census1_complete
save `census1_complete'
save "$simcensus\census1_complete.dta", replace


/*=========================================
Model selection using LASSO
*=========================================*/
 
***LASSO models to select variables for the models

use "$samples\sample1_complete.dta", clear

g uno="1"
egen hhid=concat(uno hid2)
destring hhid, replace
format hhid %20.0g

egen mun=concat(uno mun_id2)
destring mun, replace

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
lasso linear ln_pchinc $myvar [iw=FACTOR], selection(bic, postselection) 
estimates store bicmodel
di "`e(allvars_sel)'"
local hhvars=e(allvars_sel) //best model
global postlasso `hhvars'

***Trying a model
sae model lmm ln_pchinc $postlasso [aw=FACTOR],  area(mun) varest(h3)

***Selecting the alpha model
sae model lmm ln_pchinc $postlasso [aw=FACTOR], area(mun) alfatest(residual) zvar(hhsize) varest(h3)
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

lasso linear residual_alfa `A' [iw=FACTOR], selection(bic, postselection) 
local alfa=e(allvars_sel) //best model
di "`e(allvars_sel)'"
global alfa `alfa'

*===============================================================================
// SAVE the data with the pertinent covariates and other info
*===============================================================================
sae model lmm ln_pchinc $postlasso [aw=FACTOR], area(mun) zvar($alfa) varest(h3) vce(ell)

char _dta[rhs] $postlasso
char _dta[alpha] $alfa
save "$currdata\mysvy.dta", replace

