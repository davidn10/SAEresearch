
putexcel set ".\tables.xlsx", modify sheet("Table9")

global results_MEX_2010 "$MEX\2010\results"
global results_MEX_2015 "$MEX\2015\results"
global results_MEX_2020 "$MEX\2020\results"
 
global results_MEX_s20_c15 "$MEX\s20_c15\results"
global results_MEX_s20_c10 "$MEX\s20_c10\results"
global results_MEX_s15_c10 "$MEX\s15_c10\results"
global results_MEX_s15_c20 "$MEX\s15_c20\results"
global results_MEX_s10_c15 "$MEX\s10_c15\results"
global results_MEX_s10_c20 "$MEX\s10_c20\results"

clear 

local rc_file_ebp_s20_c20 "$results_MEX_2020/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s20_c20 "$results_MEX_2020/results_ell/rankcorr_ell_unit"
local rc_file_fh_s20_c20 "$results_MEX_2020/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s20_c20 "$results_MEX_2020/results_ebp/rankcorr_EBP_context_h" 

local rc_file_ebp_s20_c15 "$results_MEX_s20_c15/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s20_c15 "$results_MEX_s20_c15/results_ell/rankcorr_ell_unit"
local rc_file_fh_s20_c15 "$results_MEX_s20_c15/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s20_c15 "$results_MEX_s20_c15/results_ebp/rankcorr_EBP_context_h"
 
local rc_file_ebp_s20_c10 "$results_MEX_s20_c10/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s20_c10 "$results_MEX_s20_c10/results_ell/rankcorr_ell_unit"
local rc_file_fh_s20_c10 "$results_MEX_s20_c10/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s20_c10 "$results_MEX_s20_c10/results_ebp/rankcorr_EBP_context_h"

local rc_file_ebp_s15_c15 "$results_MEX_2015/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s15_c15 "$results_MEX_2015/results_ell/rankcorr_ell_unit"
local rc_file_fh_s15_c15 "$results_MEX_2015/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s15_c15 "$results_MEX_2015/results_ebp/rankcorr_EBP_context_h"

local rc_file_ebp_s15_c10 "$results_MEX_s15_c10/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s15_c10 "$results_MEX_s15_c10/results_ell/rankcorr_ell_unit"
local rc_file_fh_s15_c10 "$results_MEX_s15_c10/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s15_c10 "$results_MEX_s15_c10/results_ebp/rankcorr_EBP_context_h"
 
local rc_file_ebp_s15_c20 "$results_MEX_s15_c20/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s15_c20 "$results_MEX_s15_c20/results_ell/rankcorr_ell_unit"
local rc_file_fh_s15_c20 "$results_MEX_s15_c20/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s15_c20 "$results_MEX_s15_c20/results_ebp/rankcorr_EBP_context_h"

local rc_file_ebp_s10_c10 "$results_MEX_2010/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s10_c10 "$results_MEX_2010/results_ell/rankcorr_ell_unit"
local rc_file_fh_s10_c10 "$results_MEX_2010/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s10_c10 "$results_MEX_2010/results_ebp/rankcorr_EBP_context_h"

local rc_file_ebp_s10_c15 "$results_MEX_s10_c15/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s10_c15 "$results_MEX_s10_c15/results_ell/rankcorr_ell_unit"
local rc_file_fh_s10_c15 "$results_MEX_s10_c15/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s10_c15 "$results_MEX_s10_c15/results_ebp/rankcorr_EBP_context_h"
  
local rc_file_ebp_s10_c20 "$results_MEX_s10_c20/results_ebp/rankcorr_EBP_unit_h"
local rc_file_ell_s10_c20 "$results_MEX_s10_c20/results_ell/rankcorr_ell_unit"
local rc_file_fh_s10_c20 "$results_MEX_s10_c20/results_fh_smooth/rankcorr_fh_smooth"
local rc_file_nopsu_s10_c20 "$results_MEX_s10_c20/results_ebp/rankcorr_EBP_context_h"

local mae_file_ebp_s20_c20 "$results_MEX_2020/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s20_c20 "$results_MEX_2020/results_ell/errors_ell_unit"
local mae_file_fh_s20_c20 "$results_MEX_2020/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s20_c20 "$results_MEX_2020/results_ebp/errors_EBP_context_h" 

local mae_file_ebp_s20_c15 "$results_MEX_s20_c15/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s20_c15 "$results_MEX_s20_c15/results_ell/errors_ell_unit"
local mae_file_fh_s20_c15 "$results_MEX_s20_c15/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s20_c15 "$results_MEX_s20_c15/results_ebp/errors_EBP_context_h"
 
