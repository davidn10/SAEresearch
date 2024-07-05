cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\MEX\2020\full_census"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\results_ell\"
global simcensus "$currdata\simcensus\"

set seed 648743


/*===================================
=====================================
Unit level models
=====================================
===================================*/
use "$census\census.dta", clear
bys mun_id: g numh=_N

keep mun_id numh
duplicates drop
tempfile census
save `census'

***Rescaling weights
putexcel set "$results\errors_ELL_unit", replace

forvalues i=1(1)100{

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear
merge 1:m mun_id using "$rawsamples\selected\sample_`i'.dta"
keep mun_id _merge numh
duplicates drop 
g small_mun=(numh<500) //small municipalities around 27%
recode _merge (1=0) (3=1)
rename _merge in_sample
tempfile insample
save `insample'


/*=========================================
Rank correlations 
*=========================================*/

use "$results\unit\output\sim_ebp_sample_`i'", clear
destring area  fgt, replace
rename area mun_id
rename fgt sim_fgt0

merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus\full\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir

merge 1:1 mun_id using "$simcensus\full\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dirs
rename  fgt1_m fgt1_dirs
rename  fgt2_m fgt2_dirs

***Mean absolute error & RMSE
g error_me=(fgt0_true-sim_fgt0)
egen ME=mean(error_me)
egen MEin=mean(error_me) if in_sample==1
egen MEout=mean(error_me) if in_sample==0

g error_rme=abs(sim_fgt0-fgt0_true)/fgt0_true
egen RME=mean(error_rme)
egen RMEin=mean(error_rme) if in_sample==1
egen RMEout=mean(error_rme) if in_sample==0

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

sum ME 
local me_`i'=r(mean)
sum MEin 
local mein_`i'=r(mean)
sum MEout 
local meout_`i'=r(mean)

sum RME 
local rme_`i'=r(mean)
sum RMEin 
local rmein_`i'=r(mean)
sum RMEout 
local rmeout_`i'=r(mean)

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel E`i'=`rmse_`i''
putexcel F`i'=`rmsein_`i''
putexcel G`i'=`rmseout_`i''

putexcel I`i'=`me_`i''
putexcel J`i'=`mein_`i''
putexcel K`i'=`meout_`i''

putexcel M`i'=`rme_`i''
putexcel N`i'=`rmein_`i''
putexcel O`i'=`rmeout_`i''

***Only larger municipalities
keep if small_mun==0

egen ME2=mean(error_me)
egen MEin2=mean(error_me) if in_sample==1
egen MEout2=mean(error_me) if in_sample==0

egen RME2=mean(error_rme)
egen RMEin2=mean(error_rme) if in_sample==1
egen RMEout2=mean(error_rme) if in_sample==0

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

sum ME2 
local me_`i'=r(mean)
sum MEin2 
local mein_`i'=r(mean)
sum MEout2 
local meout_`i'=r(mean)

sum RME2
local rme_`i'=r(mean)
sum RMEin2 
local rmein_`i'=r(mean)
sum RMEout2 
local rmeout_`i'=r(mean)

putexcel Q`i'=`mae_`i''
putexcel R`i'=`maein_`i''
putexcel S`i'=`maeout_`i''

putexcel U`i'=`rmse_`i''
putexcel V`i'=`rmsein_`i''
putexcel W`i'=`rmseout_`i''

putexcel Y`i'=`me_`i''
putexcel Z`i'=`mein_`i''
putexcel AA`i'=`meout_`i''

putexcel AC`i'=`rme_`i''
putexcel AD`i'=`rmein_`i''
putexcel AE`i'=`rmeout_`i''

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
use `census', clear
merge 1:m mun_id using "$rawsamples\selected\sample_`i'.dta"
keep mun_id _merge numh
duplicates drop 
g small_mun=(numh<500) //small municipalities around 27%
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

merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true

merge 1:1 mun_id using "$simcensus\full\direct_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dir
rename  fgt1_m fgt1_dir
rename  fgt2_m fgt2_dir

merge 1:1 mun_id using "$simcensus\full\direct_resc2_fg0_`i'.dta", keepusing(fgt0_m fgt1_m fgt2_m)
drop _merge
rename  fgt0_m fgt0_dirs
rename  fgt1_m fgt1_dirs
rename  fgt2_m fgt2_dirs

***Mean absolute error & RMSE
g error_me=(fgt0_true-sim_fgt0)
egen ME=mean(error_me)
egen MEin=mean(error_me) if in_sample==1
egen MEout=mean(error_me) if in_sample==0

g error_rme=abs(sim_fgt0-fgt0_true)/fgt0_true
egen RME=mean(error_rme)
egen RMEin=mean(error_rme) if in_sample==1
egen RMEout=mean(error_rme) if in_sample==0

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

sum ME 
local me_`i'=r(mean)
sum MEin 
local mein_`i'=r(mean)
sum MEout 
local meout_`i'=r(mean)

sum RME 
local rme_`i'=r(mean)
sum RMEin 
local rmein_`i'=r(mean)
sum RMEout 
local rmeout_`i'=r(mean)

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel E`i'=`rmse_`i''
putexcel F`i'=`rmsein_`i''
putexcel G`i'=`rmseout_`i''

putexcel I`i'=`me_`i''
putexcel J`i'=`mein_`i''
putexcel K`i'=`meout_`i''

putexcel M`i'=`rme_`i''
putexcel N`i'=`rmein_`i''
putexcel O`i'=`rmeout_`i''

***Only larger municipalities
keep if small_mun==0

egen ME2=mean(error_me)
egen MEin2=mean(error_me) if in_sample==1
egen MEout2=mean(error_me) if in_sample==0

egen RME2=mean(error_rme)
egen RMEin2=mean(error_rme) if in_sample==1
egen RMEout2=mean(error_rme) if in_sample==0

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

sum ME2 
local me_`i'=r(mean)
sum MEin2 
local mein_`i'=r(mean)
sum MEout2 
local meout_`i'=r(mean)

sum RME2
local rme_`i'=r(mean)
sum RMEin2 
local rmein_`i'=r(mean)
sum RMEout2 
local rmeout_`i'=r(mean)

putexcel Q`i'=`mae_`i''
putexcel R`i'=`maein_`i''
putexcel S`i'=`maeout_`i''

putexcel U`i'=`rmse_`i''
putexcel V`i'=`rmsein_`i''
putexcel W`i'=`rmseout_`i''

putexcel Y`i'=`me_`i''
putexcel Z`i'=`mein_`i''
putexcel AA`i'=`meout_`i''

putexcel AC`i'=`rme_`i''
putexcel AD`i'=`rmein_`i''
putexcel AE`i'=`rmeout_`i''

di "`i'"
}

