* cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/
global currdata10 "H:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global data10 "$currdata10\rawdata\"
global rawsamples10 "$currdata10\rawsamples_full\"
global census10 "$data10\census_proc_MEX_2010.dta"

global currdata20 "H:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census"
global data20 "$currdata20\rawdata\"
global rawsamples20 "$currdata20\rawsamples_full\"
global census20 "$data20\census_proc_MEX_2020.dta"

global currdatas20c10 "H:\david\SAE\SAE_research_with_Melany\MEX\s20_c10\full_census"
global results "$currdatas20c10\results"

//global with candidate variables for unit level models
global myvar wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet hhsize hhsize2 female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old
  
/*aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu*/


set seed 648743

***In the census
use "$currdata10\census\census.dta", clear
keep psu_id* mun_id*  hid* pchinc $myvar ln_pchinc popwt ENT state_*

putexcel set "$results\results_distrib\distribution_census_10", replace

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


putexcel A2="Improved walls"
putexcel A3="Improved roof"
putexcel A4="Improved floor"
putexcel A5="Improved water"
putexcel A6="Access to electricity"
putexcel A7="Access to flush toilet"
putexcel A8="Access to sewage"
putexcel A9="Own a house"
putexcel A10="Cooking fuel"
putexcel A11="Over crowding"
putexcel A12="Over crowding extreme"
putexcel A13="Has a stove"
putexcel A14="Has shower"
putexcel A15="Has radio"
putexcel A16="Has TV"
putexcel A17="Has fridge"
putexcel A18="Has washing machine"
putexcel A19="Has auto"
putexcel A20="Has computer"
putexcel A21="Has cellphone"
putexcel A22="Has internet"

putexcel A23="Household size"
putexcel A24="Household size (squared)"
putexcel A25="Child dependency ratio"
putexcel A26="Elderly dependency ratio"
putexcel A27="Female household head"
putexcel A28="Years of education of hhead"
putexcel A29="Age of hhead"
putexcel A30="Share of individuals with 0-8 years of educ."
putexcel A31="Share of individuals with 9-14 years of educ."
putexcel A32="Share of individuals with 14+ years of educ."
putexcel A33="Share of literate individuals"


putexcel B2=`m_wall_improved'
putexcel C2=`b_wall_improved'
putexcel D2=`se_wall_improved'
putexcel E2=`t_wall_improved'
putexcel F2=`p_wall_improved'

putexcel B3=`m_roof_improved'
putexcel C3=`b_roof_improved'
putexcel D3=`se_roof_improved'
putexcel E3=`t_roof_improved'
putexcel F3=`p_roof_improved'

putexcel B4=`m_floor_improved'
putexcel C4=`b_floor_improved'
putexcel D4=`se_floor_improved'
putexcel E4=`t_floor_improved'
putexcel F4=`p_floor_improved'

putexcel B5=`m_water_improved'
putexcel C5=`b_water_improved'
putexcel D5=`se_water_improved'
putexcel E5=`t_water_improved'
putexcel F5=`p_water_improved'

putexcel B6=`m_electri'
putexcel C6=`b_electri'
putexcel D6=`se_electri'
putexcel E6=`t_electri'
putexcel F6=`p_electri'

putexcel B7=`m_flush_toilet'
putexcel C7=`b_flush_toilet'
putexcel D7=`se_flush_toilet'
putexcel E7=`t_flush_toilet'
putexcel F7=`p_flush_toilet'

putexcel B8=`m_sewage'
putexcel C8=`b_sewage'
putexcel D8=`se_sewage'
putexcel E8=`t_sewage'
putexcel F8=`p_sewage'

putexcel B9=`m_own_house'
putexcel C9=`b_own_house'
putexcel D9=`se_own_house'
putexcel E9=`t_own_house'
putexcel F9=`p_own_house'

putexcel B10=`m_cook_fuel'
putexcel C10=`b_cook_fuel'
putexcel D10=`se_cook_fuel'
putexcel E10=`t_cook_fuel'
putexcel F10=`p_cook_fuel'

putexcel B11=`m_over_crowding'
putexcel C11=`b_over_crowding'
putexcel D11=`se_over_crowding'
putexcel E11=`t_over_crowding'
putexcel F11=`p_over_crowding'

