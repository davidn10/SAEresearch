cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\tables.xlsx", modify sheet("TableA7")
global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"

local row=3

foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	
	* RC files 
local rc_file_ebp_h "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_h"
local rc_file_ebp_g "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_g"
local rc_file_ebp_wb "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_unit_hh"
local rc_file_ebp_nlme "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_nlme"

local rc_file_uc_h "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"	
local rc_file_uc_g "${results_`dataset'}/results_ebp/rankcorr_ebp_context_g"	
local rc_file_uc_wb "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_context_hh"
local rc_file_uc_nlme "${results_`dataset'}/results_ebp/rankcorr_ebp_context_nlme"

local rc_file_sub_ebp_h "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_h" 
local rc_file_sub_ebp_g "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_g"	
local rc_file_sub_ebp_wb "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_subarea_hh"
local rc_file_sub_ebp_nlme "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_nlme"

local rc_file_nopsu_h "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_h"
local rc_file_nopsu_g "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_g"
local rc_file_nopsu_wb "${results_`dataset'}/results_ebpwb/rankcorr_EBPwb_nopsu_hh"
local rc_file_nopsu_nlme "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_nlme"


** MAE files 
local mae_file_ebp_h "${results_`dataset'}/results_ebp/errors_ebp_unit_h"
local mae_file_ebp_g "${results_`dataset'}/results_ebp/errors_ebp_unit_g"
local mae_file_ebp_wb "${results_`dataset'}/results_ebpwb/errors_ebpwb_unit_hh"
local mae_file_ebp_nlme "${results_`dataset'}/results_ebp/errors_ebp_unit_nlme"

local mae_file_uc_h "${results_`dataset'}/results_ebp/errors_ebp_context_h"	
local mae_file_uc_g "${results_`dataset'}/results_ebp/errors_ebp_context_g"	
local mae_file_uc_wb "${results_`dataset'}/results_ebpwb/errors_ebpwb_context_hh"
local mae_file_uc_nlme "${results_`dataset'}/results_ebp/errors_ebp_context_nlme"

local mae_file_sub_ebp_h "${results_`dataset'}/results_sub_ebp/errors_subEBP_h" 
local mae_file_sub_ebp_g "${results_`dataset'}/results_sub_ebp/errors_subEBP_g"	
local mae_file_sub_ebp_wb "${results_`dataset'}/results_ebpwb/errors_ebpwb_subarea_hh"
local mae_file_sub_ebp_nlme "${results_`dataset'}/results_sub_ebp/errors_subEBP_nlme"

local mae_file_nopsu_h "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_h"
local mae_file_nopsu_g "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_g"
local mae_file_nopsu_wb "${results_`dataset'}/results_ebpwb/errors_EBPwb_nopsu_hh"
local mae_file_nopsu_nlme "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_nlme"

foreach estimate in ebp uc sub_ebp nopsu  {
	dis "`estimate'"
	
	* rank correlation 
	* 1. Hybrid weights 
	import excel using "`rc_file_`estimate'_h'.xlsx", clear 
	dis "`rc_file_`estimate'_h'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_h_`dataset'=r(mean)
	
	* Guadarrama weights 
	import excel using "`rc_file_`estimate'_g'.xlsx", clear 
	dis "`rc_file_`estimate'_g'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_g_`dataset'=r(mean)
	
	* 3. GLS weights  
	import excel using "`rc_file_`estimate'_wb'.xlsx", clear 
	dis "`rc_file_`estimate'_wb'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_wb_`dataset'=r(mean)
	
	* 4. Conditional weights  
	import excel using "`rc_file_`estimate'_nlme'.xlsx", clear 
	dis "`rc_file_`estimate'_nlme'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar rc_`estimate'_nlme_`dataset'=r(mean)
	
	** MAE 
	* 1. Hybrid weights 
	import excel using "`mae_file_`estimate'_h'.xlsx", clear 
	dis "`mae_file_`estimate'_h'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_h_`dataset'=r(mean)
	
	* Guadarrama weights 
	import excel using "`mae_file_`estimate'_g'.xlsx", clear 
	dis "`mae_file_`estimate'_g'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_g_`dataset'=r(mean)
	
	* 3. GLS weights  
	import excel using "`mae_file_`estimate'_wb'.xlsx", clear 
	dis "`mae_file_`estimate'_wb'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_wb_`dataset'=r(mean)
	
	* 4. Conditional weights  
	import excel using "`mae_file_`estimate'_nlme'.xlsx", clear 
	dis "`mae_file_`estimate'_nlme'.xlsx"
	count 
	assert r(N)==100 
	keep A 
	su A 
	scalar mae_`estimate'_nlme_`dataset'=r(mean)

	
	
	putexcel C`row'=rc_`estimate'_nlme_`dataset'
	putexcel D`row'=rc_`estimate'_g_`dataset'
	putexcel E`row'=rc_`estimate'_wb_`dataset'
	putexcel F`row'=rc_`estimate'_h_`dataset'
	
	putexcel G`row'=mae_`estimate'_nlme_`dataset'
	putexcel H`row'=mae_`estimate'_g_`dataset'
	putexcel I`row'=mae_`estimate'_wb_`dataset'
	putexcel J`row'=mae_`estimate'_h_`dataset'
	
	local row=`row'+1 
	
}
}







