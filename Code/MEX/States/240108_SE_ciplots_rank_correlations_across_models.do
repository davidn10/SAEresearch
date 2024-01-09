
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global data "C:\Users\melyg\Desktop\SAE_Project\data"
global currdata "$data\MEX\census_2010\states\"


import excel  "$currdata\results_ell\rankcorr_ELL_unit_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_u
keep sim all_ell_u
tempfile ell_unit
save `ell_unit'

import excel  "$currdata\results_ell\rankcorr_ELL_context_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_c
keep sim all_ell_c
tempfile ell_context
save `ell_context'

import excel  "$currdata\results_ebp\rankcorr_EBP_unit_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_u
keep sim all_ebp_u
tempfile ebp_unit
save `ebp_unit'

import excel  "$currdata\results_ebp\rankcorr_EBP_context_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_c
keep sim all_ebp_c
tempfile ebp_context
save `ebp_context'

import excel  "$currdata\results_SAEf\rankcorr_SAEf_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_saef
keep sim all_saef
tempfile saef
save `saef'

import excel  "$currdata\results_BRF\rankcorr_BRF_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_brf
keep sim all_brf
tempfile brf
save `brf'

import excel  "$currdata\results_fh\rankcorr_FH.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_fh
keep sim all_fh
tempfile fh
save `fh'

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

foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh all_saef all_brf {
	ci means `x'
	return list 
	local `x'=r(mean)
}
graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh all_saef all_brf,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small))   mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.2f)) xlabel(0.88(.01)0.93) title("Rank correlation coefficients between predicted and true head count ratio") subtitle("Mexican states: Oaxaca, Jalisco, Chiapas", size(small))


***Brazil
global currdata "$data\BRA\"


import excel  "$currdata\results_ell\rankcorr_ELL_unit_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_u
keep sim all_ell_u
tempfile ell_unit
save `ell_unit'

import excel  "$currdata\results_ell\rankcorr_ELL_context_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ell_c
keep sim all_ell_c
tempfile ell_context
save `ell_context'

import excel  "$currdata\results_ebp\rankcorr_EBP_unit_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_u
keep sim all_ebp_u
tempfile ebp_unit
save `ebp_unit'

import excel  "$currdata\results_ebp\rankcorr_EBP_context_res.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_ebp_c
keep sim all_ebp_c
tempfile ebp_context
save `ebp_context'
/*
import excel  "$currdata\results_SAEf\rankcorr_SAEf_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_saef
keep sim all_saef
tempfile saef
save `saef'

import excel  "$currdata\results_BRF\rankcorr_BRF_subarea.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_brf
keep sim all_brf
tempfile brf
save `brf'
*/
import excel  "$currdata\results_fh\rankcorr_FH.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_fh
keep sim all_fh
tempfile fh
save `fh'

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
/*
merge 1:1 sim using `saef'
drop _merge
merge 1:1 sim using `brf'
drop _merge
*/
label var all_ell_u "ELL-unit"
label var all_ell_c "ELL-context"
label var all_ebp_u "EBP-unit"
label var all_ebp_c "EBP-context"
label var all_fh "FH"
*label var all_saef "MERF"
*label var all_brf "BRF"

graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh ,  msize(large) ytitle("Model", size(small)) xtitle("Rank correlation coefficient", size(small))  mlabsize(small) mlabpos(12 12 12 12 12 ) hor  xlabel(, format(%9.2f)) mlabformat(%9.3f %9.3f %9.3f %9.3f %9.3f) xlabel(0.89(.01)0.96) title("Rank correlation coefficients between predicted and true head count ratio") subtitle("Brazil: Minas Gerais", size(small))

