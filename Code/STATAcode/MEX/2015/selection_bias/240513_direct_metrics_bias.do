global rawdata "D:\SAE_project\MEX"
global currdata "$rawdata\2015\full_census_new"
global census "$currdata\rawdata\census_proc_MEX_2015.dta"
global results "$currdata\results\bias"
global simcensus "$currdata\simcensus"


****
putexcel set "$results\rankcorr_direct_bias55", replace

forvalues i=1(1)100{

use "$simcensus\bias55\true_fgt0.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\bias55\direct_bias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir12


spearman fgt0_true fgt0_dir12
local rho_`i'=r(rho)
local N_`i'=r(N)

corr fgt0_true fgt0_dir12
local rho2_`i'=r(rho)
local N2_`i'=r(N)

***Mean absolute error & RMSE
g error_me=(fgt0_true-fgt0_dir12)
egen ME=mean(error_me)

g error=abs(fgt0_true-fgt0_dir12)
g error2=(fgt0_true-fgt0_dir12)^2
egen MAE=mean(error)

egen RMSE=mean(error2)
replace RMSE=sqrt(RMSE)

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
}


****
putexcel set "$results\rankcorr_direct_bias1111", replace

forvalues i=1(1)100{

use "$simcensus\bias1111\true_fgt0.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\bias1111\direct_bias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir12


spearman fgt0_true fgt0_dir12
local rho_`i'=r(rho)
local N_`i'=r(N)

corr fgt0_true fgt0_dir12
local rho2_`i'=r(rho)
local N2_`i'=r(N)

***Mean absolute error & RMSE
g error_me=(fgt0_true-fgt0_dir12)
egen ME=mean(error_me)

g error=abs(fgt0_true-fgt0_dir12)
g error2=(fgt0_true-fgt0_dir12)^2
egen MAE=mean(error)

egen RMSE=mean(error2)
replace RMSE=sqrt(RMSE)

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
}

****
putexcel set "$results\rankcorr_direct_bias11b11", replace

forvalues i=1(1)100{

use "$simcensus\bias11b11\true_fgt0.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\bias11b11\direct_bias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir12


spearman fgt0_true fgt0_dir12
local rho_`i'=r(rho)
local N_`i'=r(N)

corr fgt0_true fgt0_dir12
local rho2_`i'=r(rho)
local N2_`i'=r(N)

***Mean absolute error & RMSE
g error_me=(fgt0_true-fgt0_dir12)
egen ME=mean(error_me)

g error=abs(fgt0_true-fgt0_dir12)
g error2=(fgt0_true-fgt0_dir12)^2
egen MAE=mean(error)

egen RMSE=mean(error2)
replace RMSE=sqrt(RMSE)

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
}

****
putexcel set "$results\rankcorr_direct_nobias", replace

forvalues i=1(1)100{

use "$simcensus\nobias\true_fgt0.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus\nobias\direct_nobias_`i'.dta", keepusing(fgt0_m )
drop _merge
rename  fgt0_m fgt0_dir12


spearman fgt0_true fgt0_dir12
local rho_`i'=r(rho)
local N_`i'=r(N)

corr fgt0_true fgt0_dir12
local rho2_`i'=r(rho)
local N2_`i'=r(N)

***Mean absolute error & RMSE
g error_me=(fgt0_true-fgt0_dir12)
egen ME=mean(error_me)

g error=abs(fgt0_true-fgt0_dir12)
g error2=(fgt0_true-fgt0_dir12)^2
egen MAE=mean(error)

egen RMSE=mean(error2)
replace RMSE=sqrt(RMSE)

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
}