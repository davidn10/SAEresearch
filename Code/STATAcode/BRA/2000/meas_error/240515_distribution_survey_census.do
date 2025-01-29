* This one is the new brazil 2000 code for measurement error 
* cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"
cd "H:\david\SAE\SAE_research_with_Melany\BRA"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata00 "H:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global data00 "$currdata00\rawdata\"
global rawsamples00 "$currdata00\rawsamples_error\"
global census00 "$data00\census_proc_BRA_2000.dta"
global results "$currdata00\results\error\"


//global with candidate variables for unit level models
global myvar over_crowding over_crowding_ext water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC hhsize female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old hhsize2


set seed 648743

***In the census
use "$currdata00\census\census.dta", clear
keep psu_id mun_id hid $myvar  popwt 

putexcel set "$results\results_distrib\distribution_census_00", replace

foreach var in $myvar {
	reg `var'  [w=popwt], r cluster(mun_id)
	estadd ysumm
	local m_`var'=e(ymean)
	return list
	mat A=r(table)
	local b_`var'=A[1,1]
	local se_`var'=A[2,1]
	local t_`var'=A[5,1]
	local p_`var'=A[6,1]
}

putexcel B1="Mean"
putexcel C1="Mean (reg)"
putexcel D1="SE"
putexcel E1="LL"
putexcel F1="UL"
 

putexcel A2="Good street"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a micro"
putexcel A11="Has radio"
putexcel A12="Has TV"
putexcel A13="Has fridge"
putexcel A14="Has washing machine"
putexcel A15="Has auto"
putexcel A16="Has computer"
putexcel A17="Has phone"
putexcel A18="AC"
putexcel A19="Household size"
putexcel A20="Household size (squared)"
putexcel A21="Female household head"
putexcel A22="Age of hhead"
putexcel A23="Hhead with primary"
putexcel A24="Hhead with secondary"
putexcel A25="Hhead with superior"
putexcel A26="Share of individuals with primary"
putexcel A27="Share of individuals with secondary"
putexcel A28="Share of individuals with superior"
putexcel A29="Share of literate individuals"
putexcel A30="Share of individuals with no education"
putexcel A31="Child dependency ratio"
putexcel A32="Elderly dependency ratio"
putexcel A33="Good toilet"



putexcel B2=`m_good_street'
putexcel C2=`b_good_street'
putexcel D2=`se_good_street'
putexcel E2=`t_good_street'
putexcel F2=`p_good_street'

putexcel B3=`m_water_improved'
putexcel C3=`b_water_improved'
putexcel D3=`se_water_improved'
putexcel E3=`t_water_improved'
putexcel F3=`p_water_improved'

putexcel B4=`m_electri'
putexcel C4=`b_electri'
putexcel D4=`se_electri'
putexcel E4=`t_electri'
putexcel F4=`p_electri'

putexcel B5=`m_sewage'
putexcel C5=`b_sewage'
putexcel D5=`se_sewage'
putexcel E5=`t_sewage'
putexcel F5=`p_sewage'

putexcel B6=`m_own_house'
putexcel C6=`b_own_house'
putexcel D6=`se_own_house'
putexcel E6=`t_own_house'
putexcel F6=`p_own_house'

putexcel B7=`m_good_house'
putexcel C7=`b_good_house'
putexcel D7=`se_good_house'
putexcel E7=`t_good_house'
putexcel F7=`p_good_house'

putexcel B8=`m_over_crowding'
putexcel C8=`b_over_crowding'
putexcel D8=`se_over_crowding'
putexcel E8=`t_over_crowding'
putexcel F8=`p_over_crowding'

putexcel B9=`m_over_crowding_ext'
putexcel C9=`b_over_crowding_ext'
putexcel D9=`se_over_crowding_ext'
putexcel E9=`t_over_crowding_ext'
putexcel F9=`p_over_crowding_ext'

putexcel B10=`m_micro'
putexcel C10=`b_micro'
putexcel D10=`se_micro'
putexcel E10=`t_micro'
putexcel F10=`p_micro'

putexcel B11=`m_radio'
putexcel C11=`b_radio'
putexcel D11=`se_radio'
putexcel E11=`t_radio'
putexcel F11=`p_radio'

