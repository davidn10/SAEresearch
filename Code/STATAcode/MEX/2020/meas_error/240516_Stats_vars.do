
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

* global currdata "D:\SAE_project\MEX\2020\full_census_new"
global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census"
global census "$currdata\census\"
global results "$currdata\results\error\"


set seed 648743


forvalues i=1(1)100 {

putexcel set "$results\results_error\no_error_means_`i'", replace

use "$currdata\rawsamples_full\sample_`i'.dta", clear
merge 1:1 hid using "$census\census.dta"
keep if _merge==3

foreach var in wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet  female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old {
	sum `var', d
	local m_`var'=r(mean)
	*local b_`var'=r(sd)
}

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

*putexcel A23="Household size"
*putexcel A24="Household size (squared)"
putexcel A23="Child dependency ratio"
putexcel A24="Elderly dependency ratio"
putexcel A25="Female household head"
putexcel A26="Years of education of hhead"
putexcel A27="Age of hhead"
putexcel A28="Share of individuals with 0-8 years of educ."
putexcel A29="Share of individuals with 9-14 years of educ."
putexcel A30="Share of individuals with 14+ years of educ."
putexcel A31="Share of literate individuals"


putexcel B2=`m_wall_improved'
*putexcel C2=`b_wall_improved'

putexcel B3=`m_roof_improved'
*putexcel C3=`b_roof_improved'

putexcel B4=`m_floor_improved'
*putexcel C4=`b_floor_improved'

putexcel B5=`m_water_improved'
*putexcel C5=`b_water_improved'

putexcel B6=`m_electri'
*putexcel C6=`b_electri'

putexcel B7=`m_flush_toilet'
*putexcel C7=`b_flush_toilet'

putexcel B8=`m_sewage'
*putexcel C8=`b_sewage'

putexcel B9=`m_own_house'
*putexcel C9=`b_own_house'

putexcel B10=`m_cook_fuel'
*putexcel C10=`b_cook_fuel'

putexcel B11=`m_over_crowding'
*putexcel C11=`b_over_crowding'

putexcel B12=`m_over_crowding_ext'
*putexcel C12=`b_over_crowding_ext'

putexcel B13=`m_stove'
*putexcel C13=`b_stove'

putexcel B14=`m_shower'
*putexcel C14=`b_shower'

putexcel B15=`m_radio'
*putexcel C15=`b_radio'

putexcel B16=`m_tele'
*putexcel C16=`b_tele'

putexcel B17=`m_fridge'
*putexcel C17=`b_fridge'

putexcel B18=`m_washing'
*putexcel C18=`b_washing'

putexcel B19=`m_auto'
*putexcel C19=`b_auto'

putexcel B20=`m_compu'
*putexcel C20=`b_compu'

putexcel B21=`m_cell'
*putexcel C21=`b_cell'

putexcel B22=`m_internet'
*putexcel C22=`b_internet'
/*
putexcel B23=`m_hhsize'
putexcel C23=`b_hhsize'

putexcel B24=`m_hhsize2'
putexcel C24=`b_hhsize2'
*/
putexcel B23=`m_depen_ch'
*putexcel C25=`b_depen_ch'

putexcel B24=`m_depen_old'
*putexcel C26=`b_depen_old'

putexcel B25=`m_female_hh'
*putexcel C27=`b_female_hh'

putexcel B26=`m_educ_hh'
*putexcel C28=`b_educ_hh'

putexcel B27=`m_age_hh'
*putexcel C29=`b_age_hh'

putexcel B28=`m_sh_educ0_8'
*putexcel C30=`b_sh_educ0_8'

putexcel B29=`m_sh_educ9_13'
*putexcel C31=`b_sh_educ9_13'

putexcel B30=`m_sh_educ14_plus'
*putexcel C32=`b_sh_educ14_plus'

putexcel B31=`m_sh_literate'
*putexcel C33=`b_sh_literate'


putexcel set "$results\results_error\errorh_means_`i'", replace

use "$currdata\rawsamples_error\sample_`i'.dta", clear
rename educ_low_hh educ_hh_low
rename educ_high_hh educ_hh_high
rename age_low_hh age_hh_low
rename age_high_hh age_hh_high

drop *_low

foreach var in educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus depen_ch depen_old female_hh sh_literate wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel stove shower radio tele fridge washing auto compu cell internet over_crowding over_crowding_ext {
	rename `var'_high `var'
}


foreach var in wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet  female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old {
	sum `var', d
	local m_`var'=r(mean)
	local b_`var'=r(sd)
}

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

*putexcel A23="Household size"
*putexcel A24="Household size (squared)"
putexcel A23="Child dependency ratio"
putexcel A24="Elderly dependency ratio"
putexcel A25="Female household head"
putexcel A26="Years of education of hhead"
putexcel A27="Age of hhead"
putexcel A28="Share of individuals with 0-8 years of educ."
putexcel A29="Share of individuals with 9-14 years of educ."
putexcel A30="Share of individuals with 14+ years of educ."
putexcel A31="Share of literate individuals"

putexcel B2=`m_wall_improved'
*putexcel C2=`b_wall_improved'

putexcel B3=`m_roof_improved'
*putexcel C3=`b_roof_improved'

putexcel B4=`m_floor_improved'
*putexcel C4=`b_floor_improved'

putexcel B5=`m_water_improved'
*putexcel C5=`b_water_improved'

putexcel B6=`m_electri'
*putexcel C6=`b_electri'

putexcel B7=`m_flush_toilet'
*putexcel C7=`b_flush_toilet'

putexcel B8=`m_sewage'
*putexcel C8=`b_sewage'

putexcel B9=`m_own_house'
*putexcel C9=`b_own_house'

putexcel B10=`m_cook_fuel'
*putexcel C10=`b_cook_fuel'

putexcel B11=`m_over_crowding'
*putexcel C11=`b_over_crowding'

putexcel B12=`m_over_crowding_ext'
*putexcel C12=`b_over_crowding_ext'

putexcel B13=`m_stove'
*putexcel C13=`b_stove'

putexcel B14=`m_shower'
*putexcel C14=`b_shower'

putexcel B15=`m_radio'
*putexcel C15=`b_radio'

putexcel B16=`m_tele'
*putexcel C16=`b_tele'

putexcel B17=`m_fridge'
*putexcel C17=`b_fridge'

putexcel B18=`m_washing'
*putexcel C18=`b_washing'

putexcel B19=`m_auto'
*putexcel C19=`b_auto'

putexcel B20=`m_compu'
*putexcel C20=`b_compu'

putexcel B21=`m_cell'
*putexcel C21=`b_cell'

putexcel B22=`m_internet'
*putexcel C22=`b_internet'
/*
putexcel B23=`m_hhsize'
putexcel C23=`b_hhsize'

putexcel B24=`m_hhsize2'
putexcel C24=`b_hhsize2'
*/
putexcel B23=`m_depen_ch'
*putexcel C25=`b_depen_ch'

putexcel B24=`m_depen_old'
*putexcel C26=`b_depen_old'

putexcel B25=`m_female_hh'
*putexcel C27=`b_female_hh'

putexcel B26=`m_educ_hh'
*putexcel C28=`b_educ_hh'

putexcel B27=`m_age_hh'
*putexcel C29=`b_age_hh'

putexcel B28=`m_sh_educ0_8'
*putexcel C30=`b_sh_educ0_8'

putexcel B29=`m_sh_educ9_13'
*putexcel C31=`b_sh_educ9_13'

putexcel B30=`m_sh_educ14_plus'
*putexcel C32=`b_sh_educ14_plus'

putexcel B31=`m_sh_literate'
*putexcel C33=`b_sh_literate'



putexcel set "$results\results_error\errorl_means_`i'", replace

use "$currdata\rawsamples_error\sample_`i'.dta", clear
rename educ_low_hh educ_hh_low
rename educ_high_hh educ_hh_high
rename age_low_hh age_hh_low
rename age_high_hh age_hh_high

drop *_high

foreach var in educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus depen_ch depen_old female_hh sh_literate wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel stove shower radio tele fridge washing auto compu cell internet over_crowding over_crowding_ext {
	rename `var'_low `var'
}


foreach var in wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding over_crowding_ext stove shower radio tele fridge washing auto compu cell internet  female_hh educ_hh age_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old {
	sum `var', d
	local m_`var'=r(mean)
	local b_`var'=r(sd)
}

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

*putexcel A23="Household size"
*putexcel A24="Household size (squared)"
putexcel A23="Child dependency ratio"
putexcel A24="Elderly dependency ratio"
putexcel A25="Female household head"
putexcel A26="Years of education of hhead"
putexcel A27="Age of hhead"
putexcel A28="Share of individuals with 0-8 years of educ."
putexcel A29="Share of individuals with 9-14 years of educ."
putexcel A30="Share of individuals with 14+ years of educ."
putexcel A31="Share of literate individuals"


putexcel B2=`m_wall_improved'
*putexcel C2=`b_wall_improved'

putexcel B3=`m_roof_improved'
*putexcel C3=`b_roof_improved'

putexcel B4=`m_floor_improved'
*putexcel C4=`b_floor_improved'

putexcel B5=`m_water_improved'
*putexcel C5=`b_water_improved'

putexcel B6=`m_electri'
*putexcel C6=`b_electri'

putexcel B7=`m_flush_toilet'
*putexcel C7=`b_flush_toilet'

putexcel B8=`m_sewage'
*putexcel C8=`b_sewage'

putexcel B9=`m_own_house'
*putexcel C9=`b_own_house'

putexcel B10=`m_cook_fuel'
*putexcel C10=`b_cook_fuel'

putexcel B11=`m_over_crowding'
*putexcel C11=`b_over_crowding'

putexcel B12=`m_over_crowding_ext'
*putexcel C12=`b_over_crowding_ext'

putexcel B13=`m_stove'
*putexcel C13=`b_stove'

putexcel B14=`m_shower'
*putexcel C14=`b_shower'

putexcel B15=`m_radio'
*putexcel C15=`b_radio'

putexcel B16=`m_tele'
*putexcel C16=`b_tele'

putexcel B17=`m_fridge'
*putexcel C17=`b_fridge'

putexcel B18=`m_washing'
*putexcel C18=`b_washing'

putexcel B19=`m_auto'
*putexcel C19=`b_auto'

putexcel B20=`m_compu'
*putexcel C20=`b_compu'

putexcel B21=`m_cell'
*putexcel C21=`b_cell'

putexcel B22=`m_internet'
*putexcel C22=`b_internet'
/*
putexcel B23=`m_hhsize'
putexcel C23=`b_hhsize'

putexcel B24=`m_hhsize2'
putexcel C24=`b_hhsize2'
*/
putexcel B23=`m_depen_ch'
*putexcel C25=`b_depen_ch'

putexcel B24=`m_depen_old'
*putexcel C26=`b_depen_old'

putexcel B25=`m_female_hh'
*putexcel C27=`b_female_hh'

putexcel B26=`m_educ_hh'
*putexcel C28=`b_educ_hh'

putexcel B27=`m_age_hh'
*putexcel C29=`b_age_hh'

putexcel B28=`m_sh_educ0_8'
*putexcel C30=`b_sh_educ0_8'

putexcel B29=`m_sh_educ9_13'
*putexcel C31=`b_sh_educ9_13'

putexcel B30=`m_sh_educ14_plus'
*putexcel C32=`b_sh_educ14_plus'

putexcel B31=`m_sh_literate'
*putexcel C33=`b_sh_literate'

}

forvalues i=1(1)100 {
import excel "$results\results_error\no_error_means_`i'.xlsx", sheet("Sheet1") clear
rename B value_`i'
tempfile noerror_`i'
save `noerror_`i''
}

use `noerror_1', clear
forvalues i=2(1)100 {
merge 1:1 A using `noerror_`i''
drop _merge
}

egen mean_var_noerror=rowmean(value_1 value_2 value_3 value_4 value_5 value_6 value_7 value_8 value_9 value_10 value_11 value_12 value_13 value_14 value_15 value_16 value_17 value_18 value_19 value_20 value_21 value_22 value_23 value_24 value_25 value_26 value_27 value_28 value_29 value_30 value_31 value_32 value_33 value_34 value_35 value_36 value_37 value_38 value_39 value_40 value_41 value_42 value_43 value_44 value_45 value_46 value_47 value_48 value_49 value_50 value_51 value_52 value_53 value_54 value_55 value_56 value_57 value_58 value_59 value_60 value_61 value_62 value_63 value_64 value_65 value_66 value_67 value_68 value_69 value_70 value_71 value_72 value_73 value_74 value_75 value_76 value_77 value_78 value_79 value_80 value_81 value_82 value_83 value_84 value_85 value_86 value_87 value_88 value_89 value_90 value_91 value_92 value_93 value_94 value_95 value_96 value_97 value_98 value_99 value_100)

keep A mean_var

tempfile noerror
save `noerror'



forvalues i=1(1)100 {
import excel "$results\results_error\errorh_means_`i'.xlsx", sheet("Sheet1") clear
rename B value_`i'
tempfile errorh_`i'
save `errorh_`i''
}

use `errorh_1', clear
forvalues i=2(1)100 {
merge 1:1 A using `errorh_`i''
drop _merge
}

egen mean_var_errorh=rowmean(value_1 value_2 value_3 value_4 value_5 value_6 value_7 value_8 value_9 value_10 value_11 value_12 value_13 value_14 value_15 value_16 value_17 value_18 value_19 value_20 value_21 value_22 value_23 value_24 value_25 value_26 value_27 value_28 value_29 value_30 value_31 value_32 value_33 value_34 value_35 value_36 value_37 value_38 value_39 value_40 value_41 value_42 value_43 value_44 value_45 value_46 value_47 value_48 value_49 value_50 value_51 value_52 value_53 value_54 value_55 value_56 value_57 value_58 value_59 value_60 value_61 value_62 value_63 value_64 value_65 value_66 value_67 value_68 value_69 value_70 value_71 value_72 value_73 value_74 value_75 value_76 value_77 value_78 value_79 value_80 value_81 value_82 value_83 value_84 value_85 value_86 value_87 value_88 value_89 value_90 value_91 value_92 value_93 value_94 value_95 value_96 value_97 value_98 value_99 value_100)

keep A mean_var

tempfile errorh
save `errorh'



forvalues i=1(1)100 {
import excel "$results\results_error\errorl_means_`i'.xlsx", sheet("Sheet1") clear
rename B value_`i'
tempfile errorl_`i'
save `errorl_`i''
}

use `errorl_1', clear
forvalues i=2(1)100 {
merge 1:1 A using `errorl_`i''
drop _merge
}

egen mean_var_errorl=rowmean(value_1 value_2 value_3 value_4 value_5 value_6 value_7 value_8 value_9 value_10 value_11 value_12 value_13 value_14 value_15 value_16 value_17 value_18 value_19 value_20 value_21 value_22 value_23 value_24 value_25 value_26 value_27 value_28 value_29 value_30 value_31 value_32 value_33 value_34 value_35 value_36 value_37 value_38 value_39 value_40 value_41 value_42 value_43 value_44 value_45 value_46 value_47 value_48 value_49 value_50 value_51 value_52 value_53 value_54 value_55 value_56 value_57 value_58 value_59 value_60 value_61 value_62 value_63 value_64 value_65 value_66 value_67 value_68 value_69 value_70 value_71 value_72 value_73 value_74 value_75 value_76 value_77 value_78 value_79 value_80 value_81 value_82 value_83 value_84 value_85 value_86 value_87 value_88 value_89 value_90 value_91 value_92 value_93 value_94 value_95 value_96 value_97 value_98 value_99 value_100)

keep A mean_var

tempfile errorl
save `errorl'

use `noerror', clear
merge 1:1 A using `errorh'
drop _merge
merge 1:1 A using `errorl'
drop _merge
