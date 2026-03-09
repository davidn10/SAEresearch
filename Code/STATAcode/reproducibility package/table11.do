putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("Table11")
global results_MEX_2010 "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results"
global results_MEX_2015 "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new\results"
global results_MEX_2020 "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census\results"
global results_BRA_2000 "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results"
global results_BRA_2010 "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new\results"
** selection bias results 


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	local rc_file_ebp "${results_`dataset'}/bias/results_ebp/rankcorr_ebp_unit_bias11b11"
	local rc_file_ell "${results_`dataset'}/bias/results_ell/rankcorr_ell_unit_bias11b11"
	local rc_file_uc "${results_`dataset'}/bias/results_ebp/rankcorr_ebp_context_bias11b11"	
	local rc_file_sub_ebp "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_bias11b11" 
	local rc_file_nopsu "${results_`dataset'}/bias/results_ebp/rankcorr_EBP_context_nopsu_bias11b11"
	local rc_file_brf "${results_`dataset'}/bias/results_brf_v2/rankcorr_BRF_subarea_bias11b11" 
	local rc_file_fh "${results_`dataset'}/bias/results_fh_smooth/rankcorr_fh_smooth_bias11b11" 
	
	
	local mae_file_ebp "${results_`dataset'}/bias/results_ebp/errors_EBP_unit_bias11b11"
	local mae_file_ell "${results_`dataset'}/bias/results_ell/errors_ell_unit_bias11b11"
	local mae_file_uc "${results_`dataset'}/bias/results_ebp/errors_ebp_context_bias11b11"
	local mae_file_sub_ebp "${results_`dataset'}/results_sub_ebp/errors_subEBP_bias11b11" 
	local mae_file_nopsu "${results_`dataset'}/bias/results_ebp/errors_EBP_context_nopsu_bias11b11"
	local mae_file_brf "${results_`dataset'}/bias/results_brf_v2/errors_BRF_subarea_bias11b11" 
	local mae_file_fh "${results_`dataset'}/bias/results_fh_smooth/errors_fh_smooth_bias11b11" 
	
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
 

