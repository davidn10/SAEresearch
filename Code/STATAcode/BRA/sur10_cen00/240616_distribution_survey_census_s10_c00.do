clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata10 "H:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"
global data10 "$currdata10\rawdata\"
global rawsamples10 "$currdata10\rawsamples\"
global census10 "$data10\census_proc_BRA_2010.dta"

global currdata00 "H:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new"
global data00 "$currdata00\rawdata\"
global rawsamples00 "$currdata00\rawsamples_full\"
global census00 "$data00\census_proc_BRA_2000.dta"

global currdatas10c00 "H:\david\SAE\SAE_research_with_Melany\BRA\s10_c00\full_census"
global results "$currdatas10c00\results\results_distrib"

//global with candidate variables for unit level models
  
*** Common variables 2000 and 2010
global myvar over_crowding over_crowding_ext water_improved electri sewage own_house good_house radio tele fridge washing auto compu cell hhsize hhsize2  female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old   
 

set seed 648743

***In the census
use "$currdata00\census\census.dta", clear
keep psu_id* mun_id*  hid* pchinc $myvar ln_pchinc popwt state_*

putexcel set "$results\distribution_census_00", replace

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
 
putexcel A2="Improved water"
putexcel A3="Access to electricity"
putexcel A4="Access to sewage"
putexcel A5="Own a house"
putexcel A6="Good house"
putexcel A7="Over crowding"
putexcel A8="Over crowding extreme"
putexcel A9="Has radio"
putexcel A10="Has TV"
putexcel A11="Has fridge"
putexcel A12="Has washing machine"
putexcel A13="Has auto"
putexcel A14="Has computer"
putexcel A15="Has phone"
putexcel A16="Household size"
putexcel A17="Household size (squared)"
putexcel A18="Female household head"
putexcel A19="Age of hhead"
putexcel A20="Hhead with primary"
putexcel A21="Hhead with secondary"
putexcel A22="Hhead with superior"
putexcel A23="Share of individuals with primary"
putexcel A24="Share of individuals with secondary"
putexcel A25="Share of individuals with superior"
putexcel A26="Share of literate individuals"
putexcel A27="Share of individuals with no education"
putexcel A28="Child dependency ratio"
putexcel A29="Elderly dependency ratio"




putexcel B2=`m_water_improved'
putexcel C2=`b_water_improved'
putexcel D2=`se_water_improved'
putexcel E2=`t_water_improved'
putexcel F2=`p_water_improved'

putexcel B3=`m_electri'
putexcel C3=`b_electri'
putexcel D3=`se_electri'
putexcel E3=`t_electri'
putexcel F3=`p_electri'

putexcel B4=`m_sewage'
putexcel C4=`b_sewage'
putexcel D4=`se_sewage'
putexcel E4=`t_sewage'
putexcel F4=`p_sewage'

putexcel B5=`m_own_house'
putexcel C5=`b_own_house'
putexcel D5=`se_own_house'
putexcel E5=`t_own_house'
putexcel F5=`p_own_house'

putexcel B6=`m_good_house'
putexcel C6=`b_good_house'
putexcel D6=`se_good_house'
putexcel E6=`t_good_house'
putexcel F6=`p_good_house'

putexcel B7=`m_over_crowding'
putexcel C7=`b_over_crowding'
putexcel D7=`se_over_crowding'
putexcel E7=`t_over_crowding'
putexcel F7=`p_over_crowding'

putexcel B8=`m_over_crowding_ext'
putexcel C8=`b_over_crowding_ext'
putexcel D8=`se_over_crowding_ext'
putexcel E8=`t_over_crowding_ext'
putexcel F8=`p_over_crowding_ext'

putexcel B9=`m_radio'
putexcel C9=`b_radio'
putexcel D9=`se_radio'
putexcel E9=`t_radio'
putexcel F9=`p_radio'

putexcel B10=`m_tele'
putexcel C10=`b_tele'
putexcel D10=`se_tele'
putexcel E10=`t_tele'
putexcel F10=`p_tele'

putexcel B11=`m_fridge'
putexcel C11=`b_fridge'
putexcel D11=`se_fridge'
putexcel E11=`t_fridge'
putexcel F11=`p_fridge'

putexcel B12=`m_washing'
putexcel C12=`b_washing'
putexcel D12=`se_washing'
putexcel E12=`t_washing'
putexcel F12=`p_washing'

putexcel B13=`m_auto'
putexcel C13=`b_auto'
putexcel D13=`se_auto'
putexcel E13=`t_auto'
putexcel F13=`p_auto'

putexcel B14=`m_compu'
putexcel C14=`b_compu'
putexcel D14=`se_compu'
putexcel E14=`t_compu'
putexcel F14=`p_compu'

putexcel B15=`m_cell'
putexcel C15=`b_cell'
putexcel D15=`se_cell'
putexcel E15=`t_cell'
putexcel F15=`p_cell'

