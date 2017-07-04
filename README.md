---
title: 
	Files used for _The Fragmented Evolution of Racial Integration since the Civil Rights Movement_
author:
	- Michael D. M. Bader
	- Siri Warkentien
date: March 2, 2016
...

All files are the same as those used to produce the final version of the article, [The Fragmented Evolution of Racial Integration since the Civil Rights Movement][trajPaper], published in _Sociological Science_. 


[trajPaper]: https://www.sociologicalscience.com/articles-v3-8-135/


Data Files
----------

Source data are saved in `SourceData/`. 

Generated data are saved in `Datasets/`. See code below for use and creation of various datasets. 

Stata Files to Prepare Data
---------------------------

Stata source code files included in `DatasetConstruction/`

### `ncdb1970merge.do` 

Merges two NCDB files to get complete data from the 1970 NCDB
	
Creates

: 
	* `ncdb1970merge.dta`
	
Uses

: 
	* `NCDB_1970to2000_NATIONALALL_whtblk1980vars.dta`	
	* `NCDB_1970to2000_NATIONALALL_whtblk1980vars2.dta`

### `ncdb2000_to_ltdb2010.do` 

Takes 1970 and 1980 white, black, and hisp counts (from NCDB, harmonized to 2000 
boundaries) and harmonizes to 2010 boundaries using the LTDB crosswalk file and 
interpolation code

Creates

: 
	* `ncdb2000_to_ltdb2010.dta`

Uses

:	
	* `crosswalk_2000_2010.dta`
	* `ncdb1970merge.dta`		

### `mrg01.do` 

Merges all LTDB files and the NCDB harmonized file (`ncdb2000_to_ltdb2010.dta`)

Creates

: 
	* `mrg01.dta`			

Uses

:	
	* `ltdb_std_2010_fullcount.dta`	
	* `ltdb_std_2000_fullcount.dta`	
	* `ltdb_std_1990_fullcount.dta`	
	* `ltdb_std_1980_fullcount.dta`	
	* `ltdb_std_1970_fullcount.dta`	
	* `ncdb2000_to_ltdb2010.dta`	

### `pcn02.do` 

Calculates racial/ethnic counts and percentages for all census tracts (w,b,h,a only)

Creates

: 
	* `pcn02.dta`

Uses

: 
	* `mrg01.dta`

### `4metro_mp4.do`

Creates analytic sample (4 metro areas; deletes tract-years with <100 people); 
Prepares file for Mplus 

Creates

: 
	* `4metro_mp4.dta`

Uses

: 
	* `4metro01.dta`



Mplus Analysis Files 
--------------------

Analysis files for [Mplus][] analyses are saved in `MplusFiles/`. The files analyze the data using 9-,10-,11-, and 12-class growth mixture models. 

* `4metro_mp4_gmm1_c9.inp`
* `4metro_mp4_gmm1_c10.inp`
* `4metro_mp4_gmm1_c11.inp`
* `4metro_mp4_gmm1_c12.inp`

[Mplus]: https://www.statmodel.com/

Predicted Trajectories
----------------------

A file containing each tract analyzed and its predicted class trajectory membership can be found in `PredictedClassMembership/classesMergedToFIPS.csv`. The file contains four columns: 

**c**

:    Most probable class membership predicted from growth mixture model using the following codes:

	1. "Stable Black"
	2. "White flight"
	3. "Gradual Black succession"
	4. "Latino enclaves"
	5. "Post-reform Latino growth, White decline"
	6. "Post-reform Latino growth, Black decline"
	7. "Recent Latino growth"
	8. "Recent Asian growth"
	9. "Global n'hood"
	10. "White entry in Latino enclaves"
	11. "Stable White"

**idnew**

:	Sequential unique tract identifier used in MPlus models

**trtid4**

:	Census 2010 FIPS code 

**geoid10**

:	Census 2010 FIPS code (used to confirm `trtid4`)





