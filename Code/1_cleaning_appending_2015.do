cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

forvalues i=1(1)32 {
	use "intercensal_2015\eic2015_`i'_dta\Tr_persona`i'.dta", clear
	do "intercensal_2015\eic2015_`i'_dta\personas.do"
	keep ID_VIV ID_PERSONA ENT NOM_ENT MUN NOM_MUN LOC50K NOM_LOC COBERTURA ESTRATO UPM FACTOR NUMPER SEXO EDAD PARENT PARENT_OTRO_C PARENT_OTRO_C_E ESCOLARI NIVACAD ALFABET ESCOACUM CONACT         	SITUACION_TRAB INGTRMEN TAMLOC

	tempfile district_`i'
	save `district_`i''
}

use `district_1', clear
forvalues i=2(1)32 {
	append using `district_`i''
}

save "intercensal_2015\intercensal_ind_2015.dta", replace



forvalues i=1(1)32 {
	use "intercensal_2015\eic2015_`i'_dta\Tr_vivienda`i'.dta", clear
	do "intercensal_2015\eic2015_`i'_dta\viviendas.do"
	drop ING_ALIM_MEN3 ING_ALIM_MEN2 ING_ALIM_MEN1 ALIM_MEN3 ALIM_MEN2 ALIM_MEN1 ING_ALIM_ADU1 ING_ALIM_ADU2 ING_ALIM_ADU3 ALIM_ADU1 ALIM_ADU2 ALIM_ADU3 NUM_DUE_TERR TERRENO_VIVERO TERRENO_AGROPE INGR_JUBPEN INGR_AYUGOB INGR_PERDENTPAIS INGR_PEROTROPAIS

	tempfile district_`i'
	save `district_`i''
}

use `district_1', clear
forvalues i=2(1)32 {
	append using `district_`i''
}

save "intercensal_2015\intercensal_viv_2015.dta", replace
