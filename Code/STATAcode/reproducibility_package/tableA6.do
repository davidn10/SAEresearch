cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\tables.xlsx", modify sheet("TableA6")
global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"

local row=3


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	
local icc_file_ebp "${results_`dataset'}/results_ebp/icc_ebp_unit_h"
local icc_file_ebp_norescale "${results_`dataset'}/results_ebp_norescale/icc_ebp_unit_norescale_h"
local icc_file_ebp_wow "${results_`dataset'}/results_ebp/icc_EBP_unit_wow"

local icc_file_uc "${results_`dataset'}/results_ebp/icc_ebp_context_h"	
local icc_file_uc_norescale "${results_`dataset'}/results_ebp_norescale/icc_EBP_context_norescale_h"	
local icc_file_uc_wow "${results_`dataset'}/results_ebp/icc_EBP_context_wow"	
 
local icc_file_nopsu "${results_`dataset'}/results_ebp/icc_EBP_nopsu_h"
local icc_file_nopsu_norescale "${results_`dataset'}/results_ebp_norescale/icc_ebp_nopsu_norescale_h"
local icc_file_nopsu_wow "${results_`dataset'}/results_ebp/icc_EBP_context_nopsu_wow"





foreach estimate in ebp uc nopsu  {
	dis "`estimate'"
	
	* rank correlation 
	* 1. Standard ebp 
	import excel using "`icc_file_`estimate''.xlsx", clear 
	count 
	dis "`icc_file_`estimate''.xlsx""
	assert r(N)==100 
	keep A B C 
	su A 
	scalar sigma2eta_`estimate'_base_`dataset'=r(mean)
	su C 
	scalar icc_`estimate'_base_`dataset'=r(mean) 
		
	* 2. No weight rescaling 
	import excel using "`icc_file_`estimate'_norescale'.xlsx", clear 
	dis "`icc_file_`estimate'_norescale'.xlsx"
	count 
	assert r(N)==100 
	keep A B C 
	su A 
	scalar sigma2eta_`estimate'_noresc_`dataset'=r(mean)
	
	su C 
	scalar icc_`estimate'_noresc_`dataset'=r(mean) 

	* 3. No weights 
	import excel using "`icc_file_`estimate'_wow'.xlsx", clear 
	dis "`icc_file_`estimate'_wow'.xlsx"
	count 
	assert r(N)==100 
	keep A B C
	su A 
	scalar sigma2eta_`estimate'_wow_`dataset'=r(mean)
	su C 
	scalar icc_`estimate'_wow_`dataset'=r(mean) 
	

		
	putexcel C`row'=sigma2eta_`estimate'_base_`dataset'
	putexcel D`row'=sigma2eta_`estimate'_noresc_`dataset'
	putexcel E`row'=sigma2eta_`estimate'_wow_`dataset'
	
	putexcel F`row'=icc_`estimate'_base_`dataset'
	putexcel G`row'=icc_`estimate'_noresc_`dataset'
	putexcel H`row'=icc_`estimate'_wow_`dataset'

	local row=`row'+1 
}
}



