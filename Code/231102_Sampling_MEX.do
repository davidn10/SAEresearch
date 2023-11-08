cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"


use "census_2010\census_proc_MEX_2010", clear

***PSU size
g aux=1
bys psu_id: egen size=sum(aux)
drop aux

***Sample of UPMs by strata porportional to size
keep ENT MUN TAM_LOC UPM strata psu_id size
duplicates drop

***Number of upms by strata
bys strata: g num_upm=_N

***Total size
bys strata: egen total_size=sum(size)

***Cases to select by strata (5%)
g cases_strata=int(round(num_upm*0.05)) //comparing sample in survey versus census, survey has approx: 5% of census UPMs
replace cases_strata=1 if cases_strata==0 //for strata where the number of psu is not enought to get 5%=1 psu, so select 1
format cases_strata %2.0f

***Criteria for erros in samplepps
g double lhs=size/total_size
g double ratio=1/cases_strata
g indicator=((lhs>ratio) | (lhs==1 & ratio==1))

bys strata: egen id_error=max(indicator)
bys strata: egen no_error=sum(indicator)
drop lhs 

/*
***Modifying UPM size only for cases it gives an error. Ask if it's okay
rename size size_orig
g size=size_orig
replace size=total_size*(ratio) if id_error==1 & indicator==1
replace size=trunc(size)

g lhs=size/total_size
g indicator2=(lhs>ratio)

bys strata: egen id_error2=max(indicator2)
drop lhs ratio id_error2 indicator2
*/
keep strata id_error psu_id size cases_strata total_size num_upm

save "census_2010\census_sampling_MEX_2010", replace


***Getting samples
forvalues x=1(1)100 {

use "census_2010\census_sampling_MEX_2010", clear

levelsof strata if id_error==0 , local(index)

***Sample for strata with (size/total_size>1/no.cases) (so, error)
set sortseed 54321

preserve
keep if id_error==1 & ((num_upm*0.05)>=0.5)
gsample 5 , percent  strata(strata) wor 
keep psu_id strata num_upm
***Number of selected upms by strata
bys strata: g num_upm_select=_N
g prob_select_upm= num_upm_select/num_upm
drop num_upm
tempfile ag`x'_sample
save `ag`x'_sample'
*save "census_2010\samples\ag`x'_sample.dta", replace
restore 

preserve
keep if id_error==1 & ((num_upm*0.05)<0.5)
gsample 1, strata(strata) wor 
keep psu_id strata num_upm
***Number of selected upms by strata
bys strata: g num_upm_select=_N
g prob_select_upm= num_upm_select/num_upm
drop num_upm

tempfile ag2`x'_sample
save `ag2`x'_sample'
*save "census_2010\samples\ag2`x'_sample.dta", replace
restore 

***Sample for strata with (size/total_size<=1/no.cases)-so, no error in samplepps
	foreach i in `index' {
		qui sum cases_strata if strata == `i'
		local h2 =round(`r(mean)')
		local h2: disp %2.0f `h2'
		samplepps select_`i' if strata == `i', size(size) n(`h2')
		preserve
		keep if select_`i'==1
		***Number of selected upms by strata
		bys strata: g num_upm_select_`i'=_N
		g prob_select_upm= (num_upm_select_`i'*size)/total_size
        sum prob_select_upm
		keep psu_id strata prob_select_upm
		
		tempfile strata`i'`x'_data
		save `strata`i'`x'_data'
		*save "census_2010\samples\strata`i'`x'_data.dta", replace
		restore
}

use `strata1`x'_data', clear
*use `strata1`x'_data', clear

foreach m in 2 3 5 6 7 8 9 10 12 13 15 16 18 20 21 22 23 24 28 30 32 33 34 35 36 38 40 41 42 43 44 46 48 49 50 51 52 54 56 57 60 61 62 64 65 66 68 70 71 72 76 78 80 84 85 86 87 88 89 90 92 96 97 98 100 102 104 105 108 110 112 113 114 117 119 121 123 125 126 127 {
append using `strata`m'`x'_data'
}
append using  `ag`x'_sample'
append using  `ag2`x'_sample'


tempfile sample_`x'
save `sample_`x''
save "census_2010\samples\sample_`x'.dta", replace

}





