  /*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new"
global rawsamples "$currdata\rawsamples\"
global census "$currdata\census\"
global results "$currdata\results\results_ebp_norescale"
global simcensus "$currdata\simcensus\"



use "$census\census.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'



putexcel set "$results\rankcorr_EBP_context_norescale", replace

forvalues i=1(1)100{
	dis `i'

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

spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''

}
