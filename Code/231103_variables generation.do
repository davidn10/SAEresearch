cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2010
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

**********************************************************************************
***Household level variables individuals
use "census_2010\census_ind_2010.dta", clear

***PSU ID
set seed 3454
egen psu_id=group(ENT MUN TAM_LOC UPM)
egen psu_id2=concat(ENT MUN TAM_LOC UPM)

***Generating strata
set seed 3454
egen strata = group(ENT TAM_LOC)
egen strata2 = concat(ENT TAM_LOC)

***Households ID
set seed 3454
egen hid=group(ENT MUN ID_VIV)
egen hid2=concat(ENT MUN ID_VIV)

***Municipality ID
set seed 3454
egen mun_id=group(ENT MUN)
egen mun_id2=concat(ENT MUN)

***Household size
bys hid: g hhsize=_N

***Labor per capita income
recode INGTRMEN (999999=.)
bys hid: egen aux_pchinc=sum(INGTRMEN),m
g pchinc=aux_pchinc/hhsize
drop aux*

***Average income of head
recode INGTRMEN (999999=.)
g aux_income=INGTRMEN if PARENT==1
bys hid: egen income_hh=max(aux_income)
drop aux_income

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

***Average age of HH
g aux_agehh=EDAD if PARENT==1
bys hid: egen age_hh=max(aux_agehh)
drop aux*

***Share of adults with XX years of school
g aux_sh_educ0_8=0 if ESCOACUM!=.
replace aux_sh_educ0_8=1 if ESCOACUM>=0 & ESCOACUM<=8 

bys hid: egen aux2_sh_educ0_8=mean(aux_sh_educ0_8) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ0_8=max(aux2_sh_educ0_8) 
drop aux*

g aux_sh_educ9_13=0 if ESCOACUM!=.
replace aux_sh_educ9_13=1 if ESCOACUM>=9 & ESCOACUM<=13

bys hid: egen aux2_sh_educ9_13=mean(aux_sh_educ9_13) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ9_13=max(aux2_sh_educ9_13) 
drop aux*

g aux_sh_educ14_plus=0 if ESCOACUM!=.
replace aux_sh_educ14_plus=1 if ESCOACUM>=14 & ESCOACUM!=.

bys hid: egen aux2_sh_educ14_plus=mean(aux_sh_educ14_plus) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ14_plus=max(aux2_sh_educ14_plus) 
drop aux*

***Share of adults iliterate
recode ALFABET (9=.) (3=0)

bys hid: egen aux_sh_literate=mean(ALFABET) if EDAD>=18 & EDAD<=65
bys hid: egen sh_literate=max(aux_sh_literate) 
drop aux*

***Sahre of children 7-14 attending school
recode ASISTEN (9=.) (3=0)

bys hid: egen aux_sh_attend=mean(ASISTEN) if EDAD>=7 & EDAD<=14
bys hid: egen sh_attend=max(aux_sh_attend) 
drop aux*

***Dependency ratios
g id_child=(EDAD>=0 & EDAD<=14)
bys hid: egen no_child=sum(id_child)
g depen_ch=no_child/hhsize 
replace depen_ch=0 if no_child==0 & hhsize!=0

***Elderly
g id_old=(EDAD>=65 & EDAD!=.)
bys hid: egen no_old=sum(id_old)
g depen_old=no_old/hhsize
replace depen_old=0 if no_old==0 & hhsize!=0 

***PEA
g PEA=inlist(CONACT,10,13,14,15,16,17,18,19,20,30)
replace PEA=. if PEA==0 & (CONACT==40 | CONACT==50 | CONACT==60 | CONACT==70 | CONACT==80 | CONACT==99)

***Unemployment
g unemp=0 if PEA!=.
replace unemp=1 if CONACT==30 & PEA!=.

***Employment
g emp=0 if PEA!=.
replace emp=1 if CONACT>=10 & CONACT<=20 & PEA!=.

***Self-employment
g informal=0 if emp==1
replace informal=1 if emp==1 & SITTRA>=4 & SITTRA<=6

