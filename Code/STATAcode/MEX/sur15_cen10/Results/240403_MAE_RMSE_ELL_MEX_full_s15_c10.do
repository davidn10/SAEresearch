cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\MEX\s15_c10\full_census\"
global simcensus15 "D:\SAE_project\MEX\2015\full_census_new\"
global results "$currdata\results\results_ell\"
set seed 648743


/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\errors_ELL_unit", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus15\census\census.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
merge 1:m mun_id using "$currdata\rawsamples_full\selected\sample_`i'.dta" //samples from 2015 created in ELL unit s15_c10
keep mun_id _merge num_hh
duplicates drop 
g small_mun=(num_hh<500) //small municipalities around 27%
recode _merge (1=0) (3=1)
rename _merge in_sample
tempfile insample
save `insample'


/*=========================================
Rank correlations 
*=========================================*/

use "$results\unit\output\sim_ebp_sample_`i'", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0

merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus15\simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus15\simcensus\full\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir

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

***Only larger municipalities
keep if small_mun==0

egen MAE2=mean(error) 
egen MAEin2=mean(error) if in_sample==1
egen MAEout2=mean(error) if in_sample==0 

egen RMSE2=mean(error2) if small_mun==0
egen RMSEin2=mean(error2) if in_sample==1 
egen RMSEout2=mean(error2) if in_sample==0 

replace RMSE2=sqrt(RMSE2)
replace RMSEin2=sqrt(RMSEin2)
replace RMSEout2=sqrt(RMSEout2)

sum MAE2 
local mae_`i'=r(mean)
sum MAEin2 
local maein_`i'=r(mean)
sum MAEout2 
local maeout_`i'=r(mean)

sum RMSE2 
local rmse_`i'=r(mean)
sum RMSEin2 
local rmsein_`i'=r(mean)
sum RMSEout2 
local rmseout_`i'=r(mean)

putexcel I`i'=`mae_`i''
putexcel J`i'=`maein_`i''
putexcel K`i'=`maeout_`i''

putexcel M`i'=`rmse_`i''
putexcel N`i'=`rmsein_`i''
putexcel O`i'=`rmseout_`i''

di "`i'"
}


/*===================================
=====================================
Unit context models
=====================================
===================================*/
putexcel set "$results\errors_ELL_context", replace

forvalues i=1(1)100 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use "$simcensus15\census\census.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
merge 1:m mun_id using "$currdata\rawsamples_full\selected\sample_`i'.dta" //samples from 2015 created in ELL unit s15_c10
keep mun_id _merge num_hh
duplicates drop 
g small_mun=(num_hh<500) //small municipalities around 27%
recode _merge (1=0) (3=1)
rename _merge in_sample
tempfile insample
save `insample'


/*=========================================
Rank correlations 
*=========================================*/

use "$results\context\output\sim_ebp_sample_`i'", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0


merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus15\simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus15\simcensus\full\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir

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

***Only larger municipalities
keep if small_mun==0

egen MAE2=mean(error) 
egen MAEin2=mean(error) if in_sample==1
egen MAEout2=mean(error) if in_sample==0 

egen RMSE2=mean(error2) if small_mun==0
egen RMSEin2=mean(error2) if in_sample==1 
egen RMSEout2=mean(error2) if in_sample==0 

replace RMSE2=sqrt(RMSE2)
replace RMSEin2=sqrt(RMSEin2)
replace RMSEout2=sqrt(RMSEout2)

sum MAE2 
local mae_`i'=r(mean)
sum MAEin2 
local maein_`i'=r(mean)
sum MAEout2 
local maeout_`i'=r(mean)

sum RMSE2 
local rmse_`i'=r(mean)
sum RMSEin2 
local rmsein_`i'=r(mean)
sum RMSEout2 
local rmseout_`i'=r(mean)

putexcel I`i'=`mae_`i''
putexcel J`i'=`maein_`i''
putexcel K`i'=`maeout_`i''

putexcel M`i'=`rmse_`i''
putexcel N`i'=`rmsein_`i''
putexcel O`i'=`rmseout_`i''

di "`i'"
}

