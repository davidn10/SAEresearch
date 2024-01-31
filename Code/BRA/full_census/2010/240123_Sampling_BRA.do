cd "D:\SAE_project\BRA\2010\full_census"

/*================================================
  Sampling Brazil 2010
================================================*/

use "rawdata\census_proc_BRA_2010", clear

/*IN the current version of the census I do not have PSU or EA indicators, 
so this initial version of sampling is made in 2 stages, selecting a pps sample 
of municipalities (150) to follow Minas Gerais paper, then select 12000 households
based on the size of the municipality*/

***Non-weighted municipality size and total_size
bys mun_id: gen mun_size2=_N
g uno=1
egen total_size2=sum(uno)
drop uno

g total_size=58051449 //total number of HH: g uno=1, sum uno [w=weights]

preserve
g uno=1
collapse (sum) mun_size=uno [pw=weights], by(mun_id)
tempfile size
save `size'
restore

merge m:1 mun_id using `size'
drop _merge


/*We have 5565 municipalities in Brazil, so we select 40% of them 2226or ~2200*/

set sortseed 54321

forvalues x=1(1)100 {
	
preserve
keep mun_id total_size* mun_size*
duplicates drop

gen sample=0 
set sortseed 54321
*foreach sample of numlist 1/1800 { //40% of 853 mun
forvalues i=1(1)2200 {
samplepps this_sample if sample==0, ncases(1) size(mun_size)
qui replace sample=1 if this_sample==1  
drop this_sample 
} 

***Probability of a municiaplity to be selected
***probability explanation: https://homepages.ecs.vuw.ac.nz/~rarnold/STAT392/SampleSurveysBook/_book/probability-proportional-to-size-sampling.html //with replacement
**WOR: https://dickbrus.github.io/SpatialSamplingwithR/pps.html (it seems is fine what I did)
**WOR: https://go.documentation.sas.com/doc/en/pgmsascdc/9.4_3.3/statug/statug_surveyselect_details13.htm

g popshare2=mun_size2/total_size2
g popshare=mun_size/total_size
gen prob_select_mun=1-((1-popshare)^2200)
*sum prob_select_mun
gen prob_select_mun2=popshare*2200
		
qui keep if sample==1  
keep mun_id  mun_size* prob_select_mun*
tempfile samplefile
save `samplefile'
restore

***Getting samples
preserve
set sortseed 54321
use "rawdata\census_proc_BRA_2010", clear

merge m:1 mun_id using `samplefile'
keep if _merge==3
drop _merge
desc,short
set sortseed 54321
sample 2, by(mun_id)  

***Number of selected upms by strata
bys mun_id: g num_hh_select=_N
g prob_select_hh= num_hh_select/mun_size2
sum prob_select_hh
/*
preserve
g uno=1
collapse (sum) tothh_size=uno [pw=weights], by(mun_id)
tempfile size
save `size'
restore

merge m:1 mun_id using `size'
drop _merge

g prob_select_hh2= tothh_size/mun_size
sum prob_select_hh2
*/


***Factor de expansion
g popwt=(weights*hhsize)
g prob_select=prob_select_hh*prob_select_mun
g prob_select2=prob_select_hh*prob_select_mun2

gen factor_sample=(1/prob_select)
gen factor_sample2=(1/prob_select2)

g factor_total=factor_sample*popwt
g factor_total2=factor_sample2*popwt


/*
egen double test=sum(factor_sample)
sum test
egen double test2=sum(factor_total)
sum test2
egen double test3=sum(factor_total2)
sum test3 [w=hhsize]
*/
des,short

***Total weights
bys mun_id: egen totw1=sum(factor_total)
bys mun_id: egen totw2=mean(factor_total)

bys mun_id: egen totw1_2=sum(factor_total2)
bys mun_id: egen totw2_2=mean(factor_total2)

g factor2=factor_total/totw1
g factor3=factor_total/totw2

g factor2_2=factor_total2/totw1_2
g factor3_2=factor_total2/totw2_2

rename factor2 FACTOR_res
rename factor3 FACTOR_res2
rename factor_total FACTOR

rename factor2_2 FACTOR_res_2
rename factor3_2 FACTOR_res2_2
rename factor_total2 FACTOR_2

keep mun_id hid FACTOR FACTOR_res FACTOR_res2 FACTOR_2 FACTOR_res_2 FACTOR_res2_2

save "rawsamples\sample_`x'.dta", replace
restore
}

***Direct estimates
global census "$data\census_proc_BRA_2010.dta"

use $census, clear
keep mun_id fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m hid
tempfile census
save `census'

forvalues i=1(1)100 {
use "rawsamples\sample_`i'.dta", clear
merge 1:1 hid using `census'
keep if _merge==3

***Direct estimates
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR], by(mun_id)
save "simcensus\direct_fg0_`i'.dta", replace
}
