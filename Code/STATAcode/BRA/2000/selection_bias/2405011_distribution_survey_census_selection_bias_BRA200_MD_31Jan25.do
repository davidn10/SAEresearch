
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\SAE_project\BRA\BRA_2000\2000\full_census"
global data "$currdata\rawdata\"
global samplesbias11b11 "$currdata\rawsamples_bias\bias11b11"
global samplesnobias "$currdata\rawsamples_bias\nobias"
global census "$data\census_proc_BRA_2000.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results\bias\results_distrib"

//global with candidate variables for unit level models

global myvar water_improved own_house good_toilet good_house electri good_street sewage over_crowding over_crowding_ext micro radio tele fridge washing auto compu cell AC hhsize hhsize2 depen_ch depen_old  female_hh age_hh sh_noedu sh_primedu sh_secedu  sh_supedu sh_literate hh_primedu hh_secondedu hh_superior

set seed 648743

use $census, clear

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
save "$currdata\census\census.dta", replace

***True poverty rates in census indicators
collapse (mean) fgt0 fgt1 fgt2 fgt0_m fgt1_m fgt2_m [pw=popwt], by(mun_id)
save "$simcensus\true_fg0_full.dta", replace


***In the census
use "$currdata\census\census.dta", clear
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

saveold "$currdata\census\census_bias.dta", replace

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


putexcel A2="Improved water"
putexcel A3="Own a house"
putexcel A4="Good toilet"
putexcel A5="Good house"
putexcel A6="Access to electricity"
putexcel A7="Good street"
putexcel A8="Access to sewage"
putexcel A9="Over crowding"
putexcel A10="Over crowding extreme"
putexcel A11="Has a microwave"
putexcel A12="Has a radio"
putexcel A13="Has a telephone"
putexcel A14="Has fridge"
putexcel A15="Has washing machine"
putexcel A16="Has auto"
putexcel A17="Has computer"
putexcel A18="Has cellphone"
putexcel A19="Has Air conditioner"


putexcel A20="Household size"
putexcel A21="Household size (squared)"
putexcel A22="Child dependency ratio"
putexcel A23="Elderly dependency ratio"
putexcel A24="Female household head"
putexcel A25="Age of hhead"
putexcel A26="Share of individuals with no educ."
putexcel A27="Share of individuals with primary educ."
putexcel A28="Share of individuals with secondary educ."
putexcel A29="Share of individuals with SUP educ."
putexcel A30="Share of literate individuals"

putexcel A31="Hhead with primary"
putexcel A32="Hhead with secondary"
putexcel A33="Hhead with superior"


putexcel B2=`m_water_improved'
putexcel C2=`b_water_improved'
putexcel D2=`se_water_improved'
putexcel E2=`t_water_improved'
putexcel F2=`p_water_improved'

putexcel B3=`m_own_house'
putexcel C3=`b_own_house'
putexcel D3=`se_own_house'
putexcel E3=`t_own_house'
putexcel F3=`p_own_house'

putexcel B4=`m_good_toilet'
putexcel C4=`b_good_toilet'
putexcel D4=`se_good_toilet'
putexcel E4=`t_good_toilet'
putexcel F4=`p_good_toilet'


putexcel B5=`m_good_house'
putexcel C5=`b_good_house'
putexcel D5=`se_good_house'
putexcel E5=`t_good_house'
putexcel F5=`p_good_house'

putexcel B6=`m_electri'
putexcel C6=`b_electri'
putexcel D6=`se_electri'
putexcel E6=`t_electri'
putexcel F6=`p_electri'

putexcel B7=`m_good_street'
putexcel C7=`b_good_street'
putexcel D7=`se_good_street'
putexcel E7=`t_good_street'
putexcel F7=`p_good_street'

putexcel B8=`m_sewage'
putexcel C8=`b_sewage'
putexcel D8=`se_sewage'
putexcel E8=`t_sewage'
putexcel F8=`p_sewage'


putexcel B9=`m_over_crowding'
putexcel C9=`b_over_crowding'
putexcel D9=`se_over_crowding'
putexcel E9=`t_over_crowding'
putexcel F9=`p_over_crowding'

