cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"


*******************************************************************************************
*******************************************************************************************
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2015
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*******************************************************************************************
*******************************************************************************************

***Household level variables individuals
use "intercensal_2015\intercensal_ind_2015.dta", clear
*sample 3

drop NUMPER PARENT_OTRO_C PARENT_OTRO_C_E COBERTURA ID_PERSONA

***Generate strata ID based on survey design (State and locsize)
recode TAMLOC (3=2) (4=3) (5=4)

g uno="1"

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
format ID_VIV %25.0g
egen hid2=group(ENT MUN ID_VIV)
gen double hid=1000000000000+ID_VIV
format hid %25.0g

***Municipality ID
set seed 3454
egen mun_id2=group(ENT MUN)
egen mun_id=concat(uno ENT MUN)
destring mun_id, replace
drop uno

***Household size
bys hid: g hhsize=_N

***Labor per capita income
recode INGTRMEN (999999=.)
bys hid: egen aux_pchinc=sum(INGTRMEN),m
g pchinc=aux_pchinc/hhsize
drop aux*

***Head is female
g aux_female_hh=1 if SEXO==3 & PARENT==1
bys hid: egen female_hh=max(aux_female_hh)
replace female_hh=0 if female_hh==.
drop aux_*

***Education level of HH
recode ESCOACUM (99=.)

g aux_eduhh=ESCOACUM if PARENT==1
bys hid: egen educ_hh=max(aux_eduhh)
drop aux*

***Average income of head
recode INGTRMEN (999999=.)
g aux_income=INGTRMEN if PARENT==1
bys hid: egen income_hh=max(aux_income)
drop aux_income

***Poverty line 
/*
https://www.coneval.org.mx/Medicion/Paginas/ITLP-IS_pobreza_laboral.aspx#:~:text=El%20porcentaje%20de%20la%20poblaci%C3%B3n%20con%20ingreso%20laboral%20inferior%20al,%25%20a%2037.8%25%2C%20respectivamente.
scalar  uT115 	=	1296.14	; 
scalar  rT115 	=	981.50  ; 
scalar  uT215 	=	1300.42	; 
scalar  rT215 	=	985.56  ; 
scalar  uT315 	=	1312.35	; 
scalar  rT315 	=	992.04  ; 
scalar  uT415 	=	1329.88	; 
scalar  rT415 	=	1006.05	; 
Average urban: 1309.6975
Average rural: 991.2875
Average total:1150.4925; weighted average (tab TAMLOC [w=FACTOR]): 1236.4632
*/

g povline=1309.6975 if TAMLOC>=2 & TAMLOC<=4
replace povline=991.2875 if TAMLOC==1

***Indicadores de pobreza
//FGT
forval a=0/2{
gen fgt`a' = (pchinc<povline)*(1-pchinc/(povline))^`a' if pchinc!=.
}

forval a=0/2{
gen fgt`a'_m = (pchinc<1236.4632)*(1-pchinc/(1236.4632))^`a' if pchinc!=.
}

***Average age of HH
g aux_agehh=EDAD if PARENT==1
bys hid: egen age_hh=max(aux_agehh)
drop aux*


***Share of adults with XX years of school
g aaux_sh_educ0_8=0 if ESCOACUM!=.
replace aaux_sh_educ0_8=1 if ESCOACUM>=0 & ESCOACUM<=8 

g aaux_sh_educ9_13=0 if ESCOACUM!=.
replace aaux_sh_educ9_13=1 if ESCOACUM>=9 & ESCOACUM<=13

g aaux_sh_educ14_plus=0 if ESCOACUM!=.
replace aaux_sh_educ14_plus=1 if ESCOACUM>=14 & ESCOACUM!=.

