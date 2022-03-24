***2022.03.24 Data Cleaning***
clear all
global datadir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"
global logdir "E:\NYU Master\Semester 2\PADM-GP 2902 Regression and intro to economtrics\Final Project"

cd "$datadir" 
use "$datadir\country dataset with 2010 version 13 _3_.dta"

codebook frtl_rte lifeexp // Overview of the Variables. 13 missing values in frtl_rte; 12 missing values in lifeexpt

sum frtl_rte
return list
replace frtl_rte = r(mean) if frtl_rte==.
//replace missing values in frtl_rte to be their group mean

sum lifeexp
return list
replace lifeexp = r(mean) if lifeexp==.
//replace missing values in lifeexp to be their group mean

save 20220324-DataCleaning.dta, replace