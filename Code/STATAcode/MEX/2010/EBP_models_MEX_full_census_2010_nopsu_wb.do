

* what is the GLS algorithm used by state sae? 
*1. Re-estimate Bhat, presumably using Roy's GLS formulas as described in _f_hh_gls2 
*2. Use beta-hat(w) to generate residuals 


* program to test stata sae simulations 
cd "H:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"


	
	** unit-context model 
	
	
	foreach sample of numlist 76/100 {
	dis "sample `sample'"
	
* get model 	
use context/betavars_selected_nopsu_all/beta_`sample', replace 
describe, varlist 
global model=r(varlist)

sae data import, datain("./stata_sae/census") varlist($model popwt) ///
area(mun_id) uniqid(hid) dataout("./stata_sae/thecensus") 




use "rawsamples_full/selected/sample_`sample'", replace 
egen mean_FACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_rescaled=FACTOR/mean_FACTOR 
sae sim h3 ln_pchinc $model [w=FACTOR_rescaled],  area(mun_id)  ///
	     bsrep(0) matin("./stata_sae/thecensus") seed(123) mcrep(100) ///
	    indicators(FGT0) uniq(hid) aggids(0) plines(6.869814491) pwcensus(popwt)

rename Unit Domain  
rename Mean mean 
rename avg_fgt0 head_count  
keep Domain head_count mean 
save "./results/results_ebpwb/nopsu/rescaled/model_hh/model_`sample'", replace 
	}	
	
	
	