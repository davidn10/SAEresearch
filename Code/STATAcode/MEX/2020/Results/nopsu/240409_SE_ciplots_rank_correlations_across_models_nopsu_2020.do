
clear all
set more off

/*=========================================
***Full Mexico 2010 
=========================================*/

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2020\full_census"

***Correlations

import excel  "$currdata\results\results_ell\rankcorr_ELL_unit_nopsu.xlsx", sheet("Sheet1") cellrange(A4:AQ103) clear
g sim=_n
rename A all_ell_u
rename M all_ell_u2

rename E all_dir
rename Q all_dir2

keep sim all_ell_u* all_dir*
tempfile ell_unit
save `ell_unit'

import excel  "$currdata\results\results_ell\rankcorr_ELL_context_nopsu.xlsx", cellrange(A4:AQ103) sheet("Sheet1") clear
g sim=_n
rename A all_ell_c
rename M all_ell_c2
keep sim all_ell_c*
tempfile ell_context
save `ell_context'

import excel  "$currdata\results\results_ebp\rankcorr_EBP_unit_nopsu_nlme.xlsx", cellrange(A4:AQ103) sheet("Sheet1") clear
g sim=_n
rename A all_ebp_u
rename M all_ebp_u2
keep sim all_ebp_u*
tempfile ebp_unit
save `ebp_unit'

import excel  "$currdata\results\results_ebp\rankcorr_EBP_context_nopsu_nlme.xlsx", cellrange(A4:AQ103) sheet("Sheet1") clear
g sim=_n
rename A all_ebp_c
rename M all_ebp_c2
keep sim all_ebp_c*
tempfile ebp_context
save `ebp_context'
*/

import excel  "$currdata\results\results_fh\rankcorr_FH.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_fh
rename M all_fh2
keep sim all_fh*
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

label var all_ell_u "ELL-unit"
label var all_ell_c "ELL-context"
label var all_ebp_u "EBP-unit"
label var all_ebp_c "EBP-context"
label var all_fh "FH"


label var all_ell_u2 "ELL-unit"
label var all_ell_c2 "ELL-context"
label var all_ebp_u2 "EBP-unit"
label var all_ebp_c2 "EBP-context"
label var all_fh2 "FH"


putexcel set "$currdata\results\summary\stats_corr_nopsu", replace


foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  {
	ci means `x'
	return list 
	local `x'_m=r(mean)
	local `x'_se=r(se)
	local `x'_ul=r(ub) 
	local `x'_ll=r(lb)
}

foreach x in all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  {
	ci means `x'
	return list 
	local `x'_m=r(mean)
	local `x'_se=r(se)
	local `x'_ul=r(ub) 
	local `x'_ll=r(lb)
}

putexcel A2="ELL-unit"
putexcel A3="ELL-context"
putexcel A4="EBP-unit"
putexcel A5="EBP-context"
putexcel A6="FH"
putexcel A7="BRF"
putexcel A8="Direct"

putexcel B1="Rank correlation"
putexcel C1="Pearson corrleation"
putexcel D1="RC_UL"
putexcel E1="RC_LL"
putexcel F1="PC_UL"
putexcel G1="PC_LL"

putexcel B2=`all_ell_u_m'
putexcel C2=`all_ell_u2_m'
putexcel D2=`all_ell_u_ul'
putexcel E2=`all_ell_u_ll'
putexcel F2=`all_ell_u2_ul'
putexcel G2=`all_ell_u2_ll'

putexcel B3=`all_ell_c_m'
putexcel C3=`all_ell_c2_m'
putexcel D3=`all_ell_c_ul'
putexcel E3=`all_ell_c_ll'
putexcel F3=`all_ell_c2_ul'
putexcel G3=`all_ell_c2_ll'

putexcel B4=`all_ebp_u_m'
putexcel C4=`all_ebp_u2_m'
putexcel D4=`all_ebp_u_ul'
putexcel E4=`all_ebp_u_ll'
putexcel F4=`all_ebp_u2_ul'
putexcel G4=`all_ebp_u2_ll'

putexcel B5=`all_ebp_c_m'
putexcel C5=`all_ebp_c2_m'
putexcel D5=`all_ebp_c_ul'
putexcel E5=`all_ebp_c_ll'
putexcel F5=`all_ebp_c2_ul'
putexcel G5=`all_ebp_c2_ll'

putexcel B6=`all_fh_m'
putexcel C6=`all_fh2_m'
putexcel D6=`all_fh_ul'
putexcel E6=`all_fh_ll'
putexcel F6=`all_fh2_ul'
putexcel G6=`all_fh2_ll'



graph set window fontface "Times New Roman"
set scheme plotplain
ciplot  all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh ,  msize(large) ytitle("Model", size(small)) xtitle("Correlation coefficient", size(small)) /*xlabel(0.76(.02)0.99)*/  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("Rank correlation coefficients between predicted and true head count ratio") subtitle("Mexico 2020: All States", size(small))
graph save "$currdata\results\summary\rank_corr_nopsu", replace
graph export "$currdata\results\summary\rank_corr_nopsu.pdf", replace


graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2 ,  msize(large) ytitle("Model", size(small)) xtitle("Correlation coefficient", size(small)) /*xlabel(0.77(.02)0.99)*/  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("Pearson correlation coefficients between predicted and true head count ratio") subtitle("Mexico 2020: All States", size(small))
graph save "$currdata\results\summary\pear_corr_nopsu", replace
graph export "$currdata\results\summary\pear_corr_nopsu.pdf", replace