putexcel B16=`m_hhsize'
putexcel C16=`b_hhsize'
putexcel D16=`se_hhsize'
putexcel E16=`t_hhsize'
putexcel F16=`p_hhsize'

putexcel B17=`m_hhsize2'
putexcel C17=`b_hhsize2'
putexcel D17=`se_hhsize2'
putexcel E17=`t_hhsize2'
putexcel F17=`p_hhsize2'

putexcel B18=`m_female_hh'
putexcel C18=`b_female_hh'
putexcel D18=`se_female_hh'
putexcel E18=`t_female_hh'
putexcel F18=`p_female_hh'

putexcel B19=`m_age_hh'
putexcel C19=`b_age_hh'
putexcel D19=`se_age_hh'
putexcel E19=`t_age_hh'
putexcel F19=`p_age_hh'

putexcel B20=`m_hh_primedu'
putexcel C20=`b_hh_primedu'
putexcel D20=`se_hh_primedu'
putexcel E20=`t_hh_primedu'
putexcel F20=`p_hh_primedu'

putexcel B21=`m_hh_secondedu'
putexcel C21=`b_hh_secondedu'
putexcel D21=`se_hh_secondedu'
putexcel E21=`t_hh_secondedu'
putexcel F21=`p_hh_secondedu'

putexcel B22=`m_hh_superior'
putexcel C22=`b_hh_superior'
putexcel D22=`se_hh_superior'
putexcel E22=`t_hh_superior'
putexcel F22=`p_hh_superior'

putexcel B23=`m_sh_primedu'
putexcel C23=`b_sh_primedu'
putexcel D23=`se_sh_primedu'
putexcel E23=`t_sh_primedu'
putexcel F23=`p_sh_primedu'

putexcel B24=`m_sh_secedu'
putexcel C24=`b_sh_secedu'
putexcel D24=`se_sh_secedu'
putexcel E24=`t_sh_secedu'
putexcel F24=`p_sh_secedu'

putexcel B25=`m_sh_supedu'
putexcel C25=`b_sh_supedu'
putexcel D25=`se_sh_supedu'
putexcel E25=`t_sh_supedu'
putexcel F25=`p_sh_supedu'

putexcel B26=`m_sh_literate'
putexcel C26=`b_sh_literate'
putexcel D26=`se_sh_literate'
putexcel E26=`t_sh_literate'
putexcel F26=`p_sh_literate'

putexcel B27=`m_sh_noedu'
putexcel C27=`b_sh_noedu'
putexcel D27=`se_sh_noedu'
putexcel E27=`t_sh_noedu'
putexcel F27=`p_sh_noedu'

putexcel B28=`m_depen_ch'
putexcel C28=`b_depen_ch'
putexcel D28=`se_depen_ch'
putexcel E28=`t_depen_ch'
putexcel F28=`p_depen_ch'

putexcel B29=`m_depen_old'
putexcel C29=`b_depen_old'
putexcel D29=`se_depen_old'
putexcel E29=`t_depen_old'
putexcel F29=`p_depen_old'


putexcel G2="water_improved"
putexcel G3="electri"
putexcel G4="sewage"
putexcel G5="own_house"
putexcel G6="good_house"
putexcel G7="over_crowding"
putexcel G8="over_crowding_ext"
putexcel G9="radio"
putexcel G10="tele"
putexcel G11="fridge"
putexcel G12="washing"
putexcel G13="auto"
putexcel G14="compu"
putexcel G15="cell"
putexcel G16="hhsize"
putexcel G17="hhsize2"
putexcel G18="female_hh"
putexcel G19="age_hh"
putexcel G20="hh_primedu"
putexcel G21="hh_secondedu"
putexcel G22="hh_superior"
putexcel G23="sh_primedu"
putexcel G24="sh_secedu"
putexcel G25="sh_supedu"
putexcel G26="sh_literate"  
putexcel G27="sh_noedu"    
putexcel G28="depen_ch"
putexcel G29="depen_old"




