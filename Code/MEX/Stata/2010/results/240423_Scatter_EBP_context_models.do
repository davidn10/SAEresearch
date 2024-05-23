
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

set seed 648743


***2010
use "$results10\context\output_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results10\context\output\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "Mean FGT-Guadarrama"
label var sim_fgt_h "Mean FGT-Hybrid"

g unif=runiform() 

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, legend(off) ytitle("Mean FGT-Guadarrama") xtitle("Mean FGT-Hybrid") title("Mexico 2010")
graph save "$results10\mex_2010.gph" , replace

***Mexico 2015
use "$results15\context\output_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results15\context\output\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "Mean FGT-Guadarrama"
label var sim_fgt_h "Mean FGT-Hybrid"

g unif=runiform()

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, legend(off) ytitle("Mean FGT-Guadarrama") xtitle("Mean FGT-Hybrid") title("Mexico 2015")
graph save "$results15\mex_2015.gph" , replace

***Mexico 2020
use "$results20\context\output_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results20\context\output\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "Mean FGT-Guadarrama"
label var sim_fgt_h "Mean FGT-Hybrid"

g unif=runiform()

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, legend(off) ytitle("Mean FGT-Guadarrama") xtitle("Mean FGT-Hybrid") title("Mexico 2020")
graph save "$results20\mex_2020.gph", replace


***Brazil 2010
use "$results10b\context\output_h\sim_ebp_sample_50", clear
destring fgt, replace
rename fgt sim_fgt_h

merge 1:1 area using "$results10b\context\output\sim_ebp_sample_50"
destring fgt, replace
rename fgt sim_fgt_g

label var sim_fgt_g "Mean FGT-Guadarrama"
label var sim_fgt_h "Mean FGT-Hybrid"

g unif=runiform()

graph set window fontface "Times New Roman"
capture set scheme plotplain

tw scatter sim_fgt_g sim_fgt_h || line unif unif, ylabel(0(.2)1) xlabel(0(.2)1) legend(off) ytitle("Mean FGT-Guadarrama") xtitle("Mean FGT-Hybrid") title("BRA 2010")
graph save "$results10b\bra_2010.gph", replace


/*

/*=========================================
Rank correlations 
*=========================================*/

use "$results\context\output_h\sim_ebp_sample_1", clear
destring fgt, replace
*rename area mun_id
rename fgt sim_fgt0_1

forvalues i=2(1)100{
merge 1:1 area using "$results\context\output_h\sim_ebp_sample_`i'"
drop _merge
destring fgt, replace
rename fgt sim_fgt0_`i'
}

egen mean_fgt_h=rowmean(sim_fgt0_* )

keep area mean_fgt_h
tempfile hybrid
save `hybrid'


use "$results\context\output\sim_ebp_sample_1", clear
destring fgt, replace
*rename area mun_id
rename fgt sim_fgt0_1

forvalues i=2(1)100{
merge 1:1 area using "$results\context\output\sim_ebp_sample_`i'"
drop _merge
destring fgt, replace
rename fgt sim_fgt0_`i'
}

egen mean_fgt_g=rowmean(sim_fgt0_* )

keep area mean_fgt_g

merge 1:1 area using `hybrid'

label var mean_fgt_g "Mean FGT-Guadarrama"
label var mean_fgt_h "Mean FGT-Hybrid"

graph set window fontface "Times New Roman"
capture set scheme plotplain

scatter mean_fgt_g mean_fgt_h
