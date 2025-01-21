* cd "D:\SAE_project\BRA\2000\full_census\rawdata"
cd "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\rawdata"

forvalues i=1(1)10 {
use "BRA_`i'_2000.dta", clear
***Labeling variables
label var V0102 "UF"
label var V0103 "Municipality"
label var V0104 "District"
label var V0105 "Subdistrict"
label var V1005 "Sector"
label var V1006 "Urban"
label var V0300 "Household ID"
label var V0401 "Sex"
label var V0402 "relation_dom"
label var V0403 "relation_fam"
label var V0408 "Race"
label var V0428 "Literate"
label var V0429 "School type"
label var V0430 "School Grade"
label var V0431 "Serie school"
label var V4752 "Age (years)"
label var V4754 "Age (months)"
label var V0432 "Highest level attended"
label var V0433 "Latest finished series"
label var V0434 "Did you finish the level"
label var V4300 "Years of education"
label var V0439 "Worked last week"
label var V0440 "Absent from work"
label var V0441 "Worked without remuneration"
label var V0447 "Employment status"
label var V4512 "Gross monthly income in main job"
label var V4513 "Income from main job"
label var V4614 "Total income"
label var V4522 "Gross monthly income in other jobs"
label var V4525 "Income from all jobs"
label var V4523 "Total income other jobs"
label var PES_PESSOA "Weights"


rename V1006 urban
replace urban="1" if urban=="1"
replace urban="0" if urban=="2"
destring urban, replace
label define urban 1 "Urban" 0 "Rural"
label value urban urban

rename V0401 sex
replace sex="1" if sex=="1"
replace sex="0" if sex=="2"
destring sex, replace
label define sex 1 "Male" 0 "Female"
label value sex sex

rename V0403 relation
g hhead=0
replace hhead=1 if relation=="01"
label var hhead "Household head"

rename V0408 race
destring race, replace
label define race 1 "White" 2 "Black" 3 "Yellow" 4 "Brown" 5 "Indigenous" 6 "No response"
label value race race

rename V0428 literate
replace literate="1" if literate=="1"
replace literate="0" if literate=="2"
destring literate, replace
label define literate 1 "Literate" 0 "Illiterate"
label value literate literate

***Renaming
rename V4752 ageyrs
rename V4754 agemnth
rename V0300 hid2
rename V0102 state
rename abbrev_state nom_state
rename V0103 muni
rename V4512 gross_income_main
rename V4513 income_main
rename V4522 gross_income_other
rename V4525 income_all_jobs
rename V4614 total_income
rename PES_PESSOA weights
rename AREAP psu_id 

***Variables creation
***Household ID
egen hid=concat(muni hid2)
destring hid, replace
format hid %20.0g
label var hid "Household ID (long)"

***Mnicipality ID
gen mun_id=muni
destring mun_id, replace
label var mun_id "Municipality ID"

***Household size
bys hid: g hhsize=_N
label var hhsize "Household size"

***Labor per capita income
bys hid: egen tot_hh_income=sum(total_income)
g pchinc=tot_hh_income/hhsize

***Average income of head
/*I shoudl use this one V6527 total_income*/
g aux_income=total_income if hhead==1
bys hid: egen income_hh=max(aux_income)
drop aux_income

***Head is female
g aux_female_hh=1 if sex==0 & hhead==1
bys hid: egen female_hh=max(aux_female_hh)
replace female_hh=0 if female_hh==.
drop aux_*

***Education level
***For the ones attending
/*
1 – Creche
2 – Pré-escolar
3 – Classe de alfabetização
4 – Alfabetização de adultos
5 – Ensino fundamental ou 1º grau – regular seriado
6 – Ensino fundamental ou 1º grau – regular não-seriado
7 – Supletivo (ensino fundamental ou 1º grau)
8 – Ensino médio ou 2º grau – regular seriado
9 – Ensino médio ou 2º grau – regular não-seriado
10 – Supletivo (ensino médio ou 2º grau)
11 – Pré-vestibular
12 – Superior – graduação
13 – Mestrado ou doutorado
Branco – para os não estudantes
*/
destring V0429 V0430 V0432, replace
g school=0 if V0429==4
replace school=1 if  (V0429==1 | V0429==2) & (V0430>=1 & V0430<=4)
replace school=2 if (V0429==1 | V0429==2) & (V0430>=5 & V0430<=7)
replace school=3 if (V0429==1 | V0429==2) & (V0430>=8 & V0430<=11)
replace school=4 if (V0429==1 | V0429==2) & (V0430>=12 & V0430<=13)

***For the ones attended
replace school=1 if  (V0429==3) & (V0432==1)
replace school=2 if (V0429==3) & (V0432==2 | V0432==3 | V0432==5)
replace school=3 if (V0429==3) & (V0432==4 | V0432==6)
replace school=4 if (V0429==3) & (V0432==7 | V0432==8)

label define school 0 "No education" 1 "Basic/no formal" 2 "Some primary/elementary" 3 "Some secondary/middle" 4 "Some superior"
label value school school

 
***Household head some primary education
g aux_eduhh=(school==2 & hhead==1)
bys hid: egen hh_primedu=max(aux_eduhh)
drop aux*

***Household head some secondary education
g aux_eduhh=(school==3 & hhead==1)
bys hid: egen hh_secondedu=max(aux_eduhh)
drop aux*

***Household head some superios education
g aux_eduhh=(school==4 & hhead==1)
bys hid: egen hh_superior=max(aux_eduhh)
drop aux*

***Average age of HH
g aux_agehh=ageyrs if hhead==1
bys hid: egen age_hh=max(aux_agehh)
drop aux*

***Poverty line
/*Taken from harmonized surveys IADB
2001
-----------------------------------------------------------------------------------
        |  Linea de pobreza oficial del pais   Linea de indigencia oficial del pais
--------+--------------------------------------------------------------------------
zona_c  |                                                                          
  0     |                           100.7588                               50.37942
  1     |                           116.4754                               58.23772
  Total |                           114.2078                               57.10391
-----------------------------------------------------------------------------------

1999
        |  Linea de pobreza oficial del pais   Linea de indigencia oficial del pais
--------+--------------------------------------------------------------------------
zona_c  |                                                                          
  0     |                           86.39576                               43.19788
  1     |                            100.084                               50.04202
  Total |                           97.95901                                48.9795

tab urban [w=int(weights)]
      Urban |      Freq.     Percent        Cum.
------------+-----------------------------------
      Rural |  7,026,361       16.39       16.39
      Urban | 35,831,113       83.61      100.00
------------+-----------------------------------
      Total | 42,857,474      100.00

***Single poverty lines
Extreme: (54.13987*0.8361)+(46.78865*0.1639)=52.935005
Poverty: (108.2797*0.8361)+(93.57728*0.1639)=105.86997


*/
***Average 1999-2001 to get 2000
g povline1=54.13987 if urban==1
replace povline1=46.78865 if urban==0

g povline2=108.2797 if urban==1
replace povline2=93.57728 if urban==0


***Indicadores de pobreza
//FGT (extreme poverty)
forval a=0/2{
gen efgt`a' = (pchinc<povline1)*(1-pchinc/(povline1))^`a' if pchinc!=.
}

forval a=0/2{
gen efgt`a'_m = (pchinc<52.935005)*(1-pchinc/(52.935005))^`a' if pchinc!=.
}

//FGT (poverty)
forval a=0/2{
gen fgt`a' = (pchinc<povline2)*(1-pchinc/(povline2))^`a' if pchinc!=.
}

forval a=0/2{
gen fgt`a'_m = (pchinc<105.86997)*(1-pchinc/(105.86997))^`a' if pchinc!=.
}



***Share of adults with certain education level
tab school, g(educ_)

g aux_sh_primedu=educ_3 if ageyrs>=18 
bys hid: egen sh_primedu=mean(aux_sh_primedu)
*bys mun_id: egen sh_primedu_mun=mean(aux_sh_primedu)
*drop aux*

g aux_sh_secedu=educ_4 if ageyrs>=18 
bys hid: egen sh_secedu=mean(aux_sh_secedu)
*bys mun_id: egen sh_secedu_mun=mean(aux_sh_secedu)
*drop aux*

g aux_sh_supedu=educ_5 if ageyrs>=18 
bys hid: egen sh_supedu=mean(aux_sh_supedu)
*bys mun_id: egen sh_supedu_mun=mean(aux_sh_supedu)
*drop aux*

g aux_sh_noedu=educ_1 if ageyrs>=18 
bys hid: egen sh_noedu=mean(aux_sh_noedu)
*bys mun_id: egen sh_noedu_mun=mean(aux_sh_noedu)
*drop aux*


***Share of adults iliterate
gen aux_sh_literate=literate if ageyrs>=18 
bys hid: egen sh_literate=mean(aux_sh_literate) 
*bys mun_id: egen sh_literate_mun=mean(aux_sh_literate) 
*drop aux*

***Weighted education individual variables at mun level for area level models
preserve
g check_mun=1
collapse (mean) aux_sh_primedu aux_sh_secedu aux_sh_supedu aux_sh_noedu aux_sh_literate (sum) check_mun if ageyrs>=18 [pw=weights], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
} 
rename mun_id_mun mun_id
tempfile ind_munw
save `ind_munw'
restore

preserve
collapse (mean) aux_sh_primedu aux_sh_secedu aux_sh_supedu aux_sh_noedu aux_sh_literate if ageyrs>=18 [pw=weights], by(psu_id)
foreach x of var * { 
	rename `x' `x'_psu
} 
rename psu_id_psu psu_id
tempfile ind_psuw
save `ind_psuw'
restore


drop aux*


***Dependency ratios
g id_child=(ageyrs>=0 & ageyrs<=14)
bys hid: egen depen_ch=mean(id_child)

***Elderly
g id_old=(ageyrs>=65 & ageyrs!=.)
bys hid: egen depen_old=mean(id_old)


destring V0439 V0440 V0441 V0442 V0443 V0455 V0447, replace

***Employment
g emp=0 
replace emp=1 if V0439==1 
replace emp=1 if V0439==2 & V0440==1 & emp==.
replace emp=1 if V0439==2 & V0441==1 & emp==.
replace emp=1 if V0439==2 & V0442==1 & emp==.
replace emp=1 if V0439==2 & V0443==1 & emp==.
 
***Unemployment
g unemp=0 if emp==0
replace unemp=1 if (emp==0 & V0455==1) 

***PEA
g PEA=1 if emp==1 | unemp==1
replace PEA=0 if PEA==.

***Self-employment
g informal=0 if emp==1
replace informal=1 if emp==1 & (V0447==5 | V0447==6)

***********************************
*** Municipality indicators
***********************************
/*No PSSU in Brazil*/
/*
***Indicators at Municipality level
bys mun_id: egen aux_unemp_mun=mean(unemp) if ageyrs>=18 & PEA==1 //unemployment
bys mun_id:  egen unemp_mun=max(aux_unemp_mun)
bys mun_id: egen aux_informal_mun=mean(informal) if ageyrs>=18 & emp==1 //informality
bys mun_id: egen informal_mun=max(aux_informal_mun)
drop aux*
*/
***Weighted education individual variables at PSU and mun level for area level models
preserve
collapse (mean) unemp_mun=unemp if ageyrs>=18  [pw=weights], by(mun_id)
tempfile unemp_mun
save `unemp_mun'
restore

