global currdata "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new"
global rawsamples "$currdata\rawsamples\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

drop _all 
tempfile tempraw temprescale  
gen sim=. 

/*
forvalues i=1(1)100{
	dis "`i'"
preserve 	
use "$rawsamples\selected\sample_`i'.dta", replace 
* assert pchinc<999998 | pchinc==. 
collapse (mean) mean_y=ln_pchinc  (rawsum) FACTOR [iw=FACTOR], by(mun_id)
gen sim=`i'
qui save `tempraw', replace 
use "$rawsamples\selected\sample_`i'.dta", replace 
egen meanFACTOR=mean(FACTOR), by(mun_id)
gen FACTOR_resc=FACTOR/meanFACTOR 
collapse (rawsum) FACTOR_resc [iw=FACTOR_resc], by(mun_id)
gen sim=`i'

qui merge 1:1 sim mun_id  using `tempraw', assert(3) nogen 
qui save `temprescale', replace 

restore 

append using `temprescale'


} 
save "$results\mean_Y_bymun_BRA_2010", replace 
*/ 
*
global results "$currdata\results\results_ebp_norescale\"
drop _all 
import excel "$results\rankcorr_EBP_unit_norescale"
keep A 
rename A spearman_norescale 
drop in 1/3 
gen sim=_n 
save "$currdata\results\effective_sample_size\spearman_norescale_BRA_2010", replace 




use "$currdata/rawdata/census_proc_BRA_2010.dta", replace 
sum pchinc
gen ln_pchinc=log(pchinc)
gen popwt=weights*hhsize 


/* OLD
su ln_pchinc [aw=popwt], d 

preserve 
collapse (mean) mean_y_true=ln_pchinc (mean) TAM_LOC (rawsum) popwt [iw=popwt], by(mun_id psu_id)
loneway mean_y_true mun_id [aw=popwt]
restore 
*/ 

collapse (mean) mean_y_true=ln_pchinc (sd) sd_y_true=ln_pchinc (rawsum) popwt [iw=popwt], by(mun_id)
unique mun_id 
rename popwt popwt_census 
gen pop=popwt_census 
expand 100
bys mun_id: gen sim=_n 

global results "$currdata\results\effective_sample_size" 
merge 1:1 mun_id sim using "$results\mean_Y_bymun_BRA_2010", keep(1 3) nogen 

merge n:1 sim using  "$currdata\results\effective_sample_size\spearman_norescale_BRA_2010", assert(3) nogen 

save "$results\Y_bymun_BRA_2010", replace 
*/ 




use "$results\Y_bymun_BRA_2010", replace 




gen error=mean_y-mean_y_true



su error 
su error [aw=popwt]
su error [aw=FACTOR]
su error [aw=FACTOR_resc]

local smoother "lpoly"
gen lnpop=log(pop)
local xvar "lnpop"
label var pop "Municipal population"
merge n:1 sim using  "$currdata\results\effective_sample_size\spearman_norescale_BRA_2010", assert(3) nogen 
gen spearmanQ=1 if spearman_>=0.970
replace spearmanQ=2 if spearman_<0.970
local size "vsmall"
local size2 "small"
local size3 "medsmall"


graph twoway (`smoother' error `xvar' if spearmanQ==1 [aw=FACTOR],yaxis(1) lwidth(medthick)) (`smoother' error `xvar' if spearmanQ==2 [aw=FACTOR],yaxis(1) lwidth(medthick) lpattern(dash) lcolor(stc3) )  (hist `xvar' [fw=int(FACTOR)],yaxis(2) fcolor(red%20)  bins(20) fraction) (hist `xvar' [fw=int(FACTOR_resc)],yaxis(2) fcolor(midblue%20) bins(20) fraction)   , name(error_BRA_2010, replace) ytitle("Sampling Error",size(`size2')) xtitle("Municipal Population (log)",size(`size2')) legend(position(6) rows(2) label(1 "0.97<RC<0.975") label(2 "0.96<RC<0.97")  label(3 "Density" "(raw weights)") label(4 "Density" "(rescaled weights)") size(`size'))  title("BRA 2010",size(`size3')) ylabel(-0.25(0.05)0.25,labsize(`size2') axis(1)) ylabel(,labsize(`size2') axis(2)) ytitle("Density fraction",size(`size2') axis(2)) xlabel(8(2)16,labsize(`size2')) saving($results/sampling_error_BRA_2010, replace)




exit 
