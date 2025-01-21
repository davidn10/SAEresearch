cd "D:\david\SAE\SAE_research_with_Melany\BRA"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*- CENSUS 2000
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

**********************************************************************************
***Household level variables individuals
local command "use"
drop _all 
forvalues i=1(1)10 {
`command' "2000\full_census\rawdata\BRA_`i'_2000.dta"
local command "append using"
} 


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



*** Merging with samples

forvalues i=1(1)100 {
preserve
merge m:1 hid using "2000\full_census\rawsamples_new\sample_`i'.dta"
keep if _merge==3
drop mun_id 

***Municipality ID
gen mun_id=muni
destring mun_id, replace
label var mun_id "Municipality ID"

***Household size
bys hid: g hhsize=_N
label var hhsize "Household size"

*Education 
destring V0429 V0430 V0432, replace



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
g id_old_high=(ageyrs_low>=65 & ageyrs_high!=.)
bys hid: egen depen_old_high=mean(id_old_high)


** error for categorical variable (school)



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

* we will shift the category by 1 with a 2% probability for the low and a 10% for the high. 
scalar p_change_low = 0.02
scalar p_change_high = 0.10

generate double u_school = uniform()
gen addschool=1 if school==0 
replace addschool=-1 if school>0 // sets everything above 0 to negative 1   
replace addschool=1 if school>0 & school<4 & uniform()<0.5  // resets randomly selected half of everything between 1 and 3 to 1 
generate school_low=school+addschool if u_school<p_change_low
generate school_high=school+addschool if u_school<p_change_high 

***Household head some primary education
g aux_eduhh=(school_low==2 & hhead==1)
bys hid: egen hh_primedu_low=max(aux_eduhh)
drop aux*

g aux_eduhh=(school_high==2 & hhead==1)
bys hid: egen hh_primedu_high=max(aux_eduhh)
drop aux*

***Household head some secondary education
g aux_eduhh=(school_low==3 & hhead==1)
bys hid: egen hh_secondedu_low=max(aux_eduhh)
drop aux*

g aux_eduhh=(school_high==3 & hhead==1)
bys hid: egen hh_secondedu_high=max(aux_eduhh)
drop aux*

***Household head some superios education
g aux_eduhh=(school_low==4 & hhead==1)
bys hid: egen hh_superior_low=max(aux_eduhh)
drop aux*

g aux_eduhh=(school_high==4 & hhead==1)
bys hid: egen hh_superior_high=max(aux_eduhh)
drop aux*



***Share of adults with certain education level
tab school_low, g(educ_)

g aux_sh_primedu_low=educ_3 if ageyrs_low>=18 
bys hid: egen sh_primedu_low=mean(aux_sh_primedu_low)
*bys mun_id: egen sh_primedu_mun=mean(aux_sh_primedu)
*drop aux*

g aux_sh_secedu_low=educ_4 if ageyrs_low>=18 
bys hid: egen sh_secedu_low=mean(aux_sh_secedu_low)
*bys mun_id: egen sh_secedu_mun=mean(aux_sh_secedu)
*drop aux*

g aux_sh_supedu_low=educ_5 if ageyrs_low>=18 
bys hid: egen sh_supedu_low=mean(aux_sh_supedu_low)
*bys mun_id: egen sh_supedu_mun=mean(aux_sh_supedu)
*drop aux*

g aux_sh_noedu_low=educ_1 if ageyrs_low>=18 
bys hid: egen sh_noedu_low=mean(aux_sh_noedu_low)
*bys mun_id: egen sh_noedu_mun=mean(aux_sh_noedu)
*drop aux*

drop educ_* 
tab school_high, g(educ_)

g aux_sh_primedu_high=educ_3 if ageyrs_high>=18 
bys hid: egen sh_primedu_high=mean(aux_sh_primedu_high)
*bys mun_id: egen sh_primedu_mun=mean(aux_sh_primedu)
*drop aux*

g aux_sh_secedu_high=educ_4 if ageyrs_high>=18 
bys hid: egen sh_secedu_high=mean(aux_sh_secedu_high)
*bys mun_id: egen sh_secedu_mun=mean(aux_sh_secedu)
*drop aux*

g aux_sh_supedu_high=educ_5 if ageyrs_high>=18 
bys hid: egen sh_supedu_high=mean(aux_sh_supedu_high)
*bys mun_id: egen sh_supedu_mun=mean(aux_sh_supedu)
*drop aux*

g aux_sh_noedu_high=educ_1 if ageyrs_high>=18 
bys hid: egen sh_noedu_high=mean(aux_sh_noedu_high)
*bys mun_id: egen sh_noedu_mun=mean(aux_sh_noedu)
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

** employment 

/***Employment
g emp=0 
replace emp=1 if V0439==1 
replace emp=1 if V0439==2 & V0440==1 & emp==.
replace emp=1 if V0439==2 & V0441==1 & emp==.
replace emp=1 if V0439==2 & V0442==1 & emp==.
replace emp=1 if V0439==2 & V0443==1 & emp==.

generate emp_low=emp
replace emp_low=1 if emp==0 & u_emp < p_01_low 
replace emp_low=0 if emp==1 & u_emp < p_10_low 

generate emp_high=emp
replace emp_high=1 if emp==0 & u_emp < p_01_high 
replace emp_high=0 if emp==1 & u_emp < p_10_high 

***Unemployment
g unemp_low=0 if emp_low==0 
replace unemp_low=1 if (emp_low==0 & V0455==1) 
replace unemp_low=0 if unemp_low==1 & emp_low==0 & u_unemp<p_10_low 


g unemp_high=0 if emp_high==0 
replace unemp_high=1 if (emp_high==0 & V0455==1) 
replace unemp_high=0 if unemp_high==1 & emp_high==0 & u_unemp<p_10_high 


***PEA
g PEA_low=1 if emp_low==1 | unemp_low==1
replace PEA_low=0 if PEA_low==.

g PEA_high=1 if emp_high==1 | unemp_high==1
replace PEA_high=0 if PEA_high==.

***Self-employment
g informal_low=0 if emp_low==1
replace informal_low=1 if emp_low==1 & (V0447==5 | V0447==6)
replace informal_low=0 if informal_low=1 & u_informal < p_10_low & emp_low==1 
replace informal_low=1 if informal_low=0 & u_informal < p_01_low & emp_low==1 

g informal_high=0 if emp_high==1
replace informal_high=1 if emp_high==1 & (V0447==5 | V0447==6)
replace informal_high=0 if informal_high=1 & u_informal < p_10_high & emp_high==1 
replace informal_high=1 if informal_high=0 & u_informal < p_01_high & emp_high==1 
*/ 


keep  state nom_state muni hid2 psu_id weights urban depen_ch_* depen_old_* hid mun_id hhsize female_hh_* hh_primedu_* hh_secondedu_* hh_superior_* age_hh_* sh_primedu_* sh_secedu_* sh_supedu_* sh_noedu_* sh_literate_*  

duplicates drop 
saveold "2000\full_census\error_data\ind\variables_errors_ind_`i'", replace
restore
}