preserve
collapse (mean) informal_mun=informal if ageyrs>=18 & emp==1 [pw=weights], by(mun_id)
tempfile inf_mun
save `inf_mun'
restore

preserve
collapse (mean) unemp_psu=unemp if ageyrs>=18  [pw=weights], by(psu_id)
tempfile unemp_psu
save `unemp_psu'
restore

preserve
collapse (mean) informal_psu=informal if ageyrs>=18 & emp==1 [pw=weights], by(psu_id)
tempfile inf_psu
save `inf_psu'
restore

***Municipality level
***Weighted
preserve
keep hid mun_id hhsize income_hh pchinc hh_primedu hh_secondedu hh_superior age_hh female_hh depen_ch depen_old  weights
duplicates drop
collapse (mean) hhsize income_hh pchinc hh_primedu hh_secondedu hh_superior age_hh female_hh depen_ch depen_old [pw=weights], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
} 
rename mun_id_mun mun_id
tempfile munw
save `munw'
restore

***PSU level
preserve
keep hid psu_id hhsize income_hh pchinc hh_primedu hh_secondedu hh_superior age_hh female_hh depen_ch depen_old  weights
duplicates drop
collapse (mean) hhsize income_hh pchinc hh_primedu hh_secondedu hh_superior age_hh female_hh depen_ch depen_old [pw=weights], by(psu_id)
foreach x of var * { 
	rename `x' `x'_psu 
} 
rename psu_id_psu psu_id
tempfile psuw
save `psuw'
restore


***Before merging agregate indicators for unit-level models, create data at municipality level weighted for area-level models
preserve
keep mun_id 
duplicates drop
merge 1:1 mun_id using `ind_munw'
drop _merge
merge 1:1 mun_id using `unemp_mun'
drop _merge
merge 1:1 mun_id using `inf_mun'
drop _merge
merge 1:1 mun_id using `munw'
drop _merge
save "census_munlevel_`i'_2000", replace
restore

