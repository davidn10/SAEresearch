cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\tables.xlsx", modify sheet("TableA5")

global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"

local row=4


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	
	* RC files 
local rc_file_ebp "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_h"
local rc_file_ebp_norescale "${results_`dataset'}/results_ebp_norescale/rankcorr_ebp_unit_norescale"

local rc_file_ell "${results_`dataset'}/results_ell/rankcorr_ell_unit"
local rc_file_ell_norescale "${results_`dataset'}/results_ell_norescale/rankcorr_ell_norescale_unit"

local rc_file_uc "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"	
local rc_file_uc_norescale "${results_`dataset'}/results_ebp_norescale/rankcorr_EBP_context_norescale"	
	

local rc_file_sub_ebp "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_h" 
local rc_file_sub_ebp_norescale "${results_`dataset'}/results_sub_ebp_norescale/rankcorr_EBP_subarea_norescale" 

local rc_file_brf "${results_`dataset'}/results_brf/rankcorr_brf_subarea" 
local rc_file_brf_norescale "${results_`dataset'}/results_brf_norescale/rankcorr_BRF_norescale_subarea" 
 
local rc_file_nopsu "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_h"
local rc_file_nopsu_norescale "${results_`dataset'}/results_ebp_norescale/rankcorr_ebp_nopsu_norescale"


** MAE files 
local mae_file_ebp "${results_`dataset'}/results_ebp/errors_EBP_unit_h"
local mae_file_ebp_norescale "${results_`dataset'}/results_ebp_norescale/errors_EBP_unit_norescale"

local mae_file_ell "${results_`dataset'}/results_ell/errors_ell_unit"
local mae_file_ell_norescale "${results_`dataset'}/results_ell_norescale/errors_ell_norescale_unit"

local mae_file_uc "${results_`dataset'}/results_ebp/errors_ebp_context_h"	
local mae_file_uc_norescale "${results_`dataset'}/results_ebp_norescale/errors_EBP_context_norescale"	

local mae_file_sub_ebp "${results_`dataset'}/results_sub_ebp/errors_subEBP_h" 
local mae_file_sub_ebp_norescale "${results_`dataset'}/results_sub_ebp_norescale/errors_EBP_subarea_norescale" 
 
local mae_file_brf "${results_`dataset'}/results_brf/errors_brf_subarea" 
local mae_file_brf_norescale "${results_`dataset'}/results_brf_norescale/errors_BRF_norescale_subarea" 

local mae_file_nopsu "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_h"
local mae_file_nopsu_norescale "${results_`dataset'}/results_ebp_norescale/errors_EBP_nopsu_norescale"





foreach estimate in ebp ell uc sub_ebp brf nopsu  {
	dis "`estimate'"
	
	* rank correlation 
	* 1. Standard ebp 
	import excel using "`rc_file_`estimate''.xlsx", clear 
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar rc_`estimate'_base_`dataset'=r(mean)
	su B 
	scalar rc_`estimate'_base_in_`dataset'=r(mean) 
	su C 
	scalar rc_`estimate'_base_out_`dataset'=r(mean) 
	
	
	* 2. No weight rescaling 
	import excel using "`rc_file_`estimate'_norescale'.xlsx", clear 
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar rc_`estimate'_noresc_`dataset'=r(mean)
	su B 
	scalar rc_`estimate'_noresc_in_`dataset'=r(mean) 
	su C 
	scalar rc_`estimate'_noresc_out_`dataset'=r(mean) 

	
	
	** MAE 
	* 1. Standard ebp 
	import excel using "`mae_file_`estimate''.xlsx", clear 
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar mae_`estimate'_base_`dataset'=r(mean)
	su B 
	scalar mae_`estimate'_base_in_`dataset'=r(mean) 
	su C 
	scalar mae_`estimate'_base_out_`dataset'=r(mean) 
	
	
	
	
	* 2. No weight rescaling 
	import excel using "`mae_file_`estimate'_norescale'.xlsx", clear 
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar mae_`estimate'_noresc_`dataset'=r(mean)
	su B 
	scalar mae_`estimate'_noresc_in_`dataset'=r(mean) 
	su C 
	scalar mae_`estimate'_noresc_out_`dataset'=r(mean) 

	
	
	
	
	
	putexcel C`row'=rc_`estimate'_base_in_`dataset'
	putexcel D`row'=rc_`estimate'_base_out_`dataset'
	putexcel E`row'=rc_`estimate'_noresc_in_`dataset'
	putexcel F`row'=rc_`estimate'_noresc_out_`dataset'

	putexcel G`row'=mae_`estimate'_base_in_`dataset'
	putexcel H`row'=mae_`estimate'_base_out_`dataset'
	putexcel I`row'=mae_`estimate'_noresc_in_`dataset'
	putexcel J`row'=mae_`estimate'_noresc_out_`dataset'

	local row=`row'+1 
}
}