bys hid: egen aux2_sh_educ0_8=mean(aaux_sh_educ0_8) if EDAD>=18 
bys hid: egen sh_educ0_8=max(aux2_sh_educ0_8) 
drop aux*
/*
bys psu_id: egen aux2_sh_educ0_8=mean(aaux_sh_educ0_8) if EDAD>=18 
bys psu_id: egen sh_educ0_8_psu=max(aux2_sh_educ0_8) 
drop aux*
bys mun_id: egen aux2_sh_educ0_8=mean(aaux_sh_educ0_8) if EDAD>=18 
bys mun_id: egen sh_educ0_8_mun=max(aux2_sh_educ0_8) 
drop aux*
*/
bys hid: egen aux2_sh_educ9_13=mean(aaux_sh_educ9_13) if EDAD>=18 
bys hid: egen sh_educ9_13=max(aux2_sh_educ9_13) 
drop aux*
/*
bys psu_id: egen aux2_sh_educ9_13=mean(aaux_sh_educ9_13) if EDAD>=18 
bys psu_id: egen sh_educ9_13_psu=max(aux2_sh_educ9_13) 
drop aux*
bys mun_id: egen aux2_sh_educ9_13=mean(aaux_sh_educ9_13) if EDAD>=18 
bys mun_id: egen sh_educ9_13_mun=max(aux2_sh_educ9_13) 
drop aux*
*/
bys hid: egen aux2_sh_educ14_plus=mean(aaux_sh_educ14_plus) if EDAD>=18 
bys hid: egen sh_educ14_plus=max(aux2_sh_educ14_plus) 
drop aux*
/*
bys psu_id: egen aux2_sh_educ14_plus=mean(aaux_sh_educ14_plus) if EDAD>=18 
bys psu_id: egen sh_educ14_plus_psu=max(aux2_sh_educ14_plus) 
drop aux*
bys mun_id: egen aux2_sh_educ14_plus=mean(aaux_sh_educ14_plus) if EDAD>=18 
bys mun_id: egen sh_educ14_plus_mun=max(aux2_sh_educ14_plus) 
drop aux*
*/
***Share of adults iliterate
recode ALFABET (9=.) (7=0) (5=1)

bys hid: egen aux_sh_literate=mean(ALFABET) if EDAD>=18 
bys hid: egen sh_literate=max(aux_sh_literate) 
drop aux*
/*
bys psu_id: egen aux_sh_literate=mean(ALFABET) if EDAD>=18 
bys psu_id: egen sh_literate_psu=max(aux_sh_literate) 
drop aux*
bys mun_id: egen aux_sh_literate=mean(ALFABET) if EDAD>=18 
bys mun_id: egen sh_literate_mun=max(aux_sh_literate) 
drop aux*
*/
***Weighted education individual variables at PSU and mun level for area level models
preserve
g check_mun=1
collapse (mean) aaux_sh_educ0_8 aaux_sh_educ9_13 aaux_sh_educ14_plus ALFABET ESCOACUM fgt0 fgt0_m (sum) check_mun if EDAD>=18 [pw=FACTOR], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
} 
rename mun_id_mun mun_id

tempfile ind_mun
save `ind_mun'
restore

preserve
g check_psu=1
collapse (mean) aaux_sh_educ0_8 aaux_sh_educ9_13 aaux_sh_educ14_plus ALFABET ESCOACUM fgt0 fgt0_m (sum) check_psu if EDAD>=18 [pw=FACTOR], by(psu_id)
foreach x of var * { 
	rename `x' `x'_psu 
} 
rename psu_id_psu psu_id

tempfile ind_psu
save `ind_psu'
restore
drop aaux*


/*
***Sahre of children 7-14 attending school

recode ASISTEN (9=.) (7=0) (5=1)

bys hid: egen aux_sh_attend=mean(ASISTEN) if EDAD>=7 & EDAD<=14
bys hid: egen sh_attend=max(aux_sh_attend) 
drop aux*
*/
***Dependency ratios
g id_child=(EDAD>=0 & EDAD<=14)
bys hid: egen depen_ch=sum(id_child)

***Elderly
g id_old=(EDAD>=65 & EDAD!=.)
bys hid: egen depen_old=sum(id_old)

*** Labor indicators
***PEA
g PEA=inlist(CONACT,10,11,12,13,14,15,16,20)
replace PEA=. if PEA==0 & (CONACT==31 | CONACT==32 | CONACT==33 | CONACT==34 | CONACT==35 | CONACT==99)

***Unemployment
g unemp=0 if PEA!=.
replace unemp=1 if CONACT==30 & PEA!=.

***Employment
g emp=0 if PEA!=.
replace emp=1 if CONACT>=10 & CONACT<=20 & PEA!=.

***Self-employment
g informal=0 if emp==1
replace informal=1 if emp==1 & SITUACION_TRAB>=4 & SITUACION_TRAB<=6

***********************************
***PSU and Municipality indicators
***********************************
/*
***Indicators at PSU level
bys psu_id: egen aux_educ_psu=mean(ESCOACUM) if EDAD>=18 //Average schooling of population at PSU level
bys psu_id: egen aux_unemp_psu=mean(unemp) if EDAD>=18 & PEA==1 //unemployment
bys psu_id: egen aux_informal_psu=mean(informal) if EDAD>=18 & emp==1 //informality
bys psu_id: egen educ_psu=max(aux_educ_psu) //Average schooling of population at PSU level
bys psu_id: egen unemp_psu=max(aux_unemp_psu) //unemployment
bys psu_id: egen informal_psu=max(aux_informal_psu) //informality
drop aux*

***Indicators at Municipality level
bys mun_id: egen aux_educ_mun=mean(ESCOACUM) if EDAD>=18 //Average schooling of population at PSU level
bys mun_id: egen aux_unemp_mun=mean(unemp) if EDAD>=18 & PEA==1 //unemployment
bys mun_id: egen aux_informal_mun=mean(informal) if EDAD>=18 & emp==1 //informality
bys mun_id: egen educ_mun=max(aux_educ_mun) //Average schooling of population at PSU level
bys mun_id: egen unemp_mun=max(aux_unemp_mun) //unemployment
bys mun_id: egen informal_mun=max(aux_informal_mun) //informality
drop aux*
*/
***Weighted education individual variables at PSU and mun level for area level models
preserve
collapse (mean) unemp_mun=unemp if EDAD>=18 & PEA==1 [pw=FACTOR], by(mun_id)
tempfile unemp_mun
save `unemp_mun'
restore