preserve
keep psu_id 
duplicates drop
merge 1:1 psu_id using `ind_psuw'
drop _merge
merge 1:1 psu_id using `unemp_psu'
drop _merge
merge 1:1 psu_id using `inf_psu'
drop _merge
merge 1:1 psu_id using `psuw'
drop _merge
save "census_psulevel_`i'_2000", replace
restore


merge m:1 mun_id using `ind_munw'
drop _merge
merge m:1 mun_id using `unemp_mun'
drop _merge
merge m:1 mun_id using `inf_mun'
drop _merge
merge m:1 mun_id using `munw'
drop _merge

merge m:1 psu_id using `ind_psuw'
drop _merge
merge m:1 psu_id using `unemp_psu'
drop _merge
merge m:1 psu_id using `inf_psu'
drop _merge
merge m:1 psu_id using `psuw'
drop _merge

keep  state nom_state muni hid2 psu_id weights urban depen_ch depen_old pchinc hid mun_id hhsize income_hh female_hh hh_primedu hh_secondedu hh_superior age_hh povline1 povline2 *fgt* sh_primedu sh_secedu sh_supedu sh_noedu sh_literate *_mun *_psu

duplicates drop

sort hid

tempfile household_`i'
save `household_`i''
}

use `household_1', clear
forvalues i=2(1)10 {
append using `household_`i''
}

