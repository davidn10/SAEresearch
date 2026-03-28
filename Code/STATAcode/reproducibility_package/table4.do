* append together, take averages, and output to spreadsheet 
* 1. Skewness and kurtosis  
* a. EBP unit and context 

putexcel set ".\output\tables.xlsx", modify sheet("Table4")
global results_MEX_2010 "$MEX\2010\results"
global results_MEX_2015 "$MEX\2015\results"
global results_MEX_2020 "$MEX\2020\results"
global results_BRA_2000 "$BRA\2000\results"
global results_BRA_2010 "$BRA\2010\results"


clear 
use "$results_MEX_2010\results_ebp\normality_h_2010.dta", replace
append using "$results_MEX_2015\results_ebp\normality_h_2015.dta" "$results_MEX_2020\results_ebp\normality_h_2020.dta"


gen country="MEX" 
append using "$results_BRA_2000\results_ebp\normality_h_2000.dta"  "$results_BRA_2010\results_ebp\normality_h_2010.dta"
replace country="BRA" if country=="" 

collapse (mean) skw* kur*, by(model country)
list 
* Mexico 

su skw_re if country=="MEX" & model=="Unit" 
putexcel C4 = `=r(mean)'
su kur_re if country=="MEX" & model=="Unit" 
putexcel C5 = `=r(mean)'

su skw_error if country=="MEX" & model=="Unit" 
putexcel C7 = `=r(mean)'
su kur_error if country=="MEX" & model=="Unit" 
putexcel C8 = `=r(mean)'



su skw_re if country=="MEX" & model=="Context" 
putexcel D4 = `=r(mean)'
su kur_re if country=="MEX" & model=="Context" 
putexcel D5 = `=r(mean)'

su skw_error if country=="MEX" & model=="Context" 
putexcel D7 = `=r(mean)'
su kur_error if country=="MEX" & model=="Context" 
putexcel D8 = `=r(mean)'

* Brazil 

su skw_re if country=="BRA" & model=="Unit" 
putexcel F4 = `=r(mean)'
su kur_re if country=="BRA" & model=="Unit" 
putexcel F5 = `=r(mean)'

su skw_error if country=="BRA" & model=="Unit" 
putexcel F7 = `=r(mean)'
su kur_error if country=="BRA" & model=="Unit" 
putexcel F8 = `=r(mean)'


su skw_re if country=="BRA" & model=="Context" 
putexcel G4 = `=r(mean)'
su kur_re if country=="BRA" & model=="Context" 
putexcel G5 = `=r(mean)'

su skw_error if country=="BRA" & model=="Context" 
putexcel G7 = `=r(mean)'
su kur_error if country=="BRA" & model=="Context" 
putexcel G8 = `=r(mean)'


* b. EBP context without PSU variables 

use "$results_MEX_2010\results_ebp\normality_nopsu_h_2010", replace 
append using "$results_MEX_2015\results_ebp\normality_nopsu_h_2015" "$results_MEX_2020\results_ebp\normality_nopsu_h_2020"
gen country="MEX" 
append using "$results_BRA_2000\results_ebp\normality_nopsu_h_2000.dta"  "$results_BRA_2010\results_ebp\normality_nopsu_h_2010.dta"
replace country="BRA" if country=="" 
drop if country=="BRA" & model~="Hybrid" 
replace model="Context" if model=="Hybrid" 
keep if model=="Context" 

collapse (mean) skw* kur*, by(country model)
su skw_re if country=="MEX" & model=="Context" 
putexcel E4 = `=r(mean)'
su kur_re if country=="MEX" & model=="Context" 
putexcel E5 = `=r(mean)'

su skw_error if country=="MEX" & model=="Context" 
putexcel E7 = `=r(mean)'
su kur_error if country=="MEX" & model=="Context" 
putexcel E8 = `=r(mean)'

su skw_re if country=="BRA" & model=="Context" 
putexcel H4 = `=r(mean)'
su kur_re if country=="BRA" & model=="Context" 
putexcel H5 = `=r(mean)'

su skw_error if country=="BRA" & model=="Context" 
putexcel H7 = `=r(mean)'
su kur_error if country=="BRA" & model=="Context" 
putexcel H8 = `=r(mean)'

* 2. Variance 
* a. ebp unit and PSU U-C 
use "$results_MEX_2010\results_ebp\variance_h_2010", replace 
append using "$results_MEX_2015\results_ebp\variance_h_2015" "$results_MEX_2020\results_ebp\variance_h_2020"
gen country="MEX" 
append using "$results_BRA_2000\results_ebp\variance_h_2000" "$results_BRA_2010\results_ebp\variance_h_2010"
replace country="BRA" if country=="" 
collapse (mean) var*, by(country model)
su var_re if country=="MEX" & model=="Unit" 
putexcel C3 = `=r(mean)' 

su var_error if country=="MEX" & model=="Unit" 
putexcel C6 = `=r(mean)' 

su var_re if country=="MEX" & model=="Context" 
putexcel D3 = `=r(mean)' 

su var_error if country=="MEX" & model=="Context" 
putexcel D6 = `=r(mean)' 


su var_re if country=="BRA" & model=="Unit" 
putexcel F3 = `=r(mean)' 

su var_error if country=="BRA" & model=="Unit" 
putexcel F6 = `=r(mean)' 

su var_re if country=="BRA" & model=="Context" 
putexcel G3 = `=r(mean)' 

su var_error if country=="BRA" & model=="Context" 
putexcel G6 = `=r(mean)' 

* b. EBP area u-c 
use "$results_MEX_2010\results_ebp\variance_nopsu_h_2010", replace 
append using "$results_MEX_2015\results_ebp\variance_nopsu_h_2015" "$results_MEX_2020\results_ebp\variance_nopsu_h_2020"

