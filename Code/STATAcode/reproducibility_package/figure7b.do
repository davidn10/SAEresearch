global currdata "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new"
global rawsamples "$currdata\rawsamples_full\"
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
save "$results\mean_Y_bymun_MEX_2015", replace 
*/ 

/*
use "$currdata/rawdata/census_proc_MEX_2015.dta", replace 
gen ln_pchinc=log(pchinc_hh) 
gen popwt=FACTOR*hhsize 
tab TAMLOC
tab TAMLOC [aw=popwt]

tab TAMLOC, nol
summ ln_pchinc if TAMLOC==4 [aw=popwt], d
summ ln_pchinc if TAMLOC==4, d

 

/*


su ln_pchinc [aw=popwt], d 

preserve 
collapse (mean) mean_y_true=ln_pchinc (mean) TAMLOC (rawsum) popwt [iw=popwt], by(mun_id psu_id)
loneway mean_y_true mun_id [aw=popwt]
restore 
*/ 


collapse (mean) mean_y_true=ln_pchinc (sd) sd_y_true=ln_pchinc (mean) TAMLOC hhsize (rawsum) popwt [iw=popwt], by(mun_id)
rename popwt popwt_census 

merge 1:n mun_id using "$results\mean_Y_bymun_MEX_2015", keep(3) nogen 
*merge 1:n mun_id sim using "$currdata\results\results_ebp_norescale\leverage_bymun_MEX_2015_s99"
save "$results\Y_bymun_MEX_2015", replace 
*/ 

use "$results\Y_bymun_MEX_2015", replace 


* twoway (scatter mean_y mean_y_true if sim==99) (scatter mean_y mean_y_true if sim==33) (line mean_y mean_y), name(error, replace)

gen error=mean_y-mean_y_true
su error 
su error [aw=popwt]
su error [aw=FACTOR]
su error [aw=FACTOR_resc]
local smoother "lpoly"
gen lnpop=log(pop)
local xvar "lnpop"
label var pop "Municipal population"
merge n:1 sim using  "$currdata\results\effective_sample_size\spearman_norescale_MEX_2015", assert(3) nogen 
gen spearmanQ=1 if spearman_>=0.95
replace spearmanQ=2 if spearman_>0.94 & spearman_<0.95
replace spearmanQ=3 if spearman_>0.92 & spearman_<0.94
su spearman_, d 
local size "vsmall"
local size2 "small"
local size3 "medsmall"
keep if `xvar'>6 

graph twoway (`smoother' error `xvar' if spearmanQ==1 [aw=FACTOR],yaxis(1) lwidth(medthick) `options' ) (`smoother' error `xvar' if spearmanQ==2 [aw=FACTOR],yaxis(1) lwidth(medthick) lpattern(dash) lcolor(stc3) `options') (`smoother' error `xvar' if spearmanQ==3 [aw=FACTOR],yaxis(1) lwidth(medthick) lpattern(longdash)  lcolor(stc2) `options')  (hist `xvar' [fw=int(FACTOR)],yaxis(2) fcolor(red%20)  bins(20) fraction) (hist `xvar' [fw=int(FACTOR_resc)],yaxis(2) fcolor(midblue%20) bins(20) fraction)   , name(error_MEX_2015, replace) ytitle("Sampling Error",size(`size2'))  ytitle("Density fraction",size(`size2') axis(2)) xtitle("Municipal Population (log)",size(`size2')) legend(position(6) rows(2) span colgap(*2) label(1 "0.95<RC<0.955") label(2 "0.94<RC<0.95") label(3 "0.92<RC<0.94") label(4 "Density" "(raw weights)") label(5 "Density" "(rescaled weights)") size(`size'))  title("MEX 2015",size(`size3')) xlabel(6(2)14,labsize(`size2')) ylabel(-0.25(0.05)0.25,labsize(`size2')) ylabel(0(0.05)0.2,labsize(`size2') axis(2)) ylabel(,labsize(`size2') axis(2)) saving($results/sampling_error_MEX_2015, replace)
exit 





tempfile mean_norescale 
preserve 
collapse (mean) error_norescale=error TAMLOC_norescale=TAMLOC [iw=FACTOR], by(sim)
save `mean_norescale'
restore 
collapse (mean) error_rescaled=error TAMLOC_rescaled=TAMLOC [iw=FACTOR_resc], by(sim)
merge 1:1 sim using `mean_norescale', assert(3) nogen

save "$results/sampling_error_MEX_2015", replace 

drop _all 
global results "$currdata\results\results_ebp\"
import excel "$results\rankcorr_EBP_unit_h"
keep A 
rename A spearman_rescaled 
drop in 1/3 
gen sim=_n 
save "$currdata\results\effective_sample_size\spearman_rescaled_MEX_2015", replace 

global results "$currdata\results\results_ebp_norescale\"
drop _all 
import excel "$results\rankcorr_EBP_unit_norescale"
keep A 
rename A spearman_norescale 
drop in 1/3 
gen sim=_n 
save "$currdata\results\effective_sample_size\spearman_norescale_MEX_2015", replace 

 
merge 1:1 sim using "$currdata\results\effective_sample_size\spearman_rescaled_MEX_2015", assert(3) nogen 
merge 1:1 sim using "$currdata\results\effective_sample_size\sampling_error_MEX_2015", assert(3) nogen 


reshape long spearman error TAMLOC, i(sim) j(scale) string
 

gen rescaled=scale=="_rescaled" 
gen spearman_rescaled=spearman if rescaled==1 
gen spearman_norescale=spearman if rescaled==0 
label var error "Weighted average absolute sampling error"
label var spearman_rescaled "Rescaled weights"
label var spearman_norescale "Raw weights"
global results "$currdata\results\effective_sample_size" 

twoway (scatter spearman_rescaled spearman_norescale error, msymbol(oh X)) (lfit spearman_norescale error,lcolor(red)) (lfit spearman_rescale error, lcolor(blue)),  ylabel(0.9(0.01)0.96) ymtick(0.9(0.01)0.96) legend(position(bottom)) ytitle("Spearman Rank Correlation") saving($results/error_scatter_MEX_2015, replace) legend(order(1 2) rows(1) size(small)) title("Mexico 2015")
table rescaled, statistic(mean error)
su spearman_norescale 

tab rescaled, summ(TAMLOC)
regress spearman_norescale error if rescaled==0


