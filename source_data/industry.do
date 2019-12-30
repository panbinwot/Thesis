set more off
clear all

global temp "C:\Users\pb061\OneDrive\GraduateThesis\data\temp"

global marr "C:\Users\pb061\OneDrive\GraduateThesis\data\industry"
infile using $marr\industry.dct,clear

local ind1997 S3658000 S3658100 S3658200 S3658300 S3658400 S3658500 S3658600					
local ind1998 S3679000 S3679100 S3679200 S3679300 S3679400 S3679500 S3679600 S3679700 S3679800			
local ind1999 S3695000 S3695100 S3695200 S3695300 S3695400 S3695500 S3695600 S3695700 S3695800			
local ind2000 S3711000 S3711100 S3711200 S3711300 S3711400 S3711500 S3711600 S3711700 S3711800			
local ind2001 S3727000 S3727100 S3727200 S3727300 S3727400 S3727500 S3727600 S3727700				
local ind2002 S1601900 S1602000 S1602100 S1602200 S1602300 S1602400 S1602500 S1602600 S1602700 S1602800 S1602900	
local ind2003 S3755000 S3755100 S3755200 S3755300 S3755400 S3755500 S3755600 S3755700 S3755800 S3755900		
local ind2004 S5041000 S5041100 S5041200 S5041300 S5041400 S5041500 S5041600					
local ind2005 S6782200 S6782300 S6782400 S6782500 S6782600 S6782700 S6782800 S6782900 S6783000			
local ind2006 S8688800 S8688900 S8689000 S8689100 S8689200 S8689300 S8689400 S8689500 S8689600			
local ind2007 T1108600 T1108700 T1108800 T1108900 T1109000 T1109100 T1109200 T1109300				
local ind2008 T3186000 T3186100 T3186200 T3186300 T3186400 T3186500 T3186600 T3186700 T3186800			
local ind2009 T4596900 T4597000 T4597100 T4597200 T4597300 T4597400 T4597500 T4597600 T4597700			
local ind2010 T6230100 T6230200 T6230300 T6230400 T6230500 T6230600 T6230700 T6230800 T6230900			
local ind2011 T7731100 T7731200 T7731300 T7731400 T7731500 T7731600 T7731700 T7731800 T7731900 T7732000		
local ind2013 T9132600 T9132700 T9132800 T9132900 T9133000 T9133100 T9133200 T9133300 T9133400			
local ind2015 U1125900 U1126000 U1126100 U1126200 U1126300 U1126400 U1126500 U1126600 U1126700 U1126800 U1126900 U1127000

forvalues y = 1997 (1) 2013 {
	// local x = `x'
	// if `y' ==  2012 {
	// 	local x = `y' + 1
	// }
	// if `y' == 2013 {
	// 	local y = `y' + 2
	// }
	gen ind_`y' = "N/A"
	gen tmp`y' = .
	foreach v of local ind`y' {
		replace tmp`y' = `v' if `v' > 0 & `v' <=9990 
	}
	if tmp`y'>0 {
		replace ind_`y' = "AGRICULTURE, FORESTRY AND FISHERIES"  if tmp`y' >= 170 & tmp`y' <= 290
		replace ind_`y' = "MINING" if tmp`y' >=370 & tmp`y' <= 490
		replace ind_`y' = "UTILITIES" if tmp`y' >=570 & tmp`y'<= 690
		replace ind_`y' = "CONSTRUCTION" if tmp`y'== 770
		replace ind_`y' = "MANUFACTURING" if tmp`y' >=1070 & tmp`y'<=3990
		replace ind_`y' = "WHOLESALE TRADE" if tmp`y' >=4070 & tmp`y'<= 4590
		replace ind_`y' = "RETAIL TRADE" if tmp`y' >= 4670 & tmp`y'<= 5790
		replace ind_`y' = "ARTS, ENTERTAINMENT AND RECREATION SERVICES" if tmp`y'==5890
		replace ind_`y' = "TRANSPORTATION AND WAREHOUSING" if tmp`y' >= 6070 & tmp`y'<= 6390
		replace ind_`y' = "INFORMATION AND COMMUNICATION" if tmp`y' >=6470 & tmp`y'<=6780
		replace ind_`y' = "FINANCE, INSURANCE, AND REAL ESTATE" if tmp`y' >= 6870 & tmp`y'<= 7190
		replace ind_`y' = "PROFESSIONAL AND RELATED SERVICES" if tmp`y' >= 7270 & tmp`y' <= 7790
		replace ind_`y' = "EDUCATIONAL, HEALTH, AND SOCIAL SERVICES" if tmp`y' >= 7860 & tmp`y' <= 8470
		replace ind_`y' = "ENTERTAINMENT, ACCOMODATIONS, AND FOOD SERVICES" if tmp`y'>= 8560 & tmp`y'<=8690
		replace ind_`y' = "OTHER SERVICES" if tmp`y' >= 8770 & tmp`y'<=9290
		replace ind_`y' = "PUBLIC ADMINISTRATION" if tmp`y'>= 9370 & tmp`y'<= 9590
		replace ind_`y' = "ACTIVE DUTY MILITARY" if tmp`y' >= 9670 & tmp`y'<= 9890
		replace ind_`y' = "ACS SPECIAL CODES" if tmp`y' >= 9950 & tmp`y'<=9990
	}

}

keep R0000100 ind_*

gather ind_*, variable(s) value(industry)
gen Year = substr(s,5,4)

gen year = .

replace year = 2015 if Year=="2013"
replace year = 2013 if Year=="2012"
replace year = 2011 if Year=="2011"
replace year = 2010 if Year=="2010"
replace year = 2009 if Year=="2009"
replace year = 2008 if Year=="2008"
replace year = 2007 if Year=="2007"
replace year = 2006 if Year=="2006"
replace year = 2005 if Year=="2005"
replace year = 2004 if Year=="2004"
replace year = 2003 if Year=="2003"
replace year = 2002 if Year=="2002"
replace year = 2001 if Year=="2001"
replace year = 2000 if Year=="2000"
replace year = 1999 if Year=="1999"
replace year = 1998 if Year=="1998"
replace year = 1997 if Year=="1997"
drop Year s 
drop if industry=="N/A"

save $temp\industry.dta,replace
