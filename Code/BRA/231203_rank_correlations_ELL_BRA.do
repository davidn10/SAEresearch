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
global results "$currdata\results_ell\"
global simcensuslocal "$currdata\simcensus\"

set seed 648743

/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\rankcorr_ELL_unit", replace

forvalues i=1(1)100 {
/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus\census\census_R_`i'.dta", clear
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
use "$results\unit\mySAE_`i'", clear
keep avg_fgt0_163_8266 Unit
drop if Unit==0
rename Unit mun_id
rename avg_fgt0_163_8266 sim_fgt0

merge 1:1 mun_id using `sample'
drop _merge

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

merge 1:1 mun_id using "$simcensuslocal\direct_resc_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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
spearman fgt0_dir sim_fgt0
local rhod_`i'=r(rho)
local Nd_`i'=r(N)
spearman fgt0_dirs sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhod_`i''
putexcel E`i'=`rhods_`i''

putexcel G`i'=`N_`i''
putexcel H`i'=`Nin_`i''
putexcel I`i'=`Nout_`i''
putexcel J`i'=`Nd_`i''
putexcel K`i'=`Nds_`i''

di "`i'"
}


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
use "$simcensus\census\census_R_`i'.dta", clear
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
use "$results\context\mySAE_context_`i'.dta", clear
keep avg_fgt0_962_7699 Unit
drop if Unit<=133
rename Unit mun_id
rename avg_fgt0_962_7699 sim_fgt0

merge 1:1 mun_id using `sample'
drop _merge

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

merge 1:1 mun_id using "$simcensuslocal\direct_resc_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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
spearman fgt0_dir sim_fgt0
local rhod_`i'=r(rho)
local Nd_`i'=r(N)
spearman fgt0_dirs sim_fgt0 
local rhods_`i'=r(rho)
local Nds_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhod_`i''
putexcel E`i'=`rhods_`i''

putexcel G`i'=`N_`i''
putexcel H`i'=`Nin_`i''
putexcel I`i'=`Nout_`i''
putexcel J`i'=`Nd_`i''
putexcel K`i'=`Nds_`i''

di "`i'"
}