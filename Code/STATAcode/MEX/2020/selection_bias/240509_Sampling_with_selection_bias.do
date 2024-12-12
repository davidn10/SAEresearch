global rawdata "D:\SAE_project\MEX"
global currdata "$rawdata\2020\full_census"
global census "$currdata\rawdata\census_proc_MEX_2020.dta"
global homedata "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

set sortseed 54321

/*=======================================
 Remoteness index
 ======================================*/
use "$homedata\Census_2020\census_viv_2020.dta", clear
g uno="1"
destring TAMLOC, replace
recode TAMLOC (3=2) (4=3) (5=4)

***PSU ID
set seed 3454
egen psu_id2=group(ENT MUN TAMLOC UPM)
egen psu_id=concat(uno ENT MUN TAMLOC UPM)
destring psu_id, replace
format psu_id %20.0g

***Generating strata
set seed 3454
egen strata2 = group(ENT TAMLOC)
egen strata = concat(uno ENT TAMLOC)
destring strata, replace

***Households ID
set seed 3454
egen hid2=group(ENT MUN ID_VIV)
destring ID_VIV, replace
format ID_VIV %25.0g
gen double hid=1000000000000+ID_VIV
format hid %25.0g

***Municipality ID
set seed 3454
egen mun_id2=group(ENT MUN)
egen mun_id=concat(uno ENT MUN)
destring mun_id, replace
drop uno


*** Variables to get remoteness index
g water_bad = inlist(AGUA_ENTUBADA, 3) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g no_electri = inlist(ELECTRI, 3)   
g no_flush_toilet = inlist(CONAGU,2,3) //tiene descarga directa de agua
g no_sewage = inlist(DRENAJE, 3,4,5) //la red p�blica, una fosa s�ptica 
g no_sersan = inlist(SERSAN, 2,3)
g no_internet = inlist(INTERNET,8)
g rural = inlist(TAMLOC,1)

g water_good = inlist(AGUA_ENTUBADA, 1,2) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g electri = inlist(ELECTRI, 1)   
g flush_toilet = inlist(CONAGU,1) //tiene descarga directa de agua
g sewage = inlist(DRENAJE, 1,2) //la red p�blica, una fosa s�ptica 
g good_sersan = inlist(SERSAN, 1)
g internet = inlist(INTERNET, 7)
g urban = inlist(TAMLOC,2,3,4)


***House conditions
g wall_improved  = inlist(PAREDES,6,7,8) //madera, adobe; tabique, ladrillo, block, piedra, cemento, concreto
g roof_improved  = inlist(TECHOS, 3,4,9,10) //lamina metalica, lamina asbesto, teaj, losa concreto    
g floor_improved = inlist(PISOS, 2,3) //cemento; madera, mosaico 
  
g own_house = inlist(TENENCIA, 1) //vive el due�o o propietario
g cook_fuel = inlist(COMBUS, 2,3) //gas?,  electricidad?

***Overcrowding
recode TOTCUART  (99=.)
recode CUADORM (99=.)
destring NUMPERS, replace

g over_crowding=NUMPERS/TOTCUART
g over_crowding_ext=NUMPERS/CUADORM

***Household assets
g stove = inlist(ESTUFA, 1) //estufa de gas
g shower = inlist(REGADERA, 7)
g radio = inlist(RADIO,5)
g tele = inlist(TELEVISOR, 7)
g fridge = inlist(REFRIGERADOR, 1)
g washing = inlist(LAVADORA, 3)
g auto = inlist(AUTOPROP, 7)
g compu = inlist(COMPUTADORA, 1)
g cell = inlist(CELULAR, 5)


keep hid  hid2 mun_id psu_id2 psu_id water_bad no_electri no_flush_toilet no_sewage no_sersan    no_internet FACTOR rural ///
water_good electri flush_toilet sewage good_sersan  internet urban ///
cell compu auto washing fridge tele radio shower stove over_crowding cook_fuel own_house floor_improved roof_improved wall_improved

collapse (mean) mun_id water_bad no_electri no_flush_toilet no_sewage no_sersan  no_internet rural water_good electri flush_toilet sewage good_sersan internet urban cell compu auto washing fridge tele radio shower stove over_crowding cook_fuel own_house floor_improved roof_improved wall_improved (rawsum) FACTOR [pw=FACTOR], by(psu_id)

