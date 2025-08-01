
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census"

global rawsamples "$currdata\rawsamples_bias\"
global census "$currdata\census\"
global results "$currdata\results\bias\results_ebp\"
global simcensus "$currdata\simcensus\"

set seed 648743




/*===================================
=====================================
Area Unit context models-biased 
=====================================
===================================*/
use "$census\census_bias.dta", clear
bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'
/*
putexcel set "$results\rankcorr_EBP_nopsu_bias55", replace

forvalues i=1(1)100 {

/*=========================================
 Identifying in sample and out-of-sample
*=========================================*/
use `census', clear
merge 1:m mun_id using "$rawsamples\bias55\selected\sample_`i'.dta"
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
use "$results\nopsu\output_bias55\sim_ebp_sample_`i'", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0


merge 1:1 mun_id using `insample'
drop _merge

merge 1:1 mun_id using "$simcensus\bias55\true_fgt0.dta", keepusing(fgt0_m )
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\bias55\direct_bias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir


spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhodt_`i''

putexcel F`i'=`N_`i''
putexcel G`i'=`Nin_`i''
putexcel H`i'=`Nout_`i''
putexcel I`i'=`Ndt_`i''

putexcel K`i'=`rho2_`i''
putexcel L`i'=`rhoin2_`i''
putexcel M`i'=`rhoout2_`i''
putexcel N`i'=`rhodt2_`i''

putexcel P`i'=`N2_`i''
putexcel Q`i'=`Nin2_`i''
putexcel R`i'=`Nout2_`i''
putexcel S`i'=`Ndt2_`i''

***Only larger municipalities
spearman fgt0_true sim_fgt0 if small_mun==0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true if small_mun==0
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0 if small_mun==0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true if small_mun==0
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel V`i'=`rho_`i''
putexcel W`i'=`rhoin_`i''
putexcel X`i'=`rhoout_`i''
putexcel Y`i'=`rhodt_`i''

putexcel AA`i'=`N_`i''
putexcel AB`i'=`Nin_`i''
putexcel AC`i'=`Nout_`i''
putexcel AD`i'=`Ndt_`i''

putexcel AF`i'=`rho2_`i''
putexcel AG`i'=`rhoin2_`i''
putexcel AH`i'=`rhoout2_`i''
putexcel AI`i'=`rhodt2_`i''

putexcel AK`i'=`N2_`i''
putexcel AL`i'=`Nin2_`i''
putexcel AM`i'=`Nout2_`i''
putexcel AN`i'=`Ndt2_`i''


di "`i'"


}
*/ 

putexcel set "$results\rankcorr_EBP_nopsu_bias11b11", replace

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

use "$results\nopsu\output_bias11b11\sim_ebp_sample_`i'", clear
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


spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhodt_`i''

putexcel F`i'=`N_`i''
putexcel G`i'=`Nin_`i''
putexcel H`i'=`Nout_`i''
putexcel I`i'=`Ndt_`i''

putexcel K`i'=`rho2_`i''
putexcel L`i'=`rhoin2_`i''
putexcel M`i'=`rhoout2_`i''
putexcel N`i'=`rhodt2_`i''

putexcel P`i'=`N2_`i''
putexcel Q`i'=`Nin2_`i''
putexcel R`i'=`Nout2_`i''
putexcel S`i'=`Ndt2_`i''

/***Only larger municipalities
spearman fgt0_true sim_fgt0 if small_mun==0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true if small_mun==0
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0 if small_mun==0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true if small_mun==0
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel V`i'=`rho_`i''
putexcel W`i'=`rhoin_`i''
putexcel X`i'=`rhoout_`i''
putexcel Y`i'=`rhodt_`i''

putexcel AA`i'=`N_`i''
putexcel AB`i'=`Nin_`i''
putexcel AC`i'=`Nout_`i''
putexcel AD`i'=`Ndt_`i''

putexcel AF`i'=`rho2_`i''
putexcel AG`i'=`rhoin2_`i''
putexcel AH`i'=`rhoout2_`i''
putexcel AI`i'=`rhodt2_`i''

putexcel AK`i'=`N2_`i''
putexcel AL`i'=`Nin2_`i''
putexcel AM`i'=`Nout2_`i''
putexcel AN`i'=`Ndt2_`i''
*/ 

di "`i'"


}

exit 

/*===================================
=====================================
Area Unit context models-Unbiased
=====================================
===================================*/

putexcel set "$results\rankcorr_EBP_nopsu_nobias", replace

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

use "$results\nopsu\output_nobias\sim_ebp_sample_`i'", clear
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


spearman fgt0_true sim_fgt0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rhoin_`i''
putexcel C`i'=`rhoout_`i''
putexcel D`i'=`rhodt_`i''

putexcel F`i'=`N_`i''
putexcel G`i'=`Nin_`i''
putexcel H`i'=`Nout_`i''
putexcel I`i'=`Ndt_`i''

putexcel K`i'=`rho2_`i''
putexcel L`i'=`rhoin2_`i''
putexcel M`i'=`rhoout2_`i''
putexcel N`i'=`rhodt2_`i''

putexcel P`i'=`N2_`i''
putexcel Q`i'=`Nin2_`i''
putexcel R`i'=`Nout2_`i''
putexcel S`i'=`Ndt2_`i''

***Only larger municipalities
spearman fgt0_true sim_fgt0 if small_mun==0
local rho_`i'=r(rho)
local N_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin_`i'=r(rho)
local Nin_`i'=r(N)
spearman fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout_`i'=r(rho)
local Nout_`i'=r(N)
spearman fgt0_dir fgt0_true if small_mun==0
local rhodt_`i'=r(rho)
local Ndt_`i'=r(N)

***Pearson correlations
corr fgt0_true sim_fgt0 if small_mun==0
local rho2_`i'=r(rho)
local N2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==1 & small_mun==0
local rhoin2_`i'=r(rho)
local Nin2_`i'=r(N)
corr fgt0_true sim_fgt0 if in_sample==0 & small_mun==0
local rhoout2_`i'=r(rho)
local Nout2_`i'=r(N)
corr fgt0_dir fgt0_true if small_mun==0
local rhodt2_`i'=r(rho)
local Ndt2_`i'=r(N)

putexcel V`i'=`rho_`i''
putexcel W`i'=`rhoin_`i''
putexcel X`i'=`rhoout_`i''
putexcel Y`i'=`rhodt_`i''

putexcel AA`i'=`N_`i''
putexcel AB`i'=`Nin_`i''
putexcel AC`i'=`Nout_`i''
putexcel AD`i'=`Ndt_`i''

putexcel AF`i'=`rho2_`i''
putexcel AG`i'=`rhoin2_`i''
putexcel AH`i'=`rhoout2_`i''
putexcel AI`i'=`rhodt2_`i''

putexcel AK`i'=`N2_`i''
putexcel AL`i'=`Nin2_`i''
putexcel AM`i'=`Nout2_`i''
putexcel AN`i'=`Ndt2_`i''


di "`i'"
}

