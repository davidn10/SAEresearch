
putexcel set ".\output\tables.xlsx", modify sheet("Figures3and4")
global results_MEX_2010 "$MEX\2010\results"
global results_MEX_2015 "$MEX\2015\results"
global results_MEX_2020 "$MEX\2020\results"
global results_BRA_2000 "$BRA\2000\results"
global results_BRA_2010 "$BRA\2010\results"
** selection bias results 


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	* rank correlation files 

	
	local rc_file_ebp_small "${results_`dataset'}/results_ebp/sample1/rankcorr_EBP_unit_s1"
	local rc_file_ebp_med "${results_`dataset'}/results_ebp/sample2/rankcorr_EBP_unit_s2"
	local rc_file_ebp_large "${results_`dataset'}/results_ebp/sample3/rankcorr_EBP_unit_s3"
	local rc_file_ebp_main "${results_`dataset'}/results_ebp/rankcorr_EBP_unit_h"
	
	local rc_file_ell_small "${results_`dataset'}/results_ell/sample1/rankcorr_ELL_unit_s1"
	local rc_file_ell_med "${results_`dataset'}/results_ell/sample2/rankcorr_ELL_unit_s2"
	local rc_file_ell_large "${results_`dataset'}/results_ell/sample3/rankcorr_ELL_unit_s3"
	local rc_file_ell_main "${results_`dataset'}/results_ell/rankcorr_ELL_unit"
	
	local rc_file_uc_small "${results_`dataset'}/results_ebp/sample1/rankcorr_EBP_context_s1"
	local rc_file_uc_med "${results_`dataset'}/results_ebp/sample2/rankcorr_EBP_context_s2"
	local rc_file_uc_large "${results_`dataset'}/results_ebp/sample3/rankcorr_EBP_context_s3"
	local rc_file_uc_main "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"	
	
	local rc_file_sub_ebp_small "${results_`dataset'}/results_sub_ebp/sample1/rankcorr_subEBP_s1"
	local rc_file_sub_ebp_med "${results_`dataset'}/results_sub_ebp/sample2/rankcorr_subEBP_s2"
	local rc_file_sub_ebp_large "${results_`dataset'}/results_sub_ebp/sample3/rankcorr_subEBP_s3"
	local rc_file_sub_ebp_main "${results_`dataset'}/results_sub_ebp/rankcorr_subebp_h"
 	
 	local rc_file_fh_smooth_small "${results_`dataset'}/results_fh_smooth/sample1/rankcorr_fh_1"
	local rc_file_fh_smooth_med "${results_`dataset'}/results_fh_smooth/sample2/rankcorr_fh_2"
	local rc_file_fh_smooth_large "${results_`dataset'}/results_fh_smooth/sample3/rankcorr_fh_3"
	local rc_file_fh_smooth_main "${results_`dataset'}/results_fh_smooth/rankcorr_fh_smooth"
	
	local rc_file_brf_small "${results_`dataset'}/results_brf/sample1/rankcorr_BRF_subarea_1"
	local rc_file_brf_med "${results_`dataset'}/results_brf/sample2/rankcorr_BRF_subarea_2"
	local rc_file_brf_large "${results_`dataset'}/results_brf/sample3/rankcorr_BRF_subarea_3"
	local rc_file_brf_main "${results_`dataset'}/results_brf/rankcorr_BRF_subarea"
	
	
	
	* MAE files 
	local mae_file_ebp_small "${results_`dataset'}/results_ebp/sample1/errors_EBP_unit_s1"
	local mae_file_ebp_med "${results_`dataset'}/results_ebp/sample2/errors_EBP_unit_s2"
	local mae_file_ebp_large "${results_`dataset'}/results_ebp/sample3/errors_EBP_unit_s3"
	local mae_file_ebp_main "${results_`dataset'}/results_ebp/errors_EBP_unit_h"
	
	local mae_file_ell_small "${results_`dataset'}/results_ell/sample1/errors_ELL_unit_s1"
	local mae_file_ell_med "${results_`dataset'}/results_ell/sample2/errors_ELL_unit_s2"
	local mae_file_ell_large "${results_`dataset'}/results_ell/sample3/errors_ELL_unit_s3"
	local mae_file_ell_main "${results_`dataset'}/results_ell/errors_ELL_unit"
	
	local mae_file_uc_small "${results_`dataset'}/results_ebp/sample1/errors_EBP_context_s1"
	local mae_file_uc_med "${results_`dataset'}/results_ebp/sample2/errors_EBP_context_s2"
	local mae_file_uc_large "${results_`dataset'}/results_ebp/sample3/errors_EBP_context_s3"
	local mae_file_uc_main "${results_`dataset'}/results_ebp/errors_ebp_context_h"	
	
	local mae_file_sub_ebp_small "${results_`dataset'}/results_sub_ebp/sample1/errors_subEBP_s1"
	local mae_file_sub_ebp_med "${results_`dataset'}/results_sub_ebp/sample2/errors_subEBP_s2"
	local mae_file_sub_ebp_large "${results_`dataset'}/results_sub_ebp/sample3/errors_subEBP_s3"
	local mae_file_sub_ebp_main "${results_`dataset'}/results_sub_ebp/errors_subebp_h"
 	
 	local mae_file_fh_smooth_small "${results_`dataset'}/results_fh_smooth/sample1/errors_fh_1"
	local mae_file_fh_smooth_med "${results_`dataset'}/results_fh_smooth/sample2/errors_fh_2"
	local mae_file_fh_smooth_large "${results_`dataset'}/results_fh_smooth/sample3/errors_fh_3"
	local mae_file_fh_smooth_main "${results_`dataset'}/results_fh_smooth/errors_fh_smooth"
	
	local mae_file_brf_small "${results_`dataset'}/results_brf/sample1/errors_brf_subarea_1"
	local mae_file_brf_med "${results_`dataset'}/results_brf/sample2/errors_brf_subarea_2"
	local mae_file_brf_large "${results_`dataset'}/results_brf/sample3/errors_brf_subarea_3"
	local mae_file_brf_main "${results_`dataset'}/results_brf/errors_BRF_subarea"
	
	
	
	
	
	foreach estimate in ebp ell uc sub_ebp fh_smooth brf { 
		dis "`estimate'"
		foreach sample in small med large main {
			* rank correlation 
			dis "`rc_file_`estimate'_`sample''.xlsx"
			import excel using "`rc_file_`estimate'_`sample''.xlsx", clear 
			count 
			assert r(N)==100 
			keep A 
			su A 
			scalar rc_`estimate'_`sample'_`dataset'=r(mean)			
			
			dis "`mae_file_`estimate'_`sample''.xlsx"
			import excel using "`mae_file_`estimate'_`sample''.xlsx", clear 
			count 
			assert r(N)==100 
			keep A 
			su A 
			scalar mae_`estimate'_`sample'_`dataset'=r(mean)	
		} // close samples loop
	} // close estimates loop 
}	 // close dataset loop 
	 
