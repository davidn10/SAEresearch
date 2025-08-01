global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

drop _all 
tempfile tempraw temprescale  
gen sim=. 

/*
forvalues i=1(1)100{
	dis "`i'"
preserve 	
use "$rawsamples\selected\sample_`i'.dta", replace 


collapse (mean) ln_pchinc [aw=FACTOR*hhsize], by(mun_id psu_id)
egen min_ybar=min(ln_pchinc), by(mun_id)
egen max_ybar=max(ln_pchinc), by(mun_id) 
keep min_ybar max_ybar mun_id psu_id 

gen sim=`i'
qui save `tempraw', replace 
restore 



append using `tempraw'


} 
save "$results\minmax_Ybar_bymun_MEX_2010", replace 
*/ 


use "$currdata/rawdata/census_proc_MEX_2010.dta", replace 
g ln_pchinc=ln(pchinc)
g popwt=FACTOR*hhsize

collapse (mean) ln_pchinc pchinc [aw=popwt],by(mun_id psu_id)
merge 1:n mun_id psu_id using "$results\minmax_Ybar_bymun_MEX_2010",  keep(1 3) nogen 
keep if mun_id==101001 & sim<=3 
sort sim pchinc
list 
xx



drop _all 
global results "$currdata\results\results_ebp\"
import excel "$results\rankcorr_EBP_unit_h"
keep A 
rename A spearman_rescaled 
drop in 1/3 
gen sim=_n 
save "$currdata\results\effective_sample_size\spearman_rescaled_MEX_2010", replace 

global results "$currdata\results\results_ebp_norescale\"
drop _all 
import excel "$results\rankcorr_EBP_unit_norescale"
keep A 
rename A spearman_norescale 
drop in 1/3 
gen sim=_n 
 
merge 1:1 sim using "$currdata\results\effective_sample_size\spearman_rescaled_MEX_2010", assert(3) nogen 
merge 1:1 sim using "$currdata\results\effective_sample_size\Var_Y_MEX_2010", assert(3) nogen 


reshape long spearman var_y mean_y, i(sim) j(scale) string

gen rescaled=scale=="_rescaled" 
gen spearman_rescaled=spearman if rescaled==1 
gen spearman_norescale=spearman if rescaled==0 
label var var_y "variance in log PCI"
label var spearman_rescaled "Rescaled weights"
label var spearman_norescale "Raw weights"
global results "$currdata\results\effective_sample_size" 

twoway (scatter spearman_rescaled spearman_norescale var_y, msymbol(oh X)) (lfit spearman_norescale var_y,lcolor(red)) (lfit spearman_rescale var_y, lcolor(blue)),  ylabel(0.65(0.05)0.95) ymtick(0.65(0.05)0.95) legend(position(bottom)) ytitle("Spearman Rank Correlation") saving($results/var_y_scatter_MEX_2010, replace) legend(order(1 2) rows(1) size(small)) title("Mexico 2010")
table rescaled, statistic(mean var_y mean_y)
su spearman_norescale 