/*===============================================================
***Household level variables
===============================================================*/

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

******************************************
*** Creating variables without error
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



g factor_hh=PESO_DOMIC

rename AREAP psu_id

keep hid mun_id psu_id water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC  factor_hh over_crowding over_crowding_ext


*** Merging with samples
forvalues i=1(1)100 {
preserve

merge 1:1 hid using "2000\full_census\rawsamples_new\sample_`i'.dta"
keep if _merge==3

*** Missclassification probabilities for binary variables
scalar p_01_low = 0.02
scalar p_10_low = 0.02

scalar p_01_high = 0.10
scalar p_10_high = 0.10

*** Generate uniform random numbers for applying misclassification
set seed 3454

foreach var in water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC over_crowding over_crowding_ext  {
	g double u_`var'=uniform()
}
foreach var in water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC over_crowding over_crowding_ext {
	generate `var'_low = `var'
	replace `var'_low = 1 if `var' == 0 & u_`var' < p_01_low
	replace `var'_low = 0 if `var' == 1 & u_`var' < p_10_low
	
	generate `var'_high = `var'
	replace `var'_high = 1 if `var' == 0 & u_`var' < p_01_high
	replace `var'_high = 0 if `var' == 1 & u_`var' < p_10_high
}

keep hid mun_id psu_id water_improved_* electri_* sewage_* own_house_* good_toilet_* good_house_* good_street_* micro_* radio_* tele_* fridge_* washing_* auto_* compu_* cell_* AC_* factor_hh over_crowding_* over_crowding_ext_*

saveold "2000\full_census\error_data\viv\variables_errors_viv_`i'", replace
restore
}

/*===============================================================
*** Merginf variables with error with samples
===============================================================*/
forvalues i=1(1)100 {
use "2000\full_census\error_data\ind\variables_errors_ind_`i'", clear
merge 1:1 hid using "2000\full_census\error_data\viv\variables_errors_viv_`i'"
keep if _merge==3
drop _merge
save "2000\full_census\rawsamples_error\sample_`i'.dta", replace
}



