


/*===================================
=====================================
Unit level models
=====================================
===================================*/
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\results_ebp\"
global simcensus "$currdata\simcensus\"

*
use "$results\unit\output_h\sim_ebp_sample_1", replace 
gen sim=1 
forvalues i=1(1)100{
append using "$results\unit\output_h\sim_ebp_sample_`i'"
qui replace sim=`i' if sim==. 
}
destring area fgt, replace 
rename area mun_id 
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) 
gen MAE_ebp_unit=abs(fgt-fgt0_m)
gen ME_ebp_unit=fgt-fgt0_m 
collapse (mean) M*_ebp_unit, by(mun_id)
save "$results/mae_ebp_unit", replace 

/*===================================
=====================================
Unit context PSU models
=====================================
===================================*/
use "$results\context\output_h\sim_ebp_sample_1", replace 
gen sim=1 
forvalues i=2(1)100{
append using "$results\context\output_h\sim_ebp_sample_`i'"
qui replace sim=`i' if sim==. 
}
destring area fgt, replace 
rename area mun_id 
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) 
gen MAE_ebp_context=abs(fgt-fgt0_m)
gen ME_ebp_context=fgt-fgt0_m
collapse (mean) M*_ebp_context, by(mun_id)
save "$results/mae_ebp_context", replace 


/*===================================
=====================================
ELL models
=====================================
===================================*/


global results "$currdata\results\results_ell\"

use "$results\unit\output\sim_ebp_sample_1", replace 
gen sim=1 
forvalues i=2(1)100{
append using "$results\unit\output\sim_ebp_sample_`i'"
qui replace sim=`i' if sim==. 
}
destring area fgt, replace 
rename area mun_id 
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) 
gen MAE_ell=abs(fgt-fgt0_m)
gen ME_ell=fgt-fgt0_m
collapse (mean) M*_ell, by(mun_id)
save "$results/mae_ell", replace 

/*===================================
=====================================
Subarea models
=====================================
===================================*/


global results "$currdata\results\results_sub_ebp\"

use "$results\output_h\sim_ebp_subebp_1", replace 
gen sim=1 
forvalues i=2(1)100{
append using "$results\output_h\sim_ebp_subebp_`i'"
qui replace sim=`i' if sim==. 
}
destring area mean, replace 
rename area mun_id 
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) 
gen MAE_subarea=abs(mean-fgt0_m)
gen ME_subarea=mean-fgt0_m
collapse (mean) M*_subarea, by(mun_id)
save "$results/mae_subarea", replace 

/*===================================
=====================================
BRF models 
=====================================
===================================*/
global results "$currdata\results\results_BRF\"

***Weights for averaging
use "$census\census.dta", clear
collapse (rawsum) popwt, by(psu_id) 
tempfile weights
save `weights'

use "$results\BRF_sample_1", replace 
gen sim=1 
forvalues i=2(1)100{
append using "$results\BRF_sample_`i'"
qui replace sim=`i' if sim==. 
}

merge n:1 psu_id using `weights', keep(3)
collapse (mean) predictions [aw=popwt], by(mun_id)
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) nogen 

gen MAE_brf=abs(prediction-fgt0_m)
gen ME_brf=prediction-fgt0_m
collapse (mean) M*_brf, by(mun_id)
save "$results/mae_brf", replace 
/*===================================
=====================================
FH models 
=====================================
===================================*/

global results "$currdata\results\results_fh_smooth\"
use "$results\myFH_1", replace 
gen sim=1 
forvalues i=2(1)100{
append using "$results\myFH_`i'"
qui replace sim=`i' if sim==. 
}
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) 
gen MAE_FH=abs(sim_fgt0-fgt0_m)
gen ME_FH=sim_fgt0-fgt0_m
collapse (mean) M*_FH, by(mun_id)
save "$results/mae_FH", replace 


/*===================================
=====================================
Unit context area models
=====================================
===================================*/
global results "$currdata\results\results_ebp\"
use "$results\context\output_nopsu_h\sim_ebp_sample_1", replace 
gen sim=1 
forvalues i=2(1)100{
append using "$results\context\output_nopsu_h\sim_ebp_sample_`i'"
qui replace sim=`i' if sim==. 
}
destring area fgt, replace 
rename area mun_id 
merge n:1 mun_id using "$simcensus\true_fg0_full.dta", keepusing(fgt0_m fgt1_m fgt2_m) keep(3) 
gen MAE_ebp_area_context=abs(fgt-fgt0_m)
gen ME_ebp_area_context=fgt-fgt0_m
collapse (mean) M*_ebp_area_context, by(mun_id)
save "$results/mae_ebp_area_context", replace 

*/ 
global results "$currdata\results\results_ebp\"
use "$results/mae_ebp_unit", replace 
merge 1:1 mun_id using "$results/mae_ebp_context", assert(3) nogen 
global results "$currdata\results\results_ell\"
merge 1:1 mun_id using "$results/mae_ell", assert(3) nogen 
global results "$currdata\results\results_sub_ebp\"
merge 1:1 mun_id using "$results/mae_subarea", assert(3) nogen 
global results "$currdata\results\results_brf\"
merge 1:1 mun_id using "$results/mae_brf", keep(3) nogen 
global results "$currdata\results\results_fh_smooth\"
merge 1:1 mun_id using "$results/mae_FH", keep(3) nogen 
global results "$currdata\results\results_ebp\"
merge 1:1 mun_id using "$results/mae_ebp_area_context", keep(3) nogen 



order MAE_ebp_unit MAE_ell MAE_ebp_context MAE_subarea MAE_brf MAE_FH MAE_ebp_area_context 
label var MAE_ebp_unit "EBP unit"
label var MAE_ebp_context "EBP PSU U-C"
label var MAE_ell "ELL unit"	
label var MAE_subarea "Sub-area"
label var MAE_brf "BRF"
label var MAE_FH "FH"
label var MAE_ebp_area_context "EBP area U-C"

order ME_ebp_unit ME_ell ME_ebp_context ME_subarea ME_brf ME_FH ME_ebp_area_context 
label var ME_ebp_unit "EBP unit"
label var ME_ebp_context "EBP PSU U-C"
label var ME_ell "ELL unit"	
label var ME_subarea "Sub-area"
label var ME_brf "BRF"
label var ME_FH "FH"
label var ME_ebp_area_context "EBP area U-C"


global output "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results\results_error_figure"
* graph hbox  ME*, ylabel(-0.4(0.1)0.4) ytick(-0.4(0.05)0.4) name("ME", replace) ytitle("Error (percentage points)") title("Mexico 2015") saving("$output\figure_me_MEX_2010", replace) yline(0)
gen year=2000 
gen country="BRA" 
save "$output\mae_graph_BRA_2000", replace 

graph hbox  MAE*, ylabel(0(0.05)0.35) ymtick(0(0.01)0.35) name("MAE", replace) ytitle("Mean Absolute Error") title("Brazil 2000") saving("$output\figure_mae_BRA_2000", replace)
