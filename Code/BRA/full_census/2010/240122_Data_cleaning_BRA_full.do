cd "D:\SAE_project\BRA\2010\rawdata"

forvalues i=1(1)10 {
use "BRA_`i'_2010.dta", clear

***Labeling variables
label var V0002 "Municipality"
label var V0001 "State"
label var V0300 "Household ID"
label var V0011 "Ponderation area"
label var V0010 "Weights"
label var V1002 "Mesoregion"
label var V1003 "Microregion"
label var V1004 "Metropolitan region"
label var V1006 "Urban"
label var V1001 "Geographic region"
label var V0502 "Relationship"
label var V0601 "Sex"
label var V6033 "Age (years&months)"
label var V6036 "Age (years)"
label var V0606 "Race"
label var V0627 "Literate"
label var V0628 "School type"
label var V0629 "School Grade"
label var V0630 "Serie/year school"
label var V0631 "Serie school"
label var V0632 "Finish other grade"
label var V0633 "Highest level"
label var V0634 "Did you finish the level"
label var V0635 "Highest level achieved"
label var V6400 "Level of instruction"
label var V0639 "Type of union"
label var V0640 "Civil status"
label var V0641 "Did you work last week"
label var V0642 "Last week were absent from work"
label var V0643 "Did you work without any pay"
label var V0644 "Did you work only to feed memebers of the household"
label var V0645 "How many jobs did you have"
label var V6511 "Gross monthly income in main job"
label var V6513 "Income from main job"
label var V0652 "Type of income from other jobs"
label var V6521 "Gross monthly income in other jobs"
label var V6525 "Income from all jobs"
label var V6527 "Total monthly income"
label var V6529 "Household income"
label var V6531 "Per capita household income"
label var V5060 "Number of members in the household"
label var V5070 "Per capital family income"
label var V0654 "Last week di you look for jobs"
label var V0648 "Employment status"

rename V1001 region
destring region, replace
label define region 1 "North" 2 "Northeast" 3 "Southeast" 4 "South" 5 " Central"
label value region region

rename V1006 urban
replace urban="1" if urban=="Urbana"
replace urban="0" if urban=="Rural"
destring urban, replace
label define urban 1 "Urban" 0 "Rural"
label value urban urban

rename V0601 sex
replace sex="1" if sex=="Masculino"
replace sex="0" if sex=="Feminino"
destring sex, replace
label define sex 1 "Male" 0 "Female"
label value sex sex

rename V0502 relation
g hhead=0
replace hhead=1 if relation=="Pessoa responsável pelo domicílio "
label var hhead "Household head"

rename V0606 race
replace race="1" if race=="Branca"
replace race="2" if race=="Preta"
replace race="3" if race=="Amarela"
replace race="4" if race=="Parda"
replace race="5" if race=="Indígena"
replace race="6" if race=="Ignorado"

destring race, replace
label define race 1 "White" 2 "Black" 3 "Yellow" 4 "Brown" 5 "Indigenous" 6 "No response"
label value race race

rename V0627 literate
replace literate="1" if literate=="Sim"
replace literate="0" if literate=="Não"
destring literate, replace
label define literate 1 "Literate" 0 "Illiterate"
label value literate literate

***Renaming
rename V6036 ageyrs
rename V6033 ageyrmnth
rename V0300 hid2
rename V0001 state
rename abbrev_state nom_state
rename V0002 muni
rename V6511 gross_income_main
rename V6513 income_main
rename V6521 gross_income_other
rename V6525 income_all_jobs
rename V6527 total_income
rename V6529 household_income
rename V6531 percap_household_income
rename V5070 percap_family_income
rename V0010 weights

***Variables creation
***Household ID
tostring hid2, replace
gen leng=length(hid2)

gen addhid="00000" if leng==2
replace addhid="0000" if leng==3
replace addhid="000" if leng==4
replace addhid="00" if leng==5
replace addhid="0" if leng==6
replace addhid="" if leng==7

egen aux_hid=concat(addhid hid2)
drop leng
gen leng=length(aux_hid)
egen hid=concat(state muni aux_hid)
destring hid, replace
format hid %20.0g
drop aux_* addhid leng 
label var hid "Household ID (long)"

***Mnicipality ID
egen mun_id=concat(state muni)
destring mun_id, replace
label var mun_id "Municipality ID"

***Household size
bys hid: g hhsize=_N
label var hhsize "Household size"

***Labor per capita income
rename percap_household_income pchinc

***Average income of head
/*I shoudl use this one V6527 total_income*/
g aux_income=pchinc if hhead==1
bys hid: egen income_hh=max(aux_income)
drop aux_income

***Head is female
g aux_female_hh=1 if sex==0 & hhead==1
bys hid: egen female_hh=max(aux_female_hh)
replace female_hh=0 if female_hh==.
drop aux_*

***Education level
***For the ones attending
g school=0 if V0628=="Não, nunca frequentou"
replace school=1 if  (V0628=="Sim, particular" | V0628=="Sim, pública ") & (V0629=="Alfabetização de jovens e adultos" | V0629=="Classe de alfabetização - CA" | V0629=="Creche" | V0629=="Pré-escolar (maternal e jardim da infância)")
replace school=2 if (V0628=="Sim, particular" | V0628=="Sim, pública ") & (V0629=="Educação de jovens e adultos - EJA - ou supletivo do ensino fundamental" | V0629=="Regular do ensino fundamental")
replace school=3 if (V0628=="Sim, particular" | V0628=="Sim, pública ") & (V0629=="Regular do ensino médio" | V0629=="Educação de jovens e adultos - EJA - ou supletivo do ensino médio")
replace school=4 if (V0628=="Sim, particular" | V0628=="Sim, pública ") & (V0629=="Doutorado" | V0629=="Mestrado" | V0629=="Superior de graduação" |  V0629=="Especialização de nível superior ( mínimo de 360 horas )")

***For the ones attended
replace school=1 if  (V0628=="Não, já frequentou") & (V0633=="Alfabetização de jovens e adultos" | V0633=="Creche, pré-escolar (maternal e jardim de infância), classe de alfabetização - CA" )
replace school=2 if (V0628=="Não, já frequentou") & (V0633=="Antigo primário (elementar)" | V0633=="Ensino fundamental ou 1º grau (4ª série/ 5º ano)" | V0633=="Ensino fundamental ou 1º grau (da 1ª a 3ª série/ do 1º ao 4º ano)" | V0633=="Ensino fundamental ou 1º grau (da 5ª a 8ª série/ 6º ao 9º ano)" | V0633=="Supletivo do ensino fundamental ou do 1º grau")
replace school=3 if (V0628=="Não, já frequentou") & (V0633=="Antigo científico, clássico, etc.....(médio 2º ciclo)" | V0633=="Antigo ginásio (médio 1º ciclo)" | V0633=="Regular ou supletivo do ensino médio ou do 2º grau")
replace school=4 if (V0628=="Não, já frequentou") & (V0633=="Especialização de nível superior ( mínimo de 360 horas )" | V0633=="Mestrado" | V0633=="Superior de graduação" | V0633=="Doutorado")

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
/*
2009
***Poverty
replace lp_ci=157.562047734454	if region==3	& area==1            /*sudeste-urbano*/	
replace lp_ci=134.471057978337	if region==3	& area==2            /*sudeste-rural*/	
***Extreme poverty
replace lpe_ci=78.7810238672271	if region==3	& area==1		/*sudeste-urbano*/
replace lpe_ci=67.2355289891683	if region==3	& area==2		/*sudeste-rural*/
2011
***Poverty
replace lp_ci=  177.05  	if region==3	& area==1            /*sudeste-urbano*/	
replace lp_ci=  151.10  	if region==3	& area==2            /*sudeste-rural*/		
***Extreme poverty
replace lpe_ci=  88.52  	if region==3	& area==1		/*sudeste-urbano*/
replace lpe_ci=  75.55  	if region==3	& area==2		/*sudeste-rural*/

***Average two years to get 2010
***Poverty
replace lp_ci=167.30602	       /*sudeste-urbano*/	
replace lp_ci=142.78553	       /*sudeste-rural*/	
***Extreme poverty
replace lpe_ci=83.650512	   /*sudeste-urbano*/
replace lpe_ci=71.3927643	   /*sudeste-rural*/

***Weighted averages urban/rural: tab urban [w=int(V0010)]
Poverty: 163.8265625
Extreme poverty: 81.9111376

Use extreme poverty line to measure poverty using labor income as we did in Mexico
*/

g povline1=83.650512 if urban==1
replace povline1=71.3927643 if urban==0

g povline2=167.30602 if urban==1
replace povline2=142.78553 if urban==0


***Indicadores de pobreza
//FGT (extreme poverty)
forval a=0/2{
gen efgt`a' = (pchinc<povline1)*(1-pchinc/(povline1))^`a' if pchinc!=.
}

forval a=0/2{
gen efgt`a'_m = (pchinc<81.9111376)*(1-pchinc/(81.9111376))^`a' if pchinc!=.
}

//FGT (poverty)
forval a=0/2{
gen fgt`a' = (pchinc<povline2)*(1-pchinc/(povline2))^`a' if pchinc!=.
}

forval a=0/2{
gen fgt`a'_m = (pchinc<163.8265625)*(1-pchinc/(163.8265625))^`a' if pchinc!=.
}



***Share of adults with ceratin education level
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
drop aux*

***Dependency ratios
g id_child=(ageyrs>=0 & ageyrs<=14)
bys hid: egen depen_ch=mean(id_child)

***Elderly
g id_old=(ageyrs>=65 & ageyrs!=.)
bys hid: egen depen_old=mean(id_old)

***PEA
g PEA=1 if V6900=="1"
replace PEA=0 if V6900=="2"

***Unemployment
g unemp=0 if PEA!=.
replace unemp=1 if (V6910=="Desocupadas" | V6920=="Desocupadas") & PEA!=.

***Employment
g emp=0 if PEA!=.
replace emp=1 if V6910=="Ocupadas" & PEA!=.

***Self-employment
g informal=0 if emp==1
replace informal=1 if emp==1 & (V6930=="Conta própria" | V6930=="Empregadores")

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
collapse (mean) unemp_mun=unemp if ageyrs>=18 & PEA==1 [pw=weights], by(mun_id)
tempfile unemp_mun
save `unemp_mun'
restore

preserve
collapse (mean) informal_mun=informal if ageyrs>=18 & emp==1 [pw=weights], by(mun_id)
tempfile inf_mun
save `inf_mun'
restore

***Municipality level
/*
preserve
keep hid mun_id hhsize income_hh pchinc hh_primedu hh_secondedu hh_superior age_hh female_hh depen_ch depen_old
duplicates drop
bys mun_id: egen hhsize_mun=mean(hhsize) //household size
bys mun_id: egen incomehh_mun=mean(income_hh) //income of HH
bys mun_id: egen pchinc_mun=mean(pchinc) //per capita income 
bys mun_id: egen agehh_mun=mean(age_hh) //age HH
bys mun_id: egen femalehh_mun=mean(female_hh) //female HH
bys mun_id: egen dependch_mun=mean(depen_ch) //mean dependency
bys mun_id: egen dependold_mun=mean(depen_old) //mean dependency

bys mun_id: egen hh_primedu_mun=mean(hh_primedu) //educ HH
bys mun_id: egen hh_secondedu_mun=mean(hh_secondedu) //educ HH
bys mun_id: egen hh_superior_mun=mean(hh_superior) //educ HH

keep mun_id *_mun
duplicates drop
tempfile mun
save `mun'
restore
*/
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
save "census_munlevel_`i'_2010", replace
restore


merge m:1 mun_id using `ind_munw'
drop _merge
merge m:1 mun_id using `unemp_mun'
drop _merge
merge m:1 mun_id using `inf_mun'
drop _merge
merge m:1 mun_id using `munw'
drop _merge

keep  state nom_state muni hid2 weights region urban depen_ch depen_old pchinc hid mun_id hhsize income_hh female_hh hh_primedu hh_secondedu hh_superior age_hh povline1 povline2 *fgt* sh_primedu sh_secedu sh_supedu sh_noedu sh_literate *_mun

duplicates drop

sort hid

tempfile household_`i'
save `household_`i''
}

use `household_1', clear
forvalues i=2(1)10 {
append using `household_`i''
}

save "BRA_IND_2010.dta", replace

***Municipality level variables
use "census_munlevel_1_2010", clear
forvalues i=2(1)10 {
	append using "census_munlevel_`i'_2010"
}

save "census_ind_munlevel_BRA_2010", replace

**********************************************************************************
***Household level variables, househols
use "BRA_VIV_2010.dta", clear

***Household ID
tostring V0300, replace
gen leng=length(V0300)

gen addhid="00000" if leng==2
replace addhid="0000" if leng==3
replace addhid="000" if leng==4
replace addhid="00" if leng==5
replace addhid="0" if leng==6
replace addhid="" if leng==7

egen aux_hid=concat(addhid V0300)
drop leng
gen leng=length(aux_hid)
egen hid=concat(V0001 V0002 aux_hid)
destring hid, replace
format hid %20.0g
drop aux_* addhid leng 
label var hid "Household ID (long)"

***Mnicipality ID
egen mun_id=concat(V0001 V0002)
destring mun_id, replace
label var mun_id "Municipality ID"

***House conditions
destring V0207 V0202 V0208 V0211 V0201 V0213 V0214 V0215 V0216 V0217 V0218 V0219 V0220 V0221 V0222 V6210, replace

g wall_improved  = inlist(V0202,1,2,3) 
g water_improved = inlist(V0208, 1) //agua entubada dentro de la vivienda; agua entubada fuera de la vivienda,  
g electri = inlist(V0211, 1,2)   
g sewage = inlist(V0207, 1,2) //la red p�blica, una fosa s�ptica 
g own_house = inlist(V0201, 1,2) //vive el due�o o propietario
g good_house= inlist(V6210,1,2)

***Overcrowding
rename V6203 over_crowding
rename V6204 over_crowding_ext

***Household assets
g motorcy=inlist(V0221,1)
g radio = inlist(V0213, 1)
g tele = inlist(V0214, 1)
g fridge = inlist(V0216, 1)
g washing = inlist(V0215, 1)
g auto = inlist(V0222, 1)
g compu = inlist(V0219, 1)
g cell = inlist(V0217, 1)
g internet = inlist(V0220, 1)

***Check FACTOR
g factor_hh=V0010

/*
***Municipality level
bys mun_id: egen wall_improved_mun=mean(wall_improved) 
bys mun_id: egen water_improved_mun=mean(water_improved) 
bys mun_id: egen electri_mun=mean(electri) 
bys mun_id: egen sewage_mun=mean(sewage) 
bys mun_id: egen own_house_mun=mean(own_house) 
bys mun_id: egen good_house_mun=mean(good_house)
bys mun_id: egen over_crowding_mun=mean(over_crowding) 
bys mun_id: egen over_crowding_ext_mun=mean(over_crowding_ext) 
bys mun_id: egen motorcy_mun=mean(motorcy) 
bys mun_id: egen radio_mun=mean(radio) 
bys mun_id: egen tele_mun=mean(tele) 
bys mun_id: egen fridge_mun=mean(fridge) 
bys mun_id: egen washing_mun=mean(washing) 
bys mun_id: egen auto_mun=mean(auto) 
bys mun_id: egen compu_mun=mean(compu) 
bys mun_id: egen cell_mun=mean(cell) 
bys mun_id: egen internet_mun=mean(internet)
*/
keep hid mun_id wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet factor_hh over_crowding over_crowding_ext 

***Weighted agregates for area-level models
preserve
g checkhh_mun=1
collapse (mean) wall_improved water_improved electri sewage own_house good_house over_crowding over_crowding_ext motorcy radio tele fridge washing auto compu cell internet  (sum) checkhh_mun [pw=factor_hh], by(mun_id)
foreach x of var * { 
	rename `x' `x'_mun 
} 
rename mun_id_mun mun_id
save "census_viv_munlevel_BRA_2010", replace
restore

sort hid

merge 1:1 hid using "BRA_IND_2010.dta"
drop _merge

merge m:1 mun_id using "census_viv_munlevel_BRA_2010"
drop _merge

save "census_proc_BRA_2010", replace


***Arela level data
use "census_ind_munlevel_BRA_2010", clear
merge 1:1 mun_id using "census_viv_munlevel_BRA_2010"
drop _merge
save "census_mundata_BRA_2010", replace