bys mun_id: gen mun_size=_N
* drop if mun_size<8

pca water_good electri flush_toilet sewage good_sersan internet urban [w=FACTOR]
predict pcr
xtile percentile_remote = pcr, nq(100)
*xtile decile_remote = pcr, nq(100)

pca cell compu auto washing fridge tele radio shower stove over_crowding cook_fuel own_house floor_improved roof_improved wall_improved flush_toilet internet  [w=FACTOR]
predict pcas
xtile percentile_asset = pcas, nq(100)
*xtile decile_asset = pcas, nq(100)

keep psu_id percentile_remote pcr pcas mun_size mun_id percentile_asset


***Adjusting by (percentile_remoteness/20)
g prob_psu_nobias=8/mun_size
g prob_adjust_r=(percentile_remote/25)^5
replace prob_adjust_r=1 if prob_adjust_r >1

g prob_adjust2_r=(percentile_remote/25)^7
replace prob_adjust2_r=1 if prob_adjust2_r >1

g prob_adjust3_r=(percentile_remote/35)^11
replace prob_adjust3_r=1 if prob_adjust3_r >1

g prob_adjust4_r=(percentile_asset/35)^11
replace prob_adjust4_r=1 if prob_adjust4_r >1

/*
g prob_adjust_a=(percentile_asset/25)^5
replace prob_adjust_a=1 if prob_adjust_a >1

g prob_adjust2_a=(percentile_asset/30)^7
replace prob_adjust2_a=1 if prob_adjust2_a >1
*/

***Ajusteing by (value-min)/(max-min)
format pcr pcas %8.6g
sum pcr pcas
/*
g prob_adjust2=(pc1-(-13.5255))/(3.5232-(-13.5255))
replace prob_adjust2=0.0001 if prob_adjust2<0
replace prob_adjust2=1 if prob_adjust2>1
*/
g prob_psu_bias1=prob_psu_nobias*prob_adjust_r
g prob_psu_bias2=prob_psu_nobias*prob_adjust2_r
g prob_psu_bias3=prob_psu_nobias*prob_adjust3_r
g prob_psu_bias4=prob_psu_nobias*prob_adjust4_r

*g prob_psu_bias3=prob_psu_nobias*prob_adjust_a
*g prob_psu_bias4=prob_psu_nobias*prob_adjust2_a

egen mun_id2=group(mun_id)
keep psu_id mun_id prob_psu_nobias prob_psu_bias* mun_id2 prob_adjust* percentile_remote pcr pcas  percentile_asset

tempfile remoteness
save `remoteness'

/*=======================================
Census data
=======================================*/
use "$census", clear

keep MUN TAMLOC UPM strata strata2 psu_id hid ENT mun_id FACTOR hhsize
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

tempfile census
save `census'

***Census with fgt0
use "$census", clear

keep MUN TAMLOC UPM strata strata2 psu_id hid ENT mun_id FACTOR hhsize fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m
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
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=(FACTOR*hhsize)], by(mun_id)
save "$currdata\simcensus\bias55\true_fgt0.dta", replace
save "$currdata\simcensus\bias1111\true_fgt0.dta", replace
save "$currdata\simcensus\bias11b11\true_fgt0.dta", replace
save "$currdata\simcensus\nobias\true_fgt0.dta", replace
restore

