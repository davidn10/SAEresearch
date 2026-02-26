clear all
set more off

/*=========================================
***Full Mexico 2000 
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

***Unit level models
putexcel set "$results\results_ebp\normality_unit_h", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_h\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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

***Context level models
putexcel set "$results\results_ebp\normality_context_h", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_h\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
***Unit level models
putexcel set "$results\results_ebp\rsquared_unit_h", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\unit\model_h\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
	foreach x in Marginal_R2 Conditional_R2 Marginal_Area_R2 Conditional_Area_R2 {
		sum `x'
		local `x'_`i'=r(mean)
		}
	
	putexcel A`i'=`Marginal_R2_`i''
	putexcel B`i'=`Conditional_R2_`i''
    putexcel D`i'=`Marginal_Area_R2_`i''
	putexcel E`i'=`Conditional_Area_R2_`i''
}

***Context level models
putexcel set "$results\results_ebp\rsquared_context_h", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_h\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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

***Unit level models
putexcel set "$results\results_ebp\variance_unit_h", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_h\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

sum Variance if rownames=="Error"
local var1_`i'=r(mean)
sum Variance if rownames=="Random_effect"
local var2_`i'=r(mean)

putexcel A`i'=`var1_`i''
putexcel B`i'=`var2_`i''

}

***Context level models
putexcel set "$results\results_ebp\variance_context_h", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_h\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_ebp\normality_unit_h.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\normality_context_h.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\normality_h_2000.dta", replace

/*==========================
*** R-squared
==========================*/
import excel "$results\results_ebp\rsquared_unit_h.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\rsquared_context_h.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\rsquared_h_2000.dta", replace

/*====================
      Variances
====================*/
import excel "$results\results_ebp\variance_unit_h.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\variance_context_h.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\variance_h_2000.dta", replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** WOW Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\results_ebp\normality_unit_wow", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_wow\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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

***Context level models
putexcel set "$results\results_ebp\normality_context_wow", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_wow\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
***Unit level models
putexcel set "$results\results_ebp\rsquared_unit_wow", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\unit\model_wow\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
	foreach x in Marginal_R2 Conditional_R2 Marginal_Area_R2 Conditional_Area_R2 {
		sum `x'
		local `x'_`i'=r(mean)
		}
	
	putexcel A`i'=`Marginal_R2_`i''
	putexcel B`i'=`Conditional_R2_`i''
    putexcel D`i'=`Marginal_Area_R2_`i''
	putexcel E`i'=`Conditional_Area_R2_`i''
}

***Context level models
putexcel set "$results\results_ebp\rsquared_context_wow", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_wow\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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

***Unit level models
putexcel set "$results\results_ebp\variance_unit_wow", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_wow\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

sum Variance if rownames=="Error"
local var1_`i'=r(mean)
sum Variance if rownames=="Random_effect"
local var2_`i'=r(mean)

putexcel A`i'=`var1_`i''
putexcel B`i'=`var2_`i''

}

***Context level models
putexcel set "$results\results_ebp\variance_context_wow", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_wow\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_ebp\normality_unit_wow.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\normality_context_wow.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\normality_wow_2000.dta", replace

/*==========================
*** R-squared
==========================*/
import excel "$results\results_ebp\rsquared_unit_wow.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\rsquared_context_wow.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\rsquared_wow_2000.dta", replace

/*====================
      Variances
====================*/
import excel "$results\results_ebp\variance_unit_wow.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\variance_context_wow.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\variance_wow_2000.dta", replace



*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** NLME Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\results_ebp\normality_unit_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_nlme\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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

***Context level models
putexcel set "$results\results_ebp\normality_context_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nlme\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
***Unit level models
putexcel set "$results\results_ebp\rsquared_unit_nlme", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\unit\model_nlme\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
	foreach x in Marginal_R2 Conditional_R2 Marginal_Area_R2 Conditional_Area_R2 {
		sum `x'
		local `x'_`i'=r(mean)
		}
	
	putexcel A`i'=`Marginal_R2_`i''
	putexcel B`i'=`Conditional_R2_`i''
    putexcel D`i'=`Marginal_Area_R2_`i''
	putexcel E`i'=`Conditional_Area_R2_`i''
}

***Context level models
putexcel set "$results\results_ebp\rsquared_context_nlme", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_nlme\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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

***Unit level models
putexcel set "$results\results_ebp\variance_unit_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_nlme\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

sum Variance if rownames=="Error"
local var1_`i'=r(mean)
sum Variance if rownames=="Random_effect"
local var2_`i'=r(mean)

putexcel A`i'=`var1_`i''
putexcel B`i'=`var2_`i''

}

***Context level models
putexcel set "$results\results_ebp\variance_context_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_nlme\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_ebp\normality_unit_nlme.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\normality_context_nlme.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\normality_nlme_2000.dta", replace

/*==========================
*** R-squared
==========================*/
import excel "$results\results_ebp\rsquared_unit_nlme.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\rsquared_context_nlme.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\rsquared_nlme_2000.dta", replace

/*====================
      Variances
====================*/
import excel "$results\results_ebp\variance_unit_nlme.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\variance_context_nlme.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\variance_nlme_2000.dta", replace



*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** Guadarrama Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\results_ebp\normality_unit_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_g\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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

***Context level models
putexcel set "$results\results_ebp\normality_context_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_g\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
***Unit level models
putexcel set "$results\results_ebp\rsquared_unit_g", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\unit\model_g\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
	foreach x in Marginal_R2 Conditional_R2 Marginal_Area_R2 Conditional_Area_R2 {
		sum `x'
		local `x'_`i'=r(mean)
		}
	
	putexcel A`i'=`Marginal_R2_`i''
	putexcel B`i'=`Conditional_R2_`i''
    putexcel D`i'=`Marginal_Area_R2_`i''
	putexcel E`i'=`Conditional_Area_R2_`i''
}

***Context level models
putexcel set "$results\results_ebp\rsquared_context_g", replace

forvalues i=1(1)100{
	import excel "$results\results_ebp\context\model_g\model_sample_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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

***Unit level models
putexcel set "$results\results_ebp\variance_unit_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\unit\model_g\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

sum Variance if rownames=="Error"
local var1_`i'=r(mean)
sum Variance if rownames=="Random_effect"
local var2_`i'=r(mean)

putexcel A`i'=`var1_`i''
putexcel B`i'=`var2_`i''

}

***Context level models
putexcel set "$results\results_ebp\variance_context_g", replace

forvalues i=1(1)100{

import excel "$results\results_ebp\context\model_g\model_sample_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_ebp\normality_unit_g.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\normality_context_g.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\normality_g_2000.dta", replace

/*==========================
*** R-squared
==========================*/
import excel "$results\results_ebp\rsquared_unit_g.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\rsquared_context_g.xlsx", sheet("Sheet1") clear

***Context
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\rsquared_g_2000.dta", replace

/*====================
      Variances
====================*/
import excel "$results\results_ebp\variance_unit_g.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Unit"
order model
tempfile unit
save `unit'

import excel "$results\results_ebp\variance_context_g.xlsx", sheet("Sheet1") clear

***Context
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Context"
order model
tempfile context
save `context'

use `unit', clear
append using `context'
g year="2000"
order year model
save "$results\results_ebp\variance_g_2000.dta", replace
