global currdata "$BRA\2000"
global rawsamples "$currdata\rawsamples\"
global census "$currdata\census\"
global results "$currdata\results\effective_sample_size" 
global simcensus "$currdata\simcensus\"

drop _all 
tempfile tempraw temprescale  
gen sim=. 






use "$results\Y_bymun_BRA_2000", replace 




gen error=mean_y-mean_y_true



su error 
su error [aw=popwt]
su error [aw=FACTOR]
su error [aw=FACTOR_resc]

local smoother "lpoly"
gen lnpop=log(pop)
local xvar "lnpop"
label var pop "Municipal population"
merge n:1 sim using  "$currdata\results\effective_sample_size\spearman_norescale_BRA_2000", assert(3) nogen 
gen spearmanQ=1 if spearman_>=0.965
replace spearmanQ=2 if spearman_<0.965 
su spearman_* 
local size "vsmall"
local size2 "small"
local size3 "medsmall"

graph twoway (`smoother' error `xvar' if spearmanQ==1 [aw=FACTOR],yaxis(1) lwidth(medthick)  ) (`smoother' error `xvar' if spearmanQ==2 [aw=FACTOR],yaxis(1) lwidth(medthick) lpattern(dash) lcolor(stc3) )  (hist `xvar' [fw=int(FACTOR)],yaxis(2) fcolor(red%20)  bins(20) fraction) (hist `xvar' [fw=int(FACTOR_resc)],yaxis(2) fcolor(midblue%20) bins(20) fraction)   , name(error_BRA_2000, replace) ytitle("Sampling Error",size(`size2')) ytitle("Density fraction",size(`size2') axis(2)) xtitle("Municipal Population (log)",size(`size2')) legend(position(6) rows(2) label(1 "0.965>RC>0.967") label(2 "0.964<RC<0.965")  label(3 "Density" "(raw weights)") label(4 "Density " "(rescaled weights)") size(`size'))  title("BRA 2000",size(`size3')) ylabel(-0.25(0.05)0.25,labsize(`size2')) ylabel(,labsize(`size2') axis(2))  xlabel(8(2)16,labsize(`size2')) saving($results/sampling_error_BRA_2000, replace) ytitle(,size(`size2') axis(2))




exit 
