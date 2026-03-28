
putexcel set ".\tables.xlsx", modify sheet("Table12")
global results_MEX_2010 "$MEX\2010\results"
global results_MEX_2015 "$MEX\2015\results"
global results_MEX_2020 "$MEX\2020\results"
global results_BRA_2000 "$BRA\2000\results"
global results_BRA_2010 "$BRA\2010\results"
** selection bias results 


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	local rc_file_raw_main "${results_`dataset'}/results_fh/rankcorr_FH"
	local rc_file_smooth_main "${results_`dataset'}/results_fh_smooth/rankcorr_FH_smooth"
	local rc_file_raw_small "${results_`dataset'}/results_fh/sample1/rankcorr_FH_1"	
	local rc_file_smooth_small "${results_`dataset'}/results_fh_smooth/sample1/rankcorr_FH_1"
	local rc_file_raw_bias "${results_`dataset'}/bias/results_fh/rankcorr_FH_bias11b11"
	local rc_file_smooth_bias "${results_`dataset'}/bias/results_fh_smooth/rankcorr_FH_smooth_bias11b11" 
	
 	local mae_file_raw_main "${results_`dataset'}/results_fh/errors_FH"
	local mae_file_smooth_main "${results_`dataset'}/results_fh_smooth/errors_FH_smooth"
	local mae_file_raw_small "${results_`dataset'}/results_fh/sample1/errors_FH_1"	
	local mae_file_smooth_small "${results_`dataset'}/results_fh_smooth/sample1/errors_FH_1"
	local mae_file_raw_bias "${results_`dataset'}/bias/results_fh/errors_FH_bias11b11"
	local mae_file_smooth_bias "${results_`dataset'}/bias/results_fh_smooth/errors_FH_smooth_bias11b11" 
	
 	
	
	
	
	foreach variant in raw_main smooth_main raw_small smooth_small raw_bias smooth_bias {
		dis "`variant'"
		dis "`rc_file_`variant''.xlsx"
		import excel using "`rc_file_`variant''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A-C 
		su A 
		scalar rc_`variant'_`dataset'=r(mean)

		
		import excel using "`mae_file_`variant''.xlsx", clear 
		dis "`mae_file_`variant''.xlsx"
		count 
		assert r(N)==100 
		su A 
		scalar mae_`variant'_`dataset'=r(mean)

	} // close loop over variants 
} // close loop over datasets 
 
 
 

foreach variant in raw_main smooth_main raw_small smooth_small raw_bias smooth_bias {
	
local rc_row_`variant'_MEX_2010=3 
local rc_row_`variant'_MEX_2015=4 
local rc_row_`variant'_MEX_2020=5
local rc_row_`variant'_BRA_2000=6
local rc_row_`variant'_BRA_2010=7

local mae_row_`variant'_MEX_2010=8 
local mae_row_`variant'_MEX_2015=9 
local mae_row_`variant'_MEX_2020=10
local mae_row_`variant'_BRA_2000=11
local mae_row_`variant'_BRA_2010=12
}

foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
putexcel C`rc_row_smooth_main_`dataset''=rc_smooth_main_`dataset'
putexcel D`rc_row_raw_main_`dataset''=rc_raw_main_`dataset'
putexcel E`rc_row_smooth_small_`dataset''=rc_smooth_small_`dataset'
putexcel F`rc_row_raw_small_`dataset''=rc_raw_small_`dataset'
putexcel G`rc_row_smooth_bias_`dataset''=rc_smooth_bias_`dataset'
putexcel H`rc_row_raw_small_`dataset''=rc_raw_bias_`dataset'

putexcel C`mae_row_smooth_main_`dataset''=mae_smooth_main_`dataset'
putexcel D`mae_row_raw_main_`dataset''=mae_raw_main_`dataset'
putexcel E`mae_row_smooth_small_`dataset''=mae_smooth_small_`dataset'
putexcel F`mae_row_raw_small_`dataset''=mae_raw_small_`dataset'
putexcel G`mae_row_smooth_bias_`dataset''=mae_smooth_bias_`dataset'
putexcel H`mae_row_raw_small_`dataset''=mae_raw_bias_`dataset'



}


