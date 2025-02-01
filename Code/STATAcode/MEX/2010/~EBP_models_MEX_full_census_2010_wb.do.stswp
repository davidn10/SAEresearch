

* what is the GLS algorithm used by state sae? 
*1. Re-estimate Bhat, presumably using Roy's GLS formulas as described in _f_hh_gls2 
*2. Use beta-hat(w) to generate residuals 


* program to test stata sae simulations 
cd "H:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"

** prepare census 
*use "census/census", replace  
*gen hhsize2=hhsize^2 
*save "./stata_sae/census", replace 
*/ 
foreach sample of numlist 1/100 {
	dis "sample `sample'"
	
* get model 	
use betavars_selected/beta_`sample', replace 
describe, varlist 
global model=r(varlist)

sae data import, datain("./stata_sae/census") varlist($model popwt) ///
area(mun_id) uniqid(hid) dataout("./stata_sae/thecensus") 

use "rawsamples_full/selected/sample_`sample'", replace 
sae sim h3 ln_pchinc $model [w=FACTOR],  area(mun_id)  ///
	     bsrep(0) matin("./stata_sae/thecensus") seed(123) mcrep(100) ///
	    indicators(FGT0) uniq(hid) aggids(0) plines(7.1200103) pwcensus(popwt)

rename Unit Domain  
rename Mean mean 
rename avg_fgt0 head_count  
keep Domain head_count mean 
save "./results/results_ebpwb/unit/model_hh/model_`sample'", replace 
}
    
	
	
	