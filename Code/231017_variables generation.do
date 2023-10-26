cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2010
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

**********************************************************************************
***Household level variables individuals
use "census_2010\census_ind_2010.dta", clear

***Generate strata ID based on survey design (State and locsize)
egen strata_id=concat(ENT TAM_LOC)

***Households ID
egen hid=concat(ENT MUN ID_VIV)

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
bys hid: egen educhh=max(aux_eduhh)
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


keep ENT NOM_ENT MUN NOM_MUN LOC50K NOM_LOC ID_VIV TAM_LOC hid hhsize pchinc educhh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate sh_attend depen* UPM ESTRATO FACTOR female_hh strata_id
duplicates drop

sort ENT MUN ID_VIV

tempfile household
save `household'

**********************************************************************************
***Household level variables, househols
use "census_2010\census_viv_2010.dta", clear

***House conditions
g wall_improved  = inlist(PAREDES,6,7,8) 
g roof_improved  = inlist(TECHOS, 3,4,8,9)    
g floor_improved = inlist(PISOS, 2,3)  
  
g water_improved = inlist(DISAGU, 1,2)   
g electri = inlist(ELECTRI, 1)   
g flush_toilet = inlist(CONAGU,5)
g sewage = inlist(DRENAJE, 1,2)

g own_house = inlist(TENVIV, 1)

g cook_fuel = inlist(COMBUS, 1,2,5) //gas or electricity

***Overcrowding
recode TOTCUART  (99=.)
recode CUADORM (99=.)
destring NUMPERS, replace

g over_crowding=NUMPERS/TOTCUART
g over_crowding_ext=NUMPERS/CUADORM

***Household assets
g stove = inlist(ESTUFAG, 1)
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
g not_fed=inlist(SINCOMER, 1)
	
**Household income
recode INGTRHOG  (999999=.)
g pchinc_hh=INGTRHOG/NUMPERS

***Check FACTOR
g factor_hh=FACTOR

keep ENT MUN ID_VIV wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet not_fed pchinc_hh factor_hh

sort ENT MUN ID_VIV

merge 1:1 ENT MUN ID_VIV using `household'
drop _merge

save "census_2010\census_proc_MEX_2010", replace