putexcel B10=`m_over_crowding_ext'
putexcel C10=`b_over_crowding_ext'
putexcel D10=`se_over_crowding_ext'
putexcel E10=`t_over_crowding_ext'
putexcel F10=`p_over_crowding_ext'

putexcel B11=`m_micro'
putexcel C11=`b_micro'
putexcel D11=`se_micro'
putexcel E11=`t_micro'
putexcel F11=`p_micro'


putexcel B12=`m_radio'
putexcel C12=`b_radio'
putexcel D12=`se_radio'
putexcel E12=`t_radio'
putexcel F12=`p_radio'

putexcel B13=`m_tele'
putexcel C13=`b_tele'
putexcel D13=`se_tele'
putexcel E13=`t_tele'
putexcel F13=`p_tele'

putexcel B14=`m_fridge'
putexcel C14=`b_fridge'
putexcel D14=`se_fridge'
putexcel E14=`t_fridge'
putexcel F14=`p_fridge'

putexcel B15=`m_washing'
putexcel C15=`b_washing'
putexcel D15=`se_washing'
putexcel E15=`t_washing'
putexcel F15=`p_washing'

putexcel B16=`m_auto'
putexcel C16=`b_auto'
putexcel D16=`se_auto'
putexcel E16=`t_auto'
putexcel F16=`p_auto'

putexcel B17=`m_compu'
putexcel C17=`b_compu'
putexcel D17=`se_compu'
putexcel E17=`t_compu'
putexcel F17=`p_compu'

putexcel B18=`m_cell'
putexcel C18=`b_cell'
putexcel D18=`se_cell'
putexcel E18=`t_cell'
putexcel F18=`p_cell'

putexcel B19=`m_AC'
putexcel C19=`b_AC'
putexcel D19=`se_AC'
putexcel E19=`t_AC'
putexcel F19=`p_AC'

putexcel B20=`m_hhsize'
putexcel C20=`b_hhsize'
putexcel D20=`se_hhsize'
putexcel E20=`t_hhsize'
putexcel F20=`p_hhsize'

putexcel B21=`m_hhsize2'
putexcel C21=`b_hhsize2'
putexcel D21=`se_hhsize2'
putexcel E21=`t_hhsize2'
putexcel F21=`p_hhsize2'


putexcel B22=`m_depen_ch'
putexcel C22=`b_depen_ch'
putexcel D22=`se_depen_ch'
putexcel E22=`t_depen_ch'
putexcel F22=`p_depen_ch'

putexcel B23=`m_depen_old'
putexcel C23=`b_depen_old'
putexcel D23=`se_depen_old'
putexcel E23=`t_depen_old'
putexcel F23=`p_depen_old'

putexcel B24=`m_female_hh'
putexcel C24=`b_female_hh'
putexcel D24=`se_female_hh'
putexcel E24=`t_female_hh'
putexcel F24=`p_female_hh'


putexcel B25=`m_age_hh'
putexcel C25=`b_age_hh'
putexcel D25=`se_age_hh'
putexcel E25=`t_age_hh'
putexcel F25=`p_age_hh'

putexcel B26=`m_sh_noedu'
putexcel C26=`b_sh_noedu'
putexcel D26=`se_sh_noedu'
putexcel E26=`t_sh_noedu'
putexcel F26=`p_sh_noedu'

putexcel B27=`m_sh_primedu'
putexcel C27=`b_sh_primedu'
putexcel D27=`se_sh_primedu'
putexcel E27=`t_sh_primedu'
putexcel F27=`p_sh_primedu'

putexcel B28=`m_sh_secedu'
putexcel C28=`b_sh_secedu'
putexcel D28=`se_sh_secedu'
putexcel E28=`t_sh_secedu'
putexcel F28=`p_sh_secedu'

putexcel B29=`m_sh_supedu'
putexcel C29=`b_sh_supedu'
putexcel D29=`se_sh_supedu'
putexcel E29=`t_sh_supedu'
putexcel F29=`p_sh_supedu'

