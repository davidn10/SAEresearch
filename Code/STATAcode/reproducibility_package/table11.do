
putexcel set ".\tables.xlsx", modify sheet("Table11")
global results_MEX_2010 "$MEX\2010\results"
global results_MEX_2015 "$MEX\2015\results"
global results_MEX_2020 "$MEX\2020\results"
global results_BRA_2000 "$BRA\2000\results"
global results_BRA_2010 "$BRA\2010\results"
** selection bias results 


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	local rc_file_ebp "${results_`dataset'}/bias/results_ebp/rankcorr_ebp_unit_bias11b11"
	local rc_file_ell "${results_`dataset'}/bias/results_ell/rankcorr_ell_unit_bias11b11"
	local rc_file_uc "${results_`dataset'}/bias/results_ebp/rankcorr_ebp_context_bias11b11"	
	local rc_file_sub_ebp "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_bias11b11" 
	local rc_file_nopsu "${results_`dataset'}/bias/results_ebp/rankcorr_EBP_nopsu_bias11b11"
	local rc_file_brf "${results_`dataset'}/bias/results_BRF/rankcorr_BRF_subarea_bias11b11" 
	local rc_file_fh "${results_`dataset'}/bias/results_fh_smooth/rankcorr_fh_smooth_bias11b11" 
	
	
	local mae_file_ebp "${results_`dataset'}/bias/results_ebp/errors_EBP_unit_bias11b11"
	local mae_file_ell "${results_`dataset'}/bias/results_ell/errors_ell_unit_bias11b11"
	local mae_file_uc "${results_`dataset'}/bias/results_ebp/errors_ebp_context_bias11b11"
	local mae_file_sub_ebp "${results_`dataset'}/results_sub_ebp/errors_subEBP_bias11b11" 
	local mae_file_nopsu "${results_`dataset'}/bias/results_ebp/errors_EBP_nopsu_bias11b11"
	local mae_file_brf "${results_`dataset'}/bias/results_BRF/errors_BRF_subarea_bias11b11" 
	local mae_file_fh "${results_`dataset'}/bias/results_fh_smooth/errors_fh_smooth_bias11b11" 
	
	foreach estimate in ebp ell uc sub_ebp brf fh nopsu {
		dis "`estimate'"
		dis "`rc_file_`estimate''.xlsx"
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
		dis "`mae_file_`estimate''.xlsx"
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
	keep D 
	su D 
	scalar rc_dir_in_`dataset'=r(mean) 

	import excel using "`mae_file_ebp'.xlsx", clear 
	keep D
	su D
	scalar mae_dir_in_`dataset'=r(mean) 
	
} 
 
 
 
 
 
 

foreach estimate in ebp ell uc sub_ebp brf fh nopsu {
foreach sample in total in out  {
local rc_MEX_`estimate'_`sample'=(rc_`estimate'_`sample'_MEX_2010+rc_`estimate'_`sample'_MEX_2015+rc_`estimate'_`sample'_MEX_2020)/3
local rc_BRA_`estimate'_`sample'=(rc_`estimate'_`sample'_BRA_2000+rc_`estimate'_`sample'_BRA_2010)/2 

local mae_MEX_`estimate'_`sample'=(mae_`estimate'_`sample'_MEX_2010+mae_`estimate'_`sample'_MEX_2015+mae_`estimate'_`sample'_MEX_2020)/3
local mae_BRA_`estimate'_`sample'=(mae_`estimate'_`sample'_BRA_2000+mae_`estimate'_`sample'_BRA_2010)/2 
}
}

local rc_MEX_dir_in=(rc_dir_in_MEX_2010+rc_dir_in_MEX_2015+rc_dir_in_MEX_2020)/3
local rc_BRA_dir_in=(rc_dir_in_BRA_2000+rc_dir_in_BRA_2010)/2 
local mae_MEX_dir_in=(mae_dir_in_MEX_2010+mae_dir_in_MEX_2015+mae_dir_in_MEX_2020)/3
local mae_BRA_dir_in=(mae_dir_in_BRA_2000+mae_dir_in_BRA_2010)/2 


putexcel D3=`rc_MEX_dir_in'
putexcel G3=`rc_BRA_dir_in'
putexcel D11=`rc_MEX_dir_in'
putexcel G11=`rc_BRA_dir_in'

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
putexcel C`rc_row_`estimate''=`rc_MEX_`estimate'_total'
putexcel D`rc_row_`estimate''=`rc_MEX_`estimate'_in'
putexcel E`rc_row_`estimate''=`rc_MEX_`estimate'_out'

putexcel F`rc_row_`estimate''=`rc_BRA_`estimate'_total'
putexcel G`rc_row_`estimate''=`rc_BRA_`estimate'_in'
putexcel H`rc_row_`estimate''=`rc_BRA_`estimate'_out'

putexcel C`mae_row_`estimate''=`mae_MEX_`estimate'_total'
putexcel D`mae_row_`estimate''=`mae_MEX_`estimate'_in'
putexcel E`mae_row_`estimate''=`mae_MEX_`estimate'_out'

putexcel F`mae_row_`estimate''=`mae_BRA_`estimate'_total'
putexcel G`mae_row_`estimate''=`mae_BRA_`estimate'_in'
putexcel H`mae_row_`estimate''=`mae_BRA_`estimate'_out'






} 
