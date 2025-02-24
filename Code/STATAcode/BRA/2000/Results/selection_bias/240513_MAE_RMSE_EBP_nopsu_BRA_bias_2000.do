clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global rawdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global rawsamples "$currdata\rawsamples_bias\"
global currdata "$rawdata"
global results "$currdata\BRA_2000_new\results\bias\results_nopsu"
global simcensus "$currdata\simcensus"
global census "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\census"

set seed 648743





/*===================================
=====================================
Area Unit context models-biased(version1)
=====================================
===================================*/
use "$census\census_bias.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'


putexcel set "$results\errors_EBP_nopsu_bias11b11", replace

forvalues i=1(1)100 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear
merge 1:m mun_id using "$rawsamples\bias11b11\selected\sample_`i'.dta"
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

use "$results\output_bias11b11\sim_ebp_sample_`i'", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0


merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\bias11b11\true_fgt0.dta", keepusing(fgt0_m )
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\bias11b11\direct_bias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir


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
Area Unit context models
=====================================
===================================*/
putexcel set "$results\errors_EBP_nopsu_nobias", replace

forvalues i=1(1)100 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear
merge 1:m mun_id using "$rawsamples\nobias\selected\sample_`i'.dta"
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

use "$results\output_nobias\sim_ebp_sample_`i'", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0


merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\nobias\true_fgt0.dta", keepusing(fgt0_m )
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\nobias\direct_nobias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir


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


