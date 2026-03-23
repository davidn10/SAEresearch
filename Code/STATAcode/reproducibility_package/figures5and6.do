cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\tables.xlsx", modify sheet("Figures5and6")
global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"
** selection bias results 


foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	* rank correlation files 
	local rc_file_ebp "${results_`dataset'}/results_ebp/rankcorr_EBP_unit_h"
	local rc_file_ebp_error "${results_`dataset'}/error/results_ebp/rankcorr_EBP_unit_errorh"
	local rc_file_sub_area "${results_`dataset'}/results_sub_ebp/rankcorr_subEBP_h"
	local rc_file_uc  "${results_`dataset'}/results_ebp/rankcorr_ebp_context_h"
	local rc_file_ell_error "${results_`dataset'}/error/results_ell/rankcorr_ell_unit_errorh"
	local rc_file_ell "${results_`dataset'}/results_ell/rankcorr_ell_unit"
	local rc_file_fh_smooth "${results_`dataset'}/results_fh_smooth/rankcorr_fh_smooth"
	local rc_file_brf "${results_`dataset'}/results_brf/rankcorr_brf_subarea"
	local rc_file_nopsu "${results_`dataset'}/results_ebp/rankcorr_EBP_context_nopsu_h"
	
	local mae_file_ebp "${results_`dataset'}/results_ebp/errors_EBP_unit_h"
	local mae_file_ebp_error "${results_`dataset'}/error/results_ebp/errors_EBP_unit_errorh"
	local mae_file_sub_area "${results_`dataset'}/results_sub_ebp/errors_subEBP_h"
	local mae_file_uc  "${results_`dataset'}/results_ebp/errors_ebp_context_h"
	local mae_file_ell_error "${results_`dataset'}/error/results_ell/errors_ell_unit_errorh"
	local mae_file_ell "${results_`dataset'}/results_ell/errors_ell_unit"
	local mae_file_fh_smooth "${results_`dataset'}/results_fh_smooth/errors_fh_smooth"
	local mae_file_brf "${results_`dataset'}/results_brf/errors_brf_subarea"
	local mae_file_nopsu "${results_`dataset'}/results_ebp/errors_EBP_context_nopsu_h"
	
	
	
foreach variant in ebp ebp_error sub_area uc ell_error ell fh_smooth brf nopsu {
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

matrix rc_MEX=J(9,2,.)
matrix rc_BRA=J(9,2,.)
matrix mae_MEX=J(9,2,.)
matrix mae_BRA=J(9,2,.)

local row=1 
foreach variant in ebp ebp_error sub_area uc ell_error ell fh_smooth brf nopsu {
matrix rc_MEX[`row',1]=(rc_`variant'_MEX_2010+rc_`variant'_MEX_2015+rc_`variant'_MEX_2020)/3
matrix rc_MEX[`row',2]=`row'

matrix rc_BRA[`row',1]=(rc_`variant'_BRA_2000+rc_`variant'_BRA_2010)/2 
matrix rc_BRA[`row',2]=`row'

matrix mae_MEX[`row',1]=(mae_`variant'_MEX_2010+mae_`variant'_MEX_2015+mae_`variant'_MEX_2020)/3
matrix mae_MEX[`row',2]=`row'

matrix mae_BRA[`row',1]=(mae_`variant'_BRA_2000+mae_`variant'_BRA_2010)/2
matrix mae_BRA[`row',2]=`row'

local row=`row'+1

}

	

* label and sort matrices 
local estimators "ebp ebp_error sub_area uc ell_error ell fh_smooth brf nopsu"

foreach mat in rc_MEX rc_BRA mae_MEX mae_BRA {
	matrix rownames `mat' = ebp ebp_error sub_area uc ell_error ell fh_smooth brf nopsu 
	
	
	if substr("`mat'",1,2)=="rc" {		
	mata: st_matrix("`mat'", sort(st_matrix("`mat'"), -1))	
	}
	else {
	mata: st_matrix("`mat'", sort(st_matrix("`mat'"), 1))		
	}
}

foreach mat in rc_MEX rc_BRA mae_MEX mae_BRA {
foreach row of numlist 1/9 {
	local estimator=`mat'[`row',2]	
	local new : word `estimator' of `estimators'
	local rownames_`mat' "`rownames_`mat'' `new'" 
}
matrix rownames `mat'=`rownames_`mat''
matrix `mat'=`mat'[1...,1]

}



putexcel B3=matrix(rc_MEX)
putexcel B14=matrix(mae_MEX)
putexcel B27=matrix(rc_BRA)
putexcel B38=matrix(mae_BRA)
