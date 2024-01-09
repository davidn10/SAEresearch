cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\census_2010\"
global currdata "$data\MEX\census_2010\full_census\"
global census "$mdata\census_proc_MEX_2010.dta"
global simcensus "D:\SAE_project\MEX\2010\full_census\"
global simcensuslocal "$currdata\simcensus\"

/*================================================
  Sampling Mexico 2010
================================================*/
set seed 2587
set sortseed 54321

forvalues x=1(1)100 {
	
use "$census", clear
keep MUN TAM_LOC UPM strata strata2 psu_id hid ENT mun_id FACTOR

***Non-weighted municipality size and total_size
bys mun_id: gen mun_size2=_N
g uno=1
egen total_size2=sum(uno)
drop uno

g total_size=28696180 

preserve
g uno=1
collapse (sum) mun_size=uno [pw=FACTOR], by(mun_id)
tempfile size
save `size'
restore

merge m:1 mun_id using `size'
drop _merge

preserve
keep mun_id total_size* mun_size*
duplicates drop

gen sample=0 
*set sortseed 54321
foreach sample of numlist 1/985 { //~40% of 2456 mun
samplepps this_sample if sample==0, ncases(1) size(mun_size)
qui replace sample=1 if this_sample==1  
drop this_sample 
} 

***Probability of a municipality to be selected
g popshare=mun_size/total_size
g popshare2=mun_size2/total_size2
sum popshare*
*gen prob_select_mun=1-((1-popshare)^985)
*sum prob_select_mun
gen prob_select_mun=popshare*985

qui keep if sample==1  
keep mun_id  mun_size* prob_select_mun
tempfile samplefile
save `samplefile'
restore

***Keep only selected municipalities
merge m:1 mun_id using `samplefile'
keep if _merge==3
drop _merge

***Second: select PSUs
/*Once I select municipalities, select PSU. IN survey, 3900 PSU approx. 
So, for this sample of municipalities (78273 psu) we need to select ~5% of PSU */
***PSU size
g aux=1
bys psu_id: egen size=sum(aux)
drop aux

***Sample of UPMs by strata porportional to size
keep ENT MUN TAM_LOC UPM strata strata2 psu_id size ENT 
duplicates drop

***Number of upms by strata
bys strata: g num_upm=_N

***Total size of strata in terms of HH
bys strata: egen total_size=sum(size)

***Cases to select by strata (5%)
g cases_strata=int(round(num_upm*0.05)) //comparing sample in survey versus census, survey has approx: 5% of census UPMs
replace cases_strata=1 if cases_strata==0 //for strata where the number of psu is not enought to get 5%=1 psu, so select 1
format cases_strata %2.0f

***Criteria for erros in samplepps
g double lhs=size/total_size
g double ratio=1/cases_strata
g indicator=((lhs>ratio) | (lhs==1 & ratio==1))

bys strata: egen id_error=max(indicator) //=1:34 strata; =0:91 strata
bys strata: egen no_error=sum(indicator)
drop lhs 

keep id_error psu_id size cases_strata total_size num_upm id_error strata strata2 ENT

***Selecting PSU
levelsof strata2 if id_error==0 , local(index)

***Sample for strata with (size/total_size>1/no.cases) (so, error)
preserve
keep if id_error==1 & ((num_upm*0.05)>=0.5)
*set sortseed 54321
gsample 5 , percent  strata(strata2) wor 
keep psu_id strata2 num_upm ENT
tempfile ag`x'_sample
save `ag`x'_sample'
restore 

preserve
keep if id_error==1 & ((num_upm*0.05)<0.5)
*set sortseed 54321
gsample 1, strata(strata2) wor 
keep psu_id strata2 num_upm ENT
tempfile ag2`x'_sample
save `ag2`x'_sample'
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
		*set sortseed 54321
		samplepps select_`i' if strata2 == `i', size(size) n(`h2')
		preserve
		keep if select_`i'==1
		***Number of selected upms by strata
		bys strata: g num_upm_select_`i'=_N
		g prob_select_upm= (num_upm_select_`i'*size)/total_size
        sum prob_select_upm
		keep psu_id strata2 prob_select_upm ENT
		g index=`i'
		tempfile strata`i'`x'_data
		save `strata`i'`x'_data'
		*save "$currdata\samples\strata`i'1_data.dta", replace
		restore
}

levelsof strata2 if id_error==0 , local(index)

use `strata1`x'_data', clear
foreach i in `index' {
append using `strata`i'`x'_data'
}
duplicates drop

append using  `agf`x'_sample'

tempfile sample_`x'
save `sample_`x''

/*=========================================
Selection of HH
*=========================================*/

use "$census", clear
keep psu_id hid TAM_LOC ENT

merge m:1 psu_id using `sample_`x''
keep if _merge==3
drop _merge

***Selection of HH
preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
*set sortseed 54321
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_upm
tempfile sample_20
save `sample_20'
restore

preserve
keep if TAM_LOC==4
*set sortseed 54321
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_upm
tempfile sample_5
save `sample_5'
restore

/*==============================
Create samples
===============================*/
use `sample_20', clear
append using `sample_5'

merge 1:1 hid using "$census"
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun

***Correct weights
g popwt=FACTOR*hhsize

***Number of HH per UPM
g aux=1
bys psu_id: egen numberhh_upm=sum(aux)
drop aux*

***Generate state dummy variables
tab ENT, g(state_)

***Creating sample
*preserve
keep if merge_sample==3

***Probability of HH being selected
g aux=1
bys psu_id: egen num_hh_select=sum(aux)
drop aux

g prob_select_hh= num_hh_select/numberhh_upm
*sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_upm*prob_select_mun
gen factor_sample=(1/prob_select)

g factor_total=factor_sample*popwt

egen test=sum(factor_sample)
sum test
egen test2=sum(factor_total)
sum test2

***Generating a rescaled weights
***Total weights
bys mun_id: egen totw=sum(factor_total)
bys mun_id: egen totw2=mean(factor_total)
g factor2=factor_total/totw
g factor3=factor_total/totw2
rename factor2 FACTOR_res
rename factor3 FACTOR_res2

keep psu_id hid mun_id FACTOR_res FACTOR_res2 factor_total ENT fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
rename factor_total FACTOR

***Direct estimates
preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR], by(mun_id)
save "$simcensuslocal\direct_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensuslocal\direct_resc_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensuslocal\direct_resc2_fg0_`x'.dta", replace
restore

drop fgt*

save "$simcensus\rawsamples\sample_`x'.dta", replace



}


