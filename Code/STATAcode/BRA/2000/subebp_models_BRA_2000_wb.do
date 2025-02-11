cd "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new "

	** subarea model 
	
use "census/census_subebp", replace  
destring psu_id, replace 
save "./stata_sae/census_subebp", replace 
*/ 
	
	
	foreach sample of numlist 1/100 {
	dis "sample `sample'"
	
* get model 	
use subarea_ebp/subebp_`sample', replace
preserve 
drop psu_id mun_id poor_direct FACTOR  
describe, varlist 
global model=r(varlist)
restore 



sae data import, datain("./stata_sae/census_subebp") varlist($model popwt) ///
area(mun_id) uniqid(psu_id) dataout("./stata_sae/thecensus") 




use "subarea_ebp/subebp_`sample'", replace 
destring psu_id, replace 
egen mean_FACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_rescaled=FACTOR/mean_FACTOR 
sae sim h3  poor_direct $model [w=FACTOR_rescaled],  area(mun_id)  ///
	     bsrep(0) matin("./stata_sae/thecensus") seed(123) mcrep(100) ///
	    indicators(FGT0) uniq(psu_id) aggids(0) plines(6.869814491) pwcensus(popwt)

if e(eta_var)<0 {
	dis "error: negative variance"
	continue 
}		

rename Unit Domain  
rename Mean head_count
keep Domain head_count  
save "./results/results_ebpwb/subarea/rescaled/model_hh/model_`sample'", replace 
	}	