***********************************
***PSU and Municipality indicators
***********************************

***Indicators at PSU level
bys psu_id: egen educ_psu=mean(ESCOACUM) //Average schooling of population at PSU level
bys psu_id: egen unemp_psu=mean(unemp) //unemployment
bys psu_id: egen informal_psu=mean(informal) //informality

***Indicators at Municipality level
bys mun_id: egen educ_mun=mean(ESCOACUM) //Average schooling of population at PSU level
bys mun_id: egen unemp_mun=mean(unemp) //unemployment
bys mun_id: egen informal_mun=mean(informal) //informality

preserve
keep psu_id educ_psu unemp_psu informal_psu
duplicates drop
tempfile psu
save `psu'
restore

preserve
keep mun_id educ_mun unemp_mun informal_mun
duplicates drop
tempfile mun
save `mun'
restore

preserve
keep hid psu_id hhsize income_hh pchinc educ_hh age_hh 
duplicates drop
bys psu_id: egen hhsize_psu=mean(hhsize) //household size
bys psu_id: egen incomehh_psu=mean(income_hh) //income of HH
bys psu_id: egen pchinc_psu=mean(pchinc) //per capita income 
bys psu_id: egen educhh_psu=mean(educ_hh) //years of education of HH
bys psu_id: egen agehh_psu=mean(age_hh) //age HH

keep psu_id hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu
duplicates drop
tempfile psu2
save `psu2'
restore

***Municipality level
preserve
keep hid mun_id hhsize income_hh pchinc educ_hh age_hh 
duplicates drop
bys mun_id: egen hhsize_mun=mean(hhsize) //household size
bys mun_id: egen incomehh_mun=mean(income_hh) //income of HH
bys mun_id: egen pchinc_mun=mean(pchinc) //per capita income 
bys mun_id: egen educhh_mun=mean(educ_hh) //years of education of HH
bys mun_id: egen agehh_mun=mean(age_hh) //age HH

keep mun_id hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun
duplicates drop
tempfile mun2
save `mun2'
restore

merge m:1 psu_id using `psu'
drop _merge
merge m:1 psu_id using `psu2'
drop _merge
merge m:1 mun_id using `mun'
drop _merge
merge m:1 mun_id using `mun2'
drop _merge


keep ENT NOM_ENT MUN NOM_MUN LOC50K NOM_LOC ID_VIV TAM_LOC hid hid2 hhsize pchinc educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate sh_attend depen* UPM ESTRATO FACTOR female_hh strata strata2 age_hh income_hh mun_id mun_id2 hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun psu_id psu_id2 hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu educ_psu unemp_psu informal_psu educ_mun unemp_mun informal_mun

duplicates drop

sort ENT MUN ID_VIV

tempfile household
save `household'

**********************************************************************************
***Household level variables, househols
use "census_2010\census_viv_2010.dta", clear

***House conditions
g wall_improved  = inlist(PAREDES,6,7,8) //madera, adobe; tabique, ladrillo, block, piedra, cemento, concreto
g roof_improved  = inlist(TECHOS, 3,4,8,9) //lamina metalica, lamina asbesto, teaj, losa concreto    
g floor_improved = inlist(PISOS, 2,3) //cemento; madera, mosaico 
  
g water_improved = inlist(DISAGU, 1,2) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g electri = inlist(ELECTRI, 1)   
g flush_toilet = inlist(CONAGU,5) //tiene descarga directa de agua
g sewage = inlist(DRENAJE, 1,2) //la red p�blica, una fosa s�ptica 

g own_house = inlist(TENVIV, 1) //vive el due�o o propietario

g cook_fuel = inlist(COMBUS, 1,2,5) //gas de cilindro o tanque,gas natural o de tuber�a, electricity

***Overcrowding
recode TOTCUART  (99=.)
recode CUADORM (99=.)
destring NUMPERS, replace

g over_crowding=NUMPERS/TOTCUART
g over_crowding_ext=NUMPERS/CUADORM

***Household assets
g stove = inlist(ESTUFAG, 1) //estufa de gas
g shower = inlist(REGADERA, 3)
g radio = inlist(RADIO, 1)
g tele = inlist(TELEVI, 3)
g fridge = inlist(REFRIG, 1)
g washing = inlist(LAVADORA, 3)
g auto = inlist(AUTOPROP, 1)
g compu = inlist(COMPU, 3)
g cell = inlist(CELULAR, 3)
g internet = inlist(INTERNET, 1)

***Didn't eat
*g not_fed=inlist(SINCOMER, 1) //not in 2015
	
**Household income
recode INGTRHOG  (999999=.)
g pchinc_hh=INGTRHOG/NUMPERS

***Check FACTOR
g factor_hh=FACTOR

keep ENT MUN ID_VIV wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet /*not_fed*/ pchinc_hh factor_hh

sort ENT MUN ID_VIV

merge 1:1 ENT MUN ID_VIV using `household'
drop _merge