preserve
collapse (mean) informal_mun=informal if EDAD>=18 & emp==1 [pw=FACTOR], by(mun_id)
tempfile inf_mun
save `inf_mun'
restore

preserve
collapse (mean) unemp_psu=unemp if EDAD>=18 & PEA==1 [pw=FACTOR], by(psu_id)
tempfile unemp_psu
save `unemp_psu'
restore

preserve
collapse (mean) informal_psu=informal if EDAD>=18 & emp==1 [pw=FACTOR], by(psu_id)
tempfile inf_psu
save `inf_psu'
restore

***Variables at household level
***PSU level
/*
***Unweighted
preserve
keep hid psu_id hhsize income_hh pchinc educ_hh age_hh female_hh depen_ch depen_old
duplicates drop
bys psu_id: egen hhsize_psu=mean(hhsize) //household size
bys psu_id: egen incomehh_psu=mean(income_hh) //income of HH
bys psu_id: egen pchinc_psu=mean(pchinc) //per capita income 
bys psu_id: egen educhh_psu=mean(educ_hh) //years of education of HH
bys psu_id: egen agehh_psu=mean(age_hh) //age HH
bys psu_id: egen femalehh_psu=mean(female_hh) //female HH
bys psu_id: egen dependch_psu=mean(depen_ch) //mean dependency
bys psu_id: egen dependold_psu=mean(depen_old) //mean dependency

keep psu_id hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu femalehh_psu dependch_psu dependold_psu
duplicates drop
tempfile psu
save `psu'
restore
*/
***Weighted
preserve
keep hid psu_id hhsize income_hh pchinc educ_hh age_hh female_hh depen_ch depen_old FACTOR
duplicates drop
collapse (mean) hhsize income_hh pchinc educ_hh age_hh female_hh depen_ch depen_old [pw=FACTOR], by(psu_id)
foreach x of var * { 
	rename `x' `x'_psu 
} 
rename psu_id_psu psu_id

tempfile psuw
save `psuw'
restore


***Municipality level
/*
***Unweighted
preserve
keep hid mun_id hhsize income_hh pchinc educ_hh age_hh female_hh depen_ch depen_old
duplicates drop
bys mun_id: egen hhsize_mun=mean(hhsize) //household size
bys mun_id: egen incomehh_mun=mean(income_hh) //income of HH
bys mun_id: egen pchinc_mun=mean(pchinc) //per capita income 
bys mun_id: egen educhh_mun=mean(educ_hh) //years of education of HH
bys mun_id: egen agehh_mun=mean(age_hh) //age HH
bys mun_id: egen femalehh_mun=mean(female_hh) //female HH
bys mun_id: egen dependch_mun=mean(depen_ch) //mean dependency
bys mun_id: egen dependold_mun=mean(depen_old) //mean dependency

keep mun_id hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun femalehh_mun dependch_mun dependold_mun
duplicates drop
tempfile mun
save `mun'
restore
*/
***Weighted
preserve
keep hid mun_id hhsize income_hh pchinc educ_hh age_hh female_hh depen_ch depen_old FACTOR
duplicates drop
collapse (mean) hhsize income_hh pchinc educ_hh age_hh female_hh depen_ch depen_old [pw=FACTOR], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
} 
rename mun_id_mun mun_id

