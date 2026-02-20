* Merge all cleaned datasets for different age groups.
clear all
capture log close
set more off
set maxvar 32767		

	* Key variables in the age group whose age ranges from 1 to 9
	use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age19_UR2007", clear
	keep ID wealthrate191 wealthrate192 wealthrate193 wealthrate194 reponsewrate19 nb_child reponseedurate190 reponseedurate191 reponseedurate192 age age_husband hwrate19 hedurate190 hedurate191 hedurate192 b_ord religionrate19 dtpeople192 missingwomen19 dtpeople192 mwshare19 vac_rate19
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age19_UR2007_merge", replace
	
	*Key variables in the age group whose age ranges from 10 to 19		
	use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1019_UR2007", clear
	keep ID wealthrate10191 wealthrate10192 wealthrate10193 wealthrate10194 reponsewrate1019 nb_child reponseedurate10190 reponseedurate10191 reponseedurate10192 age age_husband hwrate1019 hedurate10190 hedurate10191 hedurate10192 b_ord religionrate1019 dtpeople10192 missingwomen1019 dtpeople10192 mwshare1019 vac_rate1019
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1019_UR2007_merge", replace
	
	* Key variables in the age group whose age ranges from 20 to 29
	use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age2029_UR2007", clear
	keep ID wealthrate20291 wealthrate20292 wealthrate20293 wealthrate20294 reponsewrate2029 nb_child reponseedurate20290 reponseedurate20291 reponseedurate20292 age age_husband hwrate2029 hedurate20290 hedurate20291 hedurate20292 b_ord religionrate2029 dtpeople20292 missingwomen2029 dtpeople20292 mwshare2029 vac_rate2029
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age2029_UR2007_merge", replace	

	* Merge
	use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1_UR2007", clear
	sort ID, stable
	*drop _m
	
	merge 1:1 ID using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age19_UR2007_merge"
	*keep if _m==3                                                          
	drop _m
	sort ID, stable
	
	merge 1:1 ID using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1019_UR2007_merge"
	*keep if _m==3                                                          
	drop _m
	sort ID, stable
	
	merge 1:1 ID using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age2029_UR2007_merge"
	*keep if _m==3                                                          
	drop _m
	sort ID, stable
		
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR", replace
	
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age19_UR2007_merge.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1019_UR2007_merge.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age2029_UR2007_merge.dta"		
	
exit