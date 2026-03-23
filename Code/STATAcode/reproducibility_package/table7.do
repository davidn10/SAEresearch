cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\output\tables.xlsx", modify sheet("Table7")
global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"



foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	
	* RC files 
local rc_file_ebp "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_h"
local rc_file_ebp_norescale "${results_`dataset'}/results_ebp_norescale/rankcorr_ebp_unit_norescale"
local rc_file_ebp_wow "${results_`dataset'}/results_ebp/rankcorr_EBP_unit_wow"

local rc_file_ell "${results_`dataset'}/results_ell/rankcorr_ell_unit"
local rc_file_ell_norescale "${results_`dataset'}/results_ell_norescale/rankcorr_ell_norescale_unit"
local rc_file_ell_wow "${results_`dataset'}/results_ell_norescale/rankcorr_ELL_wow_unit"

local rc_file_uc "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"	
local rc_file_uc_norescale "${results_`dataset'}/results_ebp_norescale/rankcorr_EBP_context_norescale"	
local rc_file_uc_wow "${results_`dataset'}/results_ebp/rankcorr_EBP_context_wow"	

local rc_file_sub_ebp "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_h" 
local rc_file_sub_ebp_norescale "${results_`dataset'}/results_sub_ebp_norescale/rankcorr_EBP_subarea_norescale" 
local rc_file_sub_ebp_wow "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_wow" 

local rc_file_brf "${results_`dataset'}/results_brf/rankcorr_brf_subarea" 
local rc_file_brf_norescale "${results_`dataset'}/results_brf_norescale/rankcorr_BRF_norescale_subarea" 
local rc_file_brf_wow "${results_`dataset'}/results_brf_wow/rankcorr_BRF_wow_subarea" 

local rc_file_nopsu "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_h"
local rc_file_nopsu_norescale "${results_`dataset'}/results_ebp_norescale/rankcorr_ebp_nopsu_norescale"
local rc_file_nopsu_wow "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_wow"

** MAE files 
local mae_file_ebp "${results_`dataset'}/results_ebp/errors_EBP_unit_h"
local mae_file_ebp_norescale "${results_`dataset'}/results_ebp_norescale/errors_EBP_unit_norescale"
local mae_file_ebp_wow "${results_`dataset'}/results_ebp/errors_EBP_unit_wow"

local mae_file_ell "${results_`dataset'}/results_ell/errors_ell_unit"
local mae_file_ell_norescale "${results_`dataset'}/results_ell_norescale/errors_ell_norescale_unit"
local mae_file_ell_wow "${results_`dataset'}/results_ell_norescale/errors_ELL_wow_unit"

local mae_file_uc "${results_`dataset'}/results_ebp/errors_ebp_context_h"	
local mae_file_uc_norescale "${results_`dataset'}/results_ebp_norescale/errors_EBP_context_norescale"	
local mae_file_uc_wow "${results_`dataset'}/results_ebp/errors_EBP_context_wow"	

local mae_file_sub_ebp "${results_`dataset'}/results_sub_ebp/errors_subEBP_h" 
local mae_file_sub_ebp_norescale "${results_`dataset'}/results_sub_ebp_norescale/errors_EBP_subarea_norescale" 
local mae_file_sub_ebp_wow "${results_`dataset'}/results_sub_ebp/errors_subEBP_wow" 

local mae_file_brf "${results_`dataset'}/results_brf/errors_brf_subarea" 
local mae_file_brf_norescale "${results_`dataset'}/results_brf_norescale/errors_BRF_norescale_subarea" 
local mae_file_brf_wow "${results_`dataset'}/results_brf_wow/errors_BRF_wow_subarea" 

local mae_file_nopsu "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_h"
local mae_file_nopsu_norescale "${results_`dataset'}/results_ebp_norescale/errors_EBP_nopsu_norescale"
local mae_file_nopsu_wow "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_wow"




foreach estimate in ebp ell uc sub_ebp brf nopsu  {
	dis "`estimate'"
	
	* rank correlation 
	* 1. Standard ebp 
	import excel using "`rc_file_`estimate''.xlsx", clear 
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_baseline_`dataset'=r(mean)
	* 2. No weight rescaling 
	import excel using "`rc_file_`estimate'_norescale'.xlsx", clear 
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_norescale_`dataset'=r(mean)
	* 3. No weights 
	import excel using "`rc_file_`estimate'_wow'.xlsx", clear 
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_wow_`dataset'=r(mean)
	
	** MAE 
	* 1. Standard ebp 
	import excel using "`mae_file_`estimate''.xlsx", clear 
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_baseline_`dataset'=r(mean)
	* 2. No weight rescaling 
	import excel using "`mae_file_`estimate'_norescale'.xlsx", clear 
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_norescale_`dataset'=r(mean)
	* 3. No weights 
	import excel using "`mae_file_`estimate'_wow'.xlsx", clear 
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_wow_`dataset'=r(mean)
}
}

foreach estimate in ebp ell uc sub_ebp brf nopsu {
foreach type in baseline norescale wow {
local rc_MEX_`estimate'_`type'=(rc_`estimate'_`type'_MEX_2010+rc_`estimate'_`type'_MEX_2015+rc_`estimate'_`type'_MEX_2020)/3
local rc_BRA_`estimate'_`type'=(rc_`estimate'_`type'_BRA_2000+rc_`estimate'_`type'_BRA_2010)/2 

local mae_MEX_`estimate'_`type'=(mae_`estimate'_`type'_MEX_2010+mae_`estimate'_`type'_MEX_2015+mae_`estimate'_`type'_MEX_2020)/3
local mae_BRA_`estimate'_`type'=(mae_`estimate'_`type'_BRA_2000+mae_`estimate'_`type'_BRA_2010)/2 
}
}

local rc_row_ebp=3 
local rc_row_ell=4 
local rc_row_uc=5 
local rc_row_sub_ebp=6 
local rc_row_brf=7 
local rc_row_nopsu=8 

local mae_row_ebp=9 
local mae_row_ell=10 
local mae_row_uc=11
local mae_row_sub_ebp=12 
local mae_row_brf=13 
local mae_row_nopsu=14

foreach estimate in ebp ell uc sub_ebp brf nopsu {
putexcel C`rc_row_`estimate''=`rc_MEX_`estimate'_baseline'
putexcel D`rc_row_`estimate''=`rc_MEX_`estimate'_norescale'
putexcel E`rc_row_`estimate''=`rc_MEX_`estimate'_wow'

putexcel F`rc_row_`estimate''=`rc_BRA_`estimate'_baseline'
putexcel G`rc_row_`estimate''=`rc_BRA_`estimate'_norescale'
putexcel H`rc_row_`estimate''=`rc_BRA_`estimate'_wow'

putexcel C`mae_row_`estimate''=`mae_MEX_`estimate'_baseline'
putexcel D`mae_row_`estimate''=`mae_MEX_`estimate'_norescale'
putexcel E`mae_row_`estimate''=`mae_MEX_`estimate'_wow'

putexcel F`mae_row_`estimate''=`mae_BRA_`estimate'_baseline'
putexcel G`mae_row_`estimate''=`mae_BRA_`estimate'_norescale'
putexcel H`mae_row_`estimate''=`mae_BRA_`estimate'_wow'
}  



