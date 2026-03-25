cd "D:\david\SAEresearch\Code\STATAcode\combine_graphs"
graph use "D:\david\SAE\SAE_research_with_Melany\MEX\2010\full_census_new\results\effective_sample_size\sampling_error_MEX_2010", name(mex_2010, replace)
graph use "D:\david\SAE\SAE_research_with_Melany\MEX\2015\full_census_new\results\effective_sample_size\sampling_error_MEX_2015", name(mex_2015, replace)
graph use "D:\david\SAE\SAE_research_with_Melany\MEX\2020\full_census\results\effective_sample_size\sampling_error_MEX_2020", name(mex_2020, replace)
graph use "D:\david\SAE\SAE_research_with_Melany\BRA\2000\full_census\BRA_2000_new\results\effective_sample_size\sampling_error_BRA_2000", name(bra_2000, replace)
graph use "D:\david\SAE\SAE_research_with_Melany\BRA\2010\full_census_new\results\effective_sample_size\sampling_error_BRA_2010", name(bra_2010, replace)
graph combine mex_2010 mex_2015 mex_2020 bra_2000 bra_2010, name(combined, replace) 
graph export  sampling_error.png, replace name(combined) 