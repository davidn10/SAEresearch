cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"


use "census_2010\census_proc_MEX_2010", clear
drop strata*

***UPM ID
egen upm_id=concat(ENT MUN TAM_LOC UPM)

***Generating strata
set seed 3454
egen strata = group(ENT TAM_LOC)

***Number of HH per UPM
g aux=1
bys upm_id: egen numberhh_upm=sum(aux)
drop aux
bys upm_id: egen numberhh_upm_w=sum(FACTOR)


***Sample of UPMs by strata porportional to size
keep ENT MUN TAM_LOC UPM strata upm_id numberhh_upm numberhh_upm_w 
duplicates drop

***Number of upms by strata
bys strata: g num_upm=_N


***Sample for strata with upms less than minimum size
forvalues i=1(1)40 {
preserve 
keep if (num_upm*0.06)<0.5
set sortseed 54321
gsample 1,  strata(strata) wor //comparing sample in survey versus census, survey has approx: 6% of census UPMs
g sample_`i'=1
keep strata upm_id sample_`i'
***Number of upms by strata
bys strata: g num_upm_select_`i'=_N

tempfile upm_selectext_`i'
save `upm_selectext_`i''
restore

***Sample for the rest of strata
preserve
set sortseed 54321
gsample 6, percent  strata(strata) wor //comparing sample in survey versus census, survey has approx: 6% of census UPMs
g sample_`i'=1
keep strata upm_id sample_`i'
***Number of upms by strata
bys strata: g num_upm_select_`i'=_N

append using `upm_selectext_`i''

tempfile upm_select_`i'
save `upm_select_`i''
save "census_2010\subsample\upm_select_`i'.dta", replace
restore
}

************************************************************************************
***For each sub-sample
forvalues i=1(1)40 {
use "census_2010\census_proc_MEX_2010", clear
drop strata*

***Generating strata
set seed 3454
egen strata = group(ENT TAM_LOC)

***UPM ID
egen upm_id=concat(ENT MUN TAM_LOC UPM)

***Number of upms by strata
preserve
keep strata upm_id
duplicates drop
bys strata: g num_upm=_N

keep strata num_upm
duplicates drop
tempfile strata_size
save `strata_size'
restore

merge m:1 strata using `strata_size'
drop _merge


***Number of HH per UPM
g aux=1
bys upm_id: egen numberhh_upm=sum(aux)
drop aux

merge m:1 upm_id using "census_2010\subsample\upm_select_`i'.dta"
keep if _merge==3
drop _merge

***Probability  of UPM being selected
g prob_select_upm= num_upm_select_`i'/num_upm
sum prob_select_upm

***Selection of HH
preserve
keep if TAM_LOC>=1 & TAM_LOC<=3
set sortseed 54321
sample 24, count by(upm_id)
g sample_hh=1
keep hid sample_hh
tempfile sample_24
save `sample_24'
restore

preserve
keep if TAM_LOC==4
set sortseed 54321
sample 6, count by(upm_id)
g sample_hh=1
keep hid sample_hh
tempfile sample_6
save `sample_6'
restore

preserve
use `sample_24', clear
append using `sample_6'
tempfile sample_hh
save `sample_hh'
restore

merge m:1 hid using `sample_hh'
keep if _merge==3
drop _merge

***Probability of HH being selected
g aux=1
bys upm_id: egen num_hh_select=sum(aux)
drop aux

g prob_select_hh= num_hh_select/numberhh_upm
sum prob_select_hh

***Factor de expansion
g prob_select=prob_select_hh*prob_select_upm

gen factor_sample=(1/prob_select)

g factor_total=factor_sample*FACTOR


egen test=sum(factor_sample)
sum test
egen test2=sum(factor_total)
sum test2


***Summary statistics
foreach var in wall_improved roof_improved floor_improved water_improved electri over_crowding pchinc_hh hhsize female_hh educhh sh_literate depen_ch depen_old own_house flush_toilet tele fridge stove internet compu cell auto {
	sum `var' [aw=factor_total]
	local m`i'_`var'=r(mean)
	local sd`i'_`var'=r(sd)

	
}

putexcel set "census_2010\subsample\results\desc_stats_`i'", replace

putexcel B1="mean`i'"
putexcel C1="sd`i'"

putexcel A2="pchinc_hh"
putexcel A3="female_hh"
putexcel A4="hhsize"
putexcel A5="educhh"
putexcel A6="sh_literate"
putexcel A7="depen_ch"
putexcel A8="depen_old"
putexcel A9="wall_improved"
putexcel A10="roof_improved"
putexcel A11="floor_improved"
putexcel A12="water_improved"
putexcel A13="electri"
putexcel A14="over_crowding"
putexcel A15="own_house" 
putexcel A16="flush_toilet" 
putexcel A17="tele fridge" 
putexcel A18="stove" 
putexcel A19="internet" 
putexcel A20="compu" 
putexcel A21="cell" 
putexcel A22="auto"

putexcel B2=`m`i'_pchinc_hh'
putexcel B3=`m`i'_female_hh'
putexcel B4=`m`i'_hhsize'
putexcel B5=`m`i'_educhh'
putexcel B6=`m`i'_sh_literate'
putexcel B7=`m`i'_depen_ch'
putexcel B8=`m`i'_depen_old'
putexcel B9=`m`i'_wall_improved'
putexcel B10=`m`i'_roof_improved'
putexcel B11=`m`i'_floor_improved'
putexcel B12=`m`i'_water_improved'
putexcel B13=`m`i'_electri'
putexcel B14=`m`i'_over_crowding'
putexcel B15=`m`i'_own_house' 
putexcel B16=`m`i'_flush_toilet' 
putexcel B17=`m`i'_tele fridge' 
putexcel B18=`m`i'_stove' 
putexcel B19=`m`i'_internet' 
putexcel B20=`m`i'_compu' 
putexcel B21=`m`i'_cell' 
putexcel B22=`m`i'_auto'

