set mem 500m
set more off

tempfile t1 t2 t3 t4


global user "path/to/user/directory/"
global source "$user/SourceData"
global create "$user/DatasetConstruction"
global data "$user/Datasets"
global analysis "$user/AnalysisFiles"

log using "C:\Documents and Settings\Siri\My Documents\BADER\Data\LTDB\Dataset Construction\4metro01.log", replace

* 4metro00.do
* Create analytic sample: keep only 4 largest metros (NY, CHI, LA, Houston)
* keep all variables 
* June 4, 2012
* Edited May 10, 2013 to use pcn02.dta (instead of pcn01.dta)

use "C:\Documents and Settings\Siri\My Documents\BADER\Data\LTDB\Datasets\pcn02.dta"
d
sum

keep if (cbsa10==35620|cbsa10==31100|cbsa10==16980|cbsa10==26420)

*check missing
tab cbsa10

foreach yr in 70 80 90 00 10 {
gen miss`yr'=0
replace miss`yr'=1 if pw`yr'==.
}
by cbsa10, sort: tab1 miss*

drop miss*

count if pa70>.4 & pa70<.
count if pa70>.5 & pa70<.
count if pa70>.6 & pa70<.
count if pa70>.7 & pa70<.
list pw70 pb70 ph70 pa70 if pa70>.4 & pa70<.
list pw70 pb70 ph70 pa70 if pa70>.5 & pa70<.
list pw70 pb70 ph70 pa70 if pa70>.6 & pa70<.
list pw70 pb70 ph70 pa70 if pa70>.7 & pa70<.

list trtid10 state pw70 pw80 pb70 pb80 ph70 ph80 pa70 pa80 if pa70>.4 & pa70<.

d
sum

save "C:\Documents and Settings\Siri\My Documents\BADER\Data\LTDB\Datasets\4metro01.dta", replace

log close