tempfile munw
save `munw'
restore

***Before merging agregate indicators for unit-level models, create data at municipality level weighted for area-level models
preserve
keep mun_id 
duplicates drop
merge 1:1 mun_id using `ind_mun'
drop _merge
merge 1:1 mun_id using `unemp_mun'
drop _merge
merge 1:1 mun_id using `inf_mun'
drop _merge
merge 1:1 mun_id using `munw'
drop _merge
save "intercensal_2015\census_munlevel_MEX_2015", replace
restore

preserve
keep psu_id 
duplicates drop
merge 1:1 psu_id using `ind_psu'
drop _merge
merge 1:1 psu_id using `unemp_psu'
drop _merge
merge 1:1 psu_id using `inf_psu'
drop _merge
merge 1:1 psu_id using `psuw'
drop _merge
save "intercensal_2015\census_psulevel_MEX_2015", replace
restore


***Now merging the full census to aggregates
/*
merge m:1 psu_id using `psu'
drop _merge
merge m:1 mun_id using `mun'
drop _merge
*/
merge m:1 mun_id using `ind_mun'
drop _merge
merge m:1 mun_id using `unemp_mun'
drop _merge
merge m:1 mun_id using `inf_mun'
drop _merge
merge m:1 mun_id using `munw'
drop _merge

merge m:1 psu_id using `ind_psu'
drop _merge
merge m:1 psu_id using `unemp_psu'
drop _merge
merge m:1 psu_id using `inf_psu'
drop _merge
merge m:1 psu_id using `psuw'
drop _merge


keep ENT NOM_ENT MUN NOM_MUN LOC50K NOM_LOC ID_VIV TAMLOC hid hid2 hhsize pchinc educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen* UPM ESTRATO FACTOR female_hh strata strata2 age_hh income_hh mun_id mun_id2 povline fgt* hid hid2 strata strata2 psu_id psu_id2 mun_id mun_id2 *_mun *_psu

duplicates drop

sort ENT MUN ID_VIV

tempfile household
save `household'


**********************************************************************************
***Household level variables, househols
use "intercensal_2015\intercensal_viv_2015.dta", clear

***Generate strata ID based on survey design (State and locsize)
recode TAMLOC (3=2) (4=3) (5=4)

g uno="1"

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
format ID_VIV %25.0g
egen hid2=group(ENT MUN ID_VIV)
gen double hid=1000000000000+ID_VIV
format hid %25.0g

***Municipality ID
set seed 3454
egen mun_id2=group(ENT MUN)
egen mun_id=concat(uno ENT MUN)
destring mun_id, replace
drop uno


***House conditions
g wall_improved  = inlist(PAREDES,6,7,8) //Madera, adobe; tabique, ladrillo, bloque, piedra
g roof_improved  = inlist(TECHOS, 3,4,9,10) //lamina metalica,lamina asbesto, Teja, losa de concreto
g floor_improved = inlist(PISOS, 2,3) //cemento; mosaico, madera 
  
g water_improved = inlist(AGUA_ENTUBADA, 1,2)  //dentro de la vivienda?,s�lo en el patio o terreno?  
g electri = inlist(ELECTRI, 5)   
g flush_toilet = inlist(CONAGU,1) //tiene descarga directa de agua?
g sewage = inlist(DRENAJE, 1,2) //la red p�blica?; una fosa s�ptica o tanque s�ptico 

g own_house = inlist(TENENCIA, 1) // vive la due�a o due�o?

g cook_fuel = inlist(COMBUS, 1,2,5) //gas?, electricidad?

***Overcrowding
recode TOTCUART  (99=.)
recode CUADORM (99=.)
destring NUMPERS, replace

g over_crowding=NUMPERS/TOTCUART
g over_crowding_ext=NUMPERS/CUADORM

***Household assets
g stove = inlist(ESTUFA, 1)
g shower = inlist(REGADERA, 7)
g radio = inlist(RADIO, 1)
g tele = inlist(TELEVISOR, 3)
g fridge = inlist(REFRIGERADOR, 1)
g washing = inlist(LAVADORA, 3)
g auto = inlist(AUTOPROP, 7)
g compu = inlist(COMPUTADORA, 7)
g cell = inlist(CELULAR, 3)
g internet = inlist(INTERNET, 5)

**Household income
recode INGTRHOG  (999999=.)
g pchinc_hh=INGTRHOG/NUMPERS

