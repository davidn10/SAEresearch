cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"



forvalues i=1(1)32 {
	use "Census_2020\Censo2020_CA_`i'_dta\Personas`i'.dta", clear
	do "Census_2020\Censo2020_CA_`i'_dta\Personas.do"
	keep ENT NOM_ENT MUN NOM_MUN ID_VIV ESTRATO UPM FACTOR SEXO EDAD PARENTESCO ASISTEN ALFABET ESCOACUM CONACT SITTRA INGTRMEN TAMLOC*

	tempfile district_`i'
	save `district_`i''
}

use `district_1', clear
forvalues i=2(1)32 {
	append using `district_`i''
}

save "Census_2020\census_ind_2020.dta", replace



forvalues i=1(1)32 {
	use "Census_2020\Censo2020_CA_`i'_dta\Viviendas`i'.dta", clear
	do "Census_2020\Censo2020_CA_`i'_dta\Viviendas.do"
	keep ENT NOM_ENT MUN NOM_MUN ID_VIV ESTRATO UPM FACTOR PAREDES TECHOS PISOS COCINA CUADORM TOTCUART LUG_COC COMBUSTIBLE ESTUFA ELECTRICIDAD AGUA_ENTUBADA ABA_AGUA_ENTU ABA_AGUA_NO_ENTU REGADERA SERSAN CONAGUA DRENAJE REFRIGERADOR LAVADORA AUTOPROP BICICLETA MOTOCICLETA RADIO TELEVISOR COMPUTADORA TELEFONO CELULAR INTERNET TENENCIA NUMPERS INGTRHOG JEFE_SEXO JEFE_EDAD TAMLOC TAMLOC_E

	tempfile district_`i'
	save `district_`i''
}

use `district_1', clear
forvalues i=2(1)32 {
	append using `district_`i''
}

save "Census_2020\census_viv_2020.dta", replace
