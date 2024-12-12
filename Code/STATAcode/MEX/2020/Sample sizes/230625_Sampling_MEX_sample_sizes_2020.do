* cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"
cd "D:\david\SAE\SAE_research_with_Melany\MEX"

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census"
global census "$currdata\rawdata\census_proc_MEX_2020.dta"
global simcensus "$currdata\simcensus\"

/*================================================
  Sampling Mexico 2020
================================================*/

set sortseed 54321

***First select municipalities with at least 1000 households
use "$census", clear
rename TAMLOC TAM_LOC 

tempfile census
save `census'

set sortseed 54321
forvalues x=1(1)100 {
	
use `census', clear
keep MUN TAM_LOC UPM strata strata2 psu_id hid ENT mun_id FACTOR hhsize

***Municipality size and total_size in terms of households
g uno=1
sum uno [w=FACTOR]
g total_size=r(sum_w)  //sum uno [w=FACTOR] 28383893
drop uno

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

***Identifying municipalities with very high probability of selection=1 certainly selected before PPS sample
/*In this census there are 380 municipalities that have a probability of 1 to be in the sample*/
g popshare=mun_size/total_size
g certain=1 if popshare>(1/900) //174
sum certain 

egen aux_size=sum(mun_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=mun_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/726) & popshare2!=. //165
sum certain2 
drop aux_size


egen aux_size=sum(mun_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=mun_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/561) & popshare3!=. //50
sum certain3
drop aux_size


egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1
egen total_size4=max(aux_size)
g popshare4=mun_size/total_size4 if certain!=1 & certain2!=1 & certain3!=1
g certain4=1 if popshare4>(1/511) & popshare4!=. //1
sum certain4
drop aux*

g certain_sample=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
tab certain_sample 

g prob_select_mun=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
drop popshare* total_size*


***PPS sample on the remaining municipalities
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1, ncases(510) size(mun_size)


***Probability of a municipality to be selected
egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1
egen total_size=max(aux_size)

g popshare=mun_size/total_size if this_sample==1
replace prob_select_mun=popshare*510 if this_sample==1

sum prob_select_mun
keep if this_sample==1  | certain_sample==1


keep mun_id  prob_select_mun*
tempfile samplefile
save `samplefile'
restore

drop total_size* mun_size*

***Second: select PSUs
/*Selecting same number of PSUs for all datasets: 9 PSUs/mun*/
***Data at PSU level
keep ENT MUN TAM_LOC UPM strata strata2 psu_id ENT mun_id
duplicates drop

***Number of PSU per municipalities
bys mun_id: g total_psu=_N

***Merging only selected municipalities
merge m:1 mun_id using `samplefile'
keep if _merge==3
drop _merge

preserve
sample 5 , count by(mun_id)
g sample_psu=1
keep psu_id sample_psu  mun_id total_psu
bys mun_id: gen selected_psu=_N
***Probability of PSU getting selected
g prob_select_psu= selected_psu/total_psu
drop total_psu
tempfile sample_psu
save `sample_psu'
restore


/*=========================================
Selection of HH
*=========================================*/
use `census', clear

merge m:1 psu_id using `sample_psu'
keep if _merge==3
drop _merge


***Selection of HH
preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
sample 3 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_r1
save `sample_r1'
restore

preserve
keep if TAM_LOC==4
sample 1 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_u1
save `sample_u1'
restore


preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
sample 7 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_r2
save `sample_r2'
restore

preserve
keep if TAM_LOC==4
sample 2 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_u2
save `sample_u2'
restore


preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
sample 16 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_r3
save `sample_r3'
restore

preserve
keep if TAM_LOC==4
sample 4 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_u3
save `sample_u3'
restore

/*==============================
Create samples
===============================*/
use `sample_r1', clear
append using `sample_u1'

merge 1:1 hid using `census'
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun //merge=3 equals to sample

***Correct weights
g popwt=FACTOR*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab ENT, g(state_)

***Creating sample
*preserve
keep if merge_sample==3

***Probability of HH being selected
bys psu_id: gen num_hh_select=_N

g prob_select_hh= num_hh_select/numberhh_upm
*sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_psu*prob_select_mun
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
save "$simcensus\sample1\direct_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensus\sample1\direct_resc_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensus\sample1\direct_resc2_fg0_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_full\sample1\sample_`x'.dta", replace


use `sample_r2', clear
append using `sample_u2'

merge 1:1 hid using `census'
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun //merge=3 equals to sample

***Correct weights
g popwt=FACTOR*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab ENT, g(state_)

***Creating sample
*preserve
keep if merge_sample==3

***Probability of HH being selected
bys psu_id: gen num_hh_select=_N

g prob_select_hh= num_hh_select/numberhh_upm
*sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_psu*prob_select_mun
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
save "$simcensus\sample2\direct_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensus\sample2\direct_resc_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensus\sample2\direct_resc2_fg0_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_full\sample2\sample_`x'.dta", replace


use `sample_r3', clear
append using `sample_u3'

merge 1:1 hid using `census'
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun //merge=3 equals to sample

***Correct weights
g popwt=FACTOR*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab ENT, g(state_)

***Creating sample
*preserve
keep if merge_sample==3

***Probability of HH being selected
bys psu_id: gen num_hh_select=_N

g prob_select_hh= num_hh_select/numberhh_upm
*sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_psu*prob_select_mun
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
save "$simcensus\sample3\direct_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensus\sample3\direct_resc_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensus\sample3\direct_resc2_fg0_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_full\sample3\sample_`x'.dta", replace

}


