cd "C:\Users\melyg\Desktop\SAE_Project\data\BRA"

/*================================================
  Sampling Brazil 2010
================================================*/

use "census_proc_BRA_2010", clear

/*IN the current version of the census I do not have PSU or EA indicators, 
so this initial version of sampling is made in 2 stages, selecting a pps sample 
of municipalities (150) to follow Minas Gerais paper, then select 12000 households
based on the size of the municipality*/

***Non-weighted municipality size and total_size
bys mun_id: gen mun_size2=_N
g uno=1
egen total_size2=sum(uno)
drop uno

g total_size=6111179 //total number of HH

preserve
g uno=1
collapse (sum) mun_size=uno [pw=weights], by(mun_id)
tempfile size
save `size'
restore

merge m:1 mun_id using `size'
drop _merge


set sortseed 54321
forvalues x=1(1)100 {
	
preserve
keep mun_id total_size* mun_size*
duplicates drop

gen sample=0 
set sortseed 54321
foreach sample of numlist 1/340 { //40% of 853 mun
samplepps this_sample if sample==0, ncases(1) size(mun_size)
qui replace sample=1 if this_sample==1  
drop this_sample 
} 

***Probability of a municiaplity to be selected
g popshare2=mun_size2/total_size2
g popshare=mun_size/total_size
*gen prob_select_mun=1-((1-popshare)^300)
*sum prob_select_mun
gen prob_select_mun=popshare*340
		
qui keep if sample==1  
keep mun_id  mun_size* prob_select_mun
tempfile samplefile
save `samplefile'
restore

***Getting samples
preserve
set sortseed 54321
use "census_proc_BRA_2010", clear

merge m:1 mun_id using `samplefile'
keep if _merge==3
drop _merge
desc,short
set sortseed 54321
gsample 2, percent strata(mun_id) wor 

***Number of selected upms by strata
bys mun_id: g num_hh_select=_N
g prob_select_hh= num_hh_select/mun_size2
sum prob_select_hh


***Factor de expansion
g prob_select=prob_select_hh*prob_select_mun
sum prob_select
gen factor_sample=(1/prob_select)
g popwt=(weights*hhsize)
g factor_total=factor_sample*popwt

egen double test=sum(factor_sample)
sum test
egen double test2=sum(factor_total)
sum test2
des,short

***Total weights
bys mun_id: egen totw1=sum(factor_total)
bys mun_id: egen totw2=mean(factor_total)

g factor2=factor_total/totw1
g factor3=factor_total/totw2

rename factor2 FACTOR_res
rename factor3 FACTOR_res2
rename factor_total FACTOR


keep mun_id hid FACTOR FACTOR_res FACTOR_res2

save "samples\sample_`x'.dta", replace
restore
}

