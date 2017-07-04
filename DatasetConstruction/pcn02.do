set mem 500m
set more off

tempfile t1 t2 t3 t4


global user "path/to/user/directory/"
global source "$user/SourceData"
global create "$user/DatasetConstruction"
global data "$user/Datasets"
global analysis "$user/AnalysisFiles"


log using "$create/pcn02.log", replace

* pcn02.do
* calculates racial/ethnic counts & percentages for all census tracts 
*   (1970,1980,1990,2000,2010: White, Black, Hispanic, Asian)

use "$data/mrg01.dta"
d
sum
keep trtid10 tractid state county tract placefp10 cbsa10 metdiv10 ccflag10 ///
	 shr* trctpop7 trctpop8 ///
	 pop70 white70 black70 asian70 ///
	 pop80 nhwht80 nhblk80 asian80 hisp80 ///
	 pop90 nhwht90 nhblk90 asian90 hisp90 ///
	 pop00 nhwht00 nhblk00 asian00 hisp00 ///
	 pop10 nhwht10 nhblk10 asian10 hisp10 

global yrs 70 80 90 00 10 

************************
* Generate percentages *
************************

* 1970 Estimates 
gen nhw70a= round(white70*(shrnhw8n/shrwht8n))
replace nhw70a = white70 if nhw70a==. & shrwht8n==0
label var nhw70a "Number non-Latino white; 1970 (estimated)"
gen nhb70a = round(black70*(shrnhb8n/shrblk8n))
replace nhb70a = black70 if nhb70a==. & shrblk8n==0
label var nhb70a "Number non-Latino black; 1970 (estimated)"
gen hisp70=shrhsp7n 

* Rename 1970 vars to be consistent w/ 1980-2010
ren nhw70a nhwht70
ren nhb70a nhblk70

* Create total population for each tract=W+B+H+A
foreach yr in $yrs {
    egen wbha`yr' = rowtotal(nhwht`yr' nhblk`yr' hisp`yr' asian`yr')
    label var wbha`yr' "Total residents that are white, black, Hispanic, Asian:`yr'"
    }

* create dependent variables 1980-2010: percent white, black, hispanic, asian
foreach yr in $yrs {
	gen pw`yr'=nhwht`yr'/wbha`yr'
	gen pb`yr'=nhblk`yr'/wbha`yr'
	gen ph`yr'=hisp`yr'/wbha`yr'
	gen pa`yr'=asian`yr'/wbha`yr'
	label var pw`yr' "tract proportion nhw`yr'"
	label var pb`yr' "tract proportion nhb`yr'"
	label var ph`yr' "tract proportion hisp`yr'"
	label var pa`yr' "tract proportion asian`yr'"	
}
	
keep trtid10 tractid state county tract cbsa10 placefp10 metdiv10 ccflag10 ///
	nhwht70 nhblk70 hisp70 asian70 trctpop7 pop70 wbha70 pw70 pb70 ph70 pa70 ///
	nhwht80 nhblk80 hisp80 asian80 pop80 wbha80 pw80 pb80 ph80 pa80 ///
	nhwht90 nhblk90 hisp90 asian90 pop90 wbha90 pw90 pb90 ph90 pa90 ///
	nhwht00 nhblk00 hisp00 asian00 pop00 wbha00 pw00 pb00 ph00 pa00 ///
	nhwht10 nhblk10 hisp10 asian10 pop10 wbha10 pw10 pb10 ph10 pa10
	
d
sum

save "$data/pcn02", replace

log close


