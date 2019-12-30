// 1/12/2019, Bin starts to clear data for the project

set more off
clear all

global temp "C:\Users\pb061\OneDrive\GraduateThesis\data\temp"
//------------------------------------------------------------------------
// EDU 
// Include the length of their SCHOOLING AS schooling
global edu "C:\Users\pb061\OneDrive\GraduateThesis\data\edu"
infile using $edu\edu_base.dct,clear
keep R0000100 R0536300 R0536401 R0536402 R1235800 R1482600 ///
E501* E5220* E511* E528* E513* ///
/// E501* grade k-12; E511* education & college; E528* is a different way to calculate numbers

//* Compute grade 12 education year 
// Year 1997-2008
local year 0
local month 01 02 03 04 05 06 07 08 09 10 11 12 
forvalues v = 17 (1) 28 {
	local year =`v'+1980  
	foreach i of local month {
		gen k12_`year'_`i' = 0 
	 	replace k12_`year'_`i' = 1 if E501`v'`i' == 2 
	}
	egen k12_`year' = rowtotal(k12_`year'_*)	
	drop k12_`year'_*
}
//Year 2009
forvalues i = 1 (1) 5 {
	gen k12_2009_`i' = 0
	replace k12_2009_`i'= 1 if E501290`i' ==2
}
egen k12_2009 = rowtotal(k12_2009_*)	
drop k12_2009_*

egen k12bymonth = rowtotal(k12_1997) /// ???? Why do we have to use months

forvalues i =  1997 (1) 2009 {
	gen ifk12_`i' = .
	replace ifk12_`i' = 1 if k12_`i'> 8
}
egen k12year = rowtotal(ifk12_*)
gen num = 0
replace num = 1997 - E5220100 if E5220100 <=1997 & E5220100 >1970
replace k12year = k12year + num
//drop num

//* Compute schooling year of college and above
// Year 1997-2015
local year 0
local month 02 03 04 05 06 07 08 09 10 11 12 
forvalues v = 17 (1) 35 {
	local year =`v'+1980  
	foreach i of local month {
		gen unv_`year'_`i' = 0 
	 	replace unv_`year'_`i' = 1 if E513`v'`i' >0
	}
	egen unv_`year' = rowtotal(unv_`year'_*)	
	drop unv_`year'_*
}
//Year 2016
// forvalues i = 1 (1) 8 {
// 	gen unv_2016_`i' = 0
// 	replace unv_2016_`i'= 1 if E513360`i' >0
// }
// egen unv_2016 = rowtotal(unv_2016_*)
// drop unv_2016_*

//Transform month to year
forvalues i =  1997 (1) 2015 {
	gen ifunv_`i' = .
	replace ifunv_`i' = 1 if unv_`i'> 4
}
egen unvyear = rowtotal(ifunv_*)

//----------------------------------------------------------------------------------
// Schooling
// generate the schooling for each year. For example, we get one's schooling at 2015 by compute 
// number of year of education before 2015 


local tmp 0
forvalues i = 2005 (1) 2015 {
	local tmp = `i' 
	if `tmp' <= 2009 {
		egen tmp1 = rowtotal(ifk12_1997-ifk12_`tmp')
	}
	else {
		egen tmp1 = rowtotal(ifk12_1997-ifk12_2009)
	}
	egen tmp2 = rowtotal(ifunv_1997-ifunv_`tmp')
	gen schooling_`i' = tmp1+tmp2
	drop tmp1 tmp2
	replace schooling_`i' = schooling_`i' + num
}

drop schooling_2012 schooling_2014

keep R0000100 R0536300 R0536401 R0536402 R1235800 R1482600 schooling_*

gather schooling_*, variable(s) value(schooling)
gen Year = substr(s,11,4)

gen year = .

replace year = 2015 if Year=="2015"
replace year = 2013 if Year=="2013"
replace year = 2011 if Year=="2011"
replace year = 2010 if Year=="2010"
replace year = 2009 if Year=="2009"
replace year = 2008 if Year=="2008"
replace year = 2007 if Year=="2007"
replace year = 2006 if Year=="2006"
replace year = 2005 if Year=="2005"
drop Year s
save $temp\edu.dta,replace
