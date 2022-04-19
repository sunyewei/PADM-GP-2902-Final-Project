***2022.03.24 Data Cleaning***
clear all
global datadir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"
global logdir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"

cd "$datadir" 
use "$datadir\country dataset with 2010 version 13 _3_.dta"

codebook frtl_rte lifeexp // Overview of the Variables. 13 missing values in frtl_rte; 12 missing values in lifeexpt

sum frtl_rte
return list
replace frtl_rte = r(mean) if frtl_rte ==.
// replace missing values in frtl_rte to their group mean

sum lifeexp
return list
replace lifeexp = r(mean) if lifeexp ==.
//replace missing values in lifeexp to their group mean

save 20220324-DataCleaning.dta, replace

***2022.3.31 merge the data cleaning of the group***
clear all
use "$datadir\20220324-DataCleaning.dta"

sum gdpcap
return list
replace gdpcap = r(mean) if gdpcap ==.
// replace missing values in gdpcap to their group mean (10 real changes made)

sum co2_em
return list
replace co2_em = r(mean) if co2_em ==.
// replace missing values in co2_em to their group mean (26 real changes made)

sum cvl_lib_ind
replace cvl_lib_ind = 3 if cvl_lib_ind ==.
// replace missing values in cvl_lib_ind to their group mean (55 real changes made)

sum srf_area
return list
replace srf_area = r(mean) if srf_area ==.
// replace missing values in srf_area to their group mean (5 real changes made)

save 20220331-DataCleaningALL.dta, replace


***2022.3.31 Functional Form***
clear all
use "$datadir\20220331-DataCleaningALL.dta"

codebook pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em srf_area gdpcap
// check the data cleaning process. Currently there are 531 observation include in the data set

* Step 1 Test For Multicollinearity 
reg pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em srf_area gdpcap
reg pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em srf_area gdpcap i.year
// The p values for srf_area gdpcap are not statistically significant, So we may have omitted variable bias (after adding year dummies, the results do not change much).
estat vif
// The VIF for lifeexp is alerting, but I recommend to leave it to be

* Step 2 Test For Autocorrelation (unfinished)
predict res1, rstandard
label variable res1 "Standardized residuals for primary regression"
twoway scatter res1 year // The graph indicates that there's no serial correlation to worry about
twoway scatter res1 gdpcap

* Step 3 Functional Form
foreach var of varlist srf_area gdpcap co2_em{
    gen lg_`var' = log(`var')
}
reg pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em lg_srf_area lg_gdpcap i.year
// The p values for srf_area gdpcap are still not statistically significant

gen lg_int_gdp_srf = lg_srf_area * lg_gdpcap
reg pop_grwth frtl_rte lifeexp  co2_em lg_srf_area lg_gdpcap lg_int_gdp_srf i.year
estat imtest, white
// The final(maybe) functional form for simple regression


***2022.4.06 Fixed Effect***
* Step 4 Fixed Effect
egen cnnum = group( cn ) // Destring the country identifier
xtset cnnum year
xtreg pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em srf_area gdpcap i.year, fe i(cnnum)
// Fixed effect for simple regression, srf_area and gdpcap are not significant

xtreg pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em lg_srf_area lg_gdpcap lg_int_gdp_srf i.year, fe i(cnnum)

areg pop_grwth frtl_rte lifeexp cvl_lib_ind co2_em lg_srf_area lg_gdpcap lg_int_gdp_srf i.year, fe i(cnnum)
