
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global census "$currdata\rawdata\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus_new\"

/*================================================
  Sampling Brazil 2000
================================================*/

set sortseed 54321


forvalues x=1(1)100 {
	
use "$census", clear

***Municipality size and total_size in terms of households
g uno=1
sum uno [w=weights]
g total_size=r(sum_w)  //sum uno [w=FACTOR] 28383893
drop uno

preserve
g uno=1
collapse (sum) mun_size=uno [pw=weights], by(mun_id)
tempfile size
save `size'
restore

merge m:1 mun_id using `size'
drop _merge


preserve
keep mun_id total_size* mun_size*
duplicates drop

***Identifying municipalities with very high probability of selection=1 certainly selected before PPS sample
/*In this census there are 555 municipalities that have a probability of 1 to be in the sample*/
g popshare=mun_size/total_size
g certain=1 if popshare>(1/900) //124
sum certain 



egen aux_size=sum(mun_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=mun_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/776) & popshare2!=. //60
sum certain2 
drop aux_size


egen aux_size=sum(mun_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=mun_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/716) & popshare3!=. //8
sum certain3
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1
egen total_size4=max(aux_size)
g popshare4=mun_size/total_size4 if certain!=1 & certain2!=1 & certain3!=1
g certain4=1 if popshare4>(1/708) & popshare4!=. //0
sum certain4
drop aux*

g certain_sample=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
g prob_select_mun=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
drop popshare* total_size*

***PPS sample on the remaining municipalities
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1, ncases(701) size(mun_size)


***Probability of a municipality to be selected
egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1
egen total_size=max(aux_size)

g popshare=mun_size/total_size if this_sample==1
replace prob_select_mun=popshare*707 if this_sample==1

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
keep psu_id mun_id
duplicates drop

***Number of PSU per municipalities
bys mun_id: g total_psu=_N

***Merging only selected municipalities
merge m:1 mun_id using `samplefile'
keep if _merge==3
drop _merge

preserve
sample 10, count by(mun_id)
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
use $census, clear

merge m:1 psu_id using `sample_psu'
keep if _merge==3
drop _merge

***Selection of HH: (1) 4 HH per psu_id, (2) 8 HH per psu, (3) 16
preserve
sample 4 , count by(psu_id)
desc, short
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_hh1
save `sample_hh1'
restore

preserve
sample 8 , count by(psu_id)
desc, short
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_hh2
save `sample_hh2'
restore

preserve
sample 16 , count by(psu_id)
desc, short
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu
tempfile sample_hh3
save `sample_hh3'
restore


use `sample_hh1', clear
merge 1:1 hid using $census
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun //merge=3 equals to sample

***Correct weights
g popwt=weights*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab state, g(state_)

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

egen test=sum(factor_sample) //should be close to 5'304 711
sum test
egen test2=sum(factor_total) //shoudl be close to 169'872 856
sum test2

***Generating a rescaled weights
***Total weights
bys mun_id: egen totw=sum(factor_total)
bys mun_id: egen totw2=mean(factor_total)
g factor2=factor_total/totw
g factor3=factor_total/totw2
rename factor2 FACTOR_res
rename factor3 FACTOR_res2

keep psu_id hid mun_id FACTOR_res FACTOR_res2 factor_total state fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
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
keep mun_id hid FACTOR FACTOR_res FACTOR_res2

save "$currdata\rawsamples_new\sample1\sample_`x'.dta", replace


use `sample_hh2', clear
merge 1:1 hid using $census
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun //merge=3 equals to sample

***Correct weights
g popwt=weights*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab state, g(state_)

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

egen test=sum(factor_sample) //should be close to 5'304 711
sum test
egen test2=sum(factor_total) //shoudl be close to 169'872 856
sum test2

***Generating a rescaled weights
***Total weights
bys mun_id: egen totw=sum(factor_total)
bys mun_id: egen totw2=mean(factor_total)
g factor2=factor_total/totw
g factor3=factor_total/totw2
rename factor2 FACTOR_res
rename factor3 FACTOR_res2

keep psu_id hid mun_id FACTOR_res FACTOR_res2 factor_total state fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
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
keep mun_id hid FACTOR FACTOR_res FACTOR_res2

save "$currdata\rawsamples_new\sample2\sample_`x'.dta", replace


use `sample_hh3', clear
merge 1:1 hid using $census
rename _merge merge_sample

merge m:1 mun_id using `samplefile', keepusing(prob_select_mun)
rename _merge merge_mun //merge=3 equals to sample

***Correct weights
g popwt=weights*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab state, g(state_)

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

egen test=sum(factor_sample) //should be close to 5'304 711
sum test
egen test2=sum(factor_total) //shoudl be close to 169'872 856
sum test2

***Generating a rescaled weights
***Total weights
bys mun_id: egen totw=sum(factor_total)
bys mun_id: egen totw2=mean(factor_total)
g factor2=factor_total/totw
g factor3=factor_total/totw2
rename factor2 FACTOR_res
rename factor3 FACTOR_res2

keep psu_id hid mun_id FACTOR_res FACTOR_res2 factor_total state fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
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
keep mun_id hid FACTOR FACTOR_res FACTOR_res2

save "$currdata\rawsamples_new\sample3\sample_`x'.dta", replace

}


