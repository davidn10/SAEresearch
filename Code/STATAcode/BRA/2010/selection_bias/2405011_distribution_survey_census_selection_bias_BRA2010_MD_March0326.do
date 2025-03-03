
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
* global currdata10 "D:\SAE_project\BRA\BRA_2010\2010\full_census_new"
*global currdata10 "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"
global currdata10 "C:\DavidNewhouse2024\BRA\2010\full_census"
global data10 "$currdata10\rawdata\"
global samplesbias11b11 "$currdata10\rawsamples_bias\bias11b11"
global samplesnobias "$currdata10\rawsamples_bias\nobias"
global census10 "$data10\census_proc_BRA_2010.dta"
global simcensus "$currdata10\simcensus\"
global results "$currdata10\results\bias\results_distrib"



//global with candidate variables for unit level models
/*
global myvar wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old  
*/
global myvar over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet urban hhsize hhsize2  female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old 

set seed 648743

use $census10, clear

***Correct weights
g popwt=weights*hhsize

***Logaritm of per capita income
g ln_pchinc=ln(pchinc)

***Squared household size
g hhsize2=hhsize*hhsize

***Generate state dummy variables
tab nom_state, g(state_)

encode (state), gen(state_n)
drop state
rename state_n state


keep $myvar popwt mun_id* hid* pchinc ln_pchinc  fgt* state* psu_id* *_mun *_psu
save "$currdata10\census\census.dta", replace

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensus\true_fg0_full.dta", replace

***In the census
use "$currdata10\census\census.dta", clear
keep psu_id* mun_id*  hid* pchinc $myvar ln_pchinc state* *_mun popwt *_psu


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
*drop if size_mun<8

saveold "$currdata10\census\census_bias.dta", replace

putexcel set "$results\distribution_census_10", replace

