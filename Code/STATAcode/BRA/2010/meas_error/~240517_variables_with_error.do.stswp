** This is for BRA 2010 
cd "D:\david\SAE\SAE_research_with_Melany\BRA"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2010
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

**********************************************************************************
***Household level variables individuals
local command "use"
drop _all 
forvalues i=1(1)10 {
`command' "2010\full_census\rawdata\BRA_`i'_2010.dta"
local command "append using"
} 


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

*** Merging with samples
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

forvalues i=1(1)100 {
preserve
merge m:1 hid using "2010\full_census_new\rawsamples\sample_`i'.dta"
keep if _merge==3
drop mun_id 

* rename V0011 psu_id
* destring psu_id, replace
* format psu_id %20.0g

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

***Variables creation

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

 
* we will shift the category by 1 with a 2% probability for the low and a 10% for the high. 
scalar p_change_low = 0.02
scalar p_change_high = 0.10

generate double u_school = uniform()
gen addschool=1 if school==0 
replace addschool=-1 if school>0 // sets everything above 0 to negative 1   
replace addschool=1 if school>0 & school<4 & uniform()<0.5  // resets randomly selected half of everything between 1 and 3 to 1 
generate school_low=school 
generate school_high=school 
replace school_low=school+addschool if u_school<p_change_low
replace school_high=school+addschool if u_school<p_change_high 


 
 
***Household head some primary education
g aux_eduhh=(school_high==2 & hhead==1)
bys hid: egen hh_primedu_high=max(aux_eduhh)
drop aux*

g aux_eduhh=(school_low==2 & hhead==1)
bys hid: egen hh_primedu_low=max(aux_eduhh)
drop aux*


***Household head some secondary education
g aux_eduhh_=(school_high==3 & hhead==1)
bys hid: egen hh_secondedu_high=max(aux_eduhh)
drop aux*

g aux_eduhh=(school_low==3 & hhead==1)
bys hid: egen hh_secondedu_low=max(aux_eduhh)
drop aux*


***Household head some superios education
g aux_eduhh=(school_high==4 & hhead==1)
bys hid: egen hh_superior_high=max(aux_eduhh)
drop aux*

***Household head some superios education
g aux_eduhh=(school_low==4 & hhead==1)
bys hid: egen hh_superior_low=max(aux_eduhh)
drop aux*



***Average age of HH
g aux_agehh=ageyrs if hhead==1
bys hid: egen age_hh=max(aux_agehh)
drop aux*

***Dependency ratios
g id_child=(ageyrs>=0 & ageyrs<=14)
bys hid: egen depen_ch=mean(id_child)

***Elderly
g id_old=(ageyrs>=65 & ageyrs!=.)
bys hid: egen depen_old=mean(id_old)

***Unemployment
g unemp=0 
replace unemp=1 if (V6910=="Desocupadas" | V6920=="Desocupadas") 

***Employment
g emp=0 
replace emp=1 if V6910=="Ocupadas" 

***PEA 
g PEA=(emp==1 | unemp==1)

***Self-employment
g informal=0 if emp==1
replace informal=1 if emp==1 & (V6930=="Conta própria" | V6930=="Empregadores")






***Variances of continuous variables
***Low and high reliability
sum ageyrs,d
scalar sim_ageyrs_sd_low=sqrt(r(Var)*(1-0.5))
scalar sim_ageyrs_sd_high=sqrt(r(Var)*(1-0.9))

***Generating errors of continuous variables - just age in BRA 
***Low reliability generates larger errors and viceversa
generate error_ageyrs_high = rnormal(0, sim_ageyrs_sd_low)
generate error_ageyrs_low = rnormal(0, sim_ageyrs_sd_high)

***Generating continuous variables with errors 
generate ageyrs_low = ageyrs + error_ageyrs_low
generate ageyrs_high = ageyrs + error_ageyrs_high
replace ageyrs_low=0 if ageyrs_low<0
replace ageyrs_high=0 if ageyrs_high<0


**********************************
***Generating variables for the model

***Average age of HH
g aux_agehh=ageyrs_low if hhead==1
bys hid: egen age_hh_low=max(aux_agehh)
drop aux*

g aux_agehh=ageyrs_high if hhead==1
bys hid: egen age_hh_high=max(aux_agehh)
drop aux*

***Dependency ratios
g id_child_low=(ageyrs_low>=0 & ageyrs_low<=14)
bys hid: egen depen_ch_low=mean(id_child_low)

g id_child_high=(ageyrs_high>=0 & ageyrs_high<=14)
bys hid: egen depen_ch_high=mean(id_child_high)

***Elderly
g id_old_low=(ageyrs_low>=65 & ageyrs_low!=.)
bys hid: egen depen_old_low=mean(id_old_low)

***Elderly
g id_old_high=(ageyrs_high>=65 & ageyrs_high!=.)
bys hid: egen depen_old_high=mean(id_old_high)





***Share of adults with ceratin education level
tab school_low, g(educ_)

g aux_sh_primedu=educ_3 if ageyrs>=18 
bys hid: egen sh_primedu_low=mean(aux_sh_primedu)
*bys mun_id: egen sh_primedu_mun=mean(aux_sh_primedu)
drop aux*

g aux_sh_secedu=educ_4 if ageyrs>=18 
bys hid: egen sh_secedu_low=mean(aux_sh_secedu)
*bys mun_id: egen sh_secedu_mun=mean(aux_sh_secedu)
drop aux*

g aux_sh_supedu=educ_5 if ageyrs>=18 
bys hid: egen sh_supedu_low=mean(aux_sh_supedu)
*bys mun_id: egen sh_supedu_mun=mean(aux_sh_supedu)
*drop aux*

g aux_sh_noedu=educ_1 if ageyrs>=18 
bys hid: egen sh_noedu_low=mean(aux_sh_noedu)
*bys mun_id: egen sh_noedu_mun=mean(aux_sh_noedu)
drop aux*

drop educ_* 

tab school_high, g(educ_)

g aux_sh_primedu=educ_3 if ageyrs>=18 
bys hid: egen sh_primedu_high=mean(aux_sh_primedu)
*bys mun_id: egen sh_primedu_mun=mean(aux_sh_primedu)
drop aux*

g aux_sh_secedu=educ_4 if ageyrs>=18 
bys hid: egen sh_secedu_high=mean(aux_sh_secedu)
*bys mun_id: egen sh_secedu_mun=mean(aux_sh_secedu)
drop aux*

g aux_sh_supedu=educ_5 if ageyrs>=18 
bys hid: egen sh_supedu_high=mean(aux_sh_supedu)
*bys mun_id: egen sh_supedu_mun=mean(aux_sh_supedu)
drop aux*

g aux_sh_noedu=educ_1 if ageyrs>=18 
bys hid: egen sh_noedu_high=mean(aux_sh_noedu)
*bys mun_id: egen sh_noedu_mun=mean(aux_sh_noedu)
drop aux*




***Share of adults iliterate -- error simulated below 
gen aux_sh_literate=literate if ageyrs>=18 
bys hid: egen sh_literate=mean(aux_sh_literate) 
*bys mun_id: egen sh_literate_mun=mean(aux_sh_literate) 
*drop aux*


*****************************************************************
*** Missclassification probabilities for binary variables
scalar p_01_low = 0.02
scalar p_10_low = 0.02

scalar p_01_high = 0.10
scalar p_10_high = 0.10

*** Generate uniform random numbers for applying misclassification
generate double u_literate = uniform()
generate double u_sex = uniform()
generate double u_emp = uniform()
generate double u_unemp = uniform()
generate double u_informal = uniform()

***Share of adults iliterate
generate literate_low = literate
replace literate_low = 1 if literate == 0 & u_literate < p_01_low
replace literate_low = 0 if literate == 1 & u_literate < p_10_low

gen aux_sh_literate_low=literate if ageyrs_low>=18 
bys hid: egen sh_literate_low=mean(aux_sh_literate_low) 

gen aux_sh_literate_high=literate if ageyrs_low>=18 
bys hid: egen sh_literate_high=mean(aux_sh_literate_low) 

generate sex_low = sex
replace sex_low = 1 if sex == 0 & u_sex < p_01_low
replace sex_low = 0 if sex == 1 & u_sex < p_10_low

generate sex_high = sex
replace sex_high = 1 if sex == 0 & u_sex < p_01_high
replace sex_high = 0 if sex == 1 & u_sex < p_10_high

***Head is female
g aux_female_hh=1 if sex_low==0 & hhead==1
bys hid: egen female_hh_low=max(aux_female_hh)
replace female_hh_low=0 if female_hh_low==.
drop aux_*

g aux_female_hh=1 if sex_high==0 & hhead==1
bys hid: egen female_hh_high=max(aux_female_hh)
replace female_hh_high=0 if female_hh_high==.
drop aux_*

keep  state nom_state muni hid2 weights region urban depen_ch_* depen_old_* pchinc hid mun_id psu_id hhsize income_hh female_hh_* hh_primedu_* hh_secondedu_* hh_superior_* age_hh_* sh_primedu_* sh_secedu_* sh_supedu_* sh_noedu_* sh_literate_* 

duplicates drop
saveold "2010\full_census_new\error_data\ind\variables_errors_ind_`i'", replace
restore
}


