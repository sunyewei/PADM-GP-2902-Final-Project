clear all
prog drop _all
capture log close
set more off

global datadir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"
global logdir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"

use "$datadir\country dataset with 2010 version 13 _3_.dta"

***Data Cleaning***

sum frtl_rte
return list
replace frtl_rte = r(mean) if frtl_rte ==.
//replace missing values in frtl_rte to their group mean

sum lifeexp
return list
replace lifeexp = r(mean) if lifeexp ==.
//replace missing values in lifeexp to their group mean

sum gdpcap
return list
replace gdpcap = r(mean) if gdpcap ==.
//replace missing values in gdpcap to their group mean (10 real changes made)

sum co2_em
return list
replace co2_em = r(mean) if co2_em ==.
//replace missing values in co2_em to their group mean (26 real changes made)

save DataCleaningALL.dta, replace 

** Descriptive statistics**
sum pop_grwth gdpcap frtl_rte lifeexp co2_em
** Generate Table 1 **
estpost sum pop_grwth gdpcap frtl_rte lifeexp co2_em  
esttab, cells("count mean sd min max"), using Table1.doc, replace
eststo clear

*** Models ***
//check the data cleaning process. Currently there are 531 observation include in the data set
codebook pop_grwth gdpcap frtl_rte lifeexp co2_em  

** Base model **
reg pop_grwth gdpcap i.year

** Base with controls **
reg pop_grwth gdpcap frtl_rte lifeexp co2_em i.year
// The p values for gdpcap is not statistically significant

//Test For Multicollinearity//
estat vif
// The VIF for all variables is less than 5, no multicollinearity

// Test for correlation//
twoway scatter pop_grwth co2_em
twoway scatter pop_grwth gdpcap

** Functional Form **
gen lg_gdpcap = log(gdpcap)
gen lg_co2_em = log(co2_em)
gen int_gdpco2 = log(gdpcap) * log(co2_em)
reg pop_grwth frtl_rte lifeexp lg_gdpcap lg_co2_em int_gdpco2 i.year

// Test heteroskedasticity (White Test) //
estat imtest, white
// p value is less than 0.01, so there is heteroskedasticity, we need Robust standard errors for the above models//

** Models with robust **
reg pop_grwth gdpcap i.year, robust
reg pop_grwth gdpcap frtl_rte lifeexp co2_em i.year, robust
reg pop_grwth frtl_rte lifeexp lg_gdpcap lg_co2_em int_gdpco2 i.year, robust

** Fixed Effect **
egen cnnum = group( cn ) // Destring the country identifier
xtset cnnum year
xtreg pop_grwth frtl_rte lifeexp lg_gdpcap lg_co2_em int_gdpco2 i.year, fe i(cnnum) 
xtreg pop_grwth frtl_rte lifeexp lg_gdpcap lg_co2_em int_gdpco2 i.year, fe i(cnnum) robust

** Generate Table 2 **
eststo: quietly reg pop_grwth gdpcap i.year, robust
eststo: quietly reg pop_grwth gdpcap frtl_rte lifeexp co2_em i.year, robust
eststo: quietly reg pop_grwth frtl_rte lifeexp lg_gdpcap lg_co2_em int_gdpco2 i.year, robust
eststo: quietly xtreg pop_grwth frtl_rte lifeexp lg_gdpcap lg_co2_em int_gdpco2 i.year, fe i(cnnum) robust
esttab using Table2.doc, replace
eststo clear

log close 

translate "$logdir/SC solution log.smcl" "$logdir/SC 0415 solution log.pdf", replace fontsize(10) lmargin(.5) rmargin(.5)