putexcel B12=`m_tele'
putexcel C12=`b_tele'
putexcel D12=`se_tele'
putexcel E12=`t_tele'
putexcel F12=`p_tele'

putexcel B13=`m_fridge'
putexcel C13=`b_fridge'
putexcel D13=`se_fridge'
putexcel E13=`t_fridge'
putexcel F13=`p_fridge'

putexcel B14=`m_washing'
putexcel C14=`b_washing'
putexcel D14=`se_washing'
putexcel E14=`t_washing'
putexcel F14=`p_washing'

putexcel B15=`m_auto'
putexcel C15=`b_auto'
putexcel D15=`se_auto'
putexcel E15=`t_auto'
putexcel F15=`p_auto'

putexcel B16=`m_compu'
putexcel C16=`b_compu'
putexcel D16=`se_compu'
putexcel E16=`t_compu'
putexcel F16=`p_compu'

putexcel B17=`m_cell'
putexcel C17=`b_cell'
putexcel D17=`se_cell'
putexcel E17=`t_cell'
putexcel F17=`p_cell'

putexcel B18=`m_AC'
putexcel C18=`b_AC'
putexcel D18=`se_AC'
putexcel E18=`t_AC'
putexcel F18=`p_AC'

putexcel B19=`m_hhsize'
putexcel C19=`b_hhsize'
putexcel D19=`se_hhsize'
putexcel E19=`t_hhsize'
putexcel F19=`p_hhsize'

putexcel B20=`m_hhsize2'
putexcel C20=`b_hhsize2'
putexcel D20=`se_hhsize2'
putexcel E20=`t_hhsize2'
putexcel F20=`p_hhsize2'

putexcel B21=`m_female_hh'
putexcel C21=`b_female_hh'
putexcel D21=`se_female_hh'
putexcel E21=`t_female_hh'
putexcel F21=`p_female_hh'

putexcel B22=`m_age_hh'
putexcel C22=`b_age_hh'
putexcel D22=`se_age_hh'
putexcel E22=`t_age_hh'
putexcel F22=`p_age_hh'

putexcel B23=`m_hh_primedu'
putexcel C23=`b_hh_primedu'
putexcel D23=`se_hh_primedu'
putexcel E23=`t_hh_primedu'
putexcel F23=`p_hh_primedu'

putexcel B24=`m_hh_secondedu'
putexcel C24=`b_hh_secondedu'
putexcel D24=`se_hh_secondedu'
putexcel E24=`t_hh_secondedu'
putexcel F24=`p_hh_secondedu'

putexcel B25=`m_hh_superior'
putexcel C25=`b_hh_superior'
putexcel D25=`se_hh_superior'
putexcel E25=`t_hh_superior'
putexcel F25=`p_hh_superior'

putexcel B26=`m_sh_primedu'
putexcel C26=`b_sh_primedu'
putexcel D26=`se_sh_primedu'
putexcel E25=`t_sh_primedu'
putexcel F26=`p_sh_primedu'

putexcel B27=`m_sh_secedu'
putexcel C27=`b_sh_secedu'
putexcel D27=`se_sh_secedu'
putexcel E27=`t_sh_secedu'
putexcel F27=`p_sh_secedu'

putexcel B28=`m_sh_supedu'
putexcel C28=`b_sh_supedu'
putexcel D28=`se_sh_supedu'
putexcel E28=`t_sh_supedu'
putexcel F28=`p_sh_supedu'

putexcel B29=`m_sh_literate'
putexcel C29=`b_sh_literate'
putexcel D29=`se_sh_literate'
putexcel E29=`t_sh_literate'
putexcel F29=`p_sh_literate'

putexcel B30=`m_sh_noedu'
putexcel C30=`b_sh_noedu'
putexcel D30=`se_sh_noedu'
putexcel E30=`t_sh_noedu'
putexcel F30=`p_sh_noedu'

putexcel B31=`m_depen_ch'
putexcel C31=`b_depen_ch'
putexcel D31=`se_depen_ch'
putexcel E31=`t_depen_ch'
putexcel F31=`p_depen_ch'

