clear all

global datadir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"
global logdir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"

log using "$logdir\Presentation Part Do File.smcl", replace
use "$datadir\20220324-DataCleaning.dta"

sum gdpcap
return list
replace gdpcap = r(mean) if gdpcap ==.
// replace missing values in gdpcap to their group mean (10 real changes made)

sum frtl_rte
return list
replace frtl_rte = r(mean) if frtl_rte ==.
// replace missing values in frtl_rte to their group mean (0 real changes made)

sum lifeexp
return list
replace lifeexp = r(mean) if lifeexp ==.
// replace missing values in lifeexp to their group mean (0 real changes made)

sum co2_em
return list
replace co2_em = r(mean) if co2_em ==.
// replace missing values in co2_em to their group mean (26 real changes made)

tabstat pop_grwth gdpcap frtl_rte lifeexp co2_em, stat(n mean sd min max q) col(stat)

//sum2docx pop_grwth gdpcap frtl_rte lifeexp co2_em using "$datadir\table1.docx", replace stats(N mean sd min(%9.0g) max(%9.0g) p25(%9.0g) median(%9.0g) p75(%9.0g)) title("Descriptive Statistics")

hist gdpcap, freq normal title("Distribuation of GDP Per Capita")
graph export "$datadir\DistribuationGDP.png", replace

hist co2_em, freq normal title("Distribuation of CO2 Emission")
graph export "$datadir\DistribuationCO2.png", replace

gen lg_gdpcap = log(gdpcap)
gen lg_co2_em = log(co2_em)
gen int_gdpco2 = log(gdpcap) * log(co2_em)

hist lg_gdpcap, freq normal title("Distribuation of Log_GDP Per Capita")
graph export "$datadir\DistribuationLogGDP.png", replace

hist lg_co2_em, freq normal title("Distribuation of Log_CO2 Emission")
graph export "$datadir\DistribuationLogCO2.png", replace

log close

translate "$logdir\Presentation Part Do File.smcl" "$logdir\Presentation Part Do File.pdf", replace