foreach estimate in ebp ell uc sub_ebp fh_smooth brf {
foreach sample in small med large main {
local rc_MEX_`estimate'_`sample'=(rc_`estimate'_`sample'_MEX_2010+rc_`estimate'_`sample'_MEX_2015+rc_`estimate'_`sample'_MEX_2020)/3
local rc_BRA_`estimate'_`sample'=(rc_`estimate'_`sample'_BRA_2000+rc_`estimate'_`sample'_BRA_2010)/2 

local mae_MEX_`estimate'_`sample'=(mae_`estimate'_`sample'_MEX_2010+mae_`estimate'_`sample'_MEX_2015+mae_`estimate'_`sample'_MEX_2020)/3
local mae_BRA_`estimate'_`sample'=(mae_`estimate'_`sample'_BRA_2000+mae_`estimate'_`sample'_BRA_2010)/2 
}
}	 
	 

	 
local rc_row_ell=3 
local rc_row_ebp=4 
local rc_row_uc=5 
local rc_row_sub_ebp=6 
local rc_row_fh_smooth=7 
local rc_row_brf=8 


local mae_row_ell=12 
local mae_row_ebp=13
local mae_row_uc=14
local mae_row_sub_ebp=15 
local mae_row_fh_smooth=16 
local mae_row_brf=17 	 
	 
	 


foreach estimate in ebp ell uc sub_ebp fh_smooth brf {
putexcel B`rc_row_`estimate''=`rc_MEX_`estimate'_small'
putexcel C`rc_row_`estimate''=`rc_MEX_`estimate'_med'
putexcel D`rc_row_`estimate''=`rc_MEX_`estimate'_large'
putexcel E`rc_row_`estimate''=`rc_MEX_`estimate'_main'

putexcel F`rc_row_`estimate''=`rc_BRA_`estimate'_small'
putexcel G`rc_row_`estimate''=`rc_BRA_`estimate'_med'
putexcel H`rc_row_`estimate''=`rc_BRA_`estimate'_large'
putexcel I`rc_row_`estimate''=`rc_BRA_`estimate'_main'

putexcel B`mae_row_`estimate''=`mae_MEX_`estimate'_small'
putexcel C`mae_row_`estimate''=`mae_MEX_`estimate'_med'
putexcel D`mae_row_`estimate''=`mae_MEX_`estimate'_large'
putexcel E`mae_row_`estimate''=`mae_MEX_`estimate'_main'

putexcel F`mae_row_`estimate''=`mae_BRA_`estimate'_small'
putexcel G`mae_row_`estimate''=`mae_BRA_`estimate'_med'
putexcel H`mae_row_`estimate''=`mae_BRA_`estimate'_large'
putexcel I`mae_row_`estimate''=`mae_BRA_`estimate'_main'

}  
 
 
