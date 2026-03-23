* append together, take averages, and output to spreadsheet 
* 1. Skewness and kurtosis  
* a. `estimate' unit and context 
putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("TableA3")
global results_MEX_2010 "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results"
global results_MEX_2015 "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new\results"
global results_MEX_2020 "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census\results"
global results_BRA_2000 "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results"
global results_BRA_2010 "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new\results"


clear 
* Rank correlation 
** unit 


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	local rc_file_ebp "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_h"
	local rc_file_ell "${results_`dataset'}/results_ell/rankcorr_ell_unit"
	local rc_file_uc "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"	
	local rc_file_sub_ebp "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_h" 
	local rc_file_nopsu "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_h"
	local rc_file_brf "${results_`dataset'}/results_brf_v2/rankcorr_BRF_subarea" 
	local rc_file_fh "${results_`dataset'}/results_fh_smooth/rankcorr_fh_smooth" 
	
	
	local mae_file_ebp "${results_`dataset'}/results_ebp/errors_ebp_unit_h"
	local mae_file_ell "${results_`dataset'}/results_ell/errors_ell_unit"
	local mae_file_uc "${results_`dataset'}/results_ebp/errors_ebp_context_h"
	local mae_file_sub_ebp "${results_`dataset'}/results_sub_ebp/errors_subEBP_h" 
	local mae_file_nopsu "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_h"
	local mae_file_brf "${results_`dataset'}/results_brf_v2/errors_BRF_subarea" 
	local mae_file_fh "${results_`dataset'}/results_fh_smooth/errors_fh_smooth" 
	
	foreach estimate in ebp ell uc sub_ebp brf fh nopsu {
		dis "`estimate'"
		import excel using "`rc_file_`estimate''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A-C 
		su A 
		scalar rc_`estimate'_total_`dataset'=r(mean)
		su B 
		scalar rc_`estimate'_in_`dataset'=r(mean)
		su C
		scalar rc_`estimate'_out_`dataset'=r(mean)
		
		import excel using "`mae_file_`estimate''.xlsx", clear 
		count 
		assert r(N)==100 
		su A 
		scalar mae_`estimate'_total_`dataset'=r(mean)
		su B 
		scalar mae_`estimate'_in_`dataset'=r(mean)
		su C
		scalar mae_`estimate'_out_`dataset'=r(mean)		
	} // close loop over estimates 
	** add direct estimates 
	
	import excel using "`rc_file_ebp'.xlsx", clear 
	keep E 
	su E 
	scalar rc_dir_in_`dataset'=r(mean) 

	import excel using "`mae_file_ebp'.xlsx", clear 
	keep E 
	su E 
	scalar mae_dir_in_`dataset'=r(mean) 
} 





local cols "C D E F G H I"
local rc_row=4
local mae_row=11

foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
putexcel B`rc_row'=rc_dir_in_`dataset'	
putexcel B`mae_row'=mae_dir_in_`dataset'	
local estimatenum=1 
	foreach estimate in ebp ell uc sub_ebp fh nopsu brf {
	local col : word `estimatenum' of `cols'
	putexcel `col'`rc_row'=rc_`estimate'_total_`dataset'
	putexcel `col'`mae_row'=mae_`estimate'_total_`dataset'
	local estimatenum=`estimatenum'+1
	}	
	local rc_row=`rc_row'+1
	local mae_row=`mae_row'+1 
} 
	
	