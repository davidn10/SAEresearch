putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("Table10")

global results_BRA_2010 "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new\results"
global results_BRA_2000 "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results"
global results_BRA_s10_c00 "D:\david\SAE\SAE_research_with_Melany\BRA\s10_c00\full_census\results"
global results_BRA_s00_c10 "D:\david\SAE\SAE_research_with_Melany\BRA\s00_c10\full_census\results"

local rc_file_ebp_s10_c10 "$results_BRA_2010/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s10_c10 "$results_BRA_2010/results_ell/rankcorr_ell_unit"
local rc_file_fh_s10_c10 "$results_BRA_2010/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s10_c10 "$results_BRA_2010/results_ebp/rankcorr_EBP_context_h" 

local rc_file_ebp_s10_c00 "$results_BRA_s10_c00/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s10_c00 "$results_BRA_s10_c00/results_ell/rankcorr_ell_unit"
local rc_file_fh_s10_c00 "$results_BRA_s10_c00/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s10_c00 "$results_BRA_s10_c00/results_ebp/rankcorr_EBP_context_h"

local rc_file_ebp_s00_c00 "$results_BRA_2000/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s00_c00 "$results_BRA_2000/results_ell/rankcorr_ell_unit"
local rc_file_fh_s00_c00 "$results_BRA_2000/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s00_c00 "$results_BRA_2000/results_ebp/rankcorr_EBP_context_h" 

local rc_file_ebp_s00_c10 "$results_BRA_s00_c10/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s00_c10 "$results_BRA_s00_c10/results_ell/rankcorr_ell_unit"
local rc_file_fh_s00_c10 "$results_BRA_s00_c10/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s00_c10 "$results_BRA_s00_c10/results_ebp/rankcorr_EBP_context_h" 

local mae_file_ebp_s10_c10 "$results_BRA_2010/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s10_c10 "$results_BRA_2010/results_ell/errors_ell_unit"
local mae_file_fh_s10_c10 "$results_BRA_2010/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s10_c10 "$results_BRA_2010/results_ebp/errors_EBP_context_h" 

local mae_file_ebp_s10_c00 "$results_BRA_s10_c00/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s10_c00 "$results_BRA_s10_c00/results_ell/errors_ell_unit"
local mae_file_fh_s10_c00 "$results_BRA_s10_c00/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s10_c00 "$results_BRA_s10_c00/results_ebp/errors_EBP_context_h"

local mae_file_ebp_s00_c00 "$results_BRA_2000/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s00_c00 "$results_BRA_2000/results_ell/errors_ell_unit"
local mae_file_fh_s00_c00 "$results_BRA_2000/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s00_c00 "$results_BRA_2000/results_ebp/errors_EBP_context_h" 

local mae_file_ebp_s00_c10 "$results_BRA_s00_c10/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s00_c10 "$results_BRA_s00_c10/results_ell/errors_ell_unit"
local mae_file_fh_s00_c10 "$results_BRA_s00_c10/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s00_c10 "$results_BRA_s00_c10/results_ebp/errors_EBP_context_h" 

*Brazil 
foreach method in ebp ell fh nopsu {
     foreach year in s10_c10 s10_c00 s00_c00 s00_c10  {
	 		dis "`method' `year'"
			* dis "rc_file_`estimate'_`year'
		
		* rank correlation 
		import excel using "`rc_file_`method'_`year''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A 
		su A 
		scalar rc_BRA_`method'_`year'=r(mean)
		
		** MAE 
		import excel using "`mae_file_`method'_`year''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A 
		su A 
		scalar mae_BRA_`method'_`year'=r(mean)
		}
	}
	
	
local rc_row_ebp=5 
local rc_row_ell=6 
local rc_row_nopsu=7 
local rc_row_fh=8 

local mae_row_ebp=9 
local mae_row_ell=10 
local mae_row_nopsu=11
local mae_row_fh=12

foreach method in ebp ell fh nopsu {
	dis "rc_row_`method'"
	dis "`rc_row_`method''"

putexcel C`rc_row_`method''=rc_BRA_`method'_s10_c10
putexcel D`rc_row_`method''=rc_BRA_`method'_s10_c00
putexcel E`rc_row_`method''=rc_BRA_`method'_s00_c00
putexcel F`rc_row_`method''=rc_BRA_`method'_s00_c10 

putexcel C`mae_row_`method''=mae_BRA_`method'_s10_c10
putexcel D`mae_row_`method''=mae_BRA_`method'_s10_c00
putexcel E`mae_row_`method''=mae_BRA_`method'_s00_c00
putexcel F`mae_row_`method''=mae_BRA_`method'_s00_c10 



} 

	
	
	