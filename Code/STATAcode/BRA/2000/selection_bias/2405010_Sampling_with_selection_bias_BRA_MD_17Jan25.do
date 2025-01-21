/*global rawdata "D:\SAE_project\MEX"
global currdata "$rawdata\2010\full_census_new"
global census "$currdata\rawdata\census_proc_MEX_2010.dta"
*/

****CHANGE DIRECTION****
global rawdata "D:\SAE_project\BRA\BRA_2000"
global currdata "$rawdata\2000\full_census"
global census "$currdata\rawdata\census_proc_BRA_2000.dta"
*global savetempfile "$currdata\census"

set sortseed 54321

/*=======================================
 Remoteness index
 ======================================*/

use "$rawdata\2000\BRA_VIV_2000.dta", clear

***label variables for Brazil_2000:

label var V0102 "UF"
label var V0103 "Municipality"
label var V0104 "District"
label var V0105 "Subdistrict"
label var V1005 "Sector"
label var V1006 "Urban"
label var V0300 "Household ID"

label var V1001 "Geographic region"
label var V1002 "Mesoregion"
label var V1003 "Microregion"
label var V1004 "Metropolitan region"

*Rename variables:

rename V0102 state
rename PESO_DOMIC weights

rename V1001 region
destring region, replace
label define region 1 "North" 2 "Northeast" 3 "Southeast" 4 "South" 5 " Central"
label value region region

rename V1006 urban
replace urban="1" if urban=="1"
replace urban="0" if urban=="2"
destring urban, replace
label define urban 1 "Urban" 0 "Rural"
label value urban urban



***Variables creation

***PSU ID
set seed 3454
rename AREAP psu_id
egen psu_id2=group(psu_id)
*destring psu_id, replace
*format psu_id %20.0g

/*
***Generating strata
set seed 3454
egen strata2 = group(ENT TAM_LOC)
egen strata = concat(uno ENT TAM_LOC)
destring strata, replace
*/

***Households ID
set seed 3454
egen hid=concat(V0103 V0300)
egen hid2=group(hid)
destring hid, replace
format hid %20.0g
label var hid "Household ID (long)"


***Municipality ID
set seed 3454
rename V0103 mun_id
egen mun_id2=group(mun_id)
destring mun_id, replace
label var mun_id "Municipality ID"


***House conditions
destring V0201 V0205 V0207 V0208 V0211 V0212 V0213 V0214 V0215 V0217 V0219 V0220 V0221 V0218 v1113 V0223 V7617, replace
*HH assets: V0218, V0214, V0215, V0217, V0223:83245 missing values; V0221: already numeric 

g water_improved = inlist(V0208, 1,2) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g electri = inlist(V0213, 1)   
g sewage = inlist(V0212, 1,2) //la red p�blica, una fosa s�ptica 
g own_house = inlist(V0205, 1,2) //vive el due�o o propietario
g good_toilet= inlist(V0211,2,1,2)
g good_house= inlist(V0201,1,2) //particular vs. colectivo
g good_street=inlist(v1113,1)
***Overcrowding
rename V7203 over_crowding
rename V7204 over_crowding_ext

***Household assets
g micro=inlist(V0218,1)
g radio = inlist(V0214, 1)
g tele = (V0221>0 & V0221!=.)
g fridge = inlist(V0215, 1)
g washing = inlist(V0217, 1)
g auto = (V0222>0 & V0222!=.)
g compu = inlist(V0220, 1)
g cell = inlist(V0219, 1)
g AC= V0223>0 & V0223!=.



keep state hid hid2 mun_id psu_id2 psu_id urban water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC weights

collapse (mean) mun_id urban water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC (rawsum) weights [pw=weights], by(psu_id)

bys mun_id: gen mun_size=_N
*drop if mun_size<8

pca water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC [w=weights]
predict pcas
xtile percentile_asset = pcas, nq(100)
*xtile decile_asset = pcas, nq(100)
	
keep psu_id pcas mun_size mun_id percentile_asset


***Adjusting by (percentile_asset/20)

g prob_psu_nobias=1/mun_size
g prob_adjust4_r=(percentile_asset/35)^11
replace prob_adjust4_r=1 if prob_adjust4_r >1

/*
g prob_adjust_a=(percentile_asset/25)^5
replace prob_adjust_a=1 if prob_adjust_a >1

g prob_adjust2_a=(percentile_asset/30)^7
replace prob_adjust2_a=1 if prob_adjust2_a >1
*/

