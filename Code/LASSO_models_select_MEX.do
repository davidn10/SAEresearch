cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

***LASSO models to select variables for the models

use "census_2010\census_proc_MEX_2010", clear

***Logaritm of per capita income
g log_pchinc=log(pchinc)

***Models
global indepvar="hhsize female_hh educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding stove shower radio tele fridge washing auto compu cell internet" 

global indep_ag="educ_mun unemp_mun informal_mun hhsize_mun incomehh_mun pchinc_mun educhh_mun agehh_mun educ_psu unemp_psu informal_psu hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu"

lasso linear log_pchinc $indepvar $indep_ag [iw=factor_hh], nolog rseed(12345) 
estimates store cvmodel
di "`e(post_sel_vars)'"

lasso linear log_pchinc $indepvar $indep_ag [iw=factor_hh], nolog rseed(12345) selection(adaptive)
estimates store adapmodel
di "`e(post_sel_vars)'"

lasso linear log_pchinc $indepvar $indep_ag [iw=factor_hh], selection(plugin) 
estimates store plugmodel
di "`e(post_sel_vars)'"

lasso linear log_pchinc $indepvar $indep_ag [iw=factor_hh], selection(bic) 
estimates store bicmodel
di "`e(post_sel_vars)'"

lassocoef cvmodel adapmodel plugmodel bicmodel, display(coef, postselection)


