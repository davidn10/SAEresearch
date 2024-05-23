
cd "D:\SAE_project\MEX\2010\full_census_new"

use "results\model_sample\unit_ebp_coef_50.dta", clear
rename coefficients EBP_unit
merge 1:1 names using "results\model_sample\unit_ell_coef_50.dta"
drop _merge
rename coefficients ELL_unit
do "C:\Users\melyg\Desktop\SAE_Project\code\Code\Stata\MEX\240520_labels_coefficients models"

drop if names=="(Intercept)"

g type=.
replace type=2  if strpos(long_name ,"(mun)")>0 
replace type=3  if strpos(long_name ,"(psu)")>0 
replace type=4  if strpos(names ,"state_")>0 

replace type=1 if type==.
drop if type==4
sort type



use "results\model_sample\context_ebp_coef_50.dta", clear
rename coefficients EBP_Context
merge 1:1 names using "results\model_sample\context_ell_coef_50.dta"
drop _merge
rename coefficients ELL_Context
do "C:\Users\melyg\Desktop\SAE_Project\code\Code\Stata\MEX\240520_labels_coefficients models"

drop if names=="(Intercept)"

g type=.
replace type=2  if strpos(long_name ,"(mun)")>0 
replace type=3  if strpos(long_name ,"(psu)")>0 
replace type=4  if strpos(names ,"state_")>0 
replace type=1 if type==.
drop if type==4
sort type