***Ajusteing by (value-min)/(max-min)
format pcas %8.6g
sum pcas
/*
g prob_adjust2=(pc1-(-13.5255))/(3.5232-(-13.5255))
replace prob_adjust2=0.0001 if prob_adjust2<0
replace prob_adjust2=1 if prob_adjust2>1
*/

g prob_psu_bias4=prob_psu_nobias*prob_adjust4_r

*g prob_psu_bias3=prob_psu_nobias*prob_adjust_a
*g prob_psu_bias4=prob_psu_nobias*prob_adjust2_a

egen mun_id2=group(mun_id)
keep psu_id mun_id prob_psu_nobias prob_psu_bias* mun_id2 prob_adjust* pcas  percentile_asset

tempfile remoteness
save `remoteness', replace

/*=======================================
Census data
=======================================*/
use "$census", clear

keep mun_id state psu_id hid weights hhsize

preserve
keep mun_id psu_id
duplicates drop
bys mun_id: g size_mun=_N
keep mun_id size_mun
duplicates drop
tempfile size
save `size'
restore
merge m:1 mun_id using `size'
drop _merge
*drop if size_mun<8 //dropping mun with <8 PSU 121264 HH

tempfile census
save `census', replace


***Census with fgt0
use "$census", clear

keep mun_id state psu_id hid weights hhsize fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
preserve
keep mun_id psu_id
duplicates drop
bys mun_id: g size_mun=_N
keep mun_id size_mun
duplicates drop
tempfile size
save `size'
restore
merge m:1 mun_id using `size'
drop _merge
* drop if size_mun<8 //dropping mun with <8 PSU 121264 HH

preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=(weights*hhsize)], by(mun_id)
save "$currdata\simcensus\bias55\true_fgt0.dta", replace
save "$currdata\simcensus\bias77\true_fgt0.dta", replace
save "$currdata\simcensus\bias1111\true_fgt0.dta", replace
save "$currdata\simcensus\bias11b11\true_fgt0.dta", replace
save "$currdata\simcensus\nobias\true_fgt0.dta", replace
restore

tempfile census_fgt
save `census_fgt', replace 


/*=======================================
 Sample selection
=======================================*/

set sortseed 54321
forvalues x=1(1)100 {
 
use `census', clear
***Municipality size and total_size in terms of households
g uno=1
sum uno [w=weights]
g total_size=r(sum_w)  //sum uno [w=FACTOR] 28383893
drop uno

preserve
g uno=1
collapse (sum) mun_size=uno [pw=weights], by(mun_id)
tempfile size
save `size', replace 
restore

merge m:1 mun_id using `size'
drop _merge

************************************
*** Selecting municipalities
preserve
keep mun_id total_size* mun_size*
duplicates drop

***Identifying municipalities with very high probability of selection=1 certainly selected before PPS sample

g popshare=mun_size/total_size
g certain=1 if popshare>(1/900) 
sum certain 

egen aux_size=sum(mun_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=mun_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/739) & popshare2!=. //175
sum certain2 
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=mun_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/564) & popshare3!=. //30
sum certain3
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1
egen total_size4=max(aux_size)
g popshare4=mun_size/total_size4 if certain!=1 & certain2!=1 & certain3!=1
g certain4=1 if popshare4>(1/534) & popshare4!=. //2
sum certain4
drop aux*

g certain_sample=1 if certain==1 | certain2==1 | certain3==1 | certain4==1 
g prob_select_mun=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
drop popshare* total_size*

***PPS sample on the remaining municipalities
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1, ncases(532) size(mun_size)


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

*******************************
*** Selecting PSUs

keep mun_id psu_id 
duplicates drop

***Merging only selected municipalities
merge m:1 mun_id using `samplefile' 
keep if _merge==3
drop _merge

merge 1:1 psu_id using `remoteness'
keep if _merge==3
drop _merge

