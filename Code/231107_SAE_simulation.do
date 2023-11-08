cd "C:\Users\melyg\Desktop\SAE_Project\data\MEX"

clear all
set more off

/*=========================================
 Defining globals
 *=========================================*/

global main "C:\Users\melyg\Desktop\SAE_Project"
global data "C:\Users\melyg\Desktop\SAE_Project\data\"
global mdata "$data\MEX\"
global currdata "$data\MEX\census_2010\"
global samples "$currdata\samples\"
global census "$currdata\census_proc_MEX_2010.dta"
global simcensus "$currdata\simcensus\"
global results "$currdata\results_ell\"

//global with candidate variables.
global myvar hhsize female_hh educ_hh sh_educ0_8 sh_educ9_13 sh_educ14_plus sh_literate depen_ch depen_old wall_improved roof_improved floor_improved water_improved electri flush_toilet sewage own_house cook_fuel over_crowding stove shower radio tele fridge washing auto compu cell internet *_mun educ_psu unemp_psu informal_psu hhsize_psu incomehh_psu pchinc_psu educhh_psu agehh_psu hhsize2

set seed 648743


use "$currdata\mysvy.dta", clear
global hhmodel: char _dta[rhs] 
global alpha  : char _dta[alpha] 

use "$simcensus\census1_complete.dta", clear
g uno="1"
egen hhid=concat(uno hid2)
destring hhid, replace
format hhid %20.0g

egen mun=concat(uno mun_id2)
destring mun, replace

tempfile census1
save `census1'

// Create data ready for SAE - optimized dataset
sae data import, datain(`census1') varlist($hhmodel $alpha FACTOR) area(mun) uniqid(hhid) dataout("$currdata\census_mata")

*===============================================================================
// Simulation -> Obtain point estimates
*===============================================================================
use "$currdata\mysvy.dta", clear

sae sim lmm ln_pchinc $hhmodel , area(mun) rep(100) matin($currdata\census_mata) zvar($alpha) varest(h3) seed(648743) pwcensus(FACTOR) lny indicators(fgt0 fgt1) uniqid(hhid) plines(914) eta(normal) epsilon(normal) ydump($currdata\test) aggids(0 4)

*sae data export, matasource($currdata\test) numfiles(5) prefix(sim) saveold datasave($currdata\proc)
