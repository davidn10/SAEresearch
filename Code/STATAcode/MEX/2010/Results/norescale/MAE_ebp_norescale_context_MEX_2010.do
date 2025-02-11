  /*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\results_ebp_norescale"
global simcensus "$currdata\simcensus\"


use "$census\census.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'
putexcel set "$results\errors_EBP_context_hh", replace

forvalues i=1(1)100{
	dis `i'

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear

merge 1:m mun_id using "$rawsamples\selected\sample_`i'.dta"
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

use "$results\context\output_h\sim_ebp_sample_`i'", clear
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


***Mean absolute error & RMSE
g error_me=(fgt0_true-sim_fgt0)
egen ME=mean(error_me)
egen MEin=mean(error_me) if in_sample==1
egen MEout=mean(error_me) if in_sample==0


g error=abs(fgt0_true-sim_fgt0)
egen MAE=mean(error)
egen MAEin=mean(error) if in_sample==1
egen MAEout=mean(error) if in_sample==0


sum MAE 
local mae_`i'=r(mean)
sum MAEin 
local maein_`i'=r(mean)
sum MAEout 
local maeout_`i'=r(mean)

sum ME 
local me_`i'=r(mean)
sum MEin 
local mein_`i'=r(mean)
sum MEout 
local meout_`i'=r(mean)

putexcel A`i'=`mae_`i''
putexcel B`i'=`maein_`i''
putexcel C`i'=`maeout_`i''

putexcel I`i'=`me_`i''
putexcel J`i'=`mein_`i''
putexcel K`i'=`meout_`i''

} 








