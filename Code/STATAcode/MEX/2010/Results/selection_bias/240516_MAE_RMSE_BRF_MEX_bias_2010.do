cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_bias\"
global census "$currdata\census\"
global results "$currdata\results\bias\results_BRF\"
global simcensus "$currdata\simcensus\"

set seed 648743

***Weights fro averaging
use "$census\census_bias.dta", clear
collapse (rawsum) popwt [aw=popwt] , by(psu_id) 
tempfile weights
save `weights'

use "$census\census_bias.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'

/*===================================
=====================================
Unit level models
=====================================
===================================*/
putexcel set "$results\errors_BRF_subarea_bias55", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear

merge 1:m mun_id using "$rawsamples\bias55\selected\sample_`i'.dta"
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

use "$results\output_bias55\BRF_sample_`i'.dta", clear
merge 1:1 psu_id using `weights'

collapse (mean) sim_fgt0=predictions  [aw=popwt] , by(mun_id)
 
merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\bias55\true_fgt0.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus\bias55\direct_bias_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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




putexcel set "$results\errors_BRF_subarea_bias11b11", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear

merge 1:m mun_id using "$rawsamples\bias11b11\selected\sample_`i'.dta"
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

use "$results\output_bias11b11\BRF_sample_`i'.dta", clear
merge 1:1 psu_id using `weights'

collapse (mean) sim_fgt0=predictions  [aw=popwt] , by(mun_id)
 
merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\bias11b11\true_fgt0.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus\bias11b11\direct_bias_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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




putexcel set "$results\errors_BRF_subarea_nobias", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear

merge 1:m mun_id using "$rawsamples\nobias\selected\sample_`i'.dta"
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

use "$results\output_nobias\BRF_sample_`i'.dta", clear
merge 1:1 psu_id using `weights'

collapse (mean) sim_fgt0=predictions  [aw=popwt] , by(mun_id)
 
merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\nobias\true_fgt0.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus\nobias\direct_nobias_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
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