***Number of PSU per municipality
bys mun_id: g mun_size=_N
/*
g prob2=prob_psu_nobias^2
g prob3=prob_psu_nobias^3

scatter pc1 prob_psu_bias
graph save graph1.gph, replace

scatter pc1 (prob2)
graph save graph2.gph, replace

scatter pc1 (prob3)
graph save graph3.gph, replace

scatter pc1 prob_psu_nobias
graph save graph4.gph, replace

graph combine graph1.gph graph2.gph graph3.gph graph4.gph
*/
preserve 
gsample 10 if mun_size>=10 ,strata(mun_id) wor // nobias
sum pcas
codebook mun_id psu_id
keep psu_id mun_id mun_size pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys mun_id: gen selected_psu=_N
***Probability of PSU getting selected
g prob_select_psu= min(selected_psu/mun_size,1)
sum prob_select_psu prob_psu_nobias
tempfile sample_psu_nobias
save `sample_psu_nobias' 
restore

/* 
preserve
gsample 9 [w=(prob_psu_bias1^5)], strata(mun_id)  // weights2
sum pcr pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcr pcas
tempfile sample_psu_bias5_5
save `sample_psu_bias5_5'
restore

preserve
gsample 9 [w=(prob_psu_bias2^7)], strata(mun_id)  // weights2
sum pcr pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcr pcas
tempfile sample_psu_bias7_7
save `sample_psu_bias7_7'
restore


preserve
gsample 9 [w=(prob_psu_bias3^11)], strata(mun_id)  // weights2
sum pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcas
tempfile sample_psu_bias11_11
save `sample_psu_bias11_11'
restore
*/

preserve
gsample 10 [w=(prob_psu_bias4^11)], strata(mun_id)  // weights2
sum pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcas
tempfile sample_psu_bias11b_11
save `sample_psu_bias11b_11'
restore

*************************************************
*** Selection of HH (non biased samples)

use `census', clear
merge m:1 psu_id using `sample_psu_nobias'
keep if _merge==3
drop _merge

***Selection of HH
preserve
sample 28 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun pcas percentile_asset  prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore


/*==============================
Final samples
===============================*/
use `sample_24', clear

merge 1:1 hid using `census_fgt'
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
g prob_select=prob_select_hh*prob_psu_nobias*prob_select_mun
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

keep psu_id hid mun_id FACTOR_res FACTOR_res2 factor_total state fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
rename factor_total FACTOR

***Direct estimates
preserve
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=FACTOR], by(mun_id)
save "$currdata\simcensus\nobias\direct_nobias_`x'.dta", replace
restore
drop fgt*
save "$currdata\rawsamples_bias\nobias\sample_nobias_`x'.dta", replace


*************************************************
*** Selection of HH (biased samples)

use `census', clear
merge m:1 psu_id using `sample_psu_bias5_5'
keep if _merge==3
drop _merge


****************************Melany dofile
***Selection of HH
preserve
sample 28 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore


/*==============================
Final samples
===============================*/
use `sample_24', clear

merge 1:1 hid using `census_fgt'
rename _merge merge_sample

***Correct weights
g popwt=FACTOR*hhsize

***Number of HH per UPM
bys psu_id: gen numberhh_upm=_N

***Generate state dummy variables
tab code_stat, g(state_)

***Creating sample
*preserve
keep if merge_sample==3

***Probability of HH being selected
bys psu_id: gen num_hh_select=_N

g prob_select_hh= num_hh_select/numberhh_upm
*sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_psu_nobias*prob_select_mun
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
save "$currdata\simcensus\bias55\direct_bias_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_bias\bias55\sample_bias_`x'.dta", replace




*************************************************
*** Selection of HH (biased samples)

use `census', clear
merge m:1 psu_id using `sample_psu_bias7_7'
keep if _merge==3
drop _merge

***Selection of HH
preserve
sample 28 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore


/*==============================
Final samples
===============================*/



/*==============================
Final samples
===============================*/
use `sample_24', clear

merge 1:1 hid using `census_fgt'
rename _merge merge_sample

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
g prob_select=prob_select_hh*prob_psu_nobias*prob_select_mun
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
save "$currdata\simcensus\bias1111\direct_bias_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_bias\bias1111\sample_bias_`x'.dta", replace



*************************************************
*** Selection of HH (biased samples)

use `census', clear
merge m:1 psu_id using `sample_psu_bias11b_11'
keep if _merge==3
drop _merge

***Selection of HH
preserve
sample 28 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore


/*==============================
Final samples
===============================*/
use `sample_24', clear

merge 1:1 hid using `census_fgt'
rename _merge merge_sample

***Correct weights
g popwt=FACTOR*hhsize

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
g prob_select=prob_select_hh*prob_psu_nobias*prob_select_mun
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
save "$currdata\simcensus\bias11b11\direct_bias_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_bias\bias11b11\sample_bias_`x'.dta", replace


}