putexcel C2=`sd`i'_pchinc_hh'
putexcel C3=`sd`i'_female_hh'
putexcel C4=`sd`i'_hhsize'
putexcel C5=`sd`i'_educhh'
putexcel C6=`sd`i'_sh_literate'
putexcel C7=`sd`i'_depen_ch'
putexcel C8=`sd`i'_depen_old'
putexcel C9=`sd`i'_wall_improved'
putexcel C10=`sd`i'_roof_improved'
putexcel C11=`sd`i'_floor_improved'
putexcel C12=`sd`i'_water_improved'
putexcel C13=`sd`i'_electri'
putexcel C14=`sd`i'_over_crowding'
putexcel C15=`sd`i'_own_house' 
putexcel C16=`sd`i'_flush_toilet' 
putexcel C17=`sd`i'_tele fridge' 
putexcel C18=`sd`i'_stove' 
putexcel C19=`sd`i'_internet' 
putexcel C20=`sd`i'_compu' 
putexcel C21=`sd`i'_cell' 
putexcel C22=`sd`i'_auto'
}

use "census_2010\census_proc_MEX_2010", clear

foreach var in wall_improved roof_improved floor_improved water_improved electri over_crowding pchinc_hh hhsize female_hh educhh sh_literate depen_ch depen_old own_house flush_toilet tele fridge stove internet compu cell auto {
	sum `var' [aw=FACTOR]
	local m_`var'=r(mean)
	local sd_`var'=r(sd)
}	
putexcel set "census_2010\subsample\results\desc_stats", replace

putexcel B1="mean"
putexcel C1="sd"

putexcel A2="pchinc_hh"
putexcel A3="female_hh"
putexcel A4="hhsize"
putexcel A5="educhh"
putexcel A6="sh_literate"
putexcel A7="depen_ch"
putexcel A8="depen_old"
putexcel A9="wall_improved"
putexcel A10="roof_improved"
putexcel A11="floor_improved"
putexcel A12="water_improved"
putexcel A13="electri"
putexcel A14="over_crowding"
putexcel A15="own_house" 
putexcel A16="flush_toilet" 
putexcel A17="tele fridge" 
putexcel A18="stove" 
putexcel A19="internet" 
putexcel A20="compu" 
putexcel A21="cell" 
putexcel A22="auto"

putexcel B2=`m_pchinc_hh'
putexcel B3=`m_female_hh'
putexcel B4=`m_hhsize'
putexcel B5=`m_educhh'
putexcel B6=`m_sh_literate'
putexcel B7=`m_depen_ch'
putexcel B8=`m_depen_old'
putexcel B9=`m_wall_improved'
putexcel B10=`m_roof_improved'
putexcel B11=`m_floor_improved'
putexcel B12=`m_water_improved'
putexcel B13=`m_electri'
putexcel B14=`m_over_crowding'
putexcel B15=`m_own_house' 
putexcel B16=`m_flush_toilet' 
putexcel B17=`m_tele' 
putexcel B18=`m_stove' 
putexcel B19=`m_internet' 
putexcel B20=`m_compu' 
putexcel B21=`m_cell' 
putexcel B22=`m_auto'

putexcel C2=`sd_pchinc_hh'
putexcel C3=`sd_female_hh'
putexcel C4=`sd_hhsize'
putexcel C5=`sd_educhh'
putexcel C6=`sd_sh_literate'
putexcel C7=`sd_depen_ch'
putexcel C8=`sd_depen_old'
putexcel C9=`sd_wall_improved'
putexcel C10=`sd_roof_improved'
putexcel C11=`sd_floor_improved'
putexcel C12=`sd_water_improved'
putexcel C13=`sd_electri'
putexcel C14=`sd_over_crowding'
putexcel C15=`sd_own_house' 
putexcel C16=`sd_flush_toilet' 
putexcel C17=`sd_tele' 
putexcel C18=`sd_stove' 
putexcel C19=`sd_internet' 
putexcel C20=`sd_compu' 
putexcel C21=`sd_cell' 
putexcel C22=`sd_auto'

***Averages acroos samples
forvalues i=1(1)40{
import excel "census_2010\subsample\results\desc_stats_`i'.xlsx", sheet("Sheet1") firstrow clear
save "census_2010\subsample\results\desc_stats_`i'.dta", replace
}

import excel "census_2010\subsample\results\desc_stats.xlsx", sheet("Sheet1") firstrow clear
save "census_2010\subsample\results\desc_stats.dta", replace

use "census_2010\subsample\results\desc_stats_1.dta", clear
forvalues i=2(1)40{
	merge 1:1 A using  "census_2010\subsample\results\desc_stats_`i'.dta"
	drop _merge
	}
	
egen mean_ag=rowmean(mean*)
egen sd_ag=rowmean(sd*)

merge 1:1 A using  "census_2010\subsample\results\desc_stats"




/*

g aux=1
bys strata: egen numberupm_strata=sum(aux)
gen selectupm_strata=round(0.06*numberupm_strata) //6% of upms considering # of UMP in ENIGH

***Sample of upms by strata
levelsof strata, local(index)
    forvalues i=2(1)127 {
	sum selectupm_strata if strata == `i'
	local h2 =`r(mean)'   
	local h2: disp %2.0f `h2'
	samplepps treatment_upm_`i' if strata == `i', size(numberhh_upm) ncases(`h2')
	}
*/