***Check FACTOR
g factor_hh=FACTOR
***Didn't eat
*g not_fed=inlist(SINCOMER, 1) //NOT AVAILABLE
/*
***PSU level
bys psu_id: egen wall_improved_psu=mean(wall_improved) 
bys psu_id: egen roof_improved_psu=mean(roof_improved)  
bys psu_id: egen floor_improved_psu=mean(floor_improved)  
bys psu_id: egen water_improved_psu=mean(water_improved) 
bys psu_id: egen electri_psu=mean(electri) 
bys psu_id: egen flush_toilet_psu=mean(flush_toilet) 
bys psu_id: egen sewage_psu=mean(sewage) 
bys psu_id: egen own_house_psu=mean(own_house) 
bys psu_id: egen cook_fuel_psu=mean(cook_fuel)
bys psu_id: egen over_crowding_psu=mean(over_crowding) 
bys psu_id: egen over_crowding_ext_psu=mean(over_crowding_ext) 
bys psu_id: egen stove_psu=mean(stove) 
bys psu_id: egen shower_psu=mean(shower )
bys psu_id: egen radio_psu=mean(radio) 
bys psu_id: egen tele_psu=mean(tele) 
bys psu_id: egen fridge_psu=mean(fridge) 
bys psu_id: egen washing_psu=mean(washing) 
bys psu_id: egen auto_psu=mean(auto) 
bys psu_id: egen compu_psu=mean(compu) 
bys psu_id: egen cell_psu=mean(cell) 
bys psu_id: egen internet_psu=mean(internet)

***Municipality level
bys mun_id: egen wall_improved_mun=mean(wall_improved) 
bys mun_id: egen roof_improved_mun=mean(roof_improved)  
bys mun_id: egen floor_improved_mun=mean(floor_improved)  
bys mun_id: egen water_improved_mun=mean(water_improved) 
bys mun_id: egen electri_mun=mean(electri) 
bys mun_id: egen flush_toilet_mun=mean(flush_toilet) 
bys mun_id: egen sewage_mun=mean(sewage) 
bys mun_id: egen own_house_mun=mean(own_house) 
bys mun_id: egen cook_fuel_mun=mean(cook_fuel)
bys mun_id: egen over_crowding_mun=mean(over_crowding) 
bys mun_id: egen over_crowding_ext_mun=mean(over_crowding_ext) 
bys mun_id: egen stove_mun=mean(stove) 
bys mun_id: egen shower_mun=mean(shower )
bys mun_id: egen radio_mun=mean(radio) 
bys mun_id: egen tele_mun=mean(tele) 
bys mun_id: egen fridge_mun=mean(fridge) 
bys mun_id: egen washing_mun=mean(washing) 
bys mun_id: egen auto_mun=mean(auto) 
bys mun_id: egen compu_mun=mean(compu) 
bys mun_id: egen cell_mun=mean(cell) 
bys mun_id: egen internet_mun=mean(internet)
*/	

keep ENT MUN ID_VIV wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet /*not_fed*/ pchinc_hh factor_hh  mun_id psu_id 

***Weighted agregates for area-level models
preserve
g checkhh_mun=1
collapse (mean) wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet pchinc_hh  (sum) checkhh_mun [pw=factor_hh], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
}
rename mun_id_mun mun_id

save "intercensal_2015\census_viv_munlevel_MEX_2015", replace
restore

preserve
collapse (mean) wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet pchinc_hh  [pw=factor_hh], by(psu_id)
foreach x of var * { 
	rename `x' `x'_psu 
}
rename psu_id_psu psu_id
save "intercensal_2015\census_viv_psulevel_MEX_2015", replace
restore

***Now merging with other indicators
sort ENT MUN ID_VIV

merge 1:1 ENT MUN ID_VIV using `household'
drop _merge

merge m:1 mun_id using "intercensal_2015\census_viv_munlevel_MEX_2015"
drop _merge
merge m:1 psu_id using "intercensal_2015\census_viv_psulevel_MEX_2015"
drop _merge

save "intercensal_2015\census_proc_MEX_2015", replace

***Arela level data
use "intercensal_2015\census_munlevel_MEX_2015", clear
merge 1:1 mun_id using "intercensal_2015\census_viv_munlevel_MEX_2015"
drop _merge
save "intercensal_2015\census_mundata_MEX_2015", replace

use "intercensal_2015\census_psulevel_MEX_2015", clear
merge 1:1 psu_id using "intercensal_2015\census_viv_psulevel_MEX_2015"
drop _merge
save "intercensal_2015\census_psudata_MEX_2015", replace


