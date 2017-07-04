set mem 500m
set more off

tempfile t


global user "path/to/user/directory/"
global source "$user/SourceData"
global create "$user/DatasetConstruction"
global data "$user/Datasets"
global analysis "$user/AnalysisFiles"


log using "$create/ncdb1970merge.log", replace

* merge variables from NCDB_1970to2000_NATIONALALL_whtblk1980vars.dta & NCDB_1970to2000_NATIONALALL_whtblk1980vars2.dta
* first file (vars) includes geo2000, trctpop7, trctpop8, shrwht8n, shrwht8, shrblk8n, shrblk8, 
*							 shrnhw8n, shrnhw8, shrnhb8n, shrnhb8
* second file (vars2) includes geo2000, shrwht7n, shrblk7n, shrhsp7n, shrhsp7, shrwht8n, shrblk8n,
*							   shrnhw8n, shrnhb8, msacma99

use "$source/NCDB_1970to2000_NATIONALALL_whtblk1980vars"
keep geo2000 shrwht8n shrnhw8n shrblk8n shrnhb8n trctpop7 trctpop8
sort geo2000
save `t'

use "$source/NCDB_1970to2000_NATIONALALL_whtblk1980vars2"
keep geo2000 shrwht7n shrblk7n shrhsp7n msacma99
sort geo2000
merge 1:1 geo2000 using `t'
drop _merge

* change geo2000 to string variable to prepare for the 2010 harmonization do file
tostring geo2000, gen(geo2000n) format(%011.0f)
codebook geo2000n
list geo2000n in 1/20
d
sum

save "$data/ncdb1970merge", replace

log close

