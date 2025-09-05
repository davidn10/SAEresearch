
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results_ebp "$currdata\results\results_ebp\"
global results_ebp_context "$currdata\results\results_ebp\context"
global results_ell "$currdata\results\results_ell\"
global results_brf "$currdata\results\results_BRF\"
global results_subarea "$currdata\results\results_sub_ebp"
global results_fh "$currdata\results\results_fh"
global results_poverty_simulations "$currdata\results\results_poverty_simulations"
global simcensus "$currdata\simcensus\"
scalar pline=205.4
scalar prate=31.5  

use "$census\census.dta", clear
gen poor_baseline=pchinc<pline 
su poor_baseline [aw=hhsize]

collapse (rawsum) popwt [aw=popwt] , by(psu_id) 
tempfile weights
save `weights'



use "$census\census.dta", clear

bys mun_id: g num_hh=_N

keep mun_id num_hh
duplicates drop
tempfile census
save `census'
foreach i of numlist 1/100 {

use "$results_brf\BRF_sample_`i'"
merge 1:1 psu_id using `weights'
collapse (mean) sim_fgt0=predictions  [aw=popwt] , by(mun_id)
rename sim_fgt0 fgt_brf 
merge 1:n mun_id using  "$results_fh\myFH_`i'", keep(3) nogen
rename sim_fgt0 fgt_fh 
gen area=string(mun_id)


merge 1:1 area using "$results_ebp\unit\output_h\sim_ebp_sample_`i'", keep(3) nogen 

rename fgt fgt_ebp_unit  
merge 1:1 area using "$results_ell\unit\output\sim_ebp_sample_`i'", assert(3) nogen 
rename fgt fgt_ell 
merge 1:1 area using "$results_ebp_context\output_h\sim_ebp_sample_`i'", assert(3) nogen 
rename fgt fgt_ebp_context 
merge 1:1 area using "$results_ebp_context\output_nopsu_h\sim_ebp_sample_`i'", assert(3) nogen 
rename fgt fgt_ebp_area_context 

merge 1:1 area using  "$results_subarea\output_h\sim_ebp_subebp_`i'", assert(3) nogen
rename mean fgt_subarea 

merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) nogen 
destring fgt_ebp_unit-fgt_subarea, replace 

merge 1:n mun_id using "$census\census.dta", keepusing(pchinc hhsize popwt) keep(3)
tab _m 





gen p0_baseline=pchinc<pline 
gen p1_baseline=(pline-pchinc)/pline if pchinc<pline 
replace p1_baseline=0 if pchinc>=pline 

gen fgt_true=fgt0_m

* foreach threshold of numlist 5(5)50 {
local threshold=prate 
foreach method in true brf fh ebp_unit ell ebp_context ebp_area_context subarea {

* beneficiaries are those in X percent of poorest areas, so calculate 100-X percentile cutoff 
local oneminusthreshold=100-`threshold'
_pctile fgt_`method' [fw=hhsize], p(`oneminusthreshold')
dis r(r1)

gen beneficiary_`method'=fgt_`method'>r(r1)
su beneficiary_`method' [aw=hhsize]

gen pchinc_`method'=pchinc 
replace pchinc_`method'=pchinc_`method'+0.1*pline if beneficiary_`method'==1 
gen p0_`method'=pchinc_`method'<pline 
gen p1_`method'=(pline-pchinc_`method')/pline if pchinc_`method'<pline
replace p1_`method'=0 if pchinc_`method'>=pline 
} 
su p0_baseline p0_* [aw=hhsize]
su p1_baseline p1_* [aw=hhsize]
 
collapse (mean) p0* p1* [aw=hhsize]
su p0* 
su p1* 
gen id=1 
reshape long p0_ p1_, i(id) j(method) string
drop id 
rename p0_ p0 
rename p1_ p1 

gen ebp_unit=p1 if method=="ebp_unit" 
egen p1_ebp_unit=max(ebp_unit)
gen baseline=p1 if method=="baseline" 
egen p1_baseline=max(baseline)
drop ebp_unit baseline 

gen poverty_reduction_penalty=1-(p1_baseline-p1)/(p1_baseline-p1_ebp_unit)


sort method 
gen simulation=`i'
save "$results_poverty_simulations/simulation_results_`i'", replace 
} 

global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"
global results_poverty_simulations "$currdata\results\results_poverty_simulations"
use "$results_poverty_simulations\simulation_results_1", replace 
foreach i of numlist 2/100 {
	append using "$results_poverty_simulations\simulation_results_`i'"
}

save "$results_poverty_simulations\simulation_results_all", replace 