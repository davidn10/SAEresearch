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
collapse (sd) sd_ln_pchinc=ln_pchinc (mean) mean_y_norescale=ln_pchinc  [iw=FACTOR]
gen sim=`i'
gen var_y_norescale=sd_ln_pchinc^2 
qui save `tempraw', replace 
use "$rawsamples\selected\sample_`i'.dta", replace 
egen meanFACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_resc=FACTOR/meanFACTOR 
collapse (sd) sd_ln_pchinc=ln_pchinc (mean) mean_y_rescaled=ln_pchinc [iw=FACTOR_resc]
gen sim=`i'
gen var_y_rescaled=sd_ln_pchinc^2 

qui merge 1:1 sim using `tempraw', assert(3) nogen 
qui save `temprescale', replace 

restore 

append using `temprescale'


} 
save "$results\Var_Y_MEX_2010", replace 
*/ 

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