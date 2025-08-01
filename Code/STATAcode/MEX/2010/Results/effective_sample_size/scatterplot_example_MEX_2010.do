global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

drop _all 
tempfile tempraw temprescale  
gen sim=. 

use "$census/census", replace 
collapse (rawsum) popwt, by(mun_id)
save "popwt_mun", replace 

local sample=15
drop _all 
global results "$currdata\results\"

tempfile s15 
use "$rawsamples\selected\sample_`sample'.dta",replace 
bys mun_id: keep if _n==1 
save `s15'


use "$results/results_ebp/unit/output_h/sim_ebp_sample_`sample'",   clear 
rename fgt fgt0_rescaled
merge 1:1 area using "$results/results_ebp_norescale/unit/output_h/sim_ebp_sample_`sample'", assert(3) nogen 
rename fgt fgt0_norescale 
rename area mun_id 
destring mun_id fgt0*, replace 
merge 1:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) assert(3) nogen 

merge 1:1 mun_id using "popwt_mun", assert(3) nogen 

merge 1:1 mun_id using `s15'
gen insample=_m==3 
drop _m 

rename fgt0_m fgt0_true 


label var fgt0_true "True poverty rate"
label var fgt0_norescale "Predicted poverty rate (raw weights)"
label var fgt0_rescaled "Predicted poverty rate (rescaled weights)"
*twoway   (scatter fgt0_true fgt0_norescale,msymbol(dh) color(red)) (scatter fgt0_true fgt0_rescale,msymbol(o) color(midblue))  (lfit fgt0_true fgt0_norescale,lwidth(thick) lcolor(maroon) ) (lfit fgt0_true fgt0_rescaled,lwidth(thick) lcolor(blue) lpattern(longdash)), ytitle("True poverty rate") xtitle("Predicted poverty rate") legend(label(1 "Raw weights") label(2 "Rescaled weights") label(3 "Fitted line for raw weights (rho=0.65)") label(4 "Fitted line for rescaled weights (rho=0.96)"))

twoway   (scatter fgt0_norescale fgt0_true ,msymbol(dh) color(red)) (scatter fgt0_rescale fgt0_true ,msymbol(o) color(midblue))  (lfit fgt0_norescale fgt0_true ,lwidth(thick) lcolor(maroon) ) (lfit fgt0_rescaled fgt0_true,lwidth(thick) lcolor(blue) lpattern(longdash)) (function y=x,lpattern(dash)), ytitle("Predicted poverty rate") xtitle("True poverty rate") legend(label(1 "Raw weights") label(2 "Rescaled weights") label(3 "Fitted line for raw weights" "(rho=0.84)") label(4 "Fitted line for rescaled weights" "(rho=0.96)") label(5 "45 degree line")) 

global results "$currdata\results\effective_sample_size" 
graph export "$results\predicted_true_rescaled_example_MEX_2010.png", replace 

correlate fgt0_true fgt0_rescale 
correlate fgt0_true fgt0_norescale 

correlate fgt0_true fgt0_rescale if insample==1 
correlate fgt0_true fgt0_norescale if insample==1 

correlate fgt0_true fgt0_rescale [aw=popwt] if insample==1 
correlate fgt0_true fgt0_norescale [aw=popwt] if insample==1 
