global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

drop _all 
tempfile tempraw temprescale  
gen sim=. 
** step 1: 
/** estimate models 
foreach i of numlist 1/100 { 
global model "$currdata\results\results_ebp_norescale\unit\model_h"
local model ""
use "$model\coef_sample_`i'", replace 
drop in 1 
forvalues j=1(1)`=_N' {
local model="`model'"+names[`j']+" "	
}

dis "`i'"


/*
use "$currdata/rawdata/census_proc_MEX_2010.dta", replace 
bys mun_id psu_id: keep if _n==1 
keep mun_id psu_id TAM_LOC 
save "census_psu", replace 
*/ 



use "$rawsamples\selected\sample_`i'.dta",replace 
* su hhsize [aw=FACTOR], d 
regress ln_pchinc `model' [aw=FACTOR]
estimates save "$results/models/model`i'", replace 
}
*/ 

** step 2: Predict models into census and estimate rescaled and norescaled average differences between sample and sample complement 

xx





bys mun_id psu_id: keep if _n==1 
keep mun_id psu_id 
merge 1:n mun_id psu_id using "$census/census"
gen insample=_m==3  
merge n:1 psu_id mun_id using "census_psu", assert(3) nogen 
gen hhsize2=hhsize^2 
estimates use model99 
predict yhat, xb 
collapse (mean) yhat (rawsum) popwt [aw=popwt], by(mun_id insample)