save "census_2010\census_proc_MEX_2010", replace


*******************************************************************************************
*******************************************************************************************
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2015
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*******************************************************************************************
*******************************************************************************************

***Household level variables individuals
use "intercensal_2015\intercensal_ind_2015.dta", clear
drop NUMPER PARENT_OTRO_C PARENT_OTRO_C_E COBERTURA ID_PERSONA

***Generate strata ID based on survey design (State and locsize)
recode TAMLOC (3=2) (4=3) (5=4)

***Generating strata
set seed 3454
egen strata = group(ENT TAMLOC)
egen strata2 = concat(ENT TAMLOC)

***Households ID
set seed 3454
egen hid=group(ENT MUN ID_VIV)
egen hid2=concat(ENT MUN ID_VIV)

***Household size
bys hid: g hhsize=_N

***Municipality ID
set seed 3454
egen mun_id=group(ENT MUN)
egen mun_id2=concat(ENT MUN)

***PSU ID
set seed 3454
egen psu_id=group(ENT MUN TAMLOC UPM)
egen psu_id2=concat(ENT MUN TAMLOC UPM)

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

***Average age of HH
g aux_agehh=EDAD if PARENT==1
bys hid: egen age_hh=max(aux_agehh)
drop aux*


***Share of adults with XX years of school
g aux_sh_educ0_8=0 if ESCOACUM!=.
replace aux_sh_educ0_8=1 if ESCOACUM>=0 & ESCOACUM<=8 

bys hid: egen aux2_sh_educ0_8=mean(aux_sh_educ0_8) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ0_8=max(aux2_sh_educ0_8) 
drop aux*

g aux_sh_educ9_13=0 if ESCOACUM!=.
replace aux_sh_educ9_13=1 if ESCOACUM>=9 & ESCOACUM<=13

bys hid: egen aux2_sh_educ9_13=mean(aux_sh_educ9_13) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ9_13=max(aux2_sh_educ9_13) 
drop aux*

g aux_sh_educ14_plus=0 if ESCOACUM!=.
replace aux_sh_educ14_plus=1 if ESCOACUM>=14 & ESCOACUM!=.

bys hid: egen aux2_sh_educ14_plus=mean(aux_sh_educ14_plus) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ14_plus=max(aux2_sh_educ14_plus) 
drop aux*

***Share of adults iliterate
recode ALFABET (9=.) (7=0) (5=1)

bys hid: egen aux_sh_literate=mean(ALFABET) if EDAD>=18 & EDAD<=65
bys hid: egen sh_literate=max(aux_sh_literate) 
drop aux*

***Sahre of children 7-14 attending school

recode ASISTEN (9=.) (7=0) (5=1)

bys hid: egen aux_sh_attend=mean(ASISTEN) if EDAD>=7 & EDAD<=14
bys hid: egen sh_attend=max(aux_sh_attend) 
drop aux*

***Dependency ratios
g id_child=(EDAD>=0 & EDAD<=14)
bys hid: egen no_child=sum(id_child)
g depen_ch=no_child/hhsize 
replace depen_ch=0 if no_child==0 & hhsize!=0