putexcel B30=`m_sh_literate'
putexcel C30=`b_sh_literate'
putexcel D30=`se_sh_literate'
putexcel E30=`t_sh_literate'
putexcel F30=`p_sh_literate'

putexcel B31=`m_hh_primedu'
putexcel C31=`b_hh_primedu'
putexcel D31=`se_hh_primedu'
putexcel E31=`t_hh_primedu'
putexcel F31=`p_hh_primedu'

putexcel B32=`m_hh_secondedu'
putexcel C32=`b_hh_secondedu'
putexcel D32=`se_hh_secondedu'
putexcel E32=`t_hh_secondedu'
putexcel F32=`p_hh_secondedu'

putexcel B33=`m_hh_superior'
putexcel C33=`b_hh_superior'
putexcel D33=`se_hh_superior'
putexcel E33=`t_hh_superior'
putexcel F33=`p_hh_superior'

putexcel G2="water_improved"
putexcel G3="own_house"
putexcel G4="good_toilet"
putexcel G5="good_house"
putexcel G6="electri"
putexcel G7="good_street"
putexcel G8="sewage"
putexcel G9="over_crowding"
putexcel G10="over_crowding_ext"
putexcel G11="micro"
putexcel G12="radio"
putexcel G13="tele"
putexcel G14="fridge"
putexcel G15="washing"
putexcel G16="auto"
putexcel G17="compu"
putexcel G18="cell"
putexcel G19="AC"
putexcel G20="hhsize"
putexcel G21="hhsize2"
putexcel G22="depen_ch"
putexcel G23="depen_old"
putexcel G24="female_hh"
putexcel G25="age_hh"
putexcel G26="sh_noedu"
putexcel G27="sh_primedu"
putexcel G28="sh_secedu"
putexcel G29="sh_supedu"
putexcel G30="sh_literate"
putexcel G31="hh_primedu"
putexcel G32="hh_secondedu"
putexcel G33="hh_superior"


