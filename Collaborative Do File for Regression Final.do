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
//replace missing values in frtl_rte to their group mean

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
//replace missing values in gdpcap to their group mean (10 real changes made)

sum co2_em
return list
replace co2_em = r(mean) if co2_em ==.
//replace missing values in co2_em to their group mean (26 real changes made)

sum cvl_lib_ind
replace cvl_lib_ind = 3 if cvl_lib_ind ==.
//replace missing values in cvl_lib_ind to their group mean (55 real changes made)

sum srf_area
return list
replace srf_area = r(mean) if srf_area ==.
//replace missing values in srf_area to their group mean (5 real changes made)

save 20220331-DataCleaningALL.dta, replace