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
global simcensus "D:\SAE_project\MEX\2010\states\"
global results "$currdata\results_SAEf\"
global simcensuslocal "$currdata\simcensus\"

set seed 648743


/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\rankcorr_SAEf_subarea", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus\census\census_states.dta", clear
keep mun_id 
duplicates drop
merge 1:m mun_id using "$simcensus\samples\sample_R_`i'.dta"
recode _merge (1=0) (3=1)
rename _merge in_sample
keep mun_id in_sample
duplicates drop
tempfile sample
save `sample'


/*=========================================
Rank correlations 
*=========================================*/

use "$results\SAEf_sample_R_`i'.dta.dta", clear
rename mun_id mun_id_aux
decode mun_id_aux, g(mun_id)
destring mun_id, replace
rename Mean sim_fgt0

merge 1:1 mun_id using `sample'
drop _merge

merge 1:1 mun_id using "$mdata\full_census\simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$mdata\full_census\simcensus\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir

merge 1:1 mun_id using "$mdata\full_census\simcensus\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dirs
rename  fgt1_m fgt1_dirs
rename  fgt2_m fgt2_dirs

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dirs sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

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
corr fgt0_dirs sim_fgt0 
local rhods2_`i'=r(rho)
local Nds2_`i'=r(N)
corr fgt0_dir fgt0_true
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhods_`i''
putexcel E`i'=`rhodt_`i''

putexcel G`i'=`N_`i''
putexcel H`i'=`Nin_`i''
putexcel I`i'=`Nout_`i''
putexcel J`i'=`Nds_`i''
putexcel K`i'=`Ndt_`i''

putexcel M`i'=`rho2_`i''
putexcel N`i'=`rhoin2_`i''
putexcel O`i'=`rhoout2_`i''
putexcel P`i'=`rhods2_`i''
putexcel Q`i'=`rhodt2_`i''

putexcel S`i'=`N2_`i''
putexcel T`i'=`Nin2_`i''
putexcel U`i'=`Nout2_`i''
putexcel V`i'=`Nds2_`i''
putexcel W`i'=`Ndt2_`i''

di "`i'"
}

