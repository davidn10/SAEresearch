
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\MEX\2020\full_census"
global rawsamples "$currdata\rawsamples_bias\"
global census "$currdata\census\"
global results "$currdata\results\results_sub_ebp\"
global simcensus "$currdata\simcensus\"


set seed 648743

/*===================================
=====================================
EBP subarea
=====================================
===================================*/
use "$census\census_bias.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'

putexcel set "$results\errors_subEBP_bias55", replace

forvalues i=1(1)100 {

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
use "$results\output_bias55\sim_ebp_subebp_`i'.dta", clear
rename area mun_id
destring mean mun_id, replace
rename mean sim_fgt0

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
g error_me=(fgt0_true-sim_fgt0)
egen ME=mean(error_me)
egen MEin=mean(error_me) if in_sample==1
egen MEout=mean(error_me) if in_sample==0

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

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel E`i'=`rmse_`i''
putexcel F`i'=`rmsein_`i''
putexcel G`i'=`rmseout_`i''

putexcel I`i'=`me_`i''
putexcel J`i'=`mein_`i''
putexcel K`i'=`meout_`i''

***Only larger municipalities
keep if small_mun==0

egen ME2=mean(error_me)
egen MEin2=mean(error_me) if in_sample==1
egen MEout2=mean(error_me) if in_sample==0

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

sum ME 
local me_`i'=r(mean)
sum MEin 
local mein_`i'=r(mean)
sum MEout 
local meout_`i'=r(mean)

putexcel M`i'=`mae_`i''
putexcel N`i'=`maein_`i''
putexcel O`i'=`maeout_`i''

putexcel Q`i'=`rmse_`i''
putexcel R`i'=`rmsein_`i''
putexcel S`i'=`rmseout_`i''

putexcel U`i'=`me_`i''
putexcel V`i'=`mein_`i''
putexcel W`i'=`meout_`i''

di "`i'"


}


putexcel set "$results\errors_subEBP_bias11b11", replace

forvalues i=1(1)100 {

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
use "$results\output_bias11b11\sim_ebp_subebp_`i'.dta", clear
rename area mun_id
destring mean mun_id, replace
rename mean sim_fgt0

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
g error_me=(fgt0_true-sim_fgt0)
egen ME=mean(error_me)
egen MEin=mean(error_me) if in_sample==1
egen MEout=mean(error_me) if in_sample==0

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

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel E`i'=`rmse_`i''
putexcel F`i'=`rmsein_`i''
putexcel G`i'=`rmseout_`i''

putexcel I`i'=`me_`i''
putexcel J`i'=`mein_`i''
putexcel K`i'=`meout_`i''

***Only larger municipalities
keep if small_mun==0

egen ME2=mean(error_me)
egen MEin2=mean(error_me) if in_sample==1
egen MEout2=mean(error_me) if in_sample==0

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

sum ME 
local me_`i'=r(mean)
sum MEin 
local mein_`i'=r(mean)
sum MEout 
local meout_`i'=r(mean)

putexcel M`i'=`mae_`i''
putexcel N`i'=`maein_`i''
putexcel O`i'=`maeout_`i''

putexcel Q`i'=`rmse_`i''
putexcel R`i'=`rmsein_`i''
putexcel S`i'=`rmseout_`i''

putexcel U`i'=`me_`i''
putexcel V`i'=`mein_`i''
putexcel W`i'=`meout_`i''

di "`i'"


}



putexcel set "$results\errors_subEBP_nobias", replace

forvalues i=1(1)100 {

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
use "$results\output_nobias\sim_ebp_subebp_`i'.dta", clear
rename area mun_id
destring mean mun_id, replace
rename mean sim_fgt0

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
g error_me=(fgt0_true-sim_fgt0)
egen ME=mean(error_me)
egen MEin=mean(error_me) if in_sample==1
egen MEout=mean(error_me) if in_sample==0

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

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel E`i'=`rmse_`i''
putexcel F`i'=`rmsein_`i''
putexcel G`i'=`rmseout_`i''

putexcel I`i'=`me_`i''
putexcel J`i'=`mein_`i''
putexcel K`i'=`meout_`i''

***Only larger municipalities
keep if small_mun==0

egen ME2=mean(error_me)
egen MEin2=mean(error_me) if in_sample==1
egen MEout2=mean(error_me) if in_sample==0

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

sum ME 
local me_`i'=r(mean)
sum MEin 
local mein_`i'=r(mean)
sum MEout 
local meout_`i'=r(mean)

putexcel M`i'=`mae_`i''
putexcel N`i'=`maein_`i''
putexcel O`i'=`maeout_`i''

putexcel Q`i'=`rmse_`i''
putexcel R`i'=`rmsein_`i''
putexcel S`i'=`rmseout_`i''

putexcel U`i'=`me_`i''
putexcel V`i'=`mein_`i''
putexcel W`i'=`meout_`i''

di "`i'"


}