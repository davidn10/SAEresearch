cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

/*================================================
  Sampling Mexico 2010
================================================*/

use "census_2010\census_proc_MEX_2010", clear

***PSU size
g aux=1
bys psu_id: egen size=sum(aux)
drop aux

***Sample of UPMs by strata porportional to size
keep ENT MUN TAM_LOC UPM strata strata2 psu_id size
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

bys strata: egen id_error=max(indicator) //=1:46 strata; =0:81 strata
bys strata: egen no_error=sum(indicator)
drop lhs 

keep strata strata2  id_error psu_id size cases_strata total_size num_upm

save "census_2010\census_sampling_MEX_2010", replace //at psu level


***Getting samples
set sortseed 54321
forvalues x=1(1)100 {

use "census_2010\census_sampling_MEX_2010", clear

levelsof strata2 if id_error==0 , local(index)

***Sample for strata with (size/total_size>1/no.cases) (so, error)
preserve
keep if id_error==1 & ((num_upm*0.05)>=0.5)
set sortseed 54321
gsample 5 , percent  strata(strata2) wor 
keep psu_id strata2 num_upm

tempfile ag`x'_sample
save `ag`x'_sample'
*save "census_2010\samples\ag`x'_sample.dta", replace
restore 

preserve
keep if id_error==1 & ((num_upm*0.05)<0.5)
set sortseed 54321
gsample 1, strata(strata2) wor 
keep psu_id strata2 num_upm
tempfile ag2`x'_sample
save `ag2`x'_sample'
*save "census_2010\samples\ag2`x'_sample.dta", replace
restore 

preserve
use `ag`x'_sample', clear
append using `ag2`x'_sample'
***Number of selected upms by strata
bys strata: g num_upm_select=_N
g prob_select_upm= num_upm_select/num_upm
drop num_upm
tempfile agf`x'_sample
save `agf`x'_sample'
restore

***Sample for strata with (size/total_size<=1/no.cases)-so, no error in samplepps
	foreach i in `index' {
		qui sum cases_strata if strata2 == `i'
		local h2 =round(`r(mean)')
		local h2: disp %2.0f `h2'
		set sortseed 54321
		samplepps select_`i' if strata2 == `i', size(size) n(`h2')
		preserve
		keep if select_`i'==1
		***Number of selected upms by strata
		bys strata: g num_upm_select_`i'=_N
		g prob_select_upm= (num_upm_select_`i'*size)/total_size
        sum prob_select_upm
		keep psu_id strata2 prob_select_upm
		
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
append using  `agf`x'_sample'

tempfile sample_`x'
save `sample_`x''
save "census_2010\samples\sample_`x'.dta", replace

}


/*================================================
  Sampling Mexico 2015
================================================*/


use "intercensal_2015\intercensal_proc_MEX_2015", clear

***PSU size
g aux=1
bys psu_id: egen size=sum(aux)
drop aux

***Sample of UPMs by strata porportional to size
keep ENT MUN TAMLOC UPM strata strata2 psu_id size
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

bys strata: egen id_error=max(indicator) //=1:9 strata; =0:112 strata
bys strata: egen no_error=sum(indicator)
drop lhs 

keep strata strata2  id_error psu_id size cases_strata total_size num_upm

save "intercensal_2015\census_sampling_MEX_2015", replace //at psu level


***Getting samples
set sortseed 54321
forvalues x=1(1)100 {

use "intercensal_2015\census_sampling_MEX_2015", clear

levelsof strata2 if id_error==0 , local(index)

***Sample for strata with (size/total_size>1/no.cases) (so, error)
preserve
keep if id_error==1 & ((num_upm*0.05)>=0.5)
set sortseed 54321
gsample 5 , percent  strata(strata2) wor 
keep psu_id strata2 num_upm
***Number of selected upms by strata
bys strata: g num_upm_select=_N
g prob_select_upm= num_upm_select/num_upm
drop num_upm
tempfile ag`x'_sample
save `ag`x'_sample'
*save "census_2010\samples\ag`x'_sample.dta", replace
restore 


***Sample for strata with (size/total_size<=1/no.cases)-so, no error in samplepps
	foreach i in `index' {
		qui sum cases_strata if strata2 == `i'
		local h2 =round(`r(mean)')
		local h2: disp %2.0f `h2'
		set sortseed 54321
		samplepps select_`i' if strata2 == `i', size(size) n(`h2')
		preserve
		keep if select_`i'==1
		***Number of selected upms by strata
		bys strata: g num_upm_select_`i'=_N
		g prob_select_upm= (num_upm_select_`i'*size)/total_size
        sum prob_select_upm
		keep psu_id strata2 prob_select_upm
		
		tempfile strata`i'`x'_data
		save `strata`i'`x'_data'
		*save "census_2010\samples\strata`i'`x'_data.dta", replace
		restore
}

use `strata1`x'_data', clear
*use `strata1`x'_data', clear

foreach m in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 55 56 57 58 59 60 61 62 63 65 66 67 69 70 71 73 74 75 76 77 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 102 103 104 105 106 108 109 110 111 112 113 114 115 116 117 118 119 120 121 {
append using `strata`m'`x'_data'
}
append using  `ag`x'_sample'

tempfile sample_`x'
save `sample_`x''
save "intercensal_2015\samples\sample_`x'.dta", replace

}

  


