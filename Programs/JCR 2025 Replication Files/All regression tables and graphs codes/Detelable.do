use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
		
		
**********************************************************tgover1R*******************************************************************
	* Treatment and control area dummy variables - Phase 1 death (Removed edge governates)
	recode governorate (1 2 3 4 16 17 19 21 23 22=1) ( 11 12 13 15 24 25 26 27 28 29=0), gen (tgover1R)	
	label var tgover1R "treatment ares"
	label define treatmentd1R 1 "treated" 0 "control"
	label values tgover1R treatmentd1R
	replace tgover1R=. if tgover1R==31| tgover1R==32| tgover1R==33| tgover1R==14| tgover1R==16| tgover1R==18
******************************************************************tgover1R***********************************************************	


***************************************************tgover2dR***************************************************************************
	* Treatment and control area dummy variables - Phase 2 death (Removed edge governates)
	recode governorate (1 3 4 19 21 24 26 =1) ( 2 12 15 17 22 25 27=0), gen (tgover2dR)	
	label var tgover2dR "treatment ares"
	label define treatmentd2dR 1 "treated" 0 "control"
	label values tgover2dR treatmentd2dR
	replace tgover2dR=. if tgover2dR==31| tgover2dR==32| tgover2dR==33| tgover2dR==11| tgover2dR==13| tgover2dR==14| tgover2dR==16| tgover2dR==18| tgover2dR==23| tgover2dR==28| tgover2dR==29
******************************************************tgover2dR*************************************************************************	


*************************************************tgover3dR********************************************************************************
	* Treatment and control area dummy variables - phase 3 death (Removed edge governates)
	recode governorate (1 2 3 4 14 18 19 21 24=1) (11 13 15 17 25 27 28 29=0), gen (tgover3dR)	
	label var tgover3dR "treatment ares"
	label define treatmentd3dR 1 "treated" 0 "control"
	label values tgover3dR treatmentd3dR
	replace tgover3dR=. if tgover3dR==31| tgover3dR==32| tgover3dR==33| tgover3dR==12| tgover3dR==16| tgover3dR==22| tgover3dR==23| tgover3dR==26
**************************************************tgover3dR********************************************************************************


*************************************************tgover4dR*********************************************************************************
	* Treatment and control area dummy variables - phase 4 death
	recode governorate (26 4 3 1 2 19 24 21 11 23 22=1) (15 16 25 13 18 29 14 17 27=0), gen (tgover4dR)	
	label var tgover4dR "treatment ares"
	label define treatmentd4dR 1 "treated" 0 "control"
	label values tgover4dR treatmentd4dR
	replace tgover4dR=. if tgover4dR==31| tgover4dR==32| tgover4dR==33| tgover4dR==12| tgover4dR==28
**************************************************tgover4dR********************************************************************************


save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", replace
	