putexcel B32=`m_depen_old'
putexcel C32=`b_depen_old'
putexcel D32=`se_depen_old'
putexcel E32=`t_depen_old'
putexcel F32=`p_depen_old'

putexcel B33=`m_good_toilet'
putexcel C33=`b_good_toilet'
putexcel D33=`se_good_toilet'
putexcel E33=`t_good_toilet'
putexcel F33=`p_good_toilet'


putexcel G2="good_street"
putexcel G3="water_improved"
putexcel G4="electri"
putexcel G5="sewage"
putexcel G6="own_house"
putexcel G7="good_house"
putexcel G8="over_crowding"
putexcel G9="over_crowding_ext"
putexcel G10="micro"
putexcel G11="radio"
putexcel G12="tele"
putexcel G13="fridge"
putexcel G14="washing"
putexcel G15="auto"
putexcel G16="compu"
putexcel G17="cell"
putexcel G18="AC"
putexcel G19="hhsize"
putexcel G20="hhsize2"
putexcel G21="female_hh"
putexcel G22="age_hh"
putexcel G23="hh_primedu"
putexcel G24="hh_secondedu"
putexcel G25="hh_superior"
putexcel G26="sh_primedu"
putexcel G27="sh_secedu"
putexcel G28="sh_supedu"
putexcel G29="sh_literate"  
putexcel G30="sh_noedu"    
putexcel G31="depen_ch"
putexcel G32="depen_old"
putexcel G33="good_toilet"    

