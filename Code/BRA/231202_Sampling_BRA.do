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

set sortseed 54321
forvalues x=1(1)100 {
	
preserve
keep mun_id total_size* mun_size*
duplicates drop

gen sample=0 
set sortseed 54321
foreach sample of numlist 1/150 {
samplepps this_sample if sample==0, ncases(1) size(mun_size2)
qui replace sample=1 if this_sample==1  
drop this_sample 
} 

***Probability of a municiaplity to be selected
g prob_select_mun= (150*mun_size2)/total_size2
*g popshare=mun_size2/total_size2
*gen prob_select_mun=1-((1-popshare)^150)
sum prob_select_mun
		
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
set sortseed 54321
gsample 4, percent strata(mun_id) wor 

***Number of selected upms by strata
bys mun_id: g num_hh_select=_N
g prob_select_hh= num_hh_select/mun_size2
sum prob_select_hh


***Factor de expansion
g prob_select=prob_select_hh*prob_select_mun
sum prob_select
gen factor_sample=(1/prob_select)
g popwt=int(weights*hhsize)
g factor_total=factor_sample*popwt

egen double test=sum(factor_sample)
sum test
egen double test2=sum(factor_total)
sum test2

keep mun_id hid factor_total factor_sample

save "samples\sample_`x'.dta", replace
restore
}

