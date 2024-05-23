global rawdata "D:\SAE_project\MEX"
global currdata10 "$rawdata\2010\full_census_new"
global simcensus10 "$currdata10\simcensus"

global currdata15 "$rawdata\2015\full_census_new"
global simcensus15 "$currdata15\simcensus"

global currdata20 "$rawdata\2020\full_census"
global simcensus20 "$currdata20\simcensus"

global currdata10b "D:\SAE_project\BRA\2010\full_census"
global simcensus10b "$currdata10b\simcensus"

global results "$currdata10\results"

******************
*** 2010
putexcel set "$results\rankcorr_direct_10", replace

forvalues i=1(1)100{
	
use "$simcensus10\true_fg0_full.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus10\full\direct_fg0_`i'.dta", keepusing(fgt0_m )
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

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

sum  ME
local me_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
putexcel F`i'=`me_`i''
}

*** 2015
putexcel set "$results\rankcorr_direct_15", replace

forvalues i=1(1)100{
	
use "$simcensus15\true_fg0_full.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus15\full\direct_fg0_`i'.dta", keepusing(fgt0_m )
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

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

sum  ME
local me_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
putexcel F`i'=`me_`i''
}

*** 2020
putexcel set "$results\rankcorr_direct_20", replace

forvalues i=1(1)100{
	
use "$simcensus20\true_fg0_full.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus20\full\direct_fg0_`i'.dta", keepusing(fgt0_m )
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

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

sum  ME
local me_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
putexcel F`i'=`me_`i''
}


*** 2010 Brazil
putexcel set "$results\rankcorr_direct_10b", replace

forvalues i=1(1)100{
	
use "$simcensus10b\true_fg0_full.dta", clear
rename  fgt0_m fgt0_true

merge 1:1 mun_id using "$simcensus10b\direct_fg0_`i'.dta", keepusing(fgt0_m )
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

sum MAE 
local mae_`i'=r(mean)
sum  RMSE
local rmse_`i'=r(mean)

sum  ME
local me_`i'=r(mean)

putexcel A`i'=`rho_`i''
putexcel B`i'=`rho2_`i''

putexcel D`i'=`mae_`i''
putexcel E`i'=`rmse_`i''
putexcel F`i'=`me_`i''
}