***Getting samples 2010
forvalues i=1(1)100 {
use "$rawsamples10\sample_`i'.dta", clear
merge 1:1 hid using "$currdata10\census\census.dta"
keep if _merge==3
keep psu_id* mun_id*  hid* pchinc $myvar ln_pchinc fgt0_m FACTOR FACTOR_res FACTOR_res2 state_*


putexcel set "$results\distribution_sample10_`i'", replace

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
 
putexcel A2="Improved water"
putexcel A3="Access to electricity"
putexcel A4="Access to sewage"
putexcel A5="Own a house"
putexcel A6="Good house"
putexcel A7="Over crowding"
putexcel A8="Over crowding extreme"
putexcel A9="Has radio"
putexcel A10="Has TV"
putexcel A11="Has fridge"
putexcel A12="Has washing machine"
putexcel A13="Has auto"
putexcel A14="Has computer"
putexcel A15="Has phone"
putexcel A16="Household size"
putexcel A17="Household size (squared)"
putexcel A18="Female household head"
putexcel A19="Age of hhead"
putexcel A20="Hhead with primary"
putexcel A21="Hhead with secondary"
putexcel A22="Hhead with superior"
putexcel A23="Share of individuals with primary"
putexcel A24="Share of individuals with secondary"
putexcel A25="Share of individuals with superior"
putexcel A26="Share of literate individuals"
putexcel A27="Share of individuals with no education"
putexcel A28="Child dependency ratio"
putexcel A29="Elderly dependency ratio"




putexcel B2=`m_water_improved'
putexcel C2=`b_water_improved'
putexcel D2=`se_water_improved'
putexcel E2=`t_water_improved'
putexcel F2=`p_water_improved'

putexcel B3=`m_electri'
putexcel C3=`b_electri'
putexcel D3=`se_electri'
putexcel E3=`t_electri'
putexcel F3=`p_electri'

putexcel B4=`m_sewage'
putexcel C4=`b_sewage'
putexcel D4=`se_sewage'
putexcel E4=`t_sewage'
putexcel F4=`p_sewage'

putexcel B5=`m_own_house'
putexcel C5=`b_own_house'
putexcel D5=`se_own_house'
putexcel E5=`t_own_house'
putexcel F5=`p_own_house'

putexcel B6=`m_good_house'
putexcel C6=`b_good_house'
putexcel D6=`se_good_house'
putexcel E6=`t_good_house'
putexcel F6=`p_good_house'

putexcel B7=`m_over_crowding'
putexcel C7=`b_over_crowding'
putexcel D7=`se_over_crowding'
putexcel E7=`t_over_crowding'
putexcel F7=`p_over_crowding'

putexcel B8=`m_over_crowding_ext'
putexcel C8=`b_over_crowding_ext'
putexcel D8=`se_over_crowding_ext'
putexcel E8=`t_over_crowding_ext'
putexcel F8=`p_over_crowding_ext'

putexcel B9=`m_radio'
putexcel C9=`b_radio'
putexcel D9=`se_radio'
putexcel E9=`t_radio'
putexcel F9=`p_radio'

putexcel B10=`m_tele'
putexcel C10=`b_tele'
putexcel D10=`se_tele'
putexcel E10=`t_tele'
putexcel F10=`p_tele'

putexcel B11=`m_fridge'
putexcel C11=`b_fridge'
putexcel D11=`se_fridge'
putexcel E11=`t_fridge'
putexcel F11=`p_fridge'

putexcel B12=`m_washing'
putexcel C12=`b_washing'
putexcel D12=`se_washing'
putexcel E12=`t_washing'
putexcel F12=`p_washing'

putexcel B13=`m_auto'
putexcel C13=`b_auto'
putexcel D13=`se_auto'
putexcel E13=`t_auto'
putexcel F13=`p_auto'

putexcel B14=`m_compu'
putexcel C14=`b_compu'
putexcel D14=`se_compu'
putexcel E14=`t_compu'
putexcel F14=`p_compu'

putexcel B15=`m_cell'
putexcel C15=`b_cell'
putexcel D15=`se_cell'
putexcel E15=`t_cell'
putexcel F15=`p_cell'

putexcel B16=`m_hhsize'
putexcel C16=`b_hhsize'
putexcel D16=`se_hhsize'
putexcel E16=`t_hhsize'
putexcel F16=`p_hhsize'

putexcel B17=`m_hhsize2'
putexcel C17=`b_hhsize2'
putexcel D17=`se_hhsize2'
putexcel E17=`t_hhsize2'
putexcel F17=`p_hhsize2'

putexcel B18=`m_female_hh'
putexcel C18=`b_female_hh'
putexcel D18=`se_female_hh'
putexcel E18=`t_female_hh'
putexcel F18=`p_female_hh'

putexcel B19=`m_age_hh'
putexcel C19=`b_age_hh'
putexcel D19=`se_age_hh'
putexcel E19=`t_age_hh'
putexcel F19=`p_age_hh'

putexcel B20=`m_hh_primedu'
putexcel C20=`b_hh_primedu'
putexcel D20=`se_hh_primedu'
putexcel E20=`t_hh_primedu'
putexcel F20=`p_hh_primedu'

putexcel B21=`m_hh_secondedu'
putexcel C21=`b_hh_secondedu'
putexcel D21=`se_hh_secondedu'
putexcel E21=`t_hh_secondedu'
putexcel F21=`p_hh_secondedu'

putexcel B22=`m_hh_superior'
putexcel C22=`b_hh_superior'
putexcel D22=`se_hh_superior'
putexcel E22=`t_hh_superior'
putexcel F22=`p_hh_superior'

putexcel B23=`m_sh_primedu'
putexcel C23=`b_sh_primedu'
putexcel D23=`se_sh_primedu'
putexcel E23=`t_sh_primedu'
putexcel F23=`p_sh_primedu'

putexcel B24=`m_sh_secedu'
putexcel C24=`b_sh_secedu'
putexcel D24=`se_sh_secedu'
putexcel E24=`t_sh_secedu'
putexcel F24=`p_sh_secedu'

putexcel B25=`m_sh_supedu'
putexcel C25=`b_sh_supedu'
putexcel D25=`se_sh_supedu'
putexcel E25=`t_sh_supedu'
putexcel F25=`p_sh_supedu'

putexcel B26=`m_sh_literate'
putexcel C26=`b_sh_literate'
putexcel D26=`se_sh_literate'
putexcel E26=`t_sh_literate'
putexcel F26=`p_sh_literate'

putexcel B27=`m_sh_noedu'
putexcel C27=`b_sh_noedu'
putexcel D27=`se_sh_noedu'
putexcel E27=`t_sh_noedu'
putexcel F27=`p_sh_noedu'

putexcel B28=`m_depen_ch'
putexcel C28=`b_depen_ch'
putexcel D28=`se_depen_ch'
putexcel E28=`t_depen_ch'
putexcel F28=`p_depen_ch'

putexcel B29=`m_depen_old'
putexcel C29=`b_depen_old'
putexcel D29=`se_depen_old'
putexcel E29=`t_depen_old'
putexcel F29=`p_depen_old'


putexcel G2="water_improved"
putexcel G3="electri"
putexcel G4="sewage"
putexcel G5="own_house"
putexcel G6="good_house"
putexcel G7="over_crowding"
putexcel G8="over_crowding_ext"
putexcel G9="radio"
putexcel G10="tele"
putexcel G11="fridge"
putexcel G12="washing"
putexcel G13="auto"
putexcel G14="compu"
putexcel G15="cell"
putexcel G16="hhsize"
putexcel G17="hhsize2"
putexcel G18="female_hh"
putexcel G19="age_hh"
putexcel G20="hh_primedu"
putexcel G21="hh_secondedu"
putexcel G22="hh_superior"
putexcel G23="sh_primedu"
putexcel G24="sh_secedu"
putexcel G25="sh_supedu"
putexcel G26="sh_literate"  
putexcel G27="sh_noedu"    
putexcel G28="depen_ch"
putexcel G29="depen_old"


}