***Elderly
g id_old=(EDAD>=65 & EDAD!=.)
bys hid: egen no_old=sum(id_old)
g depen_old=no_old/hhsize
replace depen_old=0 if no_old==0 & hhsize!=0 

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
***Indicators at PSU level
bys psu_id: egen educ_psu=mean(ESCOACUM) //Average schooling of population at PSU level
bys psu_id: egen unemp_psu=mean(unemp) //unemployment
bys psu_id: egen informal_psu=mean(informal) //informality

***Indicators at Municipality level
bys mun_id: egen educ_mun=mean(ESCOACUM) //Average schooling of population at PSU level
bys mun_id: egen unemp_mun=mean(unemp) //unemployment
bys mun_id: egen informal_mun=mean(informal) //informality


preserve
keep psu_id educ_psu unemp_psu informal_psu
duplicates drop
tempfile psu
save `psu'
restore

preserve
keep mun_id educ_mun unemp_mun informal_mun
duplicates drop
tempfile mun
save `mun'
restore

preserve
keep hid psu_id hhsize income_hh pchinc educ_hh age_hh 
duplicates drop
bys psu_id: egen hhsize_psu=mean(hhsize) //household size
bys psu_id: egen incomehh_psu=mean(income_hh) //income of HH
bys psu_id: egen pchinc_psu=mean(pchinc) //per capita income 
bys psu_id: egen educhh_psu=mean(educ_hh) //years of education of HH
bys psu_id: egen agehh_psu=mean(age_hh) //age HH

keep psu_id hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu
duplicates drop
tempfile psu2
save `psu2'
restore

***Municipality level
preserve
keep hid mun_id hhsize income_hh pchinc educ_hh age_hh 
duplicates drop
bys mun_id: egen hhsize_mun=mean(hhsize) //household size
bys mun_id: egen incomehh_mun=mean(income_hh) //income of HH
bys mun_id: egen pchinc_mun=mean(pchinc) //per capita income 
bys mun_id: egen educhh_mun=mean(educ_hh) //years of education of HH
bys mun_id: egen agehh_mun=mean(age_hh) //age HH

keep mun_id hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun
duplicates drop
tempfile mun2
save `mun2'
restore

merge m:1 psu_id using `psu'
drop _merge
merge m:1 psu_id using `psu2'
drop _merge
merge m:1 mun_id using `mun'
drop _merge
merge m:1 mun_id using `mun2'
drop _merge

keep ENT NOM_ENT MUN NOM_MUN LOC50K NOM_LOC ID_VIV TAMLOC hid hhsize pchinc educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate sh_attend depen* UPM ESTRATO FACTOR female_hh strata mun_id hhsize_mun incomehh_mun psu_id hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu pchinc_mun educhh_mun agehh_mun educ_psu unemp_psu informal_psu educ_mun unemp_mun informal_mun hid2 strata2 psu_id2 mun_id2
duplicates drop

sort ENT MUN ID_VIV

tempfile household
save `household'

**********************************************************************************
***Household level variables, househols
use "intercensal_2015\intercensal_viv_2015.dta", clear

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

***Didn't eat
*g not_fed=inlist(SINCOMER, 1) //NOT AVAILABLE
	
**Household income
recode INGTRHOG  (999999=.)
g pchinc_hh=INGTRHOG/NUMPERS

***Check FACTOR
g factor_hh=FACTOR

keep ENT MUN ID_VIV wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet /*not_fed*/ pchinc_hh factor_hh

sort ENT MUN ID_VIV

merge 1:1 ENT MUN ID_VIV using `household'
drop _merge

save "intercensal_2015\intercensal_proc_MEX_2015", replace


*******************************************************************************************
*******************************************************************************************
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2020
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*******************************************************************************************
*******************************************************************************************

use "Census_2020\census_ind_2020.dta", clear 

***Generating strata
set seed 3454
egen strata = group(ENT TAMLOC)
egen strata2 = concat(ENT TAMLOC)

***Households ID
set seed 3454
egen hid=group(ENT MUN ID_VIV)
egen hid2=concat(ENT MUN ID_VIV)

***Household size
bys hid: g hhsize=_N

