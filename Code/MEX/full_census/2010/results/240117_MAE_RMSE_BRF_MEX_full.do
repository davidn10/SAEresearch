cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\census_2010\"
global currdata "$data\MEX\census_2010\full_census\"
global samples "$mdata\samples\"
global census "$mdata\census_proc_MEX_2010.dta"
global simcensus "D:\SAE_project\MEX\2010\full_census\"
global results "$currdata\results_BRF\"
global simcensuslocal "$currdata\simcensus\"

set seed 648743

***Weights fro averaging
use "$simcensus\census\census.dta", clear
collapse (rawsum) popwt [aw=popwt] , by(psu_id) 
tempfile weights
save `weights'

/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\errors_BRF_subarea", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus\census\census.dta", clear
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

use "$simcensus\subarea\results_BRF\BRF_sample_R_`i'.dta", clear
merge 1:1 psu_id using `weights'

collapse (mean) sim_fgt0=predictions  [aw=popwt] , by(mun_id)

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

***Mean absolute error & RMSE
g error=abs(fgt0_true-sim_fgt0)
g error2=(fgt0_true-sim_fgt0)^2
egen MAE=mean(error)
egen MAEin=mean(error) if in_sample==1
egen MAEout=mean(error) if in_sample==0

egen RMSE=mean(error2)
egen RMSEin=mean(error2) if in_sample==1
egen RMSEout=mean(error2) if in_sample==0

replace RMSE=sqrt(RMSE)
replace RMSEin=sqrt(RMSEin)
replace RMSEout=sqrt(RMSEout)

sum MAE 
local mae_`i'=r(mean)
sum MAEin 
local maein_`i'=r(mean)
sum MAEout 
local maeout_`i'=r(mean)

sum RMSE 
local rmse_`i'=r(mean)
sum RMSEin 
local rmsein_`i'=r(mean)
sum RMSEout 
local rmseout_`i'=r(mean)

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel E`i'=`rmse_`i''
putexcel F`i'=`rmsein_`i''
putexcel G`i'=`rmseout_`i''

di "`i'"
}