*** High measurement error scenario
***Getting samples 2000
forvalues i=1(1)100 {
use "$rawsamples00\sample_`i'.dta", clear
drop over_crowding_ext 
*rename hh_primedu_low primedu_low 
*rename hh_primedu_high primedu_high
*rename hh_secondedu_low secondedu_low 
*rename hh_secondedu_high secondedu_high
*rename hh_superior_low superior_low 
*rename hh_superior_high superior_high
gen FACTOR=factor_hh*hhsize 

drop *_low

foreach var in  age_hh depen_ch depen_old sh_primedu sh_secedu sh_supedu sh_noedu sh_literate female_hh water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC over_crowding over_crowding_ext {  
	rename `var'_high `var'
}

merge 1:1 hid using "$currdata00\census\census.dta", keepusing(hhsize hhsize2)
keep if _merge==3
keep psu_id mun_id hid $myvar weights FACTOR 


putexcel set "$results\results_distrib\distribution_sample_high00_`i'", replace

	foreach var in $myvar {
	reg `var'  [w=FACTOR], r cluster(mun_id)
	estadd ysumm
	local m_`var'=e(ymean)
	return list
	mat A=r(table)
	local b_`var'=A[1,1]
	local se_`var'=A[2,1]
	local t_`var'=A[5,1]
	local p_`var'=A[6,1]
}



putexcel B1="Mean"
putexcel C1="Mean (reg)"
putexcel D1="SE"
putexcel E1="LL"
putexcel F1="UL"

putexcel A2="Good street"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a micro"
putexcel A11="Has radio"
putexcel A12="Has TV"
putexcel A13="Has fridge"
putexcel A14="Has washing machine"
putexcel A15="Has auto"
putexcel A16="Has computer"
putexcel A17="Has phone"
putexcel A18="AC"
putexcel A19="Household size"
putexcel A20="Household size (squared)"
putexcel A21="Female household head"
putexcel A22="Age of hhead"
putexcel A23="Hhead with primary"
putexcel A24="Hhead with secondary"
putexcel A25="Hhead with superior"
putexcel A26="Share of individuals with primary"
putexcel A27="Share of individuals with secondary"
putexcel A28="Share of individuals with superior"
putexcel A29="Share of literate individuals"
putexcel A30="Share of individuals with no education"
putexcel A31="Child dependency ratio"
putexcel A32="Elderly dependency ratio"
putexcel A33="Good toilet"

putexcel B2=`m_good_street'
putexcel C2=`b_good_street'
putexcel D2=`se_good_street'
putexcel E2=`t_good_street'
putexcel F2=`p_good_street'

putexcel B3=`m_water_improved'
putexcel C3=`b_water_improved'
putexcel D3=`se_water_improved'
putexcel E3=`t_water_improved'
putexcel F3=`p_water_improved'

putexcel B4=`m_electri'
putexcel C4=`b_electri'
putexcel D4=`se_electri'
putexcel E4=`t_electri'
putexcel F4=`p_electri'

putexcel B5=`m_sewage'
putexcel C5=`b_sewage'
putexcel D5=`se_sewage'
putexcel E5=`t_sewage'
putexcel F5=`p_sewage'

putexcel B6=`m_own_house'
putexcel C6=`b_own_house'
putexcel D6=`se_own_house'
putexcel E6=`t_own_house'
putexcel F6=`p_own_house'

putexcel B7=`m_good_house'
putexcel C7=`b_good_house'
putexcel D7=`se_good_house'
putexcel E7=`t_good_house'
putexcel F7=`p_good_house'

putexcel B8=`m_over_crowding'
putexcel C8=`b_over_crowding'
putexcel D8=`se_over_crowding'
putexcel E8=`t_over_crowding'
putexcel F8=`p_over_crowding'

putexcel B9=`m_over_crowding_ext'
putexcel C9=`b_over_crowding_ext'
putexcel D9=`se_over_crowding_ext'
putexcel E9=`t_over_crowding_ext'
putexcel F9=`p_over_crowding_ext'

putexcel B10=`m_micro'
putexcel C10=`b_micro'
putexcel D10=`se_micro'
putexcel E10=`t_micro'
putexcel F10=`p_micro'

putexcel B11=`m_radio'
putexcel C11=`b_radio'
putexcel D11=`se_radio'
putexcel E11=`t_radio'
putexcel F11=`p_radio'

putexcel B12=`m_tele'
putexcel C12=`b_tele'
putexcel D12=`se_tele'
putexcel E12=`t_tele'
putexcel F12=`p_tele'

putexcel B13=`m_fridge'
putexcel C13=`b_fridge'
putexcel D13=`se_fridge'
putexcel E13=`t_fridge'
putexcel F13=`p_fridge'

putexcel B14=`m_washing'
putexcel C14=`b_washing'
putexcel D14=`se_washing'
putexcel E14=`t_washing'
putexcel F14=`p_washing'

putexcel B15=`m_auto'
putexcel C15=`b_auto'
putexcel D15=`se_auto'
putexcel E15=`t_auto'
putexcel F15=`p_auto'

putexcel B16=`m_compu'
putexcel C16=`b_compu'
putexcel D16=`se_compu'
putexcel E16=`t_compu'
putexcel F16=`p_compu'

putexcel B17=`m_cell'
putexcel C17=`b_cell'
putexcel D17=`se_cell'
putexcel E17=`t_cell'
putexcel F17=`p_cell'

putexcel B18=`m_AC'
putexcel C18=`b_AC'
putexcel D18=`se_AC'
putexcel E18=`t_AC'
putexcel F18=`p_AC'

putexcel B19=`m_hhsize'
putexcel C19=`b_hhsize'
putexcel D19=`se_hhsize'
putexcel E19=`t_hhsize'
putexcel F19=`p_hhsize'

putexcel B20=`m_hhsize2'
putexcel C20=`b_hhsize2'
putexcel D20=`se_hhsize2'
putexcel E20=`t_hhsize2'
putexcel F20=`p_hhsize2'

putexcel B21=`m_female_hh'
putexcel C21=`b_female_hh'
putexcel D21=`se_female_hh'
putexcel E21=`t_female_hh'
putexcel F21=`p_female_hh'

putexcel B22=`m_age_hh'
putexcel C22=`b_age_hh'
putexcel D22=`se_age_hh'
putexcel E22=`t_age_hh'
putexcel F22=`p_age_hh'

putexcel B23=`m_hh_primedu'
putexcel C23=`b_hh_primedu'
putexcel D23=`se_hh_primedu'
putexcel E23=`t_hh_primedu'
putexcel F23=`p_hh_primedu'

putexcel B24=`m_hh_secondedu'
putexcel C24=`b_hh_secondedu'
putexcel D24=`se_hh_secondedu'
putexcel E24=`t_hh_secondedu'
putexcel F24=`p_hh_secondedu'

putexcel B25=`m_hh_superior'
putexcel C25=`b_hh_superior'
putexcel D25=`se_hh_superior'
putexcel E25=`t_hh_superior'
putexcel F25=`p_hh_superior'

putexcel B26=`m_sh_primedu'
putexcel C26=`b_sh_primedu'
putexcel D26=`se_sh_primedu'
putexcel E25=`t_sh_primedu'
putexcel F26=`p_sh_primedu'

putexcel B27=`m_sh_secedu'
putexcel C27=`b_sh_secedu'
putexcel D27=`se_sh_secedu'
putexcel E27=`t_sh_secedu'
putexcel F27=`p_sh_secedu'

putexcel B28=`m_sh_supedu'
putexcel C28=`b_sh_supedu'
putexcel D28=`se_sh_supedu'
putexcel E28=`t_sh_supedu'
putexcel F28=`p_sh_supedu'

putexcel B29=`m_sh_literate'
putexcel C29=`b_sh_literate'
putexcel D29=`se_sh_literate'
putexcel E29=`t_sh_literate'
putexcel F29=`p_sh_literate'

putexcel B30=`m_sh_noedu'
putexcel C30=`b_sh_noedu'
putexcel D30=`se_sh_noedu'
putexcel E30=`t_sh_noedu'
putexcel F30=`p_sh_noedu'

putexcel B31=`m_depen_ch'
putexcel C31=`b_depen_ch'
putexcel D31=`se_depen_ch'
putexcel E31=`t_depen_ch'
putexcel F31=`p_depen_ch'

putexcel B32=`m_depen_old'
putexcel C32=`b_depen_old'
putexcel D32=`se_depen_old'
putexcel E32=`t_depen_old'
putexcel F32=`p_depen_old'

putexcel B33=`m_good_toilet'
putexcel C33=`b_good_toilet'
putexcel D33=`se_good_toilet'
putexcel E33=`t_good_toilet'
putexcel F33=`p_good_toilet'


putexcel G2="good_street"
putexcel G3="water_improved"
putexcel G4="electri"
putexcel G5="sewage"
putexcel G6="own_house"
putexcel G7="good_house"
putexcel G8="over_crowding"
putexcel G9="over_crowding_ext"
putexcel G10="micro"
putexcel G11="radio"
putexcel G12="tele"
putexcel G13="fridge"
putexcel G14="washing"
putexcel G15="auto"
putexcel G16="compu"
putexcel G17="cell"
putexcel G18="AC"
putexcel G19="hhsize"
putexcel G20="hhsize2"
putexcel G21="female_hh"
putexcel G22="age_hh"
putexcel G23="hh_primedu"
putexcel G24="hh_secondedu"
putexcel G25="hh_superior"
putexcel G26="sh_primedu"
putexcel G27="sh_secedu"
putexcel G28="sh_supedu"
putexcel G29="sh_literate"  
putexcel G30="sh_noedu"    
putexcel G31="depen_ch"
putexcel G32="depen_old"
putexcel G33="good_toilet"
}