local mae_file_ebp_s20_c10 "$results_MEX_s20_c10/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s20_c10 "$results_MEX_s20_c10/results_ell/errors_ell_unit"
local mae_file_fh_s20_c10 "$results_MEX_s20_c10/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s20_c10 "$results_MEX_s20_c10/results_ebp/errors_EBP_context_h"

local mae_file_ebp_s15_c15 "$results_MEX_2015/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s15_c15 "$results_MEX_2015/results_ell/errors_ell_unit"
local mae_file_fh_s15_c15 "$results_MEX_2015/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s15_c15 "$results_MEX_2015/results_ebp/errors_EBP_context_h"

local mae_file_ebp_s15_c10 "$results_MEX_s15_c10/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s15_c10 "$results_MEX_s15_c10/results_ell/errors_ell_unit"
local mae_file_fh_s15_c10 "$results_MEX_s15_c10/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s15_c10 "$results_MEX_s15_c10/results_ebp/errors_EBP_context_h"
 
local mae_file_ebp_s15_c20 "$results_MEX_s15_c20/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s15_c20 "$results_MEX_s15_c20/results_ell/errors_ell_unit"
local mae_file_fh_s15_c20 "$results_MEX_s15_c20/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s15_c20 "$results_MEX_s15_c20/results_ebp/errors_EBP_context_h"

local mae_file_ebp_s10_c10 "$results_MEX_2010/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s10_c10 "$results_MEX_2010/results_ell/errors_ell_unit"
local mae_file_fh_s10_c10 "$results_MEX_2010/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s10_c10 "$results_MEX_2010/results_ebp/errors_EBP_context_h"

local mae_file_ebp_s10_c15 "$results_MEX_s10_c15/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s10_c15 "$results_MEX_s10_c15/results_ell/errors_ell_unit"
local mae_file_fh_s10_c15 "$results_MEX_s10_c15/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s10_c15 "$results_MEX_s10_c15/results_ebp/errors_EBP_context_h"
  
local mae_file_ebp_s10_c20 "$results_MEX_s10_c20/results_ebp/errors_EBP_unit_h"
local mae_file_ell_s10_c20 "$results_MEX_s10_c20/results_ell/errors_ell_unit"
local mae_file_fh_s10_c20 "$results_MEX_s10_c20/results_fh_smooth/errors_fh_smooth"
local mae_file_nopsu_s10_c20 "$results_MEX_s10_c20/results_ebp/errors_EBP_context_h"


* MEXICO 
	
foreach method in ebp ell fh nopsu {
     foreach year in s20_c20 s20_c15 s20_c10 s15_c15 s15_c10 s15_c20 s10_c10 s10_c15 s10_c20 {
	 		dis "`method' `year'"
			* dis "rc_file_`estimate'_`year'
		
		* rank correlation 
		import excel using "`rc_file_`method'_`year''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A 
		su A 
		scalar rc_MEX_`method'_`year'=r(mean)
		
		** MAE 
		import excel using "`mae_file_`method'_`year''.xlsx", clear 
		count 
		assert r(N)==100 
		keep A 
		su A 
		scalar mae_MEX_`method'_`year'=r(mean)
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

putexcel C`rc_row_`method''=rc_MEX_`method'_s20_c20
putexcel D`rc_row_`method''=rc_MEX_`method'_s20_c15
putexcel E`rc_row_`method''=rc_MEX_`method'_s20_c10

putexcel F`rc_row_`method''=rc_MEX_`method'_s15_c15 
putexcel G`rc_row_`method''=rc_MEX_`method'_s15_c10
putexcel H`rc_row_`method''=rc_MEX_`method'_s15_c20

putexcel I`rc_row_`method''=rc_MEX_`method'_s10_c10
putexcel J`rc_row_`method''=rc_MEX_`method'_s10_c15 
putexcel K`rc_row_`method''=rc_MEX_`method'_s10_c20



putexcel C`mae_row_`method''=mae_MEX_`method'_s20_c20
putexcel D`mae_row_`method''=mae_MEX_`method'_s20_c15
putexcel E`mae_row_`method''=mae_MEX_`method'_s20_c10

putexcel F`mae_row_`method''=mae_MEX_`method'_s15_c15 
putexcel G`mae_row_`method''=mae_MEX_`method'_s15_c10
putexcel H`mae_row_`method''=mae_MEX_`method'_s15_c20

putexcel I`mae_row_`method''=mae_MEX_`method'_s10_c10
putexcel J`mae_row_`method''=mae_MEX_`method'_s10_c15 
putexcel K`mae_row_`method''=mae_MEX_`method'_s10_c20






}  
		
