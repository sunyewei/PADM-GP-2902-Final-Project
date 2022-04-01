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