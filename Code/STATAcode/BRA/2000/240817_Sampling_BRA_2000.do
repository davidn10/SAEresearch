
global currdata "D:\SAE_project\BRA\2000\full_census"
global census "$currdata\rawdata\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus_new\"
global rawsamples "$currdata\rawsamples_new"

/*================================================
  Sampling Mexico 2000
================================================*/

set sortseed 54321


forvalues x=1(1)100 {
	
use "$census", clear

***Municipality size and total_size in terms of households
g uno=1
sum uno [w=weights*hhsize]
g total_size=r(sum_w)  //sum uno [w=FACTOR] 28383893
drop uno

preserve
g uno=1
collapse (sum) mun_size=uno [pw=weights*hhsize], by(mun_id)
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
g certain=1 if popshare>(1/900) //116
sum certain 

egen aux_size=sum(mun_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=mun_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/784) & popshare2!=. //63
sum certain2 
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=mun_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/721) & popshare3!=. //4
sum certain3
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1
egen total_size4=max(aux_size)
g popshare4=mun_size/total_size4 if certain!=1 & certain2!=1 & certain3!=1
g certain4=1 if popshare4>(1/717) & popshare4!=. //0
sum certain4
drop aux*

g certain_sample=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
g prob_select_mun=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
drop popshare* total_size*

***PPS sample on the remaining municipalities
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1, ncases(717) size(mun_size)


***Probability of a municipality to be selected
egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1
egen total_size=max(aux_size)

g popshare=mun_size/total_size if this_sample==1
replace prob_select_mun=popshare*706 if this_sample==1

sum prob_select_mun
keep if this_sample==1  | certain_sample==1


keep mun_id  prob_select_mun*
*tempfile samplefile
*save `samplefile'
save "$rawsamples\mun\sample_`x'.dta", replace
restore
}

set sortseed 54321

forvalues x=1(1)100 {

use "$census", clear
keep mun_id psu_id weights
***Merging only selected municipalities
merge m:1 mun_id using  "$rawsamples\mun\sample_`x'.dta"
keep if _merge==3
drop _merge

***Municipality size and total_size in terms of households
*bys mun_id: g total_size=_N
*bys psu_id: g psu_size=_N

preserve
g uno=1
collapse (sum) total_size=uno [pw=weights], by(mun_id)
tempfile totsize
save `totsize'
restore

preserve
g uno=1
collapse (sum) psu_size=uno [pw=weights], by(psu_id)
tempfile size
save `size'
restore

merge m:1 mun_id using `totsize'
drop _merge

merge m:1 psu_id using `size'
drop _merge

drop weights

duplicates drop
bys mun_id: g number_psu=_N
preserve
keep if number_psu<=10
g prob_select_psu=1
drop total_size number_psu 
tempfile smaller_mun
save `smaller_mun'
restore

***Data at PSU level
keep if number_psu>10
sum mun_id
local initial=r(min)
levelsof mun_id, local(levels)

foreach i in `levels' {
preserve
keep psu_id mun_id total_size psu_size prob_select_mun
duplicates drop	
keep if mun_id==`i'
g popshare=psu_size/total_size
g certain=1 if popshare>(1/10)
sum certain
local exc1=r(sum)

egen aux_size=sum(psu_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=psu_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/(10-`exc1')) & popshare2!=. //72
sum certain2 
local exc2=r(sum)
drop aux_size

egen aux_size=sum(psu_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=psu_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/(10-`exc1'-`exc2')) & popshare3!=. //72
sum certain3 
local exc3=r(sum)
drop aux_size

local sample=10-`exc1'-`exc2'-`exc3'
di `sample'
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 , ncases(`sample') size(psu_size)	

g prob_select_psu=1 if certain==1 | certain2==1 | certain3==1 

bys mun_id: egen aux_size=sum(psu_size) if certain!=1 & certain2!=1 & certain3!=1 
bys mun_id: egen total_size_new=max(aux_size)

g popshare_new=psu_size/total_size_new if this_sample==1
replace prob_select_psu=popshare_new*`sample' if this_sample==1
drop aux_size total_size_new popshare_new

sum prob_select_psu 
keep if this_sample==1  | certain==1 | certain2==1 | certain3==1 
drop popshare* this_sample certain* total_size*

di "`i'"
tempfile mun_`i'
save `mun_`i''
restore
}

drop if mun_id==`initial'
levelsof mun_id, local(merge)

use `mun_`initial'', clear
foreach i in `merge' {
append using `mun_`i''
}

append using `smaller_mun'

tempfile sample_psu
save `sample_psu'
 

/*=========================================
Selection of HH
*=========================================*/
use $census, clear

merge m:1 psu_id using `sample_psu'
keep if _merge==3
drop _merge

***Selection of HH
preserve
sample 28 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu prob_select_mun
tempfile sample_hh
save `sample_hh'
restore


use `sample_hh', clear
merge 1:1 hid using $census
rename _merge merge_sample

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
save "$simcensus\direct_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensus\direct_resc_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensus\direct_resc2_fg0_`x'.dta", replace
restore

drop fgt*
keep mun_id psu_id hid FACTOR FACTOR_res FACTOR_res2

save "$rawsamples\sample_`x'.dta", replace


}