**********
***Errors
**********
import excel  "$currdata\results\results_ell\errors_ELL_unit_nopsu.xlsx", sheet("Sheet1") cellrange(A4:O103) clear
g sim=_n
rename A all_ell_u
rename E all_ell_u2

keep sim all_ell_u*
tempfile ell_unit
save `ell_unit'

import excel  "$currdata\results\results_ell\errors_ELL_context_nopsu.xlsx", sheet("Sheet1") cellrange(A4:O103) clear
g sim=_n
rename A all_ell_c
rename E all_ell_c2
keep sim all_ell_c*
tempfile ell_context
save `ell_context'

import excel  "$currdata\results\results_ebp\errors_EBP_unit_nopsu_nlme.xlsx", sheet("Sheet1") cellrange(A4:O103) clear
g sim=_n
rename A all_ebp_u
rename E all_ebp_u2
keep sim all_ebp_u*
tempfile ebp_unit
save `ebp_unit'

import excel  "$currdata\results\results_ebp\errors_EBP_context_nopsu_nlme.xlsx", sheet("Sheet1") cellrange(A4:O103) clear
g sim=_n
rename A all_ebp_c
rename E all_ebp_c2
keep sim all_ebp_c*
tempfile ebp_context
save `ebp_context'

import excel  "$currdata\results\results_fh\errors_FH.xlsx", sheet("Sheet1") clear
g sim=_n
rename A all_fh
rename E all_fh2
keep sim all_fh*
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


label var all_ell_u "ELL-unit"
label var all_ell_c "ELL-context"
label var all_ebp_u "EBP-unit"
label var all_ebp_c "EBP-context"
label var all_fh "FH"


label var all_ell_u2 "ELL-unit"
label var all_ell_c2 "ELL-context"
label var all_ebp_u2 "EBP-unit"
label var all_ebp_c2 "EBP-context"
label var all_fh2 "FH"


putexcel set "$currdata\results\summary\stats_error_nopsu", replace


foreach x in all_ell_u all_ell_c all_ebp_u all_ebp_c all_fh  {
	ci means `x'
	return list 
	local `x'_m=r(mean)
	local `x'_se=r(se)
	local `x'_ul=r(ub) 
	local `x'_ll=r(lb)
}

foreach x in all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2  {
	ci means `x'
	return list 
	local `x'_m=r(mean)
	local `x'_se=r(se)
	local `x'_ul=r(ub) 
	local `x'_ll=r(lb)
}

putexcel A2="ELL-unit"
putexcel A3="ELL-context"
putexcel A4="EBP-unit"
putexcel A5="EBP-context"
putexcel A6="FH"
putexcel A7="BRF"

putexcel B1="MAE"
putexcel C1="RMSE"
putexcel D1="MAE_UL"
putexcel E1="MAE_LL"
putexcel F1="RMSE_UL"
putexcel G1="RMSE_LL"

putexcel B2=`all_ell_u_m'
putexcel C2=`all_ell_u2_m'
putexcel D2=`all_ell_u_ul'
putexcel E2=`all_ell_u_ll'
putexcel F2=`all_ell_u2_ul'
putexcel G2=`all_ell_u2_ll'

putexcel B3=`all_ell_c_m'
putexcel C3=`all_ell_c2_m'
putexcel D3=`all_ell_c_ul'
putexcel E3=`all_ell_c_ll'
putexcel F3=`all_ell_c2_ul'
putexcel G3=`all_ell_c2_ll'

putexcel B4=`all_ebp_u_m'
putexcel C4=`all_ebp_u2_m'
putexcel D4=`all_ebp_u_ul'
putexcel E4=`all_ebp_u_ll'
putexcel F4=`all_ebp_u2_ul'
putexcel G4=`all_ebp_u2_ll'

putexcel B5=`all_ebp_c_m'
putexcel C5=`all_ebp_c2_m'
putexcel D5=`all_ebp_c_ul'
putexcel E5=`all_ebp_c_ll'
putexcel F5=`all_ebp_c2_ul'
putexcel G5=`all_ebp_c2_ll'

putexcel B6=`all_fh_m'
putexcel C6=`all_fh2_m'
putexcel D6=`all_fh_ul'
putexcel E6=`all_fh_ll'
putexcel F6=`all_fh2_ul'
putexcel G6=`all_fh2_ll'




graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u all_ell_c  all_ebp_u all_ebp_c all_fh ,  msize(large) ytitle("Model", size(small)) xtitle("Error coefficient", size(small))  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("MAE") subtitle("Mexico 2020: All States", size(small))
graph save "$currdata\results\summary\mae_nopsu", replace
graph export "$currdata\results\summary\mae_nopsu.pdf", replace


graph set window fontface "Times New Roman"
set scheme plotplain
ciplot all_ell_u2 all_ell_c2 all_ebp_u2 all_ebp_c2 all_fh2 ,  msize(large) ytitle("Model", size(small)) xtitle("Error coefficient", size(small))  mlabpos(12)  mlabformat(%9.3f) hor xlabel(, format(%9.3f))  title("RMSE") subtitle("Mexico 2020: All States", size(small))
graph save "$currdata\results\summary\rmse_nopsu", replace
graph export "$currdata\results\summary\rmse_nopsu.pdf", replace


