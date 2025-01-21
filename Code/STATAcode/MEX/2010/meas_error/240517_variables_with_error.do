* cd "D:\SAE_project\MEX\"
cd "D:\david\SAE\SAE_research_with_Melany\MEX"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2010
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

**********************************************************************************
***Household level variables individuals
use "2010\census_ind_2010.dta", clear

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

*** Merging with samples
forvalues i=1(1)100 {
preserve
merge m:1 hid using "2010\full_census_new\rawsamples_full\sample_`i'.dta"
keep if _merge==3

***Variances of continuous variables
***Low and high reliability
recode EDAD (999=.)
sum EDAD,d
scalar sim_age_sd_low=sqrt(r(Var)*(1-0.5))
scalar sim_age_sd_high=sqrt(r(Var)*(1-0.9))

recode ESCOACUM (99=.)
sum ESCOACUM,d
scalar sim_esco_sd_low=sqrt(r(Var)*(1-0.5))
scalar sim_esco_sd_high=sqrt(r(Var)*(1-0.9))


***Generating errors of continuous variables
***Low reliability generates larger errors and viceversa
generate error_age_high = rnormal(0, sim_age_sd_low)
generate error_age_low = rnormal(0, sim_age_sd_high)

generate error_esco_high = rnormal(0, sim_esco_sd_low)
generate error_esco_low = rnormal(0, sim_esco_sd_high)


***Generating continuous variables with errors 
generate age_low = EDAD + error_age_low
generate age_high = EDAD + error_age_high
replace age_low=0 if age_low<0
replace age_high=0 if age_high<0

generate esco_low = ESCOACUM + error_esco_low
generate esco_high = ESCOACUM + error_esco_high
replace esco_low=0 if esco_low<0
replace esco_high=0 if esco_high<0

**********************************
***Generating variables for the model
***Education level of HH
g aux_eduhh=esco_low if PARENT==1
bys hid: egen educ_low_hh=max(aux_eduhh)
drop aux*

g aux_eduhh=esco_high if PARENT==1
bys hid: egen educ_high_hh=max(aux_eduhh)
drop aux*

***Average age of HH
g aux_agehh=age_low if PARENT==1
bys hid: egen age_low_hh=max(aux_agehh)
drop aux*

g aux_agehh=age_high if PARENT==1
bys hid: egen age_high_hh=max(aux_agehh)
drop aux*

***Share of adults with XX years of school
g aaux_sh_educ0_8_low=0 if esco_low!=.
replace aaux_sh_educ0_8_low=1 if esco_low>=0 & esco_low<=8 

g aaux_sh_educ9_13_low=0 if esco_low!=.
replace aaux_sh_educ9_13_low=1 if esco_low>=9 & esco_low<=13

g aaux_sh_educ14_plus_low=0 if esco_low!=.
replace aaux_sh_educ14_plus_low=1 if esco_low>=14 & esco_low!=.

bys hid: egen aux2_sh_educ0_8_low=mean(aaux_sh_educ0_8_low) if EDAD>=18 
bys hid: egen sh_educ0_8_low=max(aux2_sh_educ0_8_low) 
drop aux*

bys hid: egen aux2_sh_educ9_13_low=mean(aaux_sh_educ9_13_low) if EDAD>=18 
bys hid: egen sh_educ9_13_low=max(aux2_sh_educ9_13_low) 
drop aux*

bys hid: egen aux2_sh_educ14_plus_low=mean(aaux_sh_educ14_plus_low) if EDAD>=18 
bys hid: egen sh_educ14_plus_low=max(aux2_sh_educ14_plus_low) 
drop aux*


g aaux_sh_educ0_8_high=0 if esco_high!=.
replace aaux_sh_educ0_8_high=1 if esco_high>=0 & esco_high<=8 

g aaux_sh_educ9_13_high=0 if esco_high!=.
replace aaux_sh_educ9_13_high=1 if esco_high>=9 & esco_high<=13

g aaux_sh_educ14_plus_high=0 if esco_high!=.
replace aaux_sh_educ14_plus_high=1 if esco_high>=14 & esco_high!=.

bys hid: egen aux2_sh_educ0_8_high=mean(aaux_sh_educ0_8_high) if EDAD>=18 
bys hid: egen sh_educ0_8_high=max(aux2_sh_educ0_8_high) 
drop aux*

bys hid: egen aux2_sh_educ9_13_high=mean(aaux_sh_educ9_13_high) if EDAD>=18 
bys hid: egen sh_educ9_13_high=max(aux2_sh_educ9_13_high) 
drop aux*

bys hid: egen aux2_sh_educ14_plus_high=mean(aaux_sh_educ14_plus_high) if EDAD>=18 
bys hid: egen sh_educ14_plus_high=max(aux2_sh_educ14_plus_high) 
drop aux*

***Dependency ratios
g id_child_low=(age_low>=0 & age_low<=14)
bys hid: egen depen_ch_low=mean(id_child_low)

g id_child_high=(age_high>=0 & age_high<=14)
bys hid: egen depen_ch_high=mean(id_child_high)

***Elderly
g id_old_low=(age_low>=65 & age_low!=.)
bys hid: egen depen_old_low=sum(id_old_low)

g id_old_high=(age_high>=65 & age_high!=.)
bys hid: egen depen_old_high=sum(id_old_high)

*****************************************************************
*** Missclassification probabilities for binary variables
scalar p_01_low = 0.02
scalar p_10_low = 0.02

scalar p_01_high = 0.10
scalar p_10_high = 0.10

*** Generate uniform random numbers for applying misclassification
generate double u_alfabet = uniform()
generate double u_sexo = uniform()

*** Apply misclassification based on probabilities for each scenario
recode ALFABET (9=.) (3=0)

generate ALFABET_low = ALFABET
replace ALFABET_low = 1 if ALFABET == 0 & u_alfabet < p_01_low
replace ALFABET_low = 0 if ALFABET == 1 & u_alfabet < p_10_low

generate ALFABET_high = ALFABET
replace ALFABET_high = 1 if ALFABET == 0 & u_alfabet < p_01_high
replace ALFABET_high = 0 if ALFABET == 1 & u_alfabet < p_10_high

recode SEXO (3=0)

generate SEXO_low = SEXO
replace SEXO_low = 1 if SEXO == 0 & u_sexo < p_01_low
replace SEXO_low = 0 if SEXO == 1 & u_sexo < p_10_low

generate SEXO_high = SEXO
replace SEXO_high = 1 if SEXO == 0 & u_sexo < p_01_high
replace SEXO_high = 0 if SEXO == 1 & u_sexo < p_10_high

********************************
*** Generating variables for the model

***Head is female
g aux_female_hh_low=1 if SEXO_low==0 & PARENT==1
bys hid: egen female_hh_low=max(aux_female_hh_low)
replace female_hh_low=0 if female_hh_low==.
drop aux_*

g aux_female_hh_high=1 if SEXO_high==0 & PARENT==1
bys hid: egen female_hh_high=max(aux_female_hh_high)
replace female_hh_high=0 if female_hh_high==.
drop aux_*

***Share of adults iliterate
bys hid: egen aux_sh_literate_low=mean(ALFABET_low) if EDAD>=18 
bys hid: egen sh_literate_low=max(aux_sh_literate_low) 
drop aux*

bys hid: egen aux_sh_literate_high=mean(ALFABET_high) if EDAD>=18 
bys hid: egen sh_literate_high=max(aux_sh_literate_high) 
drop aux*

keep hid educ_low_hh educ_high_hh age_low_hh age_high_hh sh_educ0_8_low sh_educ9_13_low sh_educ14_plus_low sh_educ0_8_high sh_educ9_13_high sh_educ14_plus_high female_hh_low female_hh_high sh_literate_low sh_literate_high depen_ch_high depen_old_low depen_old_high depen_ch_low

duplicates drop

saveold "2010\full_census_new\error_data\ind\variables_errors_ind_`i'", replace
restore
}


