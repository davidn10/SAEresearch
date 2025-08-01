
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new"
global rawsamples "$currdata\rawsamples\"
global census "$currdata\census\"
global results "$currdata\results\results_fh_smooth\"
global simcensus "$currdata\simcensus\"


set seed 648743

use "$census\census.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'

/*===================================
=====================================
Fey-Harriot models
=====================================
===================================*/
putexcel set "$results\rankcorr_FH_smooth", replace

forvalues i=1(1)100 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear
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
use "$results\myFH_`i'.dta", clear

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

merge 1:1 mun_id using "$simcensus\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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

/***Pearson correlations
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
*/ 
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
/*
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
*/ 
di "`i'"

/***Only larger municipalities
spearman fgt0_true sim_fgt0 if small_mun==0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true if small_mun==0
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0 if small_mun==0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true if small_mun==0
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel Y`i'=`rho_`i''
putexcel Z`i'=`rhoin_`i''
putexcel AA`i'=`rhoout_`i''
putexcel AB`i'=`rhodt_`i''

putexcel AD`i'=`N_`i''
putexcel AE`i'=`Nin_`i''
putexcel AF`i'=`Nout_`i''
putexcel AG`i'=`Ndt_`i''

putexcel AI`i'=`rho2_`i''
putexcel AJ`i'=`rhoin2_`i''
putexcel AK`i'=`rhoout2_`i''
putexcel AL`i'=`rhodt2_`i''

putexcel AN`i'=`N2_`i''
putexcel AO`i'=`Nin2_`i''
putexcel AP`i'=`Nout2_`i''
putexcel AQ`i'=`Ndt2_`i''


di "`i'"
*/ 
}

