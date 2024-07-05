clear all
set more off

/*=========================================
***Full Mexico 2010 
=========================================*/

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\BRA\2010\full_census"
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
putexcel set "$results\results_sub_ebp\normality_unit_h", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_h\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_sub_ebp\rsquared_unit_h", replace

forvalues i=1(1)100{
	import excel "$results\results_sub_ebp\model_h\model_subebp_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_sub_ebp\variance_unit_h", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_h\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_sub_ebp\normality_unit_h.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Hybrid"
order model
g year="2010"
tempfile norm_h
save `norm_h'

/*==========================
*** R-squared
==========================*/
import excel "$results\results_sub_ebp\rsquared_unit_h.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Hybrid"
order model
g year="2010"
tempfile r2_h
save `r2_h'
/*====================
      Variances
====================*/
import excel "$results\results_sub_ebp\variance_unit_h.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Hybrid"
order model
g year="2010"
tempfile var_h
save `var_h'

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** WOW Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\results_sub_ebp\normality_unit_wow", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_wow\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_sub_ebp\rsquared_unit_wow", replace

forvalues i=1(1)100{
	import excel "$results\results_sub_ebp\model_wow\model_subebp_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_sub_ebp\variance_unit_wow", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_wow\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_sub_ebp\normality_unit_wow.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="WOW"
order model
g year="2010"
tempfile norm_wow
save `norm_wow'

/*==========================
*** R-squared
==========================*/
import excel "$results\results_sub_ebp\rsquared_unit_wow.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="WOW"
order model
g year="2010"
tempfile r2_wow
save `r2_wow'
/*====================
      Variances
====================*/
import excel "$results\results_sub_ebp\variance_unit_wow.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="WOW"
order model
g year="2010"
tempfile var_wow
save `var_wow'


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** NLME Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\results_sub_ebp\normality_unit_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_nlme\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_sub_ebp\rsquared_unit_nlme", replace

forvalues i=1(1)100{
	import excel "$results\results_sub_ebp\model_nlme\model_subebp_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_sub_ebp\variance_unit_nlme", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_nlme\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_sub_ebp\normality_unit_nlme.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="NLME"
order model
g year="2010"
tempfile norm_nlme
save `norm_nlme'

/*==========================
*** R-squared
==========================*/
import excel "$results\results_sub_ebp\rsquared_unit_nlme.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="NLME"
order model
g year="2010"
tempfile r2_nlme
save `r2_nlme'
/*====================
      Variances
====================*/
import excel "$results\results_sub_ebp\variance_unit_nlme.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="NLME"
order model
g year="2010"
tempfile var_nlme
save `var_nlme'

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*** Guadarrama Results
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\results_sub_ebp\normality_unit_g", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_g\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C15:G17) firstrow clear

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
putexcel set "$results\results_sub_ebp\rsquared_unit_g", replace

forvalues i=1(1)100{
	import excel "$results\results_sub_ebp\model_g\model_subebp_`i'.dta.xlsx", sheet("summary")  cellrange(D23:G24) firstrow clear
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
putexcel set "$results\results_sub_ebp\variance_unit_g", replace

forvalues i=1(1)100{

import excel "$results\results_sub_ebp\model_g\model_subebp_`i'.dta.xlsx", sheet("summary") cellrange(C19:D21) firstrow clear

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
import excel "$results\results_sub_ebp\normality_unit_g.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A skw_error
rename B skw_re
rename D kur_error
rename E kur_re

collapse (mean) skw_error skw_re kur_error kur_re
g model="Guadarrama"
order model
g year="2010"
tempfile norm_g
save `norm_g'

/*==========================
*** R-squared
==========================*/
import excel "$results\results_sub_ebp\rsquared_unit_g.xlsx", sheet("Sheet1") clear

***Unit
drop C
rename A r2_marg
rename B r2_cond
rename D r2_area_marg
rename E r2_area_cond

collapse (mean) r2_marg r2_cond r2_area_marg r2_area_cond
g model="Guadarrama"
order model
g year="2010"
tempfile r2_g
save `r2_g'
/*====================
      Variances
====================*/
import excel "$results\results_sub_ebp\variance_unit_g.xlsx", sheet("Sheet1") clear

***Unit
rename A var_error
rename B var_re

collapse (mean) var_error var_re
g model="Guadarrama"
order model
tempfile var_g
save `var_g'

use `norm_wow', clear
append using `norm_nlme'
append using `norm_g'
append using `norm_h'
order year model
save "$results\results_ebp\normality_subebp_2010.dta", replace


use `r2_wow', clear
append using `r2_nlme'
append using `r2_g'
append using `r2_h'
order year model
save "$results\results_ebp\r2_subebp_2010.dta", replace

use `var_wow', clear
append using `var_nlme'
append using `var_g'
append using `var_h'
order year model
save "$results\results_ebp\var_subebp_2010.dta", replace
