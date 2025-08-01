cd "D:\david\SAE\SAE_research_with_Melany\MEX"


clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
global model "$currdata\results\results_ebp_norescale\unit\model_h"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

set seed 648743


putexcel set "$results\informative_sampling_MEX_2010", replace
forvalues i=1(1)100{
local model ""
use "$model\coef_sample_`i'", replace 
drop in 1 
forvalues j=1(1)`=_N' {
local model="`model'"+names[`j']+" "	
}
dis "`model'"
use "$rawsamples\selected\sample_`i'.dta",replace 
* no rescaling 
* collapse (rawsum) FACTOR (mean) `model' ln_pchinc, by(mun_id)

qui regress FACTOR `model' ln_pchinc [aw=FACTOR]

local beta=abs(_b["ln_pchinc"]) 
local se=_se["ln_pchinc"]
local t=abs(`beta'/`se')
dis "`beta'"
dis "`se'"
dis "`t'"
putexcel A`i'=`beta'
putexcel B`i'=`t'

qui areg FACTOR `model' ln_pchinc [aw=FACTOR], absorb(mun_id)
local beta=abs(_b["ln_pchinc"])
local se=_se["ln_pchinc"]
local t=abs(`beta'/`se')
putexcel F`i'=`beta'
putexcel G`i'=`t'


egen meanFACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_rescaled=FACTOR/meanFACTOR
qui regress FACTOR_rescaled `model' ln_pchinc [aw=FACTOR_rescaled]
local beta=abs(_b["ln_pchinc"]) 
local se=_se["ln_pchinc"]
local t=abs(`beta'/`se')
putexcel C`i'=`beta'
putexcel D`i'=`t'

qui areg FACTOR_rescaled `model' ln_pchinc [aw=FACTOR_rescaled], absorb(mun_id)
local beta=abs(_b["ln_pchinc"])
local se=_se["ln_pchinc"]
local t=abs(`beta'/`se')
putexcel I`i'=`beta'
putexcel J`i'=`t'




} 