putexcel B12=`m_over_crowding_ext'
putexcel C12=`b_over_crowding_ext'
putexcel D12=`se_over_crowding_ext'
putexcel E12=`t_over_crowding_ext'
putexcel F12=`p_over_crowding_ext'

putexcel B13=`m_stove'
putexcel C13=`b_stove'
putexcel D13=`se_stove'
putexcel E13=`t_stove'
putexcel F13=`p_stove'

putexcel B14=`m_shower'
putexcel C14=`b_shower'
putexcel D14=`se_shower'
putexcel E14=`t_shower'
putexcel F14=`p_shower'

putexcel B15=`m_radio'
putexcel C15=`b_radio'
putexcel D15=`se_radio'
putexcel E15=`t_radio'
putexcel F15=`p_radio'

putexcel B16=`m_tele'
putexcel C16=`b_tele'
putexcel D16=`se_tele'
putexcel E16=`t_tele'
putexcel F16=`p_tele'

putexcel B17=`m_fridge'
putexcel C17=`b_fridge'
putexcel D17=`se_fridge'
putexcel E17=`t_fridge'
putexcel F17=`p_fridge'

putexcel B18=`m_washing'
putexcel C18=`b_washing'
putexcel D18=`se_washing'
putexcel E18=`t_washing'
putexcel F18=`p_washing'

putexcel B19=`m_auto'
putexcel C19=`b_auto'
putexcel D19=`se_auto'
putexcel E19=`t_auto'
putexcel F19=`p_auto'

putexcel B20=`m_compu'
putexcel C20=`b_compu'
putexcel D20=`se_compu'
putexcel E20=`t_compu'
putexcel F20=`p_compu'

putexcel B21=`m_cell'
putexcel C21=`b_cell'
putexcel D21=`se_cell'
putexcel E21=`t_cell'
putexcel F21=`p_cell'

putexcel B22=`m_internet'
putexcel C22=`b_internet'
putexcel D22=`se_internet'
putexcel E22=`t_internet'
putexcel F22=`p_internet'

putexcel B23=`m_hhsize'
putexcel C23=`b_hhsize'
putexcel D23=`se_hhsize'
putexcel E23=`t_hhsize'
putexcel F23=`p_hhsize'

putexcel B24=`m_hhsize2'
putexcel C24=`b_hhsize2'
putexcel D24=`se_hhsize2'
putexcel E24=`t_hhsize2'
putexcel F24=`p_hhsize2'

putexcel B25=`m_depen_ch'
putexcel C25=`b_depen_ch'
putexcel D25=`se_depen_ch'
putexcel E25=`t_depen_ch'
putexcel F25=`p_depen_ch'

putexcel B26=`m_depen_old'
putexcel C26=`b_depen_old'
putexcel D26=`se_depen_old'
putexcel E26=`t_depen_old'
putexcel F26=`p_depen_old'

putexcel B27=`m_female_hh'
putexcel C27=`b_female_hh'
putexcel D27=`se_female_hh'
putexcel E27=`t_female_hh'
putexcel F27=`p_female_hh'

putexcel B28=`m_educ_hh'
putexcel C28=`b_educ_hh'
putexcel D28=`se_educ_hh'
putexcel E28=`t_educ_hh'
putexcel F28=`p_educ_hh'

putexcel B29=`m_age_hh'
putexcel C29=`b_age_hh'
putexcel D29=`se_age_hh'
putexcel E29=`t_age_hh'
putexcel F29=`p_age_hh'

putexcel B30=`m_sh_educ0_8'
putexcel C30=`b_sh_educ0_8'
putexcel D30=`se_sh_educ0_8'
putexcel E30=`t_sh_educ0_8'
putexcel F30=`p_sh_educ0_8'

putexcel B31=`m_sh_educ9_13'
putexcel C31=`b_sh_educ9_13'
putexcel D31=`se_sh_educ9_13'
putexcel E31=`t_sh_educ9_13'
putexcel F31=`p_sh_educ9_13'

putexcel B32=`m_sh_educ14_plus'
putexcel C32=`b_sh_educ14_plus'
putexcel D32=`se_sh_educ14_plus'
putexcel E32=`t_sh_educ14_plus'
putexcel F32=`p_sh_educ14_plus'

putexcel B33=`m_sh_literate'
putexcel C33=`b_sh_literate'
putexcel D33=`se_sh_literate'
putexcel E33=`t_sh_literate'
putexcel F33=`p_sh_literate'