/*===============================================================
***Household level variables
===============================================================*/
use "2010\census_viv_2010.dta", clear
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

*** Merging with samples
forvalues i=1(1)100 {
preserve

merge 1:1 hid using "2010\full_census_new\rawsamples_full\sample_`i'.dta"
keep if _merge==3

******************************************
*** Creating variables without error
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

*****************************************

*** Missclassification probabilities for binary variables
scalar p_01_low = 0.02
scalar p_10_low = 0.02

scalar p_01_high = 0.10
scalar p_10_high = 0.10

*** Generate uniform random numbers for applying misclassification
set seed 3454

foreach var in wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel stove shower radio tele fridge washing auto compu cell internet  {
	g double u_`var'=uniform()
}
foreach var in wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel stove shower radio tele fridge washing auto compu cell internet  {
	generate `var'_low = `var'
	replace `var'_low = 1 if `var' == 0 & u_`var' < p_01_low
	replace `var'_low = 0 if `var' == 1 & u_`var' < p_10_low
	
	generate `var'_high = `var'
	replace `var'_high = 1 if `var' == 0 & u_`var' < p_01_high
	replace `var'_high = 0 if `var' == 1 & u_`var' < p_10_high
}


****************************************
***Variances of continuous variables
***Low and high reliability
recode TOTCUART  (99=.)
sum TOTCUART,d
scalar sim_totroom_sd_low=sqrt(r(Var)*(1-0.5))
scalar sim_totroom_sd_high=sqrt(r(Var)*(1-0.9))

recode CUADORM (99=.)
sum CUADORM,d
scalar sim_totdorm_sd_low=sqrt(r(Var)*(1-0.5))
scalar sim_totdorm_sd_high=sqrt(r(Var)*(1-0.9))


***Generating errors of continuous variables
***Low reliability generates larger errors and viceversa
generate error_totroom_high = rnormal(0, sim_totroom_sd_low)
generate error_totroom_low = rnormal(0, sim_totroom_sd_high)

generate error_totdorm_high = rnormal(0, sim_totdorm_sd_low)
generate error_totdorm_low = rnormal(0, sim_totdorm_sd_high)


***Generating continuous variables with errors 
generate TOTCUART_low = TOTCUART + error_totroom_low
generate TOTCUART_high = TOTCUART + error_totroom_high
replace TOTCUART_low=0 if TOTCUART_low<0
replace TOTCUART_high=0 if TOTCUART_high<0

generate CUADORM_low = CUADORM + error_totdorm_low
generate CUADORM_high = CUADORM + error_totdorm_high
replace CUADORM_low=0 if CUADORM_low<0
replace CUADORM_high=0 if CUADORM_high<0

***Generating overcrowding
destring NUMPERS, replace

g over_crowding_low=NUMPERS/TOTCUART_low
g over_crowding_ext_low=NUMPERS/CUADORM_low

g over_crowding_high=NUMPERS/TOTCUART_high
g over_crowding_ext_high=NUMPERS/CUADORM_high

keep hid psu_id mun_id  FACTOR* over_crowding_ext_high over_crowding_high over_crowding_ext_low over_crowding_low internet_high internet_low cell_high cell_low compu_high compu_low auto_high auto_low washing_high washing_low fridge_high fridge_low tele_high tele_low radio_high radio_low shower_high shower_low stove_high stove_low cook_fuel_high cook_fuel_low own_house_high own_house_low sewage_high sewage_low flush_toilet_high flush_toilet_low electri_high electri_low water_improved_high water_improved_low floor_improved_high floor_improved_low roof_improved_high roof_improved_low wall_improved_high wall_improved_low

saveold "2010\full_census_new\error_data\viv\variables_errors_viv_`i'", replace
restore
}


/*===============================================================
*** Merginf variables with error with samples
===============================================================*/
forvalues i=1(1)100 {
use "2010\full_census_new\error_data\ind\variables_errors_ind_`i'", clear
merge 1:1 hid using "2010\full_census_new\error_data\viv\variables_errors_viv_`i'"
keep if _merge==3
drop _merge
save "2010\full_census_new\rawsamples_error\sample_`i'.dta", replace
}