tempfile census_fgt
save `census_fgt'


/*=======================================
 Sample selection
=======================================*/

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

************************************
*** Selecting municipalities
preserve
keep mun_id total_size* mun_size*
duplicates drop

***Identifying municipalities with very high probability of selection=1 certainly selected before PPS sample
/*In this census there are 555 municipalities that have a probability of 1 to be in the sample*/
g popshare=mun_size/total_size
g certain=1 if popshare>(1/900) //174
sum certain 

egen aux_size=sum(mun_size) if certain!=1
egen total_size2=max(aux_size)
g popshare2=mun_size/total_size2 if certain!=1
g certain2=1 if popshare2>(1/726) & popshare2!=. //166
sum certain2 
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1
egen total_size3=max(aux_size)
g popshare3=mun_size/total_size3 if certain!=1 & certain2!=1
g certain3=1 if popshare3>(1/560) & popshare3!=. //50
sum certain3
drop aux_size

egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1
egen total_size4=max(aux_size)
g popshare4=mun_size/total_size4 if certain!=1 & certain2!=1 & certain3!=1
g certain4=1 if popshare4>(1/510) & popshare4!=. //3
sum certain4
drop aux*

g certain_sample=1 if certain==1 | certain2==1 | certain3==1 | certain4==1 
g prob_select_mun=1 if certain==1 | certain2==1 | certain3==1 | certain4==1
drop popshare* total_size*

***PPS sample on the remaining municipalities
samplepps this_sample if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1, ncases(507) size(mun_size)


***Probability of a municipality to be selected
egen aux_size=sum(mun_size) if certain!=1 & certain2!=1 & certain3!=1 & certain4!=1
egen total_size=max(aux_size)

g popshare=mun_size/total_size if this_sample==1
replace prob_select_mun=popshare*523 if this_sample==1

sum prob_select_mun
keep if this_sample==1  | certain_sample==1


keep mun_id  prob_select_mun*

tempfile samplefile
save `samplefile'
restore

*******************************
*** Selecting PSUs

keep ENT MUN TAMLOC UPM strata strata2 psu_id ENT mun_id
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
gsample 8 ,strata(mun_id) wor // nobias
sum pcr pcas
codebook mun_id psu_id
keep psu_id mun_id mun_size percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys mun_id: gen selected_psu=_N
***Probability of PSU getting selected
g prob_select_psu= selected_psu/mun_size
sum prob_select_psu prob_psu_nobias
tempfile sample_psu_nobias
save `sample_psu_nobias'
restore

preserve
gsample 9 [w=(prob_psu_bias1^5)], strata(mun_id)  // weights2
sum pcr pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcr pcas
tempfile sample_psu_bias5_5
save `sample_psu_bias5_5'
restore


preserve
gsample 9 [w=(prob_psu_bias3^11)], strata(mun_id)  // weights2
sum pcr pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcr pcas
tempfile sample_psu_bias11_11
save `sample_psu_bias11_11'
restore

preserve
gsample 9 [w=(prob_psu_bias4^11)], strata(mun_id)  // weights2
sum pcr pcas
*codebook mun_id psu_id
keep psu_id mun_id mun_size percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias* prob_select_mun
bys psu_id: g dup=_n
tab dup
keep if dup==1
sum pcr pcas
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
keep if TAMLOC>=1 & TAMLOC<=3
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun percentile_remote pcr pcas percentile_asset  prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore

preserve
keep if TAMLOC==4
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_6
save `sample_6'
restore

/*==============================
Final samples
===============================*/
use `sample_24', clear
append using `sample_6'

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

***Selection of HH
preserve
keep if TAMLOC>=1 & TAMLOC<=3
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore

preserve
keep if TAMLOC==4
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_6
save `sample_6'
restore

/*==============================
Final samples
===============================*/
use `sample_24', clear
append using `sample_6'

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
save "$currdata\simcensus\bias55\direct_bias_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_bias\bias55\sample_bias_`x'.dta", replace


*************************************************
*** Selection of HH (biased samples)

use `census', clear
merge m:1 psu_id using `sample_psu_bias11_11'
keep if _merge==3
drop _merge

***Selection of HH
preserve
keep if TAMLOC>=1 & TAMLOC<=3
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore

preserve
keep if TAMLOC==4
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_6
save `sample_6'
restore

/*==============================
Final samples
===============================*/
use `sample_24', clear
append using `sample_6'

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
keep if TAMLOC>=1 & TAMLOC<=3
sample 20 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh  prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_24
save `sample_24'
restore

preserve
keep if TAMLOC==4
sample 5 , count by(psu_id)
g sample_hh=1
keep psu_id hid sample_hh prob_select_mun percentile_remote pcr pcas percentile_asset prob_psu_nobias prob_psu_bias*
tempfile sample_6
save `sample_6'
restore

/*==============================
Final samples
===============================*/
use `sample_24', clear
append using `sample_6'

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
save "$currdata\simcensus\bias11b11\direct_bias_`x'.dta", replace
restore

drop fgt*

save "$currdata\rawsamples_bias\bias11b11\sample_bias_`x'.dta", replace


}