putexcel G2="wall_improved"
putexcel G3="roof_improved"
putexcel G4="floor_improved"
putexcel G5="water_improved"
putexcel G6="electri"
putexcel G7="flush_toilet"
putexcel G8="sewage"
putexcel G9="own_house"
putexcel G10="cook_fuel"
putexcel G11="over_crowding"
putexcel G12="over_crowding_ext"
putexcel G13="stove"
putexcel G14="shower"
putexcel G15="radio"
putexcel G16="tele"
putexcel G17="fridge"
putexcel G18="washing"
putexcel G19="auto"
putexcel G20="compu"
putexcel G21="cell"
putexcel G22="internet"
putexcel G23="hhsize"
putexcel G24="hhsize2"
putexcel G25="depen_ch"
putexcel G26="depen_old"
putexcel G27="female_hh"
putexcel G28="educ_hh"
putexcel G29="age_hh"
putexcel G30="sh_educ0_8"
putexcel G31="sh_educ9_13"
putexcel G32="sh_educ14_plus"
putexcel G33="sh_literate"
     



***Getting samples 2015
forvalues i=1(1)100 {
use "$rawsamples20\sample_`i'.dta", clear
merge 1:1 hid using "$currdata20\census\census.dta"
keep if _merge==3
keep psu_id* mun_id*  hid* pchinc $myvar ln_pchinc povline fgt* FACTOR FACTOR_res FACTOR_res2 ENT state_*


putexcel set "$results\results_distrib\distribution_sample20_`i'", replace

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


putexcel A2="Improved walls"
putexcel A3="Improved roof"
putexcel A4="Improved floor"
putexcel A5="Improved water"
putexcel A6="Access to electricity"
putexcel A7="Access to flush toilet"
putexcel A8="Access to sewage"
putexcel A9="Own a house"
putexcel A10="Cooking fuel"
putexcel A11="Over crowding"
putexcel A12="Over crowding extreme"
putexcel A13="Has a stove"
putexcel A14="Has shower"
putexcel A15="Has radio"
putexcel A16="Has TV"
putexcel A17="Has fridge"
putexcel A18="Has washing machine"
putexcel A19="Has auto"
putexcel A20="Has computer"
putexcel A21="Has cellphone"
putexcel A22="Has internet"

putexcel A23="Household size"
putexcel A24="Household size (squared)"
putexcel A25="Child dependency ratio"
putexcel A26="Elderly dependency ratio"
putexcel A27="Female household head"
putexcel A28="Years of education of hhead"
putexcel A29="Age of hhead"
putexcel A30="Share of individuals with 0-8 years of educ."
putexcel A31="Share of individuals with 9-14 years of educ."
putexcel A32="Share of individuals with 14+ years of educ."
putexcel A33="Share of literate individuals"


putexcel B2=`m_wall_improved'
putexcel C2=`b_wall_improved'
putexcel D2=`se_wall_improved'
putexcel E2=`t_wall_improved'
putexcel F2=`p_wall_improved'

putexcel B3=`m_roof_improved'
putexcel C3=`b_roof_improved'
putexcel D3=`se_roof_improved'
putexcel E3=`t_roof_improved'
putexcel F3=`p_roof_improved'

putexcel B4=`m_floor_improved'
putexcel C4=`b_floor_improved'
putexcel D4=`se_floor_improved'
putexcel E4=`t_floor_improved'
putexcel F4=`p_floor_improved'

putexcel B5=`m_water_improved'
putexcel C5=`b_water_improved'
putexcel D5=`se_water_improved'
putexcel E5=`t_water_improved'
putexcel F5=`p_water_improved'

putexcel B6=`m_electri'
putexcel C6=`b_electri'
putexcel D6=`se_electri'
putexcel E6=`t_electri'
putexcel F6=`p_electri'

putexcel B7=`m_flush_toilet'
putexcel C7=`b_flush_toilet'
putexcel D7=`se_flush_toilet'
putexcel E7=`t_flush_toilet'
putexcel F7=`p_flush_toilet'

putexcel B8=`m_sewage'
putexcel C8=`b_sewage'
putexcel D8=`se_sewage'
putexcel E8=`t_sewage'
putexcel F8=`p_sewage'

putexcel B9=`m_own_house'
putexcel C9=`b_own_house'
putexcel D9=`se_own_house'
putexcel E9=`t_own_house'
putexcel F9=`p_own_house'

putexcel B10=`m_cook_fuel'
putexcel C10=`b_cook_fuel'
putexcel D10=`se_cook_fuel'
putexcel E10=`t_cook_fuel'
putexcel F10=`p_cook_fuel'

putexcel B11=`m_over_crowding'
putexcel C11=`b_over_crowding'
putexcel D11=`se_over_crowding'
putexcel E11=`t_over_crowding'
putexcel F11=`p_over_crowding'

putexcel B12=`m_over_crowding_ext'
putexcel C12=`b_over_crowding_ext'
putexcel D12=`se_over_crowding_ext'
putexcel E12=`t_over_crowding_ext'
putexcel F12=`p_over_crowding_ext'

putexcel B13=`m_stove'
putexcel C13=`b_stove'
putexcel D13=`se_stove'
putexcel E13=`t_stove'
putexcel F13=`p_stove'

putexcel B14=`m_shower'
putexcel C14=`b_shower'
putexcel D14=`se_shower'
putexcel E14=`t_shower'
putexcel F14=`p_shower'

putexcel B15=`m_radio'
putexcel C15=`b_radio'
putexcel D15=`se_radio'
putexcel E15=`t_radio'
putexcel F15=`p_radio'

putexcel B16=`m_tele'
putexcel C16=`b_tele'
putexcel D16=`se_tele'
putexcel E16=`t_tele'
putexcel F16=`p_tele'

putexcel B17=`m_fridge'
putexcel C17=`b_fridge'
putexcel D17=`se_fridge'
putexcel E17=`t_fridge'
putexcel F17=`p_fridge'

putexcel B18=`m_washing'
putexcel C18=`b_washing'
putexcel D18=`se_washing'
putexcel E18=`t_washing'
putexcel F18=`p_washing'

putexcel B19=`m_auto'
putexcel C19=`b_auto'
putexcel D19=`se_auto'
putexcel E19=`t_auto'
putexcel F19=`p_auto'

putexcel B20=`m_compu'
putexcel C20=`b_compu'
putexcel D20=`se_compu'
putexcel E20=`t_compu'
putexcel F20=`p_compu'

putexcel B21=`m_cell'
putexcel C21=`b_cell'
putexcel D21=`se_cell'
putexcel E21=`t_cell'
putexcel F21=`p_cell'

putexcel B22=`m_internet'
putexcel C22=`b_internet'
putexcel D22=`se_internet'
putexcel E22=`t_internet'
putexcel F22=`p_internet'

putexcel B23=`m_hhsize'
putexcel C23=`b_hhsize'
putexcel D23=`se_hhsize'
putexcel E23=`t_hhsize'
putexcel F23=`p_hhsize'

putexcel B24=`m_hhsize2'
putexcel C24=`b_hhsize2'
putexcel D24=`se_hhsize2'
putexcel E24=`t_hhsize2'
putexcel F24=`p_hhsize2'

putexcel B25=`m_depen_ch'
putexcel C25=`b_depen_ch'
putexcel D25=`se_depen_ch'
putexcel E25=`t_depen_ch'
putexcel F25=`p_depen_ch'

putexcel B26=`m_depen_old'
putexcel C26=`b_depen_old'
putexcel D26=`se_depen_old'
putexcel E26=`t_depen_old'
putexcel F26=`p_depen_old'

putexcel B27=`m_female_hh'
putexcel C27=`b_female_hh'
putexcel D27=`se_female_hh'
putexcel E27=`t_female_hh'
putexcel F27=`p_female_hh'

putexcel B28=`m_educ_hh'
putexcel C28=`b_educ_hh'
putexcel D28=`se_educ_hh'
putexcel E28=`t_educ_hh'
putexcel F28=`p_educ_hh'

putexcel B29=`m_age_hh'
putexcel C29=`b_age_hh'
putexcel D29=`se_age_hh'
putexcel E29=`t_age_hh'
putexcel F29=`p_age_hh'

putexcel B30=`m_sh_educ0_8'
putexcel C30=`b_sh_educ0_8'
putexcel D30=`se_sh_educ0_8'
putexcel E30=`t_sh_educ0_8'
putexcel F30=`p_sh_educ0_8'

putexcel B31=`m_sh_educ9_13'
putexcel C31=`b_sh_educ9_13'
putexcel D31=`se_sh_educ9_13'
putexcel E31=`t_sh_educ9_13'
putexcel F31=`p_sh_educ9_13'

putexcel B32=`m_sh_educ14_plus'
putexcel C32=`b_sh_educ14_plus'
putexcel D32=`se_sh_educ14_plus'
putexcel E32=`t_sh_educ14_plus'
putexcel F32=`p_sh_educ14_plus'

putexcel B33=`m_sh_literate'
putexcel C33=`b_sh_literate'
putexcel D33=`se_sh_literate'
putexcel E33=`t_sh_literate'
putexcel F33=`p_sh_literate'


     


putexcel G2="wall_improved"
putexcel G3="roof_improved"
putexcel G4="floor_improved"
putexcel G5="water_improved"
putexcel G6="electri"
putexcel G7="flush_toilet"
putexcel G8="sewage"
putexcel G9="own_house"
putexcel G10="cook_fuel"
putexcel G11="over_crowding"
putexcel G12="over_crowding_ext"
putexcel G13="stove"
putexcel G14="shower"
putexcel G15="radio"
putexcel G16="tele"
putexcel G17="fridge"
putexcel G18="washing"
putexcel G19="auto"
putexcel G20="compu"
putexcel G21="cell"
putexcel G22="internet"
putexcel G23="hhsize"
putexcel G24="hhsize2"
putexcel G25="depen_ch"
putexcel G26="depen_old"
putexcel G27="female_hh"
putexcel G28="educ_hh"
putexcel G29="age_hh"
putexcel G30="sh_educ0_8"
putexcel G31="sh_educ9_13"
putexcel G32="sh_educ14_plus"
putexcel G33="sh_literate"
     


}