putexcel set "$results\sample_size", replace

global myarea aux_sh_primedu_mun aux_sh_secedu_mun aux_sh_supedu_mun aux_sh_noedu_mun aux_sh_literate_mun unemp_mun informal_mun hhsize_mun hh_primedu_mun hh_secondedu_mun hh_superior_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun water_improved_mun electri_mun sewage_mun own_house_mun good_house_mun  radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun over_crowding_mun over_crowding_ext_mun 


***Area level variables from census 2010 to merge in survey 2020
use "$currdata00\census\census.dta", clear
keep mun_id $myarea
duplicates drop
tempfile census00
save `census00'

forvalues i=1(1)100 {
***Analyzing C.I.
import excel "$results\distribution_sample10_`i'.xlsx", sheet("Sheet1") firstrow clear
foreach x of var * { 
	rename `x' `x'_sur 
} 
rename A_sur A
tempfile survey
save `survey'

import excel "$results\distribution_census_00.xlsx", sheet("Sheet1") firstrow clear

merge 1:1 A using `survey'

g check=1 if (LL_sur<=Meanreg & Meanreg<=UL_sur)
g check2=1 if (LL_sur<=LL & LL<=UL_sur) | (LL_sur<=UL & UL<=UL_sur)
g check3=1 if (LL<=LL_sur & LL_sur<=UL) | (LL<=UL_sur & UL_sur<=UL)

g check_final=1 if check2==1 | check3==1 | check==1

keep if (check_final==1 | G=="hhsize" )
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
use "$rawsamples10\sample_`i'.dta", clear
merge 1:1 hid using "$currdata10\census\census.dta"
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $tokeep  ln_pchinc fgt0_m FACTOR FACTOR_res FACTOR_res2 state_* hhsize*

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''

***Merging area-level variables
merge m:1 mun_id using `census00'
keep if _merge==3
drop _merge

save "$currdatas10c00\rawsamples\selected\sample_`i'.dta", replace
}