***PSU ID
set seed 3454
egen psu_id=group(ENT MUN TAMLOC UPM)
egen psu_id2=concat(ENT MUN TAMLOC UPM)

***Municipality ID
set seed 3454
egen mun_id=group(ENT MUN)
egen mun_id2=concat(ENT MUN)

***Labor per capita income
recode INGTRMEN (999999=.)
bys hid: egen aux_pchinc=sum(INGTRMEN),m
g pchinc=aux_pchinc/hhsize
drop aux*

***Head is female
g aux_female_hh=1 if SEXO==3 & PARENTESCO=="101"
bys hid: egen female_hh=max(aux_female_hh)
replace female_hh=0 if female_hh==.
drop aux_*

***Education level of HH
recode ESCOACUM (99=.)

g aux_eduhh=ESCOACUM if PARENTESCO=="101"
bys hid: egen educ_hh=max(aux_eduhh)
drop aux*

***Average head income
recode INGTRMEN (999999=.)
g aux_income=INGTRMEN if PARENTESCO=="101"
bys hid: egen income_hh=max(aux_income)
drop aux_income

***Average age of HH
g aux_agehh=EDAD if PARENTESCO=="101"
bys hid: egen age_hh=max(aux_agehh)
drop aux*

***Share of adults with XX years of school
g aux_sh_educ0_8=0 if ESCOACUM!=.
replace aux_sh_educ0_8=1 if ESCOACUM>=0 & ESCOACUM<=8 

bys hid: egen aux2_sh_educ0_8=mean(aux_sh_educ0_8) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ0_8=max(aux2_sh_educ0_8) 
drop aux*

g aux_sh_educ9_13=0 if ESCOACUM!=.
replace aux_sh_educ9_13=1 if ESCOACUM>=9 & ESCOACUM<=13

bys hid: egen aux2_sh_educ9_13=mean(aux_sh_educ9_13) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ9_13=max(aux2_sh_educ9_13) 
drop aux*

g aux_sh_educ14_plus=0 if ESCOACUM!=.
replace aux_sh_educ14_plus=1 if ESCOACUM>=14 & ESCOACUM!=.

bys hid: egen aux2_sh_educ14_plus=mean(aux_sh_educ14_plus) if EDAD>=18 & EDAD<=65
bys hid: egen sh_educ14_plus=max(aux2_sh_educ14_plus) 
drop aux*

***Share of adults iliterate
recode ALFABET (9=.) (3=0)

bys hid: egen aux_sh_literate=mean(ALFABET) if EDAD>=18 & EDAD<=65
bys hid: egen sh_literate=max(aux_sh_literate) 
drop aux*

***Sahre of children 7-14 attending school
recode ASISTEN (9=.) (3=0)

bys hid: egen aux_sh_attend=mean(ASISTEN) if EDAD>=7 & EDAD<=14
bys hid: egen sh_attend=max(aux_sh_attend) 
drop aux*

***Dependency ratios
g id_child=(EDAD>=0 & EDAD<=14)
bys hid: egen no_child=sum(id_child)
g depen_ch=no_child/hhsize 
replace depen_ch=0 if no_child==0 & hhsize!=0

***Elderly
g id_old=(EDAD>=65 & EDAD!=.)
bys hid: egen no_old=sum(id_old)
g depen_old=no_old/hhsize
replace depen_old=0 if no_old==0 & hhsize!=0 

*** Labor indicators
***PEA
g PEA=inlist(CONACT,10,13,14,15,16,17,18,19,20,30)
replace PEA=. if PEA==0 & (CONACT==40 | CONACT==50 | CONACT==60 | CONACT==70 | CONACT==80 | CONACT==99)

***Unemployment
g unemp=0 if PEA!=.
replace unemp=1 if CONACT==30 & PEA!=.

***Employment
g emp=0 if PEA!=.
replace emp=1 if CONACT>=10 & CONACT<=20 & PEA!=.

***Self-employment
g informal=0 if emp==1
replace informal=1 if emp==1 & SITTRA>=4 & SITTRA<=6

