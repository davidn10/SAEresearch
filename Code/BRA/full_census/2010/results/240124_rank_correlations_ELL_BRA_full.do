cd "C:\Users\melyg\Desktop\SAE_Project\data\BRA"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\BRA\2010\full_census"
global data "$currdata\rawdata\"
global rawsamples "$currdata\rawsamples\"
global census "$data\census_proc_BRA_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\results_ell\"

set seed 648743

/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\rankcorr_ELL_unit", replace

forvalues i=1(1)100 {

use "$currdata\census\census.dta", clear
keep mun_id 
duplicates drop
merge 1:m mun_id using "$currdata\samples\sample_R_`i'.dta"
keep mun_id _merge
duplicates drop 
recode _merge (1=0) (3=1)
rename _merge insample
tempfile insample
save `insample'

/*=========================================
Rank correlations 
*=========================================*/
use "$results\unit\output\mySAE_`i'", clear
keep avg_fgt0_163_8266 Unit
drop if Unit==0
rename Unit mun_id
rename avg_fgt0_163_8266 sim_fgt0_out
merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhodt_`i''

putexcel F`i'=`N_`i''
putexcel G`i'=`Nin_`i''
putexcel H`i'=`Nout_`i''
putexcel I`i'=`Ndt_`i''

putexcel K`i'=`rho2_`i''
putexcel L`i'=`rhoin2_`i''
putexcel M`i'=`rhoout2_`i''
putexcel N`i'=`rhodt2_`i''

putexcel P`i'=`N2_`i''
putexcel Q`i'=`Nin2_`i''
putexcel R`i'=`Nout2_`i''
putexcel S`i'=`Ndt2_`i''


di "`i'"
}

/*
/*===================================
=====================================
Unit context models
=====================================
===================================*/
putexcel set "$results\rankcorr_ELL_context", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus\context\census\census.dta", clear
keep mun_id 
duplicates drop
merge 1:m mun_id using "$simcensus\context\samples\sample_R_`i'.dta"
recode _merge (1=0) (3=1)
rename _merge insample
keep mun_id insample
duplicates drop
tempfile sample
save `sample'


/*=========================================
Rank correlations 
*=========================================*/
use "$results\context\mySAE_context_`i'.dta", clear
keep avg_fgt0_163_8266 Unit
drop if Unit==0
rename Unit mun_id
rename avg_fgt0_163_8266 sim_fgt0

merge 1:1 mun_id using `sample'
drop _merge

merge 1:1 mun_id using "$simcensuslocal\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensuslocal\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir
merge 1:1 mun_id using "$simcensuslocal\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dirs
rename  fgt1_m fgt1_dirs
rename  fgt2_m fgt2_dirs

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==0
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


***Rescaled weights
putexcel set "$results\rankcorr_ELL_context_res", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus\context\census\census.dta", clear
keep mun_id 
duplicates drop
merge 1:m mun_id using "$simcensus\context\samplesres\sample_R_`i'.dta"
recode _merge (1=0) (3=1)
rename _merge insample
keep mun_id insample
duplicates drop
tempfile sample
save `sample'


/*=========================================
Rank correlations 
*=========================================*/
use "$results\context\mySAEres_context_`i'.dta", clear
keep avg_fgt0_163_8266 Unit
drop if Unit==0
rename Unit mun_id
rename avg_fgt0_163_8266 sim_fgt0

merge 1:1 mun_id using `sample'
drop _merge

merge 1:1 mun_id using "$simcensuslocal\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensuslocal\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir
merge 1:1 mun_id using "$simcensuslocal\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dirs
rename  fgt1_m fgt1_dirs
rename  fgt2_m fgt2_dirs

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)


***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==0
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

***Rescaled weights
putexcel set "$results\rankcorr_ELL_context_res2", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus\context\census\census.dta", clear
keep mun_id 
duplicates drop
merge 1:m mun_id using "$simcensus\context\samplesres2\sample_R_`i'.dta"
recode _merge (1=0) (3=1)
rename _merge insample
keep mun_id insample
duplicates drop
tempfile sample
save `sample'


/*=========================================
Rank correlations 
*=========================================*/
use "$results\context\mySAEres2_context_`i'.dta", clear
keep avg_fgt0_163_8266 Unit
drop if Unit==0
rename Unit mun_id
rename avg_fgt0_163_8266 sim_fgt0

merge 1:1 mun_id using `sample'
drop _merge

merge 1:1 mun_id using "$simcensuslocal\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensuslocal\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir
merge 1:1 mun_id using "$simcensuslocal\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dirs
rename  fgt1_m fgt1_dirs
rename  fgt2_m fgt2_dirs

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if insample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)


***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if insample==0
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