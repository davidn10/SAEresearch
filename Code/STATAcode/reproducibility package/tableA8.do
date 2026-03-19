putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("TableA8")
global results_MEX_2010 "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results"
global results_MEX_2015 "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new\results"
global results_MEX_2020 "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census\results"
global results_BRA_2000 "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results"
global results_BRA_2010 "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new\results"

local rc_row=5
local mae_row=11

foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	
	* RC files 
local rc_file_ell "${results_`dataset'}/results_ell/rankcorr_ell_unit"
local rc_file_ell_het_normal "${results_`dataset'}/results_ell_het_normal/rankcorr_ell_unit"
local rc_file_ell_nohet_normal "${results_`dataset'}/results_ell_nohet_normal/rankcorr_ell_unit"
local rc_file_ell_nohet_nonnormal "${results_`dataset'}/results_ell_nohet_nonnormal/rankcorr_ell_unit"


** MAE files 
local mae_file_ell "${results_`dataset'}/results_ell/errors_ell_unit"
local mae_file_ell_het_normal "${results_`dataset'}/results_ell_het_normal/errors_ell_unit"
local mae_file_ell_nohet_normal "${results_`dataset'}/results_ell_nohet_normal/errors_ell_unit"
local mae_file_ell_nohet_nonnormal "${results_`dataset'}/results_ell_nohet_nonnormal/errors_ell_unit"

foreach variant in ell ell_het_normal ell_nohet_normal ell_nohet_nonnormal {
	dis "`variant'"
	
	* rank correlation 
	import excel using "`rc_file_`variant''.xlsx", clear 
	dis "`rc_file_`variant''.xlsx"
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar rc_`variant'_`dataset'=r(mean)
	su B 	
	scalar rc_`variant'_`dataset'i=r(mean)	
	su C 
	scalar rc_`variant'_`dataset'o=r(mean)	
	
	
	** MAE 
	import excel using "`mae_file_`variant''.xlsx", clear 
	dis "`mae_file_`variant''.xlsx"
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar e_`variant'_`dataset'=r(mean)
	su B 
	scalar e_`variant'_`dataset'i=r(mean)
	su C 
	scalar e_`variant'_`dataset'o=r(mean)
	
}	
	
	putexcel B`rc_row'=rc_ell_`dataset'
	putexcel C`rc_row'=rc_ell_het_normal_`dataset'
	putexcel D`rc_row'=rc_ell_nohet_normal_`dataset'
	putexcel E`rc_row'=rc_ell_nohet_nonnormal_`dataset'
	
	putexcel B`mae_row'=e_ell_`dataset'
	putexcel C`mae_row'=e_ell_het_normal_`dataset'
	putexcel D`mae_row'=e_ell_nohet_normal_`dataset'
	putexcel E`mae_row'=e_ell_nohet_nonnormal_`dataset'
	
	putexcel F`rc_row'=rc_ell_`dataset'i
	putexcel G`rc_row'=rc_ell_het_normal_`dataset'i
	putexcel H`rc_row'=rc_ell_nohet_normal_`dataset'i
	putexcel I`rc_row'=rc_ell_nohet_nonnormal_`dataset'i
	
	putexcel F`mae_row'=e_ell_`dataset'i
	putexcel G`mae_row'=e_ell_het_normal_`dataset'i
	putexcel H`mae_row'=e_ell_nohet_normal_`dataset'i
	putexcel I`mae_row'=e_ell_nohet_nonnormal_`dataset'i
	
	putexcel J`rc_row'=rc_ell_`dataset'o
	putexcel K`rc_row'=rc_ell_het_normal_`dataset'o
	putexcel L`rc_row'=rc_ell_nohet_normal_`dataset'o
	putexcel M`rc_row'=rc_ell_nohet_nonnormal_`dataset'o
	
	putexcel J`mae_row'=e_ell_`dataset'o
	putexcel K`mae_row'=e_ell_het_normal_`dataset'o
	putexcel L`mae_row'=e_ell_nohet_normal_`dataset'o
	putexcel M`mae_row'=e_ell_nohet_nonnormal_`dataset'o
	

	local rc_row=`rc_row'+1 
	local mae_row=`mae_row'+1 
}







