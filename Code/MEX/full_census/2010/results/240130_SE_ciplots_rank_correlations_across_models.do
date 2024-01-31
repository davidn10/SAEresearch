
clear all
set more off

/*=========================================
***Full Mexico 2010 
=========================================*/

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2010\full_census_new"
global local "C:\Users\melyg\Desktop\SAE_Project\data\MEX\census_2010\full_census"

***Correlations

import excel  "$currdata\results\results_ell\rankcorr_ELL_unit.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_u
rename M all_ell_u2

rename E all_dir
rename Q all_dir2

keep sim all_ell_u* all_dir*
tempfile ell_unit
save `ell_unit'

import excel  "$currdata\results\results_ell\rankcorr_ELL_context.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_c
rename M all_ell_c2
keep sim all_ell_c*
tempfile ell_context
save `ell_context'

import excel  "$currdata\results\results_ebp\rankcorr_EBP_unit.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_u
rename M all_ebp_u2
keep sim all_ebp_u*
tempfile ebp_unit
save `ebp_unit'

import excel  "$currdata\results\results_ebp\rankcorr_EBP_context.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_c
rename M all_ebp_c2
keep sim all_ebp_c*
tempfile ebp_context
save `ebp_context'

import excel  "$local\results_fh\rankcorr_FH.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_fh
rename M all_fh2
keep sim all_fh*
tempfile fh
save `fh'

import excel  "$currdata\results\results_SAEf\rankcorr_SAEf_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_saef
rename M all_saef2
keep sim all_saef*
tempfile saef
save `saef'

import excel  "$local\results_BRF\rankcorr_BRF_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_brf
rename M all_brf2
keep sim all_brf*
tempfile brf
save `brf'



use `ell_unit', clear
merge 1:1 sim using `ell_context'
drop _merge
merge 1:1 sim using `ell_context'
drop _merge
merge 1:1 sim using `ebp_unit'
drop _merge
merge 1:1 sim using `ebp_context'
drop _merge
merge 1:1 sim using `fh'
drop _merge
merge 1:1 sim using `saef'
drop _merge
merge 1:1 sim using `brf'
drop _merge

label var all_ell_u "ELL-unit"
label var all_ell_c "ELL-context"
label var all_ebp_u "EBP-unit"
label var all_ebp_c "EBP-context"
label var all_fh "FH"
label var all_saef "MERF"
label var all_brf "BRF"
label var all_dir "Direct"

label var all_ell_u2 "ELL-unit"
label var all_ell_c2 "ELL-context"
label var all_ebp_u2 "EBP-unit"
label var all_ebp_c2 "EBP-context"
label var all_fh2 "FH"
label var all_saef2 "MERF"
label var all_brf2 "BRF"
label var all_dir2 "Direct"

foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  all_saef all_brf all_dir {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_dir all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh all_saef all_brf,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) xlabel(0.76(.02)0.99)  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("Rank correlation coefficients between predicted and true head count ratio") subtitle("Mexico 2010: All States", size(small))
graph save "$currdata\results\rank_corr", replace
graph export "$currdata\results\rank_corr.pdf", replace

foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  all_saef all_brf all_dir {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot  all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  all_brf,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) xlabel(0.94(.005)0.96)  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("Rank correlation coefficients between predicted and true head count ratio") subtitle("Mexico 2010: All States (v2)", size(small))
graph save "$currdata\results\rank_corr_v2", replace
graph export "$currdata\results\rank_corr_v2.pdf", replace

foreach x in all_dir2 all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  all_saef2 all_brf2 {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_dir2 all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2 all_saef2 all_brf2,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) xlabel(0.77(.02)0.99)  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("Pearson correlation coefficients between predicted and true head count ratio") subtitle("Mexico 2010: All States", size(small))
graph save "$currdata\results\pear_corr", replace
graph export "$currdata\results\pear_corr.pdf", replace

foreach x in  all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  all_saef2 all_brf2 {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot  all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  all_brf2,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) xlabel(0.94(.005)0.96)  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("Pearson correlation coefficients between predicted and true head count ratio") subtitle("Mexico 2010: All States (v2)", size(small))
graph save "$currdata\results\pear_corr_v2", replace
graph export "$currdata\results\pear_corr_v2.pdf", replace

**********
***Errors
**********
import excel  "$currdata\results\results_ell\errors_ELL_unit.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_u
rename E all_ell_u2

keep sim all_ell_u*
tempfile ell_unit
save `ell_unit'

import excel  "$currdata\results\results_ell\error_ELL_context.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_c
rename E all_ell_c2
keep sim all_ell_c*
tempfile ell_context
save `ell_context'

import excel  "$currdata\results\results_ebp\errors_EBP_unit.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_u
rename E all_ebp_u2
keep sim all_ebp_u*
tempfile ebp_unit
save `ebp_unit'

import excel  "$currdata\results\results_ebp\errors_EBP_context.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_c
rename E all_ebp_c2
keep sim all_ebp_c*
tempfile ebp_context
save `ebp_context'

import excel  "$local\results_fh\errors_FH.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_fh
rename E all_fh2
keep sim all_fh*
tempfile fh
save `fh'

import excel  "$currdata\results\results_SAEf\errors_SAEf_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_saef
rename E all_saef2
keep sim all_saef*
tempfile saef
save `saef'

import excel  "$local\results_BRF\errors_BRF_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_brf
rename E all_brf2
keep sim all_brf*
tempfile brf
save `brf'



use `ell_unit', clear
merge 1:1 sim using `ell_context'
drop _merge
merge 1:1 sim using `ell_context'
drop _merge
merge 1:1 sim using `ebp_unit'
drop _merge
merge 1:1 sim using `ebp_context'
drop _merge
merge 1:1 sim using `fh'
drop _merge
merge 1:1 sim using `saef'
drop _merge
merge 1:1 sim using `brf'
drop _merge

label var all_ell_u "ELL-unit"
label var all_ell_c "ELL-context"
label var all_ebp_u "EBP-unit"
label var all_ebp_c "EBP-context"
label var all_fh "FH"
label var all_saef "MERF"
label var all_brf "BRF"

label var all_ell_u2 "ELL-unit"
label var all_ell_c2 "ELL-context"
label var all_ebp_u2 "EBP-unit"
label var all_ebp_c2 "EBP-context"
label var all_fh2 "FH"
label var all_saef2 "MERF"
label var all_brf2 "BRF"

foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  all_saef all_brf {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh all_saef all_brf,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) xlabel(0.02(.01)0.11)  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("MAE") subtitle("Mexico 2010: All States", size(small))
graph save "$currdata\results\mae", replace
graph export "$currdata\results\mae.pdf", replace

foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  all_saef all_brf {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  all_brf,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) /*xlabel(0.06(.005)0.075)*/  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("MAE") subtitle("Mexico 2010: All States (v2)", size(small))
graph save "$currdata\results\mae_v2", replace
graph export "$currdata\results\mae_v2.pdf", replace

foreach x in all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  all_saef2 all_brf2 {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2 all_saef2 all_brf2,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) xlabel(0.02(.01)0.11)  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("RMSE") subtitle("Mexico 2010: All States", size(small))
graph save "$currdata\results\rmse_corr", replace
graph export "$currdata\results\rmse_corr.pdf", replace

foreach x in all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  all_saef2 all_brf2 {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  all_brf2,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small)) /*xlabel(0.07(.005)0.09)*/  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("RMSE") subtitle("Mexico 2010: All States (v2)", size(small))
graph save "$currdata\results\rmse_corr_v2", replace
graph export "$currdata\results\rmse_corr_v2.pdf", replace