foreach var in $myvar {
	reg `var'  [w=popwt] if size_mun>=10, r cluster(mun_id)
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


putexcel A2="Improved walls"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a motocycle"
putexcel A11="Has radio"
putexcel A12="Has TV"
putexcel A13="Has fridge"
putexcel A14="Has washing machine"
putexcel A15="Has auto"
putexcel A16="Has computer"
putexcel A17="Has cellphone"
putexcel A18="Has internet"
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



putexcel B2=`m_wall_improved'
putexcel C2=`b_wall_improved'
putexcel D2=`se_wall_improved'
putexcel E2=`t_wall_improved'
putexcel F2=`p_wall_improved'

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

putexcel B10=`m_motorcy'
putexcel C10=`b_motorcy'
putexcel D10=`se_motorcy'
putexcel E10=`t_motorcy'
putexcel F10=`p_motorcy'

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

putexcel B18=`m_internet'
putexcel C18=`b_internet'
putexcel D18=`se_internet'
putexcel E18=`t_internet'
putexcel F18=`p_internet'

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




putexcel G2="wall_improved"
putexcel G3="water_improved"
putexcel G4="electri"
putexcel G5="sewage"
putexcel G6="own_house"
putexcel G7="good_house"
putexcel G8="over_crowding"
putexcel G9="over_crowding_ext"
putexcel G10="motorcy"
putexcel G11="radio"
putexcel G12="tele"
putexcel G13="fridge"
putexcel G14="washing"
putexcel G15="auto"
putexcel G16="compu"
putexcel G17="cell"
putexcel G18="internet"
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



***Biased samples version2
forvalues i=1(1)100{
use "$samplesbias11b11\sample_bias_`i'.dta", clear
*merge 1:1 hid using "$currdata10\census\census.dta"

merge 1:1 hid using $census10, force
gen hhsize2=hhsize^2 
keep if _merge==3
keep psu_id* mun_id*  hid* pchinc $myvar weights


putexcel set "$results\distribution_bias11b11_sample10_`i'", replace

	foreach var in $myvar {
	reg `var'  [w=weights], r cluster(mun_id)
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


putexcel A2="Improved walls"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a motocycle"
putexcel A11="Has radio"
putexcel A12="Has TV"
putexcel A13="Has fridge"
putexcel A14="Has washing machine"
putexcel A15="Has auto"
putexcel A16="Has computer"
putexcel A17="Has cellphone"
putexcel A18="Has internet"
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


putexcel B2=`m_wall_improved'
putexcel C2=`b_wall_improved'
putexcel D2=`se_wall_improved'
putexcel E2=`t_wall_improved'
putexcel F2=`p_wall_improved'

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

putexcel B10=`m_motorcy'
putexcel C10=`b_motorcy'
putexcel D10=`se_motorcy'
putexcel E10=`t_motorcy'
putexcel F10=`p_motorcy'

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

putexcel B18=`m_internet'
putexcel C18=`b_internet'
putexcel D18=`se_internet'
putexcel E18=`t_internet'
putexcel F18=`p_internet'

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

putexcel G2="wall_improved"
putexcel G3="water_improved"
putexcel G4="electri"
putexcel G5="sewage"
putexcel G6="own_house"
putexcel G7="good_house"
putexcel G8="over_crowding"
putexcel G9="over_crowding_ext"
putexcel G10="motorcy"
putexcel G11="radio"
putexcel G12="tele"
putexcel G13="fridge"
putexcel G14="washing"
putexcel G15="auto"
putexcel G16="compu"
putexcel G17="cell"
putexcel G18="internet"
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

     
}




***Unbiased samples
forvalues i=1(1)100{
use "$samplesnobias\sample_nobias_`i'.dta", clear
*merge 1:1 hid using "$currdata10\census\census.dta"
merge 1:1 hid using $census10, force
gen hhsize2=hhsize^2 
keep if _merge==3
keep psu_id* mun_id*  hid* pchinc $myvar weights  


putexcel set "$results\distribution_nobias_sample10_`i'", replace

	foreach var in $myvar {
	reg `var'  [w=weights], r cluster(mun_id)
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


putexcel A2="Improved walls"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a motocycle"
putexcel A11="Has radio"
putexcel A12="Has TV"
putexcel A13="Has fridge"
putexcel A14="Has washing machine"
putexcel A15="Has auto"
putexcel A16="Has computer"
putexcel A17="Has cellphone"
putexcel A18="Has internet"
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


putexcel B2=`m_wall_improved'
putexcel C2=`b_wall_improved'
putexcel D2=`se_wall_improved'
putexcel E2=`t_wall_improved'
putexcel F2=`p_wall_improved'

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

putexcel B10=`m_motorcy'
putexcel C10=`b_motorcy'
putexcel D10=`se_motorcy'
putexcel E10=`t_motorcy'
putexcel F10=`p_motorcy'

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

putexcel B18=`m_internet'
putexcel C18=`b_internet'
putexcel D18=`se_internet'
putexcel E18=`t_internet'
putexcel F18=`p_internet'

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

putexcel G2="wall_improved"
putexcel G3="water_improved"
putexcel G4="electri"
putexcel G5="sewage"
putexcel G6="own_house"
putexcel G7="good_house"
putexcel G8="over_crowding"
putexcel G9="over_crowding_ext"
putexcel G10="motorcy"
putexcel G11="radio"
putexcel G12="tele"
putexcel G13="fridge"
putexcel G14="washing"
putexcel G15="auto"
putexcel G16="compu"
putexcel G17="cell"
putexcel G18="internet"
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

     
}



***Biased2
putexcel set "$results\sample_size_bias11b11", replace

/*
global myarea aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu
*/

global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu water_improved_psu electri_psu sewage_psu own_house_psu good_house_psu over_crowding_psu over_crowding_ext_psu motorcy_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu



forvalues i=1(1)100{
***Analyzing C.I.
import excel "$results\distribution_bias11b11_sample10_`i'.xlsx", sheet("Sheet1") firstrow clear
foreach x of var * { 
	rename `x' `x'_sur 
} 
rename A_sur A
tempfile survey
save `survey'

import excel "$results\distribution_census_10.xlsx", sheet("Sheet1") firstrow clear

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
use "$samplesbias11b11\sample_bias_`i'.dta", clear
*merge 1:1 hid using "$currdata10\census\census.dta"
merge 1:1 hid using $census10, force
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $tokeep $myarea povline* fgt* weights FACTOR_res FACTOR_res2 state hhsize*

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''


save "$samplesbias11b11\selected\sample_`i'.dta", replace
}


***Unbiased
putexcel set "$results\sample_size_nobias", replace

global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun over_crowding_mun over_crowding_ext_mun motorcy_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu water_improved_psu electri_psu sewage_psu own_house_psu good_house_psu over_crowding_psu over_crowding_ext_psu motorcy_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu


forvalues i=1(1)100{
***Analyzing C.I.
import excel "$results\distribution_nobias_sample10_`i'.xlsx", sheet("Sheet1") firstrow clear
foreach x of var * { 
	rename `x' `x'_sur 
} 
rename A_sur A
tempfile survey
save `survey'

import excel "$results\distribution_census_10.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 A using `survey'

g check=1 if (LL_sur<=Meanreg & Meanreg<=UL_sur)

keep if (check==1 | G=="hhsize")
keep G 
replace G="compu" if G=="computer" 

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
use "$samplesnobias\sample_nobias_`i'.dta", clear
*merge 1:1 hid using "$currdata10\census\census.dta"
merge 1:1 hid using $census10, force
keep if _merge==3
gen hhsize2=hhsize^2 

keep psu_id* mun_id*  hid* pchinc $tokeep $myarea povline* fgt* weights FACTOR_res FACTOR_res2 state hhsize*

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''


save "$samplesnobias\selected\sample_`i'.dta", replace
}




