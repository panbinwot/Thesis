// 1/12/2019, Bin starts to clear data for the project

set more off
clear all

global temp "C:\Users\pb061\OneDrive\GraduateThesis\data\temp"
use $temp\edu.dta

merge m:m R0000100 year using  $temp\all_lnwage.dta
drop _merge
merge m:m R0000100 year using  $temp\marital_status.dta
drop _merge
merge m:m R0000100 year using  $temp\industry.dta
drop _merge

//drop if lnwage==0
ren R0536402 birthyear
ren R0536300 sex
ren R1482600 race
ren R1235800 ifoversample
drop if ifoversample==0
ren R0536401 birthmonth 
drop birthmonth ifoversample
replace sex = 0 if sex==2

save $temp\mincer.dta,replace
//------------------------------------------------------------------------
// Regressions
gen age = year-birthyear

keep if year >= 2005

gen exp = age- schooling -6
gen exp2 = exp*exp
gen exp3 = exp2*exp
ren R0000100 id
//xtset id year
//xtreg lnwage schooling i.race exp exp2 sex marital_status, re 

keep id wage lnwage year schooling age race exp exp2 exp3 sex marital_status industry

drop if lnwage <= 0 | mi(lnwage)

//1 "Black"  2 "Hispanic"  3 "Mixed Race (Non-Hispanic)"  4 "Non-Black / Non-Hispanic"
gen race2 = "Non-Black / Non-Hispanic"
replace race2 = "Black" if race == 1
replace race2 = "Hispanic" if race == 2
replace race2 = "Mixed Race (Non-Hispanic)" if race == 3
drop race
rename race2 race

tab race, gen(race_)

replace industry = "Unknown" if mi(industry)
tab industry, gen(industry_)
drop industry_17 race_4

gen sec_sector = 0
replace sec_sector = 1 if (industry == "PROFESSIONAL AND RELATED SERVICES")|(industry == "RETAIL TRADE")| (industry == "CONSTRUCTION")

order wage lnwage race industry , first
export excel using $temp\mincer.xlsx,replace first(var)

reg lnwage schooling exp exp2 sex marital_status race_* industry_*, robust
est store m1
esttab m1 m2 m3 using reg_res.tex, label title(Panel Data Regression table\label{tab1})  ar2 replace

// Obviously, using option "fe" will cause collinearity of schooling. 