save "BRA_IND_2000.dta", replace

***Municipality level variables
use "census_munlevel_1_2000", clear
forvalues i=2(1)10 {
	append using "census_munlevel_`i'_2000"
}

save "census_ind_munlevel_BRA_2000", replace

***PSU level variables
use "census_psulevel_1_2000", clear
forvalues i=2(1)10 {
	append using "census_psulevel_`i'_2000"
}

save "census_ind_psulevel_BRA_2000", replace

**********************************************************************************
***Household level variables, househols
use "2000\full_census\rawdata\BRA_VIV_2000.dta", clear

***Household ID
egen hid=concat(V0103 V0300)
destring hid, replace
format hid %20.0g
label var hid "Household ID (long)"

***Mnicipality ID
rename V0103 mun_id
destring mun_id, replace
label var mun_id "Municipality ID"

***House conditions
destring V0201 V0205 V0207 V0208 V0211 V0212 V0213 V0214 V0215 V0217 V0219 V0220 V0221 V0218 v1113 V0223 V7617, replace

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

***Household income
g household_income=V7616
replace household_income=. if household_income==999998
g pchinc_hh=household_income/V7100
***Check FACTOR
g factor_hh=PESO_DOMIC

rename AREAP psu_id

keep hid mun_id psu_id water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC household_income pchinc_hh factor_hh over_crowding over_crowding_ext

***Weighted agregates for area-level models
preserve
g checkhh_mun=1
collapse (mean) water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC over_crowding over_crowding_ext (sum) checkhh_mun [pw=factor_hh], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
} 
rename mun_id_mun mun_id
save "census_viv_munlevel_BRA_2000", replace
restore


preserve
collapse (mean) water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC over_crowding over_crowding_ext [pw=factor_hh], by(psu_id)
foreach x of var * { 
	rename `x' `x'_psu 
} 
rename psu_id_psu psu_id
save "census_viv_psulevel_BRA_2000", replace
restore


sort hid

merge 1:1 hid using "BRA_IND_2000.dta"
drop _merge

merge m:1 mun_id using "census_viv_munlevel_BRA_2000"
drop _merge

merge m:1 psu_id using "census_viv_psulevel_BRA_2000"
drop _merge

drop if mun_id==.

save "census_proc_BRA_2000", replace


***Arela level data
use "census_ind_munlevel_BRA_2000", clear
merge 1:1 mun_id using "census_viv_munlevel_BRA_2000"
drop _merge
save "census_mundata_BRA_2000", replace

use "census_ind_psulevel_BRA_2000", clear
merge 1:1 psu_id using "census_viv_psulevel_BRA_2000"
drop _merge
save "census_psudata_BRA_2000", replace

