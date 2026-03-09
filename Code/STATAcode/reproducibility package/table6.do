putexcel set "D:\david\SAE\SAE_research_with_Melany\output\tables.xlsx", modify sheet("Table6")
global results_MEX_2010 "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results"
global results_MEX_2015 "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new\results"
global results_MEX_2020 "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census\results"
global results_BRA_2000 "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results"
global results_BRA_2010 "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new\results"





use "$results_MEX_2010\results_poverty_simulations\simulation_results_all.dta", clear 
append using "$results_MEX_2015\results_poverty_simulations\simulation_results_all"
append using "$results_MEX_2020\results_poverty_simulations\simulation_results_all" 
gen country="MEX"
append using "$results_BRA_2000\results_poverty_simulations\simulation_results_all" 
append using "$results_BRA_2010\results_poverty_simulations\simulation_results_all" 
replace country="BRA" if country=="" 



collapse (mean) p0 p1*, by(method country)
sort country method 
list country method 

local col "c"
putexcel `col'3=p1[1] // baseline 
putexcel `col'4=p1[5] //ebp unit 
putexcel `col'5=p1[6] //ell unit 
putexcel `col'6=p1[4] //ebp unit-context 
putexcel `col'7=p1[8] //ebp subarea  
putexcel `col'8=p1[2] //brf 
putexcel `col'9=p1[7] //fh 
putexcel `col'10=p1[3] //ebp area-context  

local col "b"
putexcel `col'3=p1[10] // baseline 
putexcel `col'4=p1[14] //ebp unit 
putexcel `col'5=p1[15] //ell unit 
putexcel `col'6=p1[13] //ebp unit-context 
putexcel `col'7=p1[17] //ebp subarea  
putexcel `col'8=p1[11] //brf 
putexcel `col'9=p1[16] //fh 
putexcel `col'10=p1[12] //ebp area-context  