/*===============================================================
***Household level variables
===============================================================*/


***Household level variables, househols
use "2010\full_census\rawdata\BRA_VIV_2010.dta", clear




rename V0011 psu_id
destring psu_id, replace
format psu_id %20.0g

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

keep hid mun_id psu_id wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet factor_hh over_crowding over_crowding_ext 



*** Merging with samples
forvalues i=1(1)100 {
preserve

merge 1:1 hid using "2010\full_census_new\rawsamples\sample_`i'.dta"
keep if _merge==3

*** Missclassification probabilities for binary variables
scalar p_01_low = 0.02
scalar p_10_low = 0.02

scalar p_01_high = 0.10
scalar p_10_high = 0.10

*** Generate uniform random numbers for applying misclassification
set seed 3454

foreach var in wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet  over_crowding over_crowding_ext   {
	g double u_`var'=uniform()
}
foreach var in wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet  over_crowding over_crowding_ext  {
	generate `var'_low = `var'
	replace `var'_low = 1 if `var' == 0 & u_`var' < p_01_low
	replace `var'_low = 0 if `var' == 1 & u_`var' < p_10_low
	
	generate `var'_high = `var'
	replace `var'_high = 1 if `var' == 0 & u_`var' < p_01_high
	replace `var'_high = 0 if `var' == 1 & u_`var' < p_10_high
}


keep hid mun_id psu_id wall_improved_* water_improved_* electri_* sewage_* own_house_* good_house_* motorcy_* radio_* tele_* fridge_* washing_* auto_* compu_* cell_* internet_* factor_hh over_crowding_* over_crowding_ext_*

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


