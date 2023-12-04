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
global results "$currdata\results_fh\"
global simcensuslocal "$currdata\simcensus\"

set seed 648743

/*===================================
=====================================
Fey-Harriot models
=====================================
===================================*/
putexcel set "$results\rankcorr_FH", replace

forvalues i=1(1)100 {

/*=========================================
Rank correlations 
*=========================================*/
use "$results\myFH_`i'.dta", clear
rename fh_fgt0 sim_fgt0

merge 1:1 mun_id using "$simcensuslocal\true_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
/*
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
*/
spearman fgt0_dir sim_fgt0
local rhod_`i'=r(rho)
local Nd_`i'=r(N)
spearman poor_dir sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)

putexcel A`i'=`rho_`i''
*putexcel B`i'=`rhoin_`i''
*putexcel C`i'=`rhoout_`i''
putexcel B`i'=`rhod_`i''
putexcel C`i'=`rhods_`i''

putexcel E`i'=`N_`i''
*putexcel H`i'=`Nin_`i''
*putexcel I`i'=`Nout_`i''
putexcel F`i'=`Nd_`i''
putexcel G`i'=`Nds_`i''

di "`i'"
}

