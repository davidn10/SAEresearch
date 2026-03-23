* creates table 3 
cd "D:\david\SAEresearch\Code\STATAcode\reproducibility_package"
putexcel set ".\output\tables.xlsx", modify sheet("Table3")

* MEX 2010 
* census 
*
local col_1 "C"
local dir_1 "D:\david\SAEresearch_reproducibility_package_data\MEX\2010"
local main_1 "`dir_1'/rawsamples/selected"
local sample_1 "`dir_1'/rawsamples"

local col_2 "D"
local dir_2 "D:\david\SAEresearch_reproducibility_package_data\MEX\2015"
local rawsamples_2 "`dir_2'/rawsamples"
local main_2 "`dir_1'/rawsamples/selected"
local sample_2 "`dir_1'/rawsamples"

local col_3 "E"
local dir_3 "D:\david\SAEresearch_reproducibility_package_data\MEX\2020"
local rawsamples_3 "`dir_3'/rawsamples_full"
local main_3 "`dir_1'/rawsamples/selected"
local sample_3 "`dir_1'/rawsamples"


local col_4 "F"
local dir_4 "D:\david\SAEresearch_reproducibility_package_data\BRA\2000"
local main_4 "`dir_4'/rawsamples/selected"
local sample_4 "`dir_4'\rawsamples"

local col_5 "G"
local dir_5 "D:\david\SAEresearch_reproducibility_package_data\BRA\2010"

local main_5 "`dir_5'\rawsamples/selected"
local sample_5 "`dir_5'\rawsamples"


foreach i of numlist 1/5 {
dis "`i'"
local dir "`dir_`i''"
local col "`col_`i''"
local rawsamples "`rawsamples_`i''"
local main "`main_`i''"
local sample "`sample_`i''"

use "`dir'\census\census.dta", clear
unique mun_id
putexcel `col'3 = `=r(unique)'
unique psu_id 
putexcel `col'6 = `=r(unique)'
count 
putexcel `col'9 = `=r(N)'
 
* main sample 
use "`main'/sample_1", replace 
unique mun_id
putexcel `col'4 = `=r(unique)'
unique psu_id 
putexcel `col'7 = `=r(unique)'
count 
putexcel `col'10 = `=r(N)'


* large sample 
use "`sample'/sample3\selected/sample_1", replace 
unique mun_id 
putexcel `col'5 = `=r(unique)'
unique psu_id 
putexcel `col'8 = `=r(unique)'
count 
putexcel `col'11 = `=r(N)'

*medium sample 
use "`sample'/sample2/selected/sample_1", replace 
count 
putexcel `col'12 = `=r(N)'

* small sample 
use "`sample'/sample1/selected/sample_1", replace 
count 
putexcel `col'13 = `=r(N)'
*/ 
}