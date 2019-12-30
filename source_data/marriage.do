set more off
clear all

global temp "C:\Users\pb061\OneDrive\GraduateThesis\data\temp"

global marr "C:\Users\pb061\OneDrive\GraduateThesis\data\marital"
infile using $marr\marital_status.dct,clear
drop R0536300

local marrlst R2569300 R3891300 R5473300 R7237000 S1552200 S2022000 S3822900 ///
S5423000 S7525100 T0025400 T2020300 T3611000 T5211400 T6662800 ///
T8134000 U0014500 ///

local yearlst 1998
foreach w of local marrlst {
	
	if `yearlst' == 2012 {
		local yearlst = `yearlst' + 1
	}
	if `yearlst' == 2014 {
		local yearlst = `yearlst' + 1
	}
	gen marr_`yearlst' = 0
	replace marr_`yearlst' = 1 if `w' == 3
	replace marr_`yearlst' = . if `w' == -5
	
	local yearlst = `yearlst' + 1	
}

keep R0000100 marr_*

gather marr_*, variable(s) value(marital_status)
gen Year = substr(s,6,4)

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
replace year = 2004 if Year=="2004"
replace year = 2003 if Year=="2003"
replace year = 2002 if Year=="2002"
replace year = 2001 if Year=="2001"
replace year = 2000 if Year=="2000"
replace year = 1999 if Year=="1999"
replace year = 1998 if Year=="1998"
drop Year s  
save $temp\marital_status.dta,replace
