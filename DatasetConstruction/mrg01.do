set mem 500m
set more off

tempfile t1 t2 t3 t4 t5

global user "path/to/user/directory/"
global source "$user/SourceData"
global create "$user/DatasetConstruction"
global data "$user/Datasets"
global analysis "$user/AnalysisFiles"

log using "$create/mrg01.log", replace

* mrg01.do
* Merge Census files from 1970, 1980, 1990, 2000, 2010 (merge by tract number)
* Merge files from 1970&80 from NCDB (first harmonized to 2000 boundaries and then to 2010 boundaries) 

* 2010
use "$source/ltdb_std_2010_fullcount"
d
sum
sort tractid
save `t1'

* 2000
use "$source/ltdb_std_2000_fullcount", clear
d
sum
gen double tractid=trtid10
sort tractid
merge 1:1 tractid using `t1'
ren _merge _merge1
sort tractid
save `t2'

* 1990
use "$source/ltdb_std_1990_fullcount", clear
d
sum
gen double tractid=trtid10
sort tractid
merge 1:1 tractid using `t2'
ren _merge _merge2
sort tractid
save `t3'


* 1980
use "$source/ltdb_std_1980_fullcount", clear
d
sum
gen double tractid=trtid10
sort tractid
merge 1:1 tractid using `t3'
ren _merge _merge3
sort tractid
save `t4'


* 1970
use "$source/ltdb_std_1970_fullcount", clear
d
sum
gen double tractid=trtid10
sort tractid
merge 1:1 tractid using `t4'
ren _merge _merge4
sort tractid
save `t5'

* NCDB files (1970 & 1980 white/black variables)
use "$data/ncdb2000_to_ltdb2010", clear
d
sum
destring trtid10, replace
gen double tractid=trtid10
merge 1:1 tractid using `t5'
ren _merge _merge5
sort tractid

d
sum
save "$data/mrg01.dta", replace

log close