***Biased samples version2
forvalues i=1(1)100{
use "$samplesbias11b11\sample_bias_`i'.dta", clear
merge 1:1 hid using "$currdata\census\census.dta"
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



putexcel A2="Improved water"
putexcel A3="Own a house"
putexcel A4="Good toilet"
putexcel A5="Good house"
putexcel A6="Access to electricity"
putexcel A7="Good street"
putexcel A8="Access to sewage"
putexcel A9="Over crowding"
putexcel A10="Over crowding extreme"
putexcel A11="Has a microwave"
putexcel A12="Has a radio"
putexcel A13="Has a telephone"
putexcel A14="Has fridge"
putexcel A15="Has washing machine"
putexcel A16="Has auto"
putexcel A17="Has computer"
putexcel A18="Has cellphone"
putexcel A19="Has Air conditioner"


putexcel A20="Household size"
putexcel A21="Household size (squared)"
putexcel A22="Child dependency ratio"
putexcel A23="Elderly dependency ratio"
putexcel A24="Female household head"
putexcel A25="Age of hhead"
putexcel A26="Share of individuals with no educ."
putexcel A27="Share of individuals with primary educ."
putexcel A28="Share of individuals with secondary educ."
putexcel A29="Share of individuals with SUP educ."
putexcel A30="Share of literate individuals"

putexcel A31="Hhead with primary"
putexcel A32="Hhead with secondary"
putexcel A33="Hhead with superior"


putexcel B2=`m_water_improved'
putexcel C2=`b_water_improved'
putexcel D2=`se_water_improved'
putexcel E2=`t_water_improved'
putexcel F2=`p_water_improved'

putexcel B3=`m_own_house'
putexcel C3=`b_own_house'
putexcel D3=`se_own_house'
putexcel E3=`t_own_house'
putexcel F3=`p_own_house'

putexcel B4=`m_good_toilet'
putexcel C4=`b_good_toilet'
putexcel D4=`se_good_toilet'
putexcel E4=`t_good_toilet'
putexcel F4=`p_good_toilet'


putexcel B5=`m_good_house'
putexcel C5=`b_good_house'
putexcel D5=`se_good_house'
putexcel E5=`t_good_house'
putexcel F5=`p_good_house'

putexcel B6=`m_electri'
putexcel C6=`b_electri'
putexcel D6=`se_electri'
putexcel E6=`t_electri'
putexcel F6=`p_electri'

putexcel B7=`m_good_street'
putexcel C7=`b_good_street'
putexcel D7=`se_good_street'
putexcel E7=`t_good_street'
putexcel F7=`p_good_street'

putexcel B8=`m_sewage'
putexcel C8=`b_sewage'
putexcel D8=`se_sewage'
putexcel E8=`t_sewage'
putexcel F8=`p_sewage'


putexcel B9=`m_over_crowding'
putexcel C9=`b_over_crowding'
putexcel D9=`se_over_crowding'
putexcel E9=`t_over_crowding'
putexcel F9=`p_over_crowding'

putexcel B10=`m_over_crowding_ext'
putexcel C10=`b_over_crowding_ext'
putexcel D10=`se_over_crowding_ext'
putexcel E10=`t_over_crowding_ext'
putexcel F10=`p_over_crowding_ext'

putexcel B11=`m_micro'
putexcel C11=`b_micro'
putexcel D11=`se_micro'
putexcel E11=`t_micro'
putexcel F11=`p_micro'


putexcel B12=`m_radio'
putexcel C12=`b_radio'
putexcel D12=`se_radio'
putexcel E12=`t_radio'
putexcel F12=`p_radio'

putexcel B13=`m_tele'
putexcel C13=`b_tele'
putexcel D13=`se_tele'
putexcel E13=`t_tele'
putexcel F13=`p_tele'

putexcel B14=`m_fridge'
putexcel C14=`b_fridge'
putexcel D14=`se_fridge'
putexcel E14=`t_fridge'
putexcel F14=`p_fridge'

putexcel B15=`m_washing'
putexcel C15=`b_washing'
putexcel D15=`se_washing'
putexcel E15=`t_washing'
putexcel F15=`p_washing'

putexcel B16=`m_auto'
putexcel C16=`b_auto'
putexcel D16=`se_auto'
putexcel E16=`t_auto'
putexcel F16=`p_auto'

putexcel B17=`m_compu'
putexcel C17=`b_compu'
putexcel D17=`se_compu'
putexcel E17=`t_compu'
putexcel F17=`p_compu'

putexcel B18=`m_cell'
putexcel C18=`b_cell'
putexcel D18=`se_cell'
putexcel E18=`t_cell'
putexcel F18=`p_cell'

putexcel B19=`m_AC'
putexcel C19=`b_AC'
putexcel D19=`se_AC'
putexcel E19=`t_AC'
putexcel F19=`p_AC'

putexcel B20=`m_hhsize'
putexcel C20=`b_hhsize'
putexcel D20=`se_hhsize'
putexcel E20=`t_hhsize'
putexcel F20=`p_hhsize'

putexcel B21=`m_hhsize2'
putexcel C21=`b_hhsize2'
putexcel D21=`se_hhsize2'
putexcel E21=`t_hhsize2'
putexcel F21=`p_hhsize2'


putexcel B22=`m_depen_ch'
putexcel C22=`b_depen_ch'
putexcel D22=`se_depen_ch'
putexcel E22=`t_depen_ch'
putexcel F22=`p_depen_ch'

putexcel B23=`m_depen_old'
putexcel C23=`b_depen_old'
putexcel D23=`se_depen_old'
putexcel E23=`t_depen_old'
putexcel F23=`p_depen_old'

putexcel B24=`m_female_hh'
putexcel C24=`b_female_hh'
putexcel D24=`se_female_hh'
putexcel E24=`t_female_hh'
putexcel F24=`p_female_hh'


putexcel B25=`m_age_hh'
putexcel C25=`b_age_hh'
putexcel D25=`se_age_hh'
putexcel E25=`t_age_hh'
putexcel F25=`p_age_hh'

putexcel B26=`m_sh_noedu'
putexcel C26=`b_sh_noedu'
putexcel D26=`se_sh_noedu'
putexcel E26=`t_sh_noedu'
putexcel F26=`p_sh_noedu'

putexcel B27=`m_sh_primedu'
putexcel C27=`b_sh_primedu'
putexcel D27=`se_sh_primedu'
putexcel E27=`t_sh_primedu'
putexcel F27=`p_sh_primedu'

putexcel B28=`m_sh_secedu'
putexcel C28=`b_sh_secedu'
putexcel D28=`se_sh_secedu'
putexcel E28=`t_sh_secedu'
putexcel F28=`p_sh_secedu'

putexcel B29=`m_sh_supedu'
putexcel C29=`b_sh_supedu'
putexcel D29=`se_sh_supedu'
putexcel E29=`t_sh_supedu'
putexcel F29=`p_sh_supedu'

putexcel B30=`m_sh_literate'
putexcel C30=`b_sh_literate'
putexcel D30=`se_sh_literate'
putexcel E30=`t_sh_literate'
putexcel F30=`p_sh_literate'

putexcel B31=`m_hh_primedu'
putexcel C31=`b_hh_primedu'
putexcel D31=`se_hh_primedu'
putexcel E31=`t_hh_primedu'
putexcel F31=`p_hh_primedu'

putexcel B32=`m_hh_secondedu'
putexcel C32=`b_hh_secondedu'
putexcel D32=`se_hh_secondedu'
putexcel E32=`t_hh_secondedu'
putexcel F32=`p_hh_secondedu'

putexcel B33=`m_hh_superior'
putexcel C33=`b_hh_superior'
putexcel D33=`se_hh_superior'
putexcel E33=`t_hh_superior'
putexcel F33=`p_hh_superior'

putexcel G2="water_improved"
putexcel G3="own_house"
putexcel G4="good_toilet"
putexcel G5="good_house"
putexcel G6="electri"
putexcel G7="good_street"
putexcel G8="sewage"
putexcel G9="over_crowding"
putexcel G10="over_crowding_ext"
putexcel G11="micro"
putexcel G12="radio"
putexcel G13="tele"
putexcel G14="fridge"
putexcel G15="washing"
putexcel G16="auto"
putexcel G17="compu"
putexcel G18="cell"
putexcel G19="AC"
putexcel G20="hhsize"
putexcel G21="hhsize2"
putexcel G22="depen_ch"
putexcel G23="depen_old"
putexcel G24="female_hh"
putexcel G25="age_hh"
putexcel G26="sh_noedu"
putexcel G27="sh_primedu"
putexcel G28="sh_secedu"
putexcel G29="sh_supedu"
putexcel G30="sh_literate"
putexcel G31="hh_primedu"
putexcel G32="hh_secondedu"
putexcel G33="hh_superior"


     
}




