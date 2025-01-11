global rawdata "D:\SAE_project\MEX"


global currdata00b "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census"
global simcensus00b "$currdata00b\simcensus_new"

global results "$currdata00b\results"



forvalues x=1(1)3 {

*** 2010 Brazil
putexcel set "$results\rankcorr_direct_00_BRA_s`x'", replace

forvalues i=1(1)100{
	
use "$simcensus00b\true_fg0_full.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus00b\sample`x'\direct_fg0_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir


spearman fgt0_true fgt0_dir
local rho_`i'=r(rho)
local N_`i'=r(N)

corr fgt0_true fgt0_dir
local rho2_`i'=r(rho)
local N2_`i'=r(N)

***Mean absolute error & RMSE
g error_me=(fgt0_true-fgt0_dir)
egen ME=mean(error_me)

g error=abs(fgt0_true-fgt0_dir)
g error2=(fgt0_true-fgt0_dir)^2
egen MAE=mean(error)

egen RMSE=mean(error2)
replace RMSE=sqrt(RMSE)

g error_rme=abs(fgt0_dir-fgt0_true)/fgt0_true
egen RME=mean(error_rme)

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)
sum  ME
local me_`i'=r(mean)
sum  RME
local rme_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
putexcel F`i'=`me_`i''
putexcel G`i'=`rme_`i''
}
}
