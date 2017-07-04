set mem 500m
set more off

tempfile t

global user "path/to/user/directory/"
global source "$user/SourceData"
global create "$user/DatasetConstruction"
global data "$user/Datasets"
global analysis "$user/AnalysisFiles"

log using "$analysis/4metro_mp4.log", replace

* 4metro_mp4.do
* Select analytic sample of 4 metros (CHI, NY, LA, HOU)
* Prepare file for Mplus
* NOTE: set to missing tract-years with <100 ppl; remove cases missing data for all 5 census years

* Select 4 metros
use "$data/pcn02.dta"
d
sum
keep if (cbsa10==35620|cbsa10==31100|cbsa10==16980|cbsa10==26420)
keep pop* nhwht* nhblk* hisp* asian* pw* pb* ph* pa* wbha* cbsa10 trtid10

* Prepare data for Mplus
* change year suffix from 70,80,90,00,10 to 0,1,2,3,4
foreach x of varlist *70 {
local y`x'=regexr("`x'", "70", "0")
rename `x' `y`x''
}
foreach x of varlist *80 {
local y`x'=regexr("`x'", "80", "1")
rename `x' `y`x''
}
foreach x of varlist *90 {
local y`x'=regexr("`x'", "90", "2")
rename `x' `y`x''
}
foreach x of varlist *00 {
local y`x'=regexr("`x'", "00", "3")
rename `x' `y`x''
}
foreach x of varlist *10 {
local y`x'=regexr("`x'", "10", "4")
rename `x' `y`x''
}

ren trtid4 trtid10

* transformation
foreach yr in 0 1 2 3 4 {
	foreach race in w b h a {
		gen p`race't`yr' = asin(sqrt(p`race'`yr'))
	}	
}

* Delete 9 cases with missing on all r/e proportion variables
gen missall=0
replace missall=1 if  (pwt0==. & pbt0==. & pht0==. & pat0==. ///
					 & pwt1==. & pbt1==. & pht1==. & pat1==. ///
					 & pwt2==. & pbt2==. & pht2==. & pat2==. ///
					 & pwt3==. & pbt3==. & pht3==. & pat3==. /// 
					 & pwt4==. & pbt4==. & pht4==. & pat4==.)
format trtid10 %15.0g
list trtid10 cbsa4 if missall==1
drop if missall==1
drop missall

* Set to missing any tract with population below given cutoff for given year
global yrs 0 1 2 3 4 
foreach y in $yrs {
	gen flg1`y'=1 if wbha`y'<1
	gen flg100`y'=1 if wbha`y'<100
	}
gen allmiss=1 if wbha0==. & wbha1==. & wbha2==. & wbha3==. & wbha4==.
tab allmiss, missing
tab1 flg1*

foreach y in $yrs {
  replace wbha`y'=. if flg100`y'==1
}

* Generate flag for tracts w/ <100ppl in all five waves & drop them
gen fivemiss=1 if flg1000==1 & flg1001==1 & flg1002==1 & flg1003==1 & flg1004==1 
tab fivemiss, missing
drop if fivemiss==1
  
* Generate new ID variable (idnew=_n)
compress
sort trtid10
gen idnew=_n

* Keep variables
keep idnew trtid10 cbsa4  p*t0 p*t1 p*t2 p*t3 p*t4
order idnew trtid10 cbsa4 p*t0 p*t1 p*t2 p*t3 p*t4 

save `t'

* prepare entire file to save
save "$data/4metro_mp4", replace
d
sum
stata2mplus using 4metro_mp4, replace

log close

