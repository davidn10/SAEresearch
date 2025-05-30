cd "D:\david\SAE\SAE_research_with_Melany\MEX"


clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census"
global rawsamples "$currdata\rawsamples_full\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

set seed 648743


putexcel set "$results\ESS_MEX_2020", replace
forvalues i=1(1)100{
use "$rawsamples\selected\sample_`i'.dta",replace 


egen meanFACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_rescaled=FACTOR/meanFACTOR
collapse (rawsum) FACTOR_rescaled FACTOR, by(mun_id)


* rescaled weights 
gen FACTOR_rescaledsq=FACTOR_rescaled^2 
qui sum FACTOR_rescaled  
local num=r(sum)^2 
local count=r(N) 
qui sum FACTOR_rescaledsq 
local denom=r(sum)
local ESS_rescaled=`num'/`denom'
putexcel A`i'=`ESS_rescaled'

*population weights 
gen FACTOR_sq=FACTOR^2 
qui sum FACTOR 
local num=r(sum)^2 
qui sum FACTOR_sq 
local denom=r(sum)
local ESS_norescale=`num'/`denom'
putexcel B`i'=`ESS_norescale'

} 






