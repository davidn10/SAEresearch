

global currdata "$BRA\2010"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

drop _all 
import excel "$results\ESS_BRA_2010"
if A[2]==. {
drop in 1/2 
} 
rename A ess_rescaled 
rename B ess_norescale 
gen sim=_n 
save "$results\ESS_BRA_2010", replace 

drop _all 
global results "$currdata\results\results_ebp\"
import excel "$results\rankcorr_EBP_unit_h"
keep A 
rename A spearman_rescaled 

gen sim=_n 
save "$currdata\results\effective_sample_size\spearman_rescaled_BRA_2010", replace 

global results "$currdata\results\results_ebp_norescale\"
drop _all 
import excel "$results\rankcorr_EBP_unit_norescale"
keep A 
rename A spearman_norescale 

gen sim=_n 
 
merge 1:1 sim using "$currdata\results\effective_sample_size\spearman_rescaled_BRA_2010", assert(3) nogen 
merge 1:1 sim using "$currdata\results\effective_sample_size\ESS_BRA_2010", assert(3) nogen 
reshape long spearman ess, i(sim) j(scale) string 
gen rescaled=scale=="_rescaled" 
gen spearman_rescaled=spearman if rescaled==1 
gen spearman_norescale=spearman if rescaled==0 
label var ess "Effective sample size across areas"
label var spearman_rescaled "Rescaled weights"
label var spearman_norescale "Raw weights"
global results "$currdata\results\effective_sample_size" 
twoway (scatter spearman_rescaled spearman_norescale ess, msymbol(oh X)) (lfit spearman_norescale ess,lcolor(red)) (lfit spearman_rescale ess, lcolor(blue)),  xlabel(0(100)500) xmtick(0(20)500) ylabel(0.964(0.002)0.974) ymtick(0.964(0.001)0.974) legend(position(bottom)) ytitle("Spearman Rank Correlation") saving($results/ESS_scatter_BRA_2010, replace) legend(order(1 2) rows(1) size(small)) title("Brazil 2010")

table rescaled, statistic(mean ess)
