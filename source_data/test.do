set more off
clear all

global temp "C:\Users\pb061\OneDrive\GraduateThesis\data\temp"

use $temp\mincer.dta,clear
gen age = year-birthyear
gen exp = age- schooling -6 
gen exp2 = exp*exp

ren R0000100 id
ren R1482600 race
xtset id year
xtreg lnwage schooling exp exp2 sex i.race, re // Obviously, using option "fe" will cause collinearity of schooling. 

  