***Unbiased samples
forvalues i=1(1)100{
use "$samplesnobias\sample_nobias_`i'.dta", clear
merge 1:1 hid using "$currdata\census\census.dta"
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



putexcel A2="Improved water"
putexcel A3="Own a house"
putexcel A4="Good toilet"
putexcel A5="Good house"
putexcel A6="Access to electricity"
putexcel A7="Good street"
putexcel A8="Access to sewage"
putexcel A9="Over crowding"
putexcel A10="Over crowding extreme"
putexcel A11="Has a microwave"
putexcel A12="Has a radio"
putexcel A13="Has a telephone"
putexcel A14="Has fridge"
putexcel A15="Has washing machine"
putexcel A16="Has auto"
putexcel A17="Has computer"
putexcel A18="Has cellphone"
putexcel A19="Has Air conditioner"


putexcel A20="Household size"
putexcel A21="Household size (squared)"
putexcel A22="Child dependency ratio"
putexcel A23="Elderly dependency ratio"
putexcel A24="Female household head"
putexcel A25="Age of hhead"
putexcel A26="Share of individuals with no educ."
putexcel A27="Share of individuals with primary educ."
putexcel A28="Share of individuals with secondary educ."
putexcel A29="Share of individuals with SUP educ."
putexcel A30="Share of literate individuals"

putexcel A31="Hhead with primary"
putexcel A32="Hhead with secondary"
putexcel A33="Hhead with superior"


putexcel B2=`m_water_improved'
putexcel C2=`b_water_improved'
putexcel D2=`se_water_improved'
putexcel E2=`t_water_improved'
putexcel F2=`p_water_improved'

putexcel B3=`m_own_house'
putexcel C3=`b_own_house'
putexcel D3=`se_own_house'
putexcel E3=`t_own_house'
putexcel F3=`p_own_house'

putexcel B4=`m_good_toilet'
putexcel C4=`b_good_toilet'
putexcel D4=`se_good_toilet'
putexcel E4=`t_good_toilet'
putexcel F4=`p_good_toilet'


putexcel B5=`m_good_house'
putexcel C5=`b_good_house'
putexcel D5=`se_good_house'
putexcel E5=`t_good_house'
putexcel F5=`p_good_house'

putexcel B6=`m_electri'
putexcel C6=`b_electri'
putexcel D6=`se_electri'
putexcel E6=`t_electri'
putexcel F6=`p_electri'

putexcel B7=`m_good_street'
putexcel C7=`b_good_street'
putexcel D7=`se_good_street'
putexcel E7=`t_good_street'
putexcel F7=`p_good_street'

putexcel B8=`m_sewage'
putexcel C8=`b_sewage'
putexcel D8=`se_sewage'
putexcel E8=`t_sewage'
putexcel F8=`p_sewage'


putexcel B9=`m_over_crowding'
putexcel C9=`b_over_crowding'
putexcel D9=`se_over_crowding'
putexcel E9=`t_over_crowding'
putexcel F9=`p_over_crowding'

putexcel B10=`m_over_crowding_ext'
putexcel C10=`b_over_crowding_ext'
putexcel D10=`se_over_crowding_ext'
putexcel E10=`t_over_crowding_ext'
putexcel F10=`p_over_crowding_ext'

putexcel B11=`m_micro'
putexcel C11=`b_micro'
putexcel D11=`se_micro'
putexcel E11=`t_micro'
putexcel F11=`p_micro'


putexcel B12=`m_radio'
putexcel C12=`b_radio'
putexcel D12=`se_radio'
putexcel E12=`t_radio'
putexcel F12=`p_radio'

putexcel B13=`m_tele'
putexcel C13=`b_tele'
putexcel D13=`se_tele'
putexcel E13=`t_tele'
putexcel F13=`p_tele'

putexcel B14=`m_fridge'
putexcel C14=`b_fridge'
putexcel D14=`se_fridge'
putexcel E14=`t_fridge'
putexcel F14=`p_fridge'

putexcel B15=`m_washing'
putexcel C15=`b_washing'
putexcel D15=`se_washing'
putexcel E15=`t_washing'
putexcel F15=`p_washing'

putexcel B16=`m_auto'
putexcel C16=`b_auto'
putexcel D16=`se_auto'
putexcel E16=`t_auto'
putexcel F16=`p_auto'

putexcel B17=`m_compu'
putexcel C17=`b_compu'
putexcel D17=`se_compu'
putexcel E17=`t_compu'
putexcel F17=`p_compu'

putexcel B18=`m_cell'
putexcel C18=`b_cell'
putexcel D18=`se_cell'
putexcel E18=`t_cell'
putexcel F18=`p_cell'

putexcel B19=`m_AC'
putexcel C19=`b_AC'
putexcel D19=`se_AC'
putexcel E19=`t_AC'
putexcel F19=`p_AC'

putexcel B20=`m_hhsize'
putexcel C20=`b_hhsize'
putexcel D20=`se_hhsize'
putexcel E20=`t_hhsize'
putexcel F20=`p_hhsize'

putexcel B21=`m_hhsize2'
putexcel C21=`b_hhsize2'
putexcel D21=`se_hhsize2'
putexcel E21=`t_hhsize2'
putexcel F21=`p_hhsize2'


putexcel B22=`m_depen_ch'
putexcel C22=`b_depen_ch'
putexcel D22=`se_depen_ch'
putexcel E22=`t_depen_ch'
putexcel F22=`p_depen_ch'

putexcel B23=`m_depen_old'
putexcel C23=`b_depen_old'
putexcel D23=`se_depen_old'
putexcel E23=`t_depen_old'
putexcel F23=`p_depen_old'

putexcel B24=`m_female_hh'
putexcel C24=`b_female_hh'
putexcel D24=`se_female_hh'
putexcel E24=`t_female_hh'
putexcel F24=`p_female_hh'


putexcel B25=`m_age_hh'
putexcel C25=`b_age_hh'
putexcel D25=`se_age_hh'
putexcel E25=`t_age_hh'
putexcel F25=`p_age_hh'

putexcel B26=`m_sh_noedu'
putexcel C26=`b_sh_noedu'
putexcel D26=`se_sh_noedu'
putexcel E26=`t_sh_noedu'
putexcel F26=`p_sh_noedu'

putexcel B27=`m_sh_primedu'
putexcel C27=`b_sh_primedu'
putexcel D27=`se_sh_primedu'
putexcel E27=`t_sh_primedu'
putexcel F27=`p_sh_primedu'

putexcel B28=`m_sh_secedu'
putexcel C28=`b_sh_secedu'
putexcel D28=`se_sh_secedu'
putexcel E28=`t_sh_secedu'
putexcel F28=`p_sh_secedu'

putexcel B29=`m_sh_supedu'
putexcel C29=`b_sh_supedu'
putexcel D29=`se_sh_supedu'
putexcel E29=`t_sh_supedu'
putexcel F29=`p_sh_supedu'

putexcel B30=`m_sh_literate'
putexcel C30=`b_sh_literate'
putexcel D30=`se_sh_literate'
putexcel E30=`t_sh_literate'
putexcel F30=`p_sh_literate'

putexcel B31=`m_hh_primedu'
putexcel C31=`b_hh_primedu'
putexcel D31=`se_hh_primedu'
putexcel E31=`t_hh_primedu'
putexcel F31=`p_hh_primedu'

putexcel B32=`m_hh_secondedu'
putexcel C32=`b_hh_secondedu'
putexcel D32=`se_hh_secondedu'
putexcel E32=`t_hh_secondedu'
putexcel F32=`p_hh_secondedu'

putexcel B33=`m_hh_superior'
putexcel C33=`b_hh_superior'
putexcel D33=`se_hh_superior'
putexcel E33=`t_hh_superior'
putexcel F33=`p_hh_superior'

putexcel G2="water_improved"
putexcel G3="own_house"
putexcel G4="good_toilet"
putexcel G5="good_house"
putexcel G6="electri"
putexcel G7="good_street"
putexcel G8="sewage"
putexcel G9="over_crowding"
putexcel G10="over_crowding_ext"
putexcel G11="micro"
putexcel G12="radio"
putexcel G13="tele"
putexcel G14="fridge"
putexcel G15="washing"
putexcel G16="auto"
putexcel G17="compu"
putexcel G18="cell"
putexcel G19="AC"
putexcel G20="hhsize"
putexcel G21="hhsize2"
putexcel G22="depen_ch"
putexcel G23="depen_old"
putexcel G24="female_hh"
putexcel G25="age_hh"
putexcel G26="sh_noedu"
putexcel G27="sh_primedu"
putexcel G28="sh_secedu"
putexcel G29="sh_supedu"
putexcel G30="sh_literate"
putexcel G31="hh_primedu"
putexcel G32="hh_secondedu"
putexcel G33="hh_superior"


     
}



***Biased2
putexcel set "$results\sample_size_bias11b11", replace



global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu


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
merge 1:1 hid using "$currdata\census\census.dta"
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc ln_pchinc $tokeep $myarea fgt* weights FACTOR_res FACTOR_res2 state* hhsize* 

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''


save "$samplesbias11b11\selected\sample_`i'.dta", replace
}


***Unbiased
putexcel set "$results\sample_size_nobias", replace

global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_toilet_mun good_house_mun good_street_mun micro_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun AC_mun over_crowding_mun over_crowding_ext_mun aux_sh_primedu_psu aux_sh_secedu_psu aux_sh_supedu_psu aux_sh_noedu_psu aux_sh_literate_psu unemp_psu informal_psu hhsize_psu hh_primedu_psu hh_secondedu_psu hh_superior_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu water_improved_psu electri_psu sewage_psu own_house_psu good_toilet_psu good_house_psu good_street_psu micro_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu AC_psu over_crowding_psu over_crowding_ext_psu

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
merge 1:1 hid using "$currdata\census\census.dta"

keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $tokeep $myarea ln_pchinc fgt* weights FACTOR_res FACTOR_res2 state* hhsize* 

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''


save "$samplesnobias\selected\sample_`i'.dta", replace
}




