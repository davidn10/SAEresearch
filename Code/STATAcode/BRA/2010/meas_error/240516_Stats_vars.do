** This is new BRA 2010 program 
clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

* global currdata "D:\SAE_project\MEX\2010\full_census_new"
global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"

global census "$currdata\census\"
global results "$currdata\results"


set seed 648743


forvalues i=1(1)100 {

putexcel set "$results\error\no_error_means_`i'", replace

use "$currdata\rawsamples\sample_`i'.dta", clear
merge 1:1 hid using "$census\census.dta"
keep if _merge==3

foreach var in over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet hhsize female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old hhsize2 {
	sum `var', d
	local m_`var'=r(mean)
	*local b_`var'=r(sd)
}

putexcel A2="Improved walls"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a motorcycle"
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



putexcel B2=`m_wall_improved'

putexcel B3=`m_water_improved'

putexcel B4=`m_electri'

putexcel B5=`m_sewage'

putexcel B6=`m_own_house'

putexcel B7=`m_good_house'

putexcel B8=`m_over_crowding'

putexcel B9=`m_over_crowding_ext'

putexcel B10=`m_motorcy'

putexcel B11=`m_radio'

putexcel B12=`m_tele'

putexcel B13=`m_fridge'

putexcel B14=`m_washing'

putexcel B15=`m_auto'

putexcel B16=`m_compu'

putexcel B17=`m_cell'

putexcel B18=`m_internet'

putexcel B19=`m_hhsize'

putexcel B20=`m_hhsize2'

putexcel B21=`m_female_hh'

putexcel B22=`m_age_hh'

putexcel B23=`m_hh_primedu'

putexcel B24=`m_hh_secondedu'

putexcel B25=`m_hh_superior'

putexcel B26=`m_sh_primedu'

putexcel B27=`m_sh_secedu'

putexcel B28=`m_sh_supedu'

putexcel B29=`m_sh_literate'

putexcel B30=`m_sh_noedu'

putexcel B31=`m_depen_ch'

putexcel B32=`m_depen_old'

 



putexcel set "$results\error\errorh_means_`i'", replace

use "$currdata\rawsamples_error\sample_`i'.dta", clear


drop *_low 
drop over_crowding_ext 
gen hhsize2=hhsize^2 

foreach var in over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house   good_house motorcy radio tele fridge washing auto compu cell internet female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old {
	rename `var'_high `var'
}


foreach var in over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet hhsize female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old hhsize2 {
	sum `var', d
	local m_`var'=r(mean)
	local b_`var'=r(sd)
}


putexcel A2="Improved walls"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a motorcycle"
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


putexcel B2=`m_wall_improved'

putexcel B3=`m_water_improved'

putexcel B4=`m_electri'

putexcel B5=`m_sewage'

putexcel B6=`m_own_house'

putexcel B7=`m_good_house'

putexcel B8=`m_over_crowding'

putexcel B9=`m_over_crowding_ext'

putexcel B10=`m_motorcy'

putexcel B11=`m_radio'

putexcel B12=`m_tele'

putexcel B13=`m_fridge'

putexcel B14=`m_washing'

putexcel B15=`m_auto'

putexcel B16=`m_compu'

putexcel B17=`m_cell'

putexcel B18=`m_internet'

putexcel B19=`m_hhsize'

putexcel B20=`m_hhsize2'

putexcel B21=`m_female_hh'

putexcel B22=`m_age_hh'

putexcel B23=`m_hh_primedu'

putexcel B24=`m_hh_secondedu'

putexcel B25=`m_hh_superior'

putexcel B26=`m_sh_primedu'

putexcel B27=`m_sh_secedu'

putexcel B28=`m_sh_supedu'

putexcel B29=`m_sh_literate'

putexcel B30=`m_sh_noedu'

putexcel B31=`m_depen_ch'

putexcel B32=`m_depen_old'



putexcel set "$results\error\errorl_means_`i'", replace

use "$currdata\rawsamples_error\sample_`i'.dta", clear

drop *_high
drop over_crowding_ext 
gen hhsize2=hhsize^2 

foreach var in over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house   good_house motorcy radio tele fridge washing auto compu cell internet female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old {
	rename `var'_low `var'
}


foreach var in over_crowding over_crowding_ext wall_improved water_improved electri sewage own_house good_house motorcy radio tele fridge washing auto compu cell internet hhsize female_hh hh_primedu hh_secondedu hh_superior age_hh sh_primedu sh_secedu sh_supedu sh_noedu sh_literate depen_ch depen_old hhsize2 {
	sum `var', d
	local m_`var'=r(mean)
	local b_`var'=r(sd)
}

putexcel A2="Improved walls"
putexcel A3="Improved water"
putexcel A4="Access to electricity"
putexcel A5="Access to sewage"
putexcel A6="Own a house"
putexcel A7="Good house"
putexcel A8="Over crowding"
putexcel A9="Over crowding extreme"
putexcel A10="Has a motorcycle"
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



putexcel B2=`m_wall_improved'

putexcel B3=`m_water_improved'

putexcel B4=`m_electri'

putexcel B5=`m_sewage'

putexcel B6=`m_own_house'

putexcel B7=`m_good_house'

putexcel B8=`m_over_crowding'

putexcel B9=`m_over_crowding_ext'

putexcel B10=`m_motorcy'

putexcel B11=`m_radio'

putexcel B12=`m_tele'

putexcel B13=`m_fridge'

putexcel B14=`m_washing'

putexcel B15=`m_auto'

putexcel B16=`m_compu'

putexcel B17=`m_cell'

putexcel B18=`m_internet'

putexcel B19=`m_hhsize'

putexcel B20=`m_hhsize2'

putexcel B21=`m_female_hh'

putexcel B22=`m_age_hh'

putexcel B23=`m_hh_primedu'

putexcel B24=`m_hh_secondedu'

putexcel B25=`m_hh_superior'

putexcel B26=`m_sh_primedu'

putexcel B27=`m_sh_secedu'

putexcel B28=`m_sh_supedu'

putexcel B29=`m_sh_literate'

putexcel B30=`m_sh_noedu'

putexcel B31=`m_depen_ch'

putexcel B32=`m_depen_old'

}

forvalues i=1(1)100 {
import excel "$results\error\no_error_means_`i'.xlsx", sheet("Sheet1") clear
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
import excel "$results\error\errorh_means_`i'.xlsx", sheet("Sheet1") clear
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
import excel "$results\error\errorl_means_`i'.xlsx", sheet("Sheet1") clear
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
