global dir "D:\SAE_project\MEX\"

***This si form EBPmodels after running ELL unit, but these samples didn't work for ELL context
preserve 
use "$dir\2010\full_census\census\census.dta", replace
keep mun_id
duplicates drop
tempfile 2010
save `2010'
restore

forvalues i=1(1)100 {
use "$dir\s20_c10\full_census\samples\sample_R_`i'.dta", replace
merge m:1 mun_id using `2010'
keep if _merge==3
drop _merge
save "$dir\s20_c10\full_census\samples_ebp\sample_R_`i'.dta", replace
}

***Context samples

preserve 
use "$dir\2010\full_census\census\census.dta", replace
keep mun_id
duplicates drop
tempfile 2010
save `2010'
restore

forvalues i=1(1)100 {
use "$dir\s20_c10\full_census\context\samples\sample_R_`i'.dta", replace
merge m:1 mun_id using `2010'
keep if _merge==3
drop _merge
save "$dir\s20_c10\full_census\context\samples_ebp\sample_R_`i'.dta", replace
}
