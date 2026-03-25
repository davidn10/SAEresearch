cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\tables.xlsx", modify sheet("TableA2")
global results_MEX_2010 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results"
global results_MEX_2015 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results"
global results_MEX_2020 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results"
global results_BRA_2000 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results"
global results_BRA_2010 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results"
** selection bias results 


local datasetnum=1 
local cols "C D E F G"

foreach dataset in MEX_2010 MEX_2015 MEX_2020 BRA_2000 BRA_2010 { 
	dis "`dataset'"
	local ess_file "${results_`dataset'}\effective_sample_size\ESS_`dataset'"
	local is_file "${results_`dataset'}\effective_sample_size\informative_sampling_`dataset'"
 	
	
	import excel using "`ess_file'.xlsx", clear 
	count 
	assert r(N)==100 
	
	su A
	scalar ess_rescaled=r(mean)
    su D 
	scalar skew_rescaled=r(mean)
	su B 
	scalar ess_norescale=r(mean)
	su E 
	scalar skew_norescale=r(mean) 
		
	import excel using "`is_file'.xlsx", clear 
	count 
	assert r(N)==100 
	
	su A 
	scalar is_norescale=r(mean)
	
	su C 
	scalar is_rescaled=r(mean) 
	
	su F 
	scalar is_within_norescale=r(mean)
	
	su I 
	scalar is_within_rescaled=r(mean)
	
	
local col : word `datasetnum' of `cols'

putexcel `col'2=skew_norescale 	
putexcel `col'3=ess_norescale 	
putexcel `col'4=is_norescale 	
putexcel `col'5=is_within_norescale 	

putexcel `col'6=skew_rescaled 	
putexcel `col'7=ess_rescaled 	
putexcel `col'8=is_rescaled 	
putexcel `col'9=is_within_rescaled 

local datasetnum=`datasetnum'+1 
} // close loop over datasets 
 
 
 


