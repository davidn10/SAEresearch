global rawdata "D:\SAE_project\MEX"
global currdata "$rawdata\2010\full_census_new"
global census "$currdata\rawdata\census_proc_MEX_2010.dta"


*** Genrating samples of municipalities

/*================================================
  Sampling Mexico 2010
================================================*/

set sortseed 54321

***First select municipalities with at least 1000 households
use "$census", clear
keep MUN TAM_LOC UPM strata strata2 psu_id hid ENT mun_id FACTOR hhsize
tempfile census
save `census'

set sortseed 54321
forvalues x=1(1)100 {
	
use `census', clear

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
/*In this census there are 555 municipalities that have a probability of 1 to be in the sample*/
g popshare=mun_size/total_size
g certain=1 if popshare>(1/900) //166
sum certain 

egen aux_size=sum(mun_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=mun_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/734) & popshare2!=. //170
sum certain2 
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=mun_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/564) & popshare3!=. //40
sum certain3
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1
egen total_size4=max(aux_size)
g popshare4=mun_size/total_size4 if certain!=1 & certain2!=1 & certain3!=1
g certain4=1 if popshare4>(1/524) & popshare4!=. //1
sum certain4
drop aux*

g certain_sample=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
g prob_select_mun=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
drop popshare* total_size*

***PPS sample on the remaining municipalities
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1, ncases(523) size(mun_size)


***Probability of a municipality to be selected
egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1
egen total_size=max(aux_size)

g popshare=mun_size/total_size if this_sample==1
replace prob_select_mun=popshare*523 if this_sample==1

sum prob_select_mun
keep if this_sample==1  | certain_sample==1


keep mun_id  prob_select_mun*

saveold "$currdata/rawsamples_bias/samples_mun/samplemun_bias_`x'.dta", replace
restore
}

**********************************************************************************
***Household level variables, househols
use "$rawdata\2010\census_viv_2010.dta", clear
g uno="1"

***PSU ID
set seed 3454
egen psu_id2=group(ENT MUN TAM_LOC UPM)
egen psu_id=concat(uno ENT MUN TAM_LOC UPM)
destring psu_id, replace
format psu_id %20.0g

***Generating strata
set seed 3454
egen strata2 = group(ENT TAM_LOC)
egen strata = concat(uno ENT TAM_LOC)
destring strata, replace

***Households ID
set seed 3454
egen hid2=group(ENT MUN ID_VIV)
egen hid=concat(uno ENT MUN ID_VIV)
destring hid, replace
format hid %20.0g

***Municipality ID
set seed 3454
egen mun_id2=group(ENT MUN)
egen mun_id=concat(uno ENT MUN)
destring mun_id, replace
drop uno

*** Variables to get remoteness index
g water_bad = inlist(DISAGU, 4,5,6) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g no_electri = inlist(ELECTRI, 3)   
g no_flush_toilet = inlist(CONAGU,6,7) //tiene descarga directa de agua
g no_sewage = inlist(DRENAJE, 3,4,5) //la red p�blica, una fosa s�ptica 
g no_sersan = inlist(SERSAN, 3)
g shared_bath = inlist(USOEXC,1)
g bad_disposal = inlist(ELIBAS,4,5,6,7,8)
g no_medluz= inlist(MEDLUZ,2)
g no_internet = inlist(INTERNET,2)
g rural = inlist(TAM_LOC,1)

g water_good = inlist(DISAGU, 1,2) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g electri = inlist(ELECTRI, 1)   
g flush_toilet = inlist(CONAGU,5) //tiene descarga directa de agua
g sewage = inlist(DRENAJE, 1,2) //la red p�blica, una fosa s�ptica 
g good_sersan = inlist(SERSAN, 1)
g only_bath = inlist(USOEXC,3)
g good_disposal = inlist(ELIBAS,1,2,3)
g medluz= inlist(MEDLUZ,1)
g internet = inlist(INTERNET,1)
g urban = inlist(TAM_LOC,2,3,4)

keep hid  hid2 psu_id2 psu_id water_bad no_electri no_flush_toilet no_sewage no_sersan shared_bath bad_disposal no_medluz no_internet FACTOR rural ///
water_good electri flush_toilet sewage good_sersan only_bath good_disposal medluz internet urban

collapse (mean) water_bad no_electri no_flush_toilet no_sewage no_sersan shared_bath bad_disposal no_medluz no_internet rural water_good electri flush_toilet sewage good_sersan only_bath good_disposal medluz internet urban (rawsum) FACTOR [pw=FACTOR], by(psu_id)


pca water_good electri flush_toilet sewage good_sersan only_bath good_disposal medluz internet urban [w=FACTOR]

predict pc1
xtile percentile_remote = pc1, nq(100)

keep psu_id percentile_remote pc1

merge 1:m psu_id using "$currdata/census/census.dta", keepusing(mun_id)
drop _merge
duplicates drop  

bys mun_id: g mun_size=_N


g prob_8_psu=8/mun_size
replace prob_8_psu=1 if prob_8_psu>1

g prob_adjust=percentile_remote/20
replace prob_adjust=1 if prob_adjust >1

g prob_select_psu=prob_8_psu*prob_adjust

drop if mun_size<8

egen mun_id2=group(mun_id)

keep psu_id mun_id prob_select_psu mun_id2 prob_adjust percentile_remote


forvalues x=1(1)100 {
	preserve
	merge m:1 mun_id using "$currdata/rawsamples_bias/samples_mun/samplemun_bias_`x'.dta"
	keep if _merge==3
	drop _merge
	saveold "$currdata/rawsamples_bias/mun_data/data_`x'.dta", replace
	restore
}


/*==================================================
*** Sampling households
==================================================*/

use $census, clear
keep psu_id FACTOR hhsize hid TAM_LOC hhsize

***Correct weights
g popwt=FACTOR*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab ENT, g(state_)

tempfile census
save `census'

use "$currdata/rawsamples_bias/samples_psu_biased/sample_data_1.dta", clear
merge 1:m psu_id using `census'
keep if _merge==3
drop _merge


***Selection of HH
preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu prob_select_mun
tempfile sample_24
save `sample_24'
restore

preserve
keep if TAM_LOC==4
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_psu prob_select_mun
tempfile sample_6
save `sample_6'
restore

/*==============================
Create samples
===============================*/
use `sample_24', clear
append using `sample_6'

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
save "$simcensus\full\direct_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res], by(mun_id)
save "$simcensus\full\direct_resc_fg0_`x'.dta", replace
restore

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR_res2], by(mun_id)
save "$simcensus\full\direct_resc2_fg0_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_full\sample_`x'.dta", replace


