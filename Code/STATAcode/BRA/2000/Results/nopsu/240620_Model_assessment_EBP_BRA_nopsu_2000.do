clear all
set more off

/*=========================================
***Full BRA 2000 
=========================================*/

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new"

global results "$currdata\results"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** Hybrid Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


/*====================
      Normality
====================*/

***Context level models
putexcel set "$results\results_ebp\normality_context_nopsu_h", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_h\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_ebp\rsquared_context_nopsu_h", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_nopsu_h\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_ebp\variance_context_nopsu_h", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_h\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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

import excel "$results\results_ebp\normality_context_nopsu_h.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Hybrid"
order model
tempfile norm_context_h
save `norm_context_h'


/*==========================
*** R-squared
==========================*/

import excel "$results\results_ebp\rsquared_context_nopsu_h.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Hybrid"
order model
tempfile r2_context_h
save `r2_context_h'

/*====================
      Variances
====================*/


import excel "$results\results_ebp\variance_context_nopsu_h.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Hybrid"
order model
tempfile var_context_h
save `var_context_h'


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** WOW Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
/*====================
      Normality
====================*/

***Context level models
putexcel set "$results\results_ebp\normality_context_nopsu_wow", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_wow\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_ebp\rsquared_context_nopsu_wow", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_nopsu_wow\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_ebp\variance_context_nopsu_wow", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_wow\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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

import excel "$results\results_ebp\normality_context_nopsu_wow.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="WOW"
order model
tempfile norm_context_wow
save `norm_context_wow'


/*==========================
*** R-squared
==========================*/

import excel "$results\results_ebp\rsquared_context_nopsu_wow.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="WOW"
order model
tempfile r2_context_wow
save `r2_context_wow'

/*====================
      Variances
====================*/


import excel "$results\results_ebp\variance_context_nopsu_wow.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="WOW"
order model
tempfile var_context_wow
save `var_context_wow'

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** NLME Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

/*====================
      Normality
====================*/

***Context level models
putexcel set "$results\results_ebp\normality_context_nopsu_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_nlme\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_ebp\rsquared_context_nopsu_nlme", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_nopsu_nlme\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_ebp\variance_context_nopsu_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_nlme\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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

import excel "$results\results_ebp\normality_context_nopsu_nlme.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="NLME"
order model
tempfile norm_context_nlme
save `norm_context_nlme'


/*==========================
*** R-squared
==========================*/

import excel "$results\results_ebp\rsquared_context_nopsu_nlme.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="NLME"
order model
tempfile r2_context_nlme
save `r2_context_nlme'

/*====================
      Variances
====================*/


import excel "$results\results_ebp\variance_context_nopsu_nlme.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="NLME"
order model
tempfile var_context_nlme
save `var_context_nlme'

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** Guadarrama Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
/*====================
      Normality
====================*/

***Context level models
putexcel set "$results\results_ebp\normality_context_nopsu_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nopsu_g\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
	import excel "$results\results_ebp\context\model_nopsu_g\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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

import excel "$results\results_ebp\context\model_nopsu_g\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
g model="Guadarrama"
order model
tempfile norm_context_g
save `norm_context_g'


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
g model="Guadarrama"
order model
tempfile r2_context_g
save `r2_context_g'

/*====================
      Variances
====================*/


import excel "$results\results_ebp\variance_context_nopsu_g.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Guadarrama"
order model
tempfile var_context_g
save `var_context_g'



***All results

use `norm_context_wow', clear
append using `norm_context_nlme'
append using `norm_context_g'
append using `norm_context_h'
g year="2000"
order year model
save "$results\results_ebp\normality_nopsu_2000.dta", replace


use `r2_context_wow', clear
append using `r2_context_nlme'
append using `r2_context_g'
append using `r2_context_h'
g year="2000"
order year model
save "$results\results_ebp\r2_nopsu_2000.dta", replace

use `var_context_wow', clear
append using `var_context_nlme'
append using `var_context_g'
append using `var_context_h'
g year="2000"
order year model
save "$results\results_ebp\var_nopsu_2000.dta", replace