putexcel set "$results\results_distrib\sample_size", replace

global myarea aaux_sh_educ0_8_mun aaux_sh_educ9_13_mun aaux_sh_educ14_plus_mun ALFABET_mun ESCOACUM_mun unemp_mun informal_mun hhsize_mun  educ_hh_mun age_hh_mun female_hh_mun depen_ch_mun depen_old_mun wall_improved_mun roof_improved_mun floor_improved_mun water_improved_mun electri_mun flush_toilet_mun sewage_mun own_house_mun cook_fuel_mun over_crowding_mun over_crowding_ext_mun stove_mun shower_mun radio_mun tele_mun fridge_mun washing_mun auto_mun compu_mun cell_mun internet_mun 

/*aaux_sh_educ0_8_psu aaux_sh_educ9_13_psu aaux_sh_educ14_plus_psu ALFABET_psu ESCOACUM_psu unemp_psu informal_psu hhsize_psu  educ_hh_psu age_hh_psu female_hh_psu depen_ch_psu depen_old_psu wall_improved_psu roof_improved_psu floor_improved_psu water_improved_psu electri_psu flush_toilet_psu sewage_psu own_house_psu cook_fuel_psu over_crowding_psu over_crowding_ext_psu stove_psu shower_psu radio_psu tele_psu fridge_psu washing_psu auto_psu compu_psu cell_psu internet_psu*/


***Area level variables from census 2010 to merge in survey 2020
use "$currdata10\census\census.dta", clear
keep mun_id $myarea
duplicates drop
tempfile census10
save `census10'

forvalues i=1(1)100 {
***Analyzing C.I.
import excel "$results\results_distrib\distribution_sample20_`i'.xlsx", sheet("Sheet1") firstrow clear
foreach x of var * { 
	rename `x' `x'_sur 
} 
rename A_sur A
tempfile survey
save `survey'

import excel "$results\results_distrib\distribution_census_10.xlsx", sheet("Sheet1") firstrow clear

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
use "$rawsamples20\sample_`i'.dta", clear
merge 1:1 hid using "$currdata20\census\census.dta"
keep if _merge==3

keep psu_id* mun_id*  hid* pchinc $tokeep  ln_pchinc povline fgt* FACTOR FACTOR_res FACTOR_res2 ENT state_* hhsize*

desc,short
local obs_`i'=r(k)

putexcel A`i'=`obs_`i''

***Merging area-level variables
merge m:1 mun_id using `census10'
keep if _merge==3
drop _merge

save "$currdatas20c10\rawsamples\selected\sample_`i'.dta", replace
}
