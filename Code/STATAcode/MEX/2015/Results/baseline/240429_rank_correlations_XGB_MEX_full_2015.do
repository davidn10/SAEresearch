

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\results_xgb\"
global simcensus "$currdata\simcensus\"

set seed 648743


/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\rankcorr_xgb", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$census\census.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
merge 1:m mun_id using "$rawsamples\selected\sample_`i'.dta"
keep mun_id _merge num_hh
duplicates drop 
g small_mun=(num_hh<500) //small municipalities around 12%
recode _merge (1=0) (3=1)
rename _merge in_sample
tempfile insample
save `insample'

/*=========================================
Rank correlations 
*=========================================*/

use "$results\output\sim_xgb_sample_`i'", clear
destring Domain Mean, replace
rename Domain mun_id
rename Mean sim_fgt0

merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''

putexcel G`i'=`N_`i''
putexcel H`i'=`Nin_`i''
putexcel I`i'=`Nout_`i''


putexcel M`i'=`rho2_`i''
putexcel N`i'=`rhoin2_`i''
putexcel O`i'=`rhoout2_`i''

putexcel S`i'=`N2_`i''
putexcel T`i'=`Nin2_`i''
putexcel U`i'=`Nout2_`i''



di "`i'"
}