*** Preparing census
global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu


use "$currdata00\rawdata\census_proc_BRA_2000.dta", clear
g popwt=weights*hhsize
g hhsize2=hhsize*hhsize
g ln_pchinc=ln(pchinc)

tab nom_state, g(state_)


keep mun_id* psu_id hid* pchinc $myvar $myarea ln_pchinc popwt  state_* fgt0_m
tempfile census
save `census'

***Comparing census and surveys
putexcel set "$results\results_distrib\sample_size_high", replace

forvalues i=1(1)100 {
***Analyzing C.I.
import excel "$results\results_distrib\distribution_sample_high00_`i'.xlsx", sheet("Sheet1") firstrow clear
foreach x of var * { 
	rename `x' `x'_sur 
} 
rename A_sur A
tempfile survey
save `survey'

import excel "$results\results_distrib\distribution_census_00.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 A using `survey'

g check=1 if (LL_sur<=Meanreg & Meanreg<=UL_sur)

keep if (check==1 | G=="hhsize")
keep G 

***Store list of variables
levelsof G , local(vars)
foreach v in `vars'{
	g `v'=1
}
drop G
ds
local tokeep=r(varlist)
*di "`tokeep'"
global tokeep `tokeep'

***Generating samples with selected variables
use "$rawsamples00\sample_`i'.dta", clear