***********************************
***PSU and Municipality indicators
***********************************
***Indicators at PSU level
bys psu_id: egen educ_psu=mean(ESCOACUM) //Average schooling of population at PSU level
bys psu_id: egen unemp_psu=mean(unemp) //unemployment
bys psu_id: egen informal_psu=mean(informal) //informality

***Indicators at Municipality level
bys mun_id: egen educ_mun=mean(ESCOACUM) //Average schooling of population at PSU level
bys mun_id: egen unemp_mun=mean(unemp) //unemployment
bys mun_id: egen informal_mun=mean(informal) //informality


preserve
keep psu_id educ_psu unemp_psu informal_psu
duplicates drop
tempfile psu
save `psu'
restore

preserve
keep mun_id educ_mun unemp_mun informal_mun
duplicates drop
tempfile mun
save `mun'
restore

preserve
keep hid psu_id hhsize income_hh pchinc educ_hh age_hh 
duplicates drop
bys psu_id: egen hhsize_psu=mean(hhsize) //household size
bys psu_id: egen incomehh_psu=mean(income_hh) //income of HH
bys psu_id: egen pchinc_psu=mean(pchinc) //per capita income 
bys psu_id: egen educhh_psu=mean(educ_hh) //years of education of HH
bys psu_id: egen agehh_psu=mean(age_hh) //age HH

keep psu_id hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu
duplicates drop
tempfile psu2
save `psu2'
restore

***Municipality level
preserve
keep hid mun_id hhsize income_hh pchinc educ_hh age_hh 
duplicates drop
bys mun_id: egen hhsize_mun=mean(hhsize) //household size
bys mun_id: egen incomehh_mun=mean(income_hh) //income of HH
bys mun_id: egen pchinc_mun=mean(pchinc) //per capita income 
bys mun_id: egen educhh_mun=mean(educ_hh) //years of education of HH
bys mun_id: egen agehh_mun=mean(age_hh) //age HH

keep mun_id hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun
duplicates drop
tempfile mun2
save `mun2'
restore


merge m:1 psu_id using `psu'
drop _merge
merge m:1 psu_id using `psu2'
drop _merge
merge m:1 mun_id using `mun'
drop _merge
merge m:1 mun_id using `mun2'
drop _merge

keep ENT NOM_ENT MUN NOM_MUN ID_VIV TAMLOC hid hhsize pchinc educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate sh_attend depen* UPM ESTRATO FACTOR female_hh strata  mun_id hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun psu_id hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu educ_mun unemp_mun informal_mun educ_psu unemp_psu informal_psu hid2 strata2 psu_id2 mun_id2

duplicates drop

sort ENT MUN ID_VIV

tempfile household
save `household'

**********************************************************************************
***Household level variables, househols
use "Census_2020\census_viv_2020.dta", clear

***House conditions
g wall_improved  = inlist(PAREDES,6,7,8) //madera, adobe; tabique, ladrillo, block, piedra, cemento, concreto
g roof_improved  = inlist(TECHOS, 3,4,9,10) //lamina metalica, lamina asbesto, teaj, losa concreto    
g floor_improved = inlist(PISOS, 2,3) //cemento; madera, mosaico 
  
g water_improved = inlist(AGUA_ENTUBADA, 1,2) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g electri = inlist(ELECTRI, 1)   
g flush_toilet = inlist(CONAGU,1) //tiene descarga directa de agua
g sewage = inlist(DRENAJE, 1,2) //la red p�blica, una fosa s�ptica 

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
g internet = inlist(INTERNET, 7)

***Didn't eat
*g not_fed=inlist(SINCOMER, 1) //not in 2015
	
**Household income
recode INGTRHOG  (999999=.)
g pchinc_hh=INGTRHOG/NUMPERS

***Check FACTOR
g factor_hh=FACTOR

keep ENT MUN ID_VIV wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet  pchinc_hh factor_hh

sort ENT MUN ID_VIV

merge 1:1 ENT MUN ID_VIV using `household'
drop _merge

save "Census_2020\census_proc_MEX_2020", replace
