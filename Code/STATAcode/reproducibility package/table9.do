putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("Table9")
global results_MEX_2020 "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census\results"
global results_MEX_2015 "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new\results"
global results_MEX_2010 "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results"
global results_MEX_s20_c15 "D:\david\SAE\SAE_research_with_Melany\MEX\s20_c15\results"
global results_MEX_s20_c10 "D:\david\SAE\SAE_research_with_Melany\MEX\s20_c10\results"
global results_MEX_s15_c10 "D:\david\SAE\SAE_research_with_Melany\MEX\s15_c10\results"


clear 

local rc_file_ebp_s20_c20 "$results_MEX_2020\results_ebp\rankcorr_EBP_unit_h"
local rc_file_ell_s20_c20 "$results_MEX_2020\results_ell\rankcorr_ell_unit"
local rc_file_fh_s20_c20 "$results_MEX_2020\results_fh_smooth\rankcorr_fh_smooth"
local rc_file_nopsu_s20_c20 "$results_MEX_2020\results_ebp\rankcorr_EBP_context_nopsu_h" 



su A 
scalar rc_ebp_s20_c20=r(mean) 




* MEXICO 
	
foreach estimate in ebp ell fh nopsu {
     
}