gen country="MEX" 

append using "$results_BRA_2000\results_ebp\variance_nopsu_2000" "$results_BRA_2010\results_ebp\variance_nopsu_2010"
replace country="BRA" if country=="" 
drop if country=="BRA" & model~="Hybrid" 
replace model="Context" if model=="Hybrid" 

keep if model=="Context" 
collapse (mean) var*, by(country model)
su var_re if country=="MEX" & model=="Context" 
putexcel E3 = `=r(mean)' 
su var_error if country=="MEX" & model=="Context" 
putexcel E6 = `=r(mean)' 
su var_re if country=="BRA" & model=="Context" 
putexcel H3 = `=r(mean)' 

su var_error if country=="BRA" & model=="Context" 
putexcel H6 = `=r(mean)' 
* ICC 
** unit 
foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
import excel using "${results_`dataset'}\results_ebp\ICC_ebp_unit_h.xlsx", clear 
su C 
local ICC_unit_`dataset'=r(mean)
}

** PSU U-C 
foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
import excel using "${results_`dataset'}\results_ebp\ICC_ebp_context_h.xlsx", clear 
su C 
local ICC_uc_`dataset'=r(mean)
}

** Area U-C 
foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
import excel using "${results_`dataset'}\results_ebp\ICC_ebp_nopsu_h.xlsx", clear 
su C 
local ICC_nopsu_`dataset'=r(mean)
}

foreach model in unit uc nopsu {
	local ICC_`model'_MEX=(`ICC_`model'_MEX_2010'+`ICC_`model'_MEX_2015'+`ICC_`model'_MEX_2020')/3
	local ICC_`model'_BRA=(`ICC_`model'_BRA_2000'+`ICC_`model'_BRA_2010')/2 
}

putexcel C9 = `ICC_unit_MEX'
putexcel F9 = `ICC_unit_BRA'

putexcel D9 = `ICC_uc_MEX'
putexcel G9 = `ICC_uc_BRA'

putexcel E9 = `ICC_nopsu_MEX'
putexcel H9 = `ICC_nopsu_BRA'
*/ 

** R2 
** Unit and unit-context 
use "$results_MEX_2010\results_ebp\rsquared_h_2010", replace
append using "$results_MEX_2015\results_ebp\rsquared_h_2015" "$results_MEX_2020\results_ebp\rsquared_h_2020"
gen country="MEX" 
append using "$results_BRA_2000\results_ebp\rsquared_h_2000" "$results_BRA_2010\results_ebp\rsquared_h_2010"
replace country="BRA" if country=="" 
collapse (mean) r2*, by(country model)
su r2_marg if model=="Unit" & country=="MEX" 
putexcel C10 = `=r(mean)'
su r2_cond if model=="Unit" & country=="MEX" 
putexcel C11 = `=r(mean)'
su r2_area_marg if model=="Unit" & country=="MEX" 
putexcel C12 = `=r(mean)'
su r2_area_cond if model=="Unit" & country=="MEX" 
putexcel C13 = `=r(mean)'

su r2_marg if model=="Context" & country=="MEX" 
putexcel D10 = `=r(mean)'
su r2_cond if model=="Context" & country=="MEX" 
putexcel D11 = `=r(mean)'
su r2_area_marg if model=="Context" & country=="MEX" 
putexcel D12 = `=r(mean)'
su r2_area_cond if model=="Context" & country=="MEX" 
putexcel D13 = `=r(mean)'

su r2_marg if model=="Unit" & country=="BRA" 
putexcel F10 = `=r(mean)'
su r2_cond if model=="Unit" & country=="BRA" 
putexcel F11 = `=r(mean)'
su r2_area_marg if model=="Unit" & country=="BRA" 
putexcel F12 = `=r(mean)'
su r2_area_cond if model=="Unit" & country=="BRA" 
putexcel F13 = `=r(mean)'

su r2_marg if model=="Context" & country=="BRA" 
putexcel G10 = `=r(mean)'
su r2_cond if model=="Context" & country=="BRA" 
putexcel G11 = `=r(mean)'
su r2_area_marg if model=="Context" & country=="BRA" 
putexcel G12 = `=r(mean)'
su r2_area_cond if model=="Context" & country=="BRA" 
putexcel G13 = `=r(mean)'

** area unit-context 
use "$results_MEX_2010\results_ebp\rsquared_nopsu_h_2010", replace
append using "$results_MEX_2015\results_ebp\rsquared_nopsu_h_2015" "$results_MEX_2020\results_ebp\rsquared_nopsu_h_2020"
gen country="MEX" 
append using "$results_BRA_2000\results_ebp\rsquared_nopsu_2000" "$results_BRA_2010\results_ebp\rsquared_nopsu_2010"
replace country="BRA" if country=="" 
drop if country=="BRA" & model~="Hybrid" 
replace model="Context" if model=="Hybrid" 
keep if model=="Context" 
collapse (mean) r2*, by(country model)

su r2_marg if model=="Context" & country=="MEX" 
putexcel E10 = `=r(mean)'
su r2_cond if model=="Context" & country=="MEX" 
putexcel E11 = `=r(mean)'
su r2_area_marg if model=="Context" & country=="MEX" 
putexcel E12 = `=r(mean)'
su r2_area_cond if model=="Context" & country=="MEX" 
putexcel E13 = `=r(mean)'

su r2_marg if model=="Context" & country=="BRA" 
putexcel H10 = `=r(mean)'
su r2_cond if model=="Context" & country=="BRA" 
putexcel H11 = `=r(mean)'
su r2_area_marg if model=="Context" & country=="BRA" 
putexcel H12 = `=r(mean)'
su r2_area_cond if model=="Context" & country=="BRA" 
putexcel H13 = `=r(mean)'

