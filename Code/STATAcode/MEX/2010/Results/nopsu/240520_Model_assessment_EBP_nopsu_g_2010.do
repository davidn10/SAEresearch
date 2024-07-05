clear all
set more off

/*=========================================
***Full Mexico 2010 
=========================================*/

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2010\full_census_new"
global results "$currdata\results"

/*====================
      Normality
====================*/

***Context level models
putexcel set "$results\results_ebp\normality_context_nopsu_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

sum Skewness if rownames=="Error"
local skw1_`i'=r(mean)
sum Skewness if rownames=="Random_effect"
local skw2_`i'=r(mean)

sum Kurtosis if rownames=="Error"
local kur1_`i'=r(mean)
sum Kurtosis if rownames=="Random_effect"
local kur2_`i'=r(mean)


putexcel A`i'=`skw1_`i''
putexcel B`i'=`skw2_`i''

putexcel D`i'=`kur1_`i''
putexcel E`i'=`kur2_`i''
}

/*====================
      R-squared
====================*/
***Context level models
putexcel set "$results\results_ebp\rsquared_context_nopsu_g", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_nopsu\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
	foreach x in Marginal_R2 Conditional_R2 Marginal_Area_R2 Conditional_Area_R2 {
		sum `x'
		local `x'_`i'=r(mean)
		}
	
	putexcel A`i'=`Marginal_R2_`i''
	putexcel B`i'=`Conditional_R2_`i''
    putexcel D`i'=`Marginal_Area_R2_`i''
	putexcel E`i'=`Conditional_Area_R2_`i''
}

/*====================
      Variances
====================*/

***Context level models
putexcel set "$results\results_ebp\variance_context_nopsu_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

sum Variance if rownames=="Error"
local var1_`i'=r(mean)
sum Variance if rownames=="Random_effect"
local var2_`i'=r(mean)

putexcel A`i'=`var1_`i''
putexcel B`i'=`var2_`i''

}

/*==========================
*** Normality of Errors
==========================*/

import excel "$results\results_ebp\normality_context_nopsu_g.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Context"
order model
g year="2010"
order year model
save "$results\results_ebp\normality_nopsu_g_2010.dta", replace

/*==========================
*** R-squared
==========================*/

import excel "$results\results_ebp\rsquared_context_nopsu_g.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Context"
order model
g year="2010"
order year model
save "$results\results_ebp\rsquared_nopsu_g_2010.dta", replace

/*====================
      Variances
====================*/
***Context
import excel "$results\results_ebp\variance_context_nopsu_g.xlsx", sheet("Sheet1") clear

rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Context"
order model
g year="2010"
order year model
save "$results\results_ebp\variance_nopsu_g_2010.dta", replace
