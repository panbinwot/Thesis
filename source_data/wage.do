// 1/16/2019, Bin started to clear data of wage across the year

set more off
clear all

global temp "C:\Users\pb061\OneDrive\GraduateThesis\data\temp"
//------------------------------------------------------------------------
// hourly rate of WAGE of Year 
// *not compensation 
global wage2005to2015 "C:\Users\pb061\OneDrive\GraduateThesis\data\wage"
infile using $wage2005to2015\wage_2005_2015.dct
// alright, Im gonna do it brute force-ly

local wage2005 S5421000 S5421100 S5421200 S5421300 S5421400 S5421500 S5421600 S5421700 S5421800	
local wage2006 S7522200 S7522300 S7522400 S7522500 S7522600 S7522700 S7522800 S7522900 S7523000
local wage2007 T0022800 T0022900 T0023000 T0023100 T0023200 T0023300 T0023400 T0023500		
local wage2008 T2017700 T2017800 T2017900 T2018000 T2018100 T2018200 T2018300 T2018400					
local wage2009 T3608100 T3608200 T3608300 T3608400 T3608500 T3608600 T3608700 T3608800 T3608900				
local wage2010 T5208500 T5208600 T5208700 T5208800 T5208900 T5209000 T5209100 T5209200 T5209300				
local wage2011 T6658700 T6658800 T6658900 T6659000 T6659100 T6659200 T6659300 T6659400 T6659500 T6659600 T6659700 T6659800 T6659900
local wage2012 T8130800 T8130900 T8131000 T8131100 T8131200 T8131300 T8131400 T8131500 T8131600 T8131700			
local wage2013 U0010700 U0010800 U0010900 U0011000 U0011100 U0011200 U0011300 U0011400 U0011500 U0011600 U0011700 U0011800	

forvalues i = 2005 (1) 2013 {
	gen wage_`i'=.
	foreach w of local wage`i' {
		replace wage_`i'= `w' if `w'>=0
		}	
	winsor wage_`i', gen(wage_`i'_wi) p(0.001)
	replace wage_`i' = wage_`i'_wi/100
	gen lnwage_`i' = ln(wage_`i')
	drop wage_`i'_wi
}

keep R0000100 lnwage_*
gather lnwage_*, variable(s) value(lnwage)
gen wage = exp(lnwage)
gen Year = substr(s,8,4)

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

// replace year = 2015 if year==2013
// replace year = 2013 if year==2012
drop Year s
save $temp\all_lnwage.dta,replace

// infile using $wage2015\wage_2015.dct
// keep R0000100 R0536300 R0536401 R0536402 R1235800 R1482600 /// 
// U0010700 U0010800 U0010900 U0011000 U0011100 U0011200 U0011300 ///
// U0011400 U0011500 U0011600 U0011700 U0011800 ///

// drop if U0010700<0 // A suspicious error. Too bold

// gen wage = .
// local jobs U0010700 U0010800 U0010900 U0011000 U0011100 U0011200 /// 
// U0011300 U0011400 U0011500 U0011600 U0011700 U0011800 ///

// foreach v of local jobs { 
// 	replace wage = `v' if `v' >= 0
// } 
// winsor wage, gen(wage_wi) p(0.001) // Try to get rid of outliers by taking in some input values
// replace wage = wage_wi/100
// gen lnwage = ln(wage)
// keep R0000100 R0536300 R0536401 R0536402 R1235800 R1482600 lnwage
// save $alltemppath\lnwage.dta,replace