gen FACTOR=factor_hh*hhsize 

drop *_low
drop over_crowding_ext 
foreach var in hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu depen_ch depen_old female_hh sh_literate water_improved electri good_toilet sewage good_house good_street own_house radio tele fridge washing auto compu micro cell AC over_crowding over_crowding_ext {
	rename `var'_high `var'
}

merge 1:1 hid using `census'
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $tokeep $myarea ln_pchinc fgt0_m FACTOR state_* hhsize*

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''


save "$currdata00\rawsamples_error\selected_high\sample_`i'.dta", replace
}

*** Low measurement error scenario
***Getting samples 2000
forvalues i=1(1)100 {
use "$rawsamples00\sample_`i'.dta", clear
drop over_crowding_ext 
*rename hh_primedu_low primedu_low 
*rename hh_primedu_high primedu_high
*rename hh_secondedu_low secondedu_low 
*rename hh_secondedu_high secondedu_high
*rename hh_superior_low superior_low 
*rename hh_superior_high superior_high
gen FACTOR=factor_hh*hhsize 

drop *_high

foreach var in  age_hh depen_ch depen_old sh_primedu sh_secedu sh_supedu sh_noedu sh_literate female_hh water_improved electri sewage own_house good_toilet good_house good_street micro radio tele fridge washing auto compu cell AC over_crowding over_crowding_ext {  
	rename `var'_low `var'
}

merge 1:1 hid using "$currdata00\census\census.dta", keepusing(hhsize hhsize2)
keep if _merge==3
keep psu_id mun_id hid $myvar weights FACTOR 


putexcel set "$results\results_distrib\distribution_sample_low00_`i'", replace

	foreach var in $myvar {
	reg `var'  [w=FACTOR], r cluster(mun_id)
	estadd ysumm
	local m_`var'=e(ymean)
	return list
	mat A=r(table)
	local b_`var'=A[1,1]
	local se_`var'=A[2,1]
	local t_`var'=A[5,1]
	local p_`var'=A[6,1]
}



putexcel B1="Mean"
putexcel C1="Mean (reg)"
putexcel D1="SE"
putexcel E1="LL"
putexcel F1="UL"

putexcel A2="Good street"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a micro"
putexcel A11="Has radio"
putexcel A12="Has TV"
putexcel A13="Has fridge"
putexcel A14="Has washing machine"
putexcel A15="Has auto"
putexcel A16="Has computer"
putexcel A17="Has phone"
putexcel A18="AC"
putexcel A19="Household size"
putexcel A20="Household size (squared)"
putexcel A21="Female household head"
putexcel A22="Age of hhead"
putexcel A23="Hhead with primary"
putexcel A24="Hhead with secondary"
putexcel A25="Hhead with superior"
putexcel A26="Share of individuals with primary"
putexcel A27="Share of individuals with secondary"
putexcel A28="Share of individuals with superior"
putexcel A29="Share of literate individuals"
putexcel A30="Share of individuals with no education"
putexcel A31="Child dependency ratio"
putexcel A32="Elderly dependency ratio"
putexcel A33="Good toilet"

putexcel B2=`m_good_street'
putexcel C2=`b_good_street'
putexcel D2=`se_good_street'
putexcel E2=`t_good_street'
putexcel F2=`p_good_street'

putexcel B3=`m_water_improved'
putexcel C3=`b_water_improved'
putexcel D3=`se_water_improved'
putexcel E3=`t_water_improved'
putexcel F3=`p_water_improved'

putexcel B4=`m_electri'
putexcel C4=`b_electri'
putexcel D4=`se_electri'
putexcel E4=`t_electri'
putexcel F4=`p_electri'

putexcel B5=`m_sewage'
putexcel C5=`b_sewage'
putexcel D5=`se_sewage'
putexcel E5=`t_sewage'
putexcel F5=`p_sewage'

putexcel B6=`m_own_house'
putexcel C6=`b_own_house'
putexcel D6=`se_own_house'
putexcel E6=`t_own_house'
putexcel F6=`p_own_house'

putexcel B7=`m_good_house'
putexcel C7=`b_good_house'
putexcel D7=`se_good_house'
putexcel E7=`t_good_house'
putexcel F7=`p_good_house'

putexcel B8=`m_over_crowding'
putexcel C8=`b_over_crowding'
putexcel D8=`se_over_crowding'
putexcel E8=`t_over_crowding'
putexcel F8=`p_over_crowding'

putexcel B9=`m_over_crowding_ext'
putexcel C9=`b_over_crowding_ext'
putexcel D9=`se_over_crowding_ext'
putexcel E9=`t_over_crowding_ext'
putexcel F9=`p_over_crowding_ext'

putexcel B10=`m_micro'
putexcel C10=`b_micro'
putexcel D10=`se_micro'
putexcel E10=`t_micro'
putexcel F10=`p_micro'

putexcel B11=`m_radio'
putexcel C11=`b_radio'
putexcel D11=`se_radio'
putexcel E11=`t_radio'
putexcel F11=`p_radio'

putexcel B12=`m_tele'
putexcel C12=`b_tele'
putexcel D12=`se_tele'
putexcel E12=`t_tele'
putexcel F12=`p_tele'

putexcel B13=`m_fridge'
putexcel C13=`b_fridge'
putexcel D13=`se_fridge'
putexcel E13=`t_fridge'
putexcel F13=`p_fridge'

putexcel B14=`m_washing'
putexcel C14=`b_washing'
putexcel D14=`se_washing'
putexcel E14=`t_washing'
putexcel F14=`p_washing'

putexcel B15=`m_auto'
putexcel C15=`b_auto'
putexcel D15=`se_auto'
putexcel E15=`t_auto'
putexcel F15=`p_auto'

putexcel B16=`m_compu'
putexcel C16=`b_compu'
putexcel D16=`se_compu'
putexcel E16=`t_compu'
putexcel F16=`p_compu'

putexcel B17=`m_cell'
putexcel C17=`b_cell'
putexcel D17=`se_cell'
putexcel E17=`t_cell'
putexcel F17=`p_cell'

putexcel B18=`m_AC'
putexcel C18=`b_AC'
putexcel D18=`se_AC'
putexcel E18=`t_AC'
putexcel F18=`p_AC'

putexcel B19=`m_hhsize'
putexcel C19=`b_hhsize'
putexcel D19=`se_hhsize'
putexcel E19=`t_hhsize'
putexcel F19=`p_hhsize'

putexcel B20=`m_hhsize2'
putexcel C20=`b_hhsize2'
putexcel D20=`se_hhsize2'
putexcel E20=`t_hhsize2'
putexcel F20=`p_hhsize2'

putexcel B21=`m_female_hh'
putexcel C21=`b_female_hh'
putexcel D21=`se_female_hh'
putexcel E21=`t_female_hh'
putexcel F21=`p_female_hh'

putexcel B22=`m_age_hh'
putexcel C22=`b_age_hh'
putexcel D22=`se_age_hh'
putexcel E22=`t_age_hh'
putexcel F22=`p_age_hh'

putexcel B23=`m_hh_primedu'
putexcel C23=`b_hh_primedu'
putexcel D23=`se_hh_primedu'
putexcel E23=`t_hh_primedu'
putexcel F23=`p_hh_primedu'

putexcel B24=`m_hh_secondedu'
putexcel C24=`b_hh_secondedu'
putexcel D24=`se_hh_secondedu'
putexcel E24=`t_hh_secondedu'
putexcel F24=`p_hh_secondedu'

putexcel B25=`m_hh_superior'
putexcel C25=`b_hh_superior'
putexcel D25=`se_hh_superior'
putexcel E25=`t_hh_superior'
putexcel F25=`p_hh_superior'

putexcel B26=`m_sh_primedu'
putexcel C26=`b_sh_primedu'
putexcel D26=`se_sh_primedu'
putexcel E25=`t_sh_primedu'
putexcel F26=`p_sh_primedu'

putexcel B27=`m_sh_secedu'
putexcel C27=`b_sh_secedu'
putexcel D27=`se_sh_secedu'
putexcel E27=`t_sh_secedu'
putexcel F27=`p_sh_secedu'

putexcel B28=`m_sh_supedu'
putexcel C28=`b_sh_supedu'
putexcel D28=`se_sh_supedu'
putexcel E28=`t_sh_supedu'
putexcel F28=`p_sh_supedu'

putexcel B29=`m_sh_literate'
putexcel C29=`b_sh_literate'
putexcel D29=`se_sh_literate'
putexcel E29=`t_sh_literate'
putexcel F29=`p_sh_literate'

putexcel B30=`m_sh_noedu'
putexcel C30=`b_sh_noedu'
putexcel D30=`se_sh_noedu'
putexcel E30=`t_sh_noedu'
putexcel F30=`p_sh_noedu'

putexcel B31=`m_depen_ch'
putexcel C31=`b_depen_ch'
putexcel D31=`se_depen_ch'
putexcel E31=`t_depen_ch'
putexcel F31=`p_depen_ch'

putexcel B32=`m_depen_old'
putexcel C32=`b_depen_old'
putexcel D32=`se_depen_old'
putexcel E32=`t_depen_old'
putexcel F32=`p_depen_old'

putexcel B33=`m_good_toilet'
putexcel C33=`b_good_toilet'
putexcel D33=`se_good_toilet'
putexcel E33=`t_good_toilet'
putexcel F33=`p_good_toilet'


putexcel G2="good_street"
putexcel G3="water_improved"
putexcel G4="electri"
putexcel G5="sewage"
putexcel G6="own_house"
putexcel G7="good_house"
putexcel G8="over_crowding"
putexcel G9="over_crowding_ext"
putexcel G10="micro"
putexcel G11="radio"
putexcel G12="tele"
putexcel G13="fridge"
putexcel G14="washing"
putexcel G15="auto"
putexcel G16="compu"
putexcel G17="cell"
putexcel G18="AC"
putexcel G19="hhsize"
putexcel G20="hhsize2"
putexcel G21="female_hh"
putexcel G22="age_hh"
putexcel G23="hh_primedu"
putexcel G24="hh_secondedu"
putexcel G25="hh_superior"
putexcel G26="sh_primedu"
putexcel G27="sh_secedu"
putexcel G28="sh_supedu"
putexcel G29="sh_literate"  
putexcel G30="sh_noedu"    
putexcel G31="depen_ch"
putexcel G32="depen_old"
putexcel G33="good_toilet"
}


