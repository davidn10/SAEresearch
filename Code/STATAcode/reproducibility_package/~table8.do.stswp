cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\tables.xlsx", modify sheet("Table8")
global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"



foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	
	* RC files 
local rc_file_ebp_h "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_h"
local rc_file_ebp_g "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_g"
local rc_file_ebp_nlme "${results_`dataset'}/results_ebp/rankcorr_ebp_unit_nlme"
local rc_file_ebp_gls "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_unit_hh"

local rc_file_uc_h "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"	
local rc_file_uc_g "${results_`dataset'}/results_ebp/rankcorr_ebp_context_g"	
local rc_file_uc_nlme "${results_`dataset'}/results_ebp/rankcorr_ebp_context_nlme"	
local rc_file_uc_gls "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_context_hh"

local rc_file_sub_ebp_h "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_h" 
local rc_file_sub_ebp_g "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_g" 
local rc_file_sub_ebp_nlme "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_nlme" 
local rc_file_sub_ebp_gls "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_subarea_hh"

local rc_file_nopsu_h "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_h"
local rc_file_nopsu_g "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_g"
local rc_file_nopsu_nlme "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_nlme"
local rc_file_nopsu_gls "${results_`dataset'}/results_ebpwb/rankcorr_ebpwb_nopsu_hh"


** MAE files 
local mae_file_ebp_h "${results_`dataset'}/results_ebp/errors_ebp_unit_h"
local mae_file_ebp_g "${results_`dataset'}/results_ebp/errors_ebp_unit_g"
local mae_file_ebp_nlme "${results_`dataset'}/results_ebp/errors_ebp_unit_nlme"
local mae_file_ebp_gls "${results_`dataset'}/results_ebpwb/errors_ebpwb_unit_hh"

local mae_file_uc_h "${results_`dataset'}/results_ebp/errors_ebp_context_h"	
local mae_file_uc_g "${results_`dataset'}/results_ebp/errors_ebp_context_g"	
local mae_file_uc_nlme "${results_`dataset'}/results_ebp/errors_ebp_context_nlme"	
local mae_file_uc_gls "${results_`dataset'}/results_ebpwb/errors_ebpwb_context_hh"	

local mae_file_sub_ebp_h "${results_`dataset'}/results_sub_ebp/errors_subEBP_h" 
local mae_file_sub_ebp_g "${results_`dataset'}/results_sub_ebp/errors_subEBP_g" 
local mae_file_sub_ebp_nlme "${results_`dataset'}/results_sub_ebp/errors_subEBP_nlme" 
local mae_file_sub_ebp_gls "${results_`dataset'}/results_ebpwb/errors_ebpwb_unit_hh" 

local mae_file_nopsu_h "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_h"
local mae_file_nopsu_g "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_g"
local mae_file_nopsu_nlme "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_nlme"
local mae_file_nopsu_gls "${results_`dataset'}/results_ebpwb/errors_ebpwb_nopsu_hh"




foreach estimate in ebp uc sub_ebp nopsu  {
	foreach weight in nlme g h gls {
		dis "`estimate'"
		
		* rank correlation  
		import excel using "`rc_file_`estimate'_`weight''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A 
		su A 
		scalar rc_`estimate'_`weight'_`dataset'=r(mean)
		
		** MAE 
		* 1. Standard ebp 
		import excel using "`mae_file_`estimate'_`weight''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A 
		su A 
		scalar mae_`estimate'_`weight'_`dataset'=r(mean)
		}
	}
}

foreach estimate in ebp uc sub_ebp nopsu {
foreach weight in nlme g gls h {
local rc_MEX_`estimate'_`weight'=(rc_`estimate'_`weight'_MEX_2010+rc_`estimate'_`weight'_MEX_2015+rc_`estimate'_`weight'_MEX_2020)/3
local rc_BRA_`estimate'_`weight'=(rc_`estimate'_`weight'_BRA_2000+rc_`estimate'_`weight'_BRA_2010)/2 

local mae_MEX_`estimate'_`weight'=(mae_`estimate'_`weight'_MEX_2010+mae_`estimate'_`weight'_MEX_2015+mae_`estimate'_`weight'_MEX_2020)/3
local mae_BRA_`estimate'_`weight'=(mae_`estimate'_`weight'_BRA_2000+mae_`estimate'_`weight'_BRA_2010)/2 
}
}

local rc_row_nlme=3 
local rc_row_g=4 
local rc_row_gls=5 
local rc_row_h=6 

local mae_row_nlme=7 
local mae_row_g=8 
local mae_row_gls=9
local mae_row_h=10

foreach weight in nlme g gls h    {
putexcel C`rc_row_`weight''=`rc_MEX_ebp_`weight''
putexcel D`rc_row_`weight''=`rc_MEX_uc_`weight''
putexcel E`rc_row_`weight''=`rc_MEX_nopsu_`weight''
putexcel F`rc_row_`weight''=`rc_MEX_sub_ebp_`weight''

putexcel G`rc_row_`weight''=`rc_BRA_ebp_`weight''
putexcel H`rc_row_`weight''=`rc_BRA_uc_`weight''
putexcel I`rc_row_`weight''=`rc_BRA_nopsu_`weight''
putexcel J`rc_row_`weight''=`rc_BRA_sub_ebp_`weight''

putexcel C`mae_row_`weight''=`mae_MEX_ebp_`weight''
putexcel D`mae_row_`weight''=`mae_MEX_uc_`weight''
putexcel E`mae_row_`weight''=`mae_MEX_nopsu_`weight''
putexcel F`mae_row_`weight''=`mae_MEX_sub_ebp_`weight''

putexcel G`mae_row_`weight''=`mae_BRA_ebp_`weight''
putexcel H`mae_row_`weight''=`mae_BRA_uc_`weight''
putexcel I`mae_row_`weight''=`mae_BRA_nopsu_`weight''
putexcel J`mae_row_`weight''=`mae_BRA_sub_ebp_`weight''

}  