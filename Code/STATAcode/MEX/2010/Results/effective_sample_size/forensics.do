* what happenned in sample 99 to make the predictions fail, is it a common support issue? 

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\results_ebp_norescale\"
global simcensus "$currdata\simcensus\"



use "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results\results_ebpwb\unit\rescaled\model_hh\model_99", replace 
rename mean mean_rescaled 
rename head_count head_count_rescaled 
merge 1:1 Domain using "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results\results_ebpwb\unit\rescaled\model_hh\model_99", assert(3) nogen 
rename Domain mun_id
rename head_count sim_fgt0
merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) assert(3) nogen 
rename  fgt0_m fgt0_true
twoway (scatter sim_fgt0 fgt0_true), name(s99wb_resc, replace)
correlate sim_fgt0 fgt0_true 

use "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results\results_ebpwb\unit\norescale\model_hh\model_99", replace 
rename mean mean_norescale 
rename head_count head_count_norescale
merge 1:1 Domain using "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results\results_ebpwb\unit\norescale\model_hh\model_99", assert(3) nogen 
rename Domain mun_id
rename head_count sim_fgt0
merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) assert(3) nogen 
rename  fgt0_m fgt0_true
twoway (scatter sim_fgt0 fgt0_true), name(s99wb_noresc, replace)
correlate sim_fgt0 fgt0_true 



use "$results\unit\output_h\sim_ebp_sample_99", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0
merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true
twoway (scatter sim_fgt0 fgt0_true), name(s99, replace)


use "$results\unit\output_h\sim_ebp_sample_39", clear
destring area fgt, replace
rename area mun_id
rename fgt sim_fgt0
merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m)
keep if _merge==3
drop _merge
rename  fgt0_m fgt0_true
rename  fgt1_m fgt1_true
rename  fgt2_m fgt2_true
twoway (scatter sim_fgt0 fgt0_true), name(s33, replace)
*/ 

** estimate model 
global model "$currdata\results\results_ebp_norescale\unit\model_h"
local model99 ""
use "$model\coef_sample_99", replace 
drop in 1 
forvalues j=1(1)`=_N' {
local model99="`model99'"+names[`j']+" "	
}

dis "99"


/*
use "$currdata/rawdata/census_proc_MEX_2010.dta", replace 
bys mun_id psu_id: keep if _n==1 
keep mun_id psu_id TAM_LOC 
save "census_psu", replace 
*/ 



use "$rawsamples\selected\sample_99.dta",replace 

* su hhsize [aw=FACTOR], d 
regress ln_pchinc `model99' [aw=FACTOR]
estimates save model99, replace 
predict leverage, leverage  
collapse (mean) leverage [iw=FACTOR],  by(mun_id)
gen sim=99 
save "$results/leverage_bymun_MEX_2010_s99", replace 



/*
predict yhat, xb 
su yhat [aw=FACTOR], d
egen meanFACTOR=mean(FACTOR),by(mun_id)
gen FACTOR_resc=FACTOR/meanFACTOR 
su yhat [aw=FACTOR_resc], d
regress ln_pchinc `model99' [aw=FACTOR_resc]
estimates save model99_resc, replace 

use "$census/census", replace 
merge n:1 psu_id mun_id using "census_psu"
gen hhsize2=hhsize^2 
estimates use model99 
predict yhat, xb
su yhat, d 
regress yhat i.TAM_LOC [aw=popwt]
estimates use model99_resc  
predict yhat_resc, xb
su yhat_resc, d 
regress yhat_resc i.TAM_LOC [aw=popwt]
tab TAM_LOC [aw=popwt]
tab TAM_LOC 








collapse (sum) FACTOR (mean) hhsize (mean) TAM_LOC, by(psu_id mun_id)
gen popwt=FACTOR*hhsize 
tab TAM_LOC [aw=popwt]
total popwt
*/ 


global model "$currdata\results\results_ebp_norescale\unit\model_h"
local model33 ""
use "$model\coef_sample_33", replace 
drop in 1 
forvalues j=1(1)`=_N' {
local model33="`model33'"+names[`j']+" "	
}



dis "33"
 use "$rawsamples\selected\sample_33.dta",replace 

 su hhsize [aw=FACTOR], d
 regress ln_pchinc `model33' [aw=FACTOR]
preserve 
 predict leverage, leverage  
collapse (mean) leverage [iw=FACTOR],  by(mun_id)
gen sim=99 
save "$results/leverage_bymun_MEX_2010_s33", replace 
restore 
 
 
predict yhat33, xb
twoway (scatter ln_pchinc yhat33), name(yhat33, replace)

xx

collapse (sum) FACTOR, by(psu_id mun_id) 




merge 1:n psu_id mun_id using "$currdata/rawdata/census_proc_MEX_2010.dta", keep(3) nogen keepusing(TAM_LOC hhsize)
bys mun_id psu_id: keep if _n==1 

total FACTOR 
tab TAM_LOC [aw=FACTOR] 
tab TAM_LOC 


use "$currdata/rawdata/census_proc_MEX_2010.dta", replace 
collapse (sum) FACTOR (mean) hhsize (mean) TAM_LOC, by(psu_id mun_id)
gen popwt=FACTOR*hhsize 
tab TAM_LOC [aw=popwt]
total popwt
xx





egen meanFACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_resc=FACTOR/meanFACTOR

regress ln_pchinc `model' [aw=FACTOR_resc]