*** Preparing census
global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu


use "$currdata00\rawdata\census_proc_BRA_2000.dta", clear
g popwt=weights*hhsize
g hhsize2=hhsize*hhsize
g ln_pchinc=ln(pchinc)

tab nom_state, g(state_)


keep mun_id* psu_id hid* pchinc $myvar $myarea ln_pchinc popwt  state_* fgt0_m
tempfile census
save `census'

***Comparing census and surveys
putexcel set "$results\results_distrib\sample_size_low", replace

forvalues i=1(1)100 {
***Analyzing C.I.
import excel "$results\results_distrib\distribution_sample_low00_`i'.xlsx", sheet("Sheet1") firstrow clear
foreach x of var * { 
	rename `x' `x'_sur 
} 
rename A_sur A
tempfile survey
save `survey'

import excel "$results\results_distrib\distribution_census_00.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 A using `survey'

g check=1 if (LL_sur<=Meanreg & Meanreg<=UL_sur)

keep if (check==1 | G=="hhsize")
keep G 

***Store list of variables
levelsof G , local(vars)
foreach v in `vars'{
	g `v'=1
}
drop G
ds
local tokeep=r(varlist)
*di "`tokeep'"
global tokeep `tokeep'

***Generating samples with selected variables
use "$rawsamples00\sample_`i'.dta", clear


gen FACTOR=factor_hh*hhsize 

drop *_high 
drop over_crowding_ext 
foreach var in hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu depen_ch depen_old female_hh sh_literate water_improved electri good_toilet sewage good_house good_street own_house radio tele fridge washing auto compu micro cell AC over_crowding over_crowding_ext {
	rename `var'_low `var'
}

merge 1:1 hid using `census'
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $tokeep $myarea ln_pchinc fgt0_m FACTOR state_* hhsize*

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''


save "$currdata00\rawsamples_error\selected_low\sample_`i'.dta", replace
}



