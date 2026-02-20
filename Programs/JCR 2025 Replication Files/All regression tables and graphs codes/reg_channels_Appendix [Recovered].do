*** All Appendix Tables ***
clear all
capture log close
set more off

		local user=3  // 1: Firat Demir, 2: Pallab Ghosh, 3 Zhengang Xu, 4 Editor
		if `user'==1 {
		local path "C:\Users\hugue\Dropbox\Workspace\1.Projects\Women\"
		}
		if `user'==2 {
		local path "C:\Users\deboutin\Dropbox\H. Research\En cours\Women\" 
		}
		if `user'==3 {
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\" 
		}
		if `user'==4 {
		local path "..." 
		}
		
local table=9.2
			
		* local tab ="Vaccine_rate"
		* Table9 is the TableA9: Effect of Egyptian Protests on Children's Vaccination Rate
		* 
			
		* COVARIATES : 
		global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"
				
		cd "`path'"
		use "cr_master_UR.dta", clear

* TableA9: Effect of Egyptian Protests on Children's Vaccination Rate	

if `table'==9 {
	
		*****************************************************	
		* TABLE A9: models 1 to 4 (Vaccine rate - female/male)
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg vac_rate01_fm past_group group past
		quietly est store model_1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg vac_rate01_fm past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg vac_rate01_fm past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg vac_rate01_fm past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A9_Vaccine_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}


* TableA9.1: Effect of Egyptian Protests on Female Children's Vaccination Rate	

if `table'==9.1 {
	
		*****************************************************	
		* TABLE A9.1: models 1 to 4 (Vaccine rate - female)
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg vac_rate01_f past_group group past
		quietly est store model_1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.1_Fvacc_rate.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg vac_rate01_f past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.1_Fvacc_rate.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg vac_rate01_f past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.1_Fvacc_rate.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg vac_rate01_f past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.1_Fvacc_rate.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("AppendixTable_A9.1_Fvacc_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}



* TableA9.2: Effect of Egyptian Protests on Male Children's Vaccination Rate	

if `table'==9.2 {
	
		*****************************************************	
		* TABLE A9.2: models 1 to 4 (Vaccine rate - male)
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg vac_rate01_m past_group group past
		quietly est store model_1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.2_Mvacc_rate.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg vac_rate01_m past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.2_Mvacc_rate.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg vac_rate01_m past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.2_Mvacc_rate.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg vac_rate01_m past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9.2_Mvacc_rate.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A9_Vaccine_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}


exit
