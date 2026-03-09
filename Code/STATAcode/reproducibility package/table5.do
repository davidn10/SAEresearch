* append together, take averages, and output to spreadsheet 
* 1. Skewness and kurtosis  
* a. `estimate' unit and context 
putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("Table5")
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



foreach estimate in ebp ell uc sub_ebp brf fh nopsu {
foreach type in total in out {
local rc_MEX_`estimate'_`type'=(rc_`estimate'_`type'_MEX_2010+rc_`estimate'_`type'_MEX_2015+rc_`estimate'_`type'_MEX_2020)/3
local rc_BRA_`estimate'_`type'=(rc_`estimate'_`type'_BRA_2000+rc_`estimate'_`type'_BRA_2010)/2 

local mae_MEX_`estimate'_`type'=(mae_`estimate'_`type'_MEX_2010+mae_`estimate'_`type'_MEX_2015+mae_`estimate'_`type'_MEX_2020)/3
local mae_BRA_`estimate'_`type'=(mae_`estimate'_`type'_BRA_2000+mae_`estimate'_`type'_BRA_2010)/2 
}
}

local rc_MEX_dir_in=(rc_dir_in_MEX_2010+rc_dir_in_MEX_2015+rc_dir_in_MEX_2020)/3
local rc_BRA_dir_in=(rc_dir_in_BRA_2000+rc_dir_in_BRA_2010)/2

local mae_MEX_dir_in=(mae_dir_in_MEX_2010+mae_dir_in_MEX_2015+mae_dir_in_MEX_2020)/3
local mae_BRA_dir_in=(mae_dir_in_BRA_2000+mae_dir_in_BRA_2010)/2



local rc_row_ebp=4 
local rc_row_ell=5 
local rc_row_uc=6 
local rc_row_sub_ebp=7 
local rc_row_brf=8 
local rc_row_fh=9 
local rc_row_nopsu=10 

local mae_row_ebp=12 
local mae_row_ell=13 
local mae_row_uc=14 
local mae_row_sub_ebp=15 
local mae_row_brf=16 
local mae_row_fh=17 
local mae_row_nopsu=18 

foreach estimate in ebp ell uc sub_ebp brf fh nopsu {
putexcel D`rc_row_`estimate''=`rc_MEX_`estimate'_total'
putexcel E`rc_row_`estimate''=`rc_MEX_`estimate'_in'
putexcel F`rc_row_`estimate''=`rc_MEX_`estimate'_out'

putexcel G`rc_row_`estimate''=`rc_BRA_`estimate'_total'
putexcel H`rc_row_`estimate''=`rc_BRA_`estimate'_in'
putexcel I`rc_row_`estimate''=`rc_BRA_`estimate'_out'

putexcel D`mae_row_`estimate''=`mae_MEX_`estimate'_total'
putexcel E`mae_row_`estimate''=`mae_MEX_`estimate'_in'
putexcel F`mae_row_`estimate''=`mae_MEX_`estimate'_out'

putexcel G`mae_row_`estimate''=`mae_BRA_`estimate'_total'
putexcel H`mae_row_`estimate''=`mae_BRA_`estimate'_in'
putexcel I`mae_row_`estimate''=`mae_BRA_`estimate'_out'
} 

putexcel E3 = `rc_MEX_dir_in'
putexcel H3 = `rc_BRA_dir_in'

putexcel E11 = `mae_MEX_dir_in'
putexcel H11 = `mae_BRA_dir_in'


