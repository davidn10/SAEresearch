cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"

graph use "D:\david\SAEresearch_reproducibility_package_data\MEX\2010\results\effective_sample_size\ESS_scatter_MEX_2010", name(mex_2010, replace)
graph use "D:\david\SAEresearch_reproducibility_package_data\MEX\2015\results\effective_sample_size\ESS_scatter_MEX_2015", name(mex_2015, replace)
graph use "D:\david\SAEresearch_reproducibility_package_data\MEX\2020\results\effective_sample_size\ESS_scatter_MEX_2020", name(mex_2020, replace)
graph use "D:\david\SAEresearch_reproducibility_package_data\BRA\2000\results\effective_sample_size\ESS_scatter_BRA_2000", name(bra_2000, replace)
graph use "D:\david\SAEresearch_reproducibility_package_data\BRA\2010\results\effective_sample_size\ESS_scatter_BRA_2010", name(bra_2010, replace)
graph combine mex_2010 mex_2015 mex_2020 bra_2000 bra_2010, name(combined, replace) 
graph export  ess_rc.png, replace name(combined)