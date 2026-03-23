cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
clear 
set obs 1000 
gen percentile=_n/10 
gen acover35=percentile/35
gen adj_factor=min(1,acover35^11)^11
label var adj_factor "Adjustment Factor to Sample Probability"
label var percentile "National percentile of asset index"
graph twoway line adj_factor percentile if percentile>30 & percentile<40,xlabel(30(1)40)
graph export figure2.png,as(png) replace 
putexcel set ".\output\tables.xlsx", modify sheet("Figure2")
putexcel A1 = image("figure2.png")	

