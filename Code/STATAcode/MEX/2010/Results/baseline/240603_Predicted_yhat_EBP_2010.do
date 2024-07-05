clear all
set more off

/*=========================================
***Full Mexico 2010 
=========================================*/

/*=========================================
 Defining globals
 *=========================================*/
global currdata "D:\SAE_project\MEX\2010\full_census_new"
global results "$currdata\results\results_ebp"

/*====================
      Normality
====================*/

***Unit level models
putexcel set "$results\y_hat", replace

forvalues i=1(1)100{

import delimited "$results\unit\yhat_h\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel A`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\unit\yhat_nlme\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel B`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\unit\yhat_wow\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel C`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\unit\yhat_g\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel D`i'=`y_hat_`i''
}


***Context level models
forvalues i=1(1)100{

import delimited "$results\context\yhat_h\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel F`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\context\yhat_nlme\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel G`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\context\yhat_wow\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel H`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\context\yhat_g\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel I`i'=`y_hat_`i''
}


***Context area level models
forvalues i=1(1)100{

import delimited "$results\context\yhat_nopsu_h\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel K`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\context\yhat_nopsu_nlme\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel L`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\context\yhat_nopsu_wow\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel M`i'=`y_hat_`i''
}

forvalues i=1(1)100{

import delimited "$results\context\yhat_nopsu_g\yhat_sample_`i'.dta.csv", clear


sum ybarhat_h
local y_hat_`i'=r(mean)

putexcel N`i'=`y_hat_`i''
}


/*==========================
*** Normality of Errors
==========================*/
import excel "$results\y_hat", sheet("Sheet1") clear

***Unit

rename A Hybrid_unit
rename B nlme_unit
rename C WOW_unit
rename D Guadarrama_unit

rename F Hybrid_context
rename G nlme_context
rename H WOW_context
rename I Guadarrama_context

rename K Hybrid_area_context
rename L nlme_area_context
rename M WOW_area_context
rename N Guadarrama_area_context

collapse (mean) Hybrid_unit nlme_unit WOW_unit Guadarrama_unit Hybrid_context nlme_context WOW_context Guadarrama_context Hybrid_area_context nlme_area_context WOW_area_context Guadarrama_area_context
g model="Unit"
order model
tempfile unit
save `unit'
