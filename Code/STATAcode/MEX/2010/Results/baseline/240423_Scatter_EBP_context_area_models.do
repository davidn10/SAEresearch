
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\"
global results10 "$currdata\MEX\2010\full_census_new\results\results_ebp\"
global results15 "$currdata\MEX\2015\full_census_new\results\results_ebp\"
global results20 "$currdata\MEX\2020\full_census\results\results_ebp\"
global results10b "$currdata\BRA\2010\full_census\results\results_ebp\"

global simcensus10 "$currdata\MEX\2010\full_census_new\simcensus\"
global simcensus15 "$currdata\MEX\2015\full_census_new\simcensus\"
global simcensus20 "$currdata\MEX\2020\full_census\simcensus\"
global simcensus10b "$currdata\BRA\2010\full_census\simcensus\"


set seed 648743


***2010
use "$results10\context\output_nopsu_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results10\context\output_nopsu\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "FGT-Guadarrama"
label var sim_fgt_h "FGT-Hybrid"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, legend(off) ytitle("FGT-Guadarrama") xtitle("FGT-Hybrid") title("Mexico 2010")
graph save "$results10\mex_nopsu_2010.gph" , replace

***Mexico 2015
use "$results15\context\output_nopsu_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results15\context\output_nopsu\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "FGT-Guadarrama"
label var sim_fgt_h "FGT-Hybrid"

g unif=runiform()

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, legend(off) ytitle("FGT-Guadarrama") xtitle("FGT-Hybrid") title("Mexico 2015")
graph save "$results15\mex_nopsu_2015.gph" , replace

***Mexico 2020
use "$results20\context\output_nopsu_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results20\context\output_nopsu\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "FGT-Guadarrama"
label var sim_fgt_h "FGT-Hybrid"

g unif=runiform()

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, legend(off) ytitle("FGT-Guadarrama") xtitle("FGT-Hybrid") title("Mexico 2020")
graph save "$results20\mex_nopsu_2020.gph", replace




*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** Comparing Hybrid with true values


***2010
use "$results10\context\output_nopsu_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h
rename area mun_id
destring mun_id, replace
merge 1:1 mun_id using "$simcensus10\true_fg0_full.dta", keepusing(fgt0_m)
drop _merge

label var fgt0_m "Mean FGT-True"
label var sim_fgt_h "FGT-Hybrid"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_h fgt0_m  || line unif unif, legend(off) xtitle("True FGT") ytitle("FGT-Hybrid") title("Mexico 2010")
graph save "$results10\mex_nopsu_h_true_2010.gph" , replace

***Mexico 2015
use "$results15\context\output_nopsu_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h
rename area mun_id
destring mun_id, replace
merge 1:1 mun_id using "$simcensus15\true_fg0_full.dta", keepusing(fgt0_m)
drop _merge

label var fgt0_m "Mean FGT-True"
label var sim_fgt_h "FGT-Hybrid"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_h fgt0_m || line unif unif, legend(off) xtitle("True FGT") ytitle("FGT-Hybrid") title("Mexico 2015")
graph save "$results10\mex_nopsu_h_true_2015.gph" , replace

***Mexico 2020
use "$results20\context\output_nopsu_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h
rename area mun_id
destring mun_id, replace
merge 1:1 mun_id using "$simcensus20\true_fg0_full.dta", keepusing(fgt0_m)
drop _merge

label var fgt0_m "Mean FGT-True"
label var sim_fgt_h "FGT-Hybrid"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_h fgt0_m || line unif unif, legend(off) xtitle("True FGT") ytitle("FGT-Hybrid") title("Mexico 2020")
graph save "$results10\mex_nopsu_h_true_2020.gph" , replace


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** Comparing Guadarrama with true values


***2010
use "$results10\context\output_nopsu\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h
rename area mun_id
destring mun_id, replace
merge 1:1 mun_id using "$simcensus10\true_fg0_full.dta", keepusing(fgt0_m)
drop _merge

label var fgt0_m "Mean FGT-True"
label var sim_fgt_h "FGT-Guadarrama"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_h fgt0_m  || line unif unif, legend(off) xtitle("True FGT") ytitle("FGT-Guadarrama") title("Mexico 2010")
graph save "$results10\mex_nopsu_g_true_2010.gph" , replace

***Mexico 2015
use "$results15\context\output_nopsu\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h
rename area mun_id
destring mun_id, replace
merge 1:1 mun_id using "$simcensus15\true_fg0_full.dta", keepusing(fgt0_m)
drop _merge

label var fgt0_m "Mean FGT-True"
label var sim_fgt_h "FGT-Guadarrama"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_h fgt0_m || line unif unif, legend(off) xtitle("True FGT") ytitle("FGT-Guadarrama") title("Mexico 2015")
graph save "$results10\mex_nopsu_g_true_2015.gph" , replace

***Mexico 2020
use "$results20\context\output_nopsu\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h
rename area mun_id
destring mun_id, replace
merge 1:1 mun_id using "$simcensus20\true_fg0_full.dta", keepusing(fgt0_m)
drop _merge

label var fgt0_m "Mean FGT-True"
label var sim_fgt_h "FGT-Guadarrama"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_h fgt0_m  || line unif unif, legend(off) xtitle("True FGT") ytitle("FGT-Guadarrama") title("Mexico 2020")
graph save "$results10\mex_nopsu_g_true_2020.gph" , replace



