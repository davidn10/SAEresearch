cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

forvalues i=1(1)32 {
	use "census_2010\MC2010_`i'_dta\personas_`i'.dta", clear
	do "census_2010\MC2010_`i'_dta\Personas.do"
	keep ENT NOM_ENT MUN NOM_MUN LOC50K NOM_LOC ID_VIV ID_PER NUMPER SEXO EDAD PARENT ASISTEN ESCOLARI NIVACAD ESCOACUM NIV_CAR NIV_CAR_E ALFABET CONACT SITTRA INGTRMEN HORTRA FACTOR ESTRATO UPM    CERTEZA TAM_LOC

	tempfile district_`i'
	save `district_`i''
}

use `district_1', clear
forvalues i=2(1)32 {
	append using `district_`i''
}

save "census_2010\census_ind_2010.dta", replace


forvalues i=1(1)32 {
	use "census_2010\MC2010_`i'_dta\viviendas_`i'.dta", clear
	do "census_2010\MC2010_`i'_dta\Vivienda.do"

	tempfile district_`i'
	save `district_`i''
}

use `district_1', clear
forvalues i=2(1)32 {
	append using `district_`i''
}

save "census_2010\census_viv_2010.dta", replace