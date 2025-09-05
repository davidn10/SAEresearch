
global currdata "D:\david\SAE\SAE_research_with_Melany"
global output "D:\david\SAEresearch\Code\STATAcode\combine_simulation_results"
putexcel set "$output/combined_simulation_results", modify 

use "$currdata\MEX\2010\full_census_new\results\results_poverty_simulations\simulation_results_all.dta", clear 
collapse (mean) p0 p1*, by(method)

local col "b"
putexcel `col'4=p1[1] // baseline 
putexcel `col'5=p1[5] //ebp unit 
putexcel `col'6=p1[6] //ell unit 
putexcel `col'7=p1[4] //ebp unit-context 
putexcel `col'8=p1[8] //ebp subarea  
putexcel `col'9=p1[2] //brf 
putexcel `col'10=p1[7] //fh 
putexcel `col'11=p1[3] //ebp area-context  

local col "h"
putexcel `col'4=p0[1] // baseline 
putexcel `col'5=p0[5] //ebp unit 
putexcel `col'6=p0[6] //ell unit 
putexcel `col'7=p0[4] //ebp unit-context 
putexcel `col'8=p0[8] //ebp subarea  
putexcel `col'9=p0[2] //brf 
putexcel `col'10=p0[7] //fh 
putexcel `col'11=p0[3] //ebp area-context  




use "$currdata\MEX\2015\full_census_new\results\results_poverty_simulations\simulation_results_all", clear 
collapse (mean) p0 p1*, by(method)
local col "c"
putexcel `col'4=p1[1] // baseline 
putexcel `col'5=p1[5] //ebp unit 
putexcel `col'6=p1[6] //ell unit 
putexcel `col'7=p1[4] //ebp unit-context 
putexcel `col'8=p1[8] //ebp subarea  
putexcel `col'9=p1[2] //brf 
putexcel `col'10=p1[7] //fh 
putexcel `col'11=p1[3] //ebp area-context  

local col "i"
putexcel `col'4=p0[1] // baseline 
putexcel `col'5=p0[5] //ebp unit 
putexcel `col'6=p0[6] //ell unit 
putexcel `col'7=p0[4] //ebp unit-context 
putexcel `col'8=p0[8] //ebp subarea  
putexcel `col'9=p0[2] //brf 
putexcel `col'10=p0[7] //fh 
putexcel `col'11=p0[3] //ebp area-context  


use "$currdata\MEX\2020\full_census\results\results_poverty_simulations\simulation_results_all", clear
collapse (mean) p0 p1*, by(method)
local col "d"
putexcel `col'4=p1[1] // baseline 
putexcel `col'5=p1[5] //ebp unit 
putexcel `col'6=p1[6] //ell unit 
putexcel `col'7=p1[4] //ebp unit-context 
putexcel `col'8=p1[8] //ebp subarea  
putexcel `col'9=p1[2] //brf 
putexcel `col'10=p1[7] //fh 
putexcel `col'11=p1[3] //ebp area-context   

local col "j"
putexcel `col'4=p0[1] // baseline 
putexcel `col'5=p0[5] //ebp unit 
putexcel `col'6=p0[6] //ell unit 
putexcel `col'7=p0[4] //ebp unit-context 
putexcel `col'8=p0[8] //ebp subarea  
putexcel `col'9=p0[2] //brf 
putexcel `col'10=p0[7] //fh 
putexcel `col'11=p0[3] //ebp area-context  


use "$currdata\BRA\2000\full_census\BRA_2000_new\results\results_poverty_simulations\simulation_results_all", clear
collapse (mean) p0 p1*, by(method)
local col "e"
putexcel `col'4=p1[1] // baseline 
putexcel `col'5=p1[5] //ebp unit 
putexcel `col'6=p1[6] //ell unit 
putexcel `col'7=p1[4] //ebp unit-context 
putexcel `col'8=p1[8] //ebp subarea  
putexcel `col'9=p1[2] //brf 
putexcel `col'10=p1[7] //fh 
putexcel `col'11=p1[3] //ebp area-context  

local col "k"
putexcel `col'4=p0[1] // baseline 
putexcel `col'5=p0[5] //ebp unit 
putexcel `col'6=p0[6] //ell unit 
putexcel `col'7=p0[4] //ebp unit-context 
putexcel `col'8=p0[8] //ebp subarea  
putexcel `col'9=p0[2] //brf 
putexcel `col'10=p0[7] //fh 
putexcel `col'11=p0[3] //ebp area-context 



use "$currdata\BRA\2010\full_census_new\results\results_poverty_simulations\simulation_results_all", clear
local col "f"
putexcel `col'4=p1[1] // baseline 
putexcel `col'5=p1[5] //ebp unit 
putexcel `col'6=p1[6] //ell unit 
putexcel `col'7=p1[4] //ebp unit-context 
putexcel `col'8=p1[8] //ebp subarea  
putexcel `col'9=p1[2] //brf 
putexcel `col'10=p1[7] //fh 
putexcel `col'11=p1[3] //ebp area-context 

local col "l"
putexcel `col'4=p0[1] // baseline 
putexcel `col'5=p0[5] //ebp unit 
putexcel `col'6=p0[6] //ell unit 
putexcel `col'7=p0[4] //ebp unit-context 
putexcel `col'8=p0[8] //ebp subarea  
putexcel `col'9=p0[2] //brf 
putexcel `col'10=p0[7] //fh 
putexcel `col'11=p0[3] //ebp area-context 

