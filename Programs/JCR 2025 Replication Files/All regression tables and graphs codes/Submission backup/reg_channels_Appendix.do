*** All possible channels checking Appendix Table A9 ***
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
		
local table=8
			
		* local tab ="Vaccine_rate"
			
		* COVARIATES : 
		global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"
				
		cd "`path'"
		use "cr_master_UR.dta", clear

* Table Appendix A8:  Vaccine rate - female/male	
if `table'==8 {
	
		*****************************************************	
		* TABLE A8: models 1 to 4 (Vaccine rate - female/male)
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg vac_rate01_fm past_group group past
		quietly est store model_1
		quietly outreg2 using  "Table_A8_Vaccine_rate.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg vac_rate01_fm past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "Table_A8_Vaccine_rate.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg vac_rate01_fm past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "Table_A8_Vaccine_rate.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg vac_rate01_fm past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "Table_A8_Vaccine_rate.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A8_Vaccine_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}

	
* Table Appendix A9:  Doctor visiting during pregnancy	
if `table'==9 {
	
		*****************************************************	
		* TABLE A9: models 1 to 4 (doctor visiting rate - (# of doctors/# of pregnecy)), # of doctors is between 5 and 15.
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg dr_visit_rate01 past_group group past
		quietly est store model_1
		quietly outreg2 using  "Table_A9_Dr_visiting_rate.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg dr_visit_rate01 past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "Table_A9_Dr_visiting_rate.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg dr_visit_rate01 past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "Table_A9_Dr_visiting_rate.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg dr_visit_rate01 past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "Table_A9_Dr_visiting_rate.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A9_Dr_visiting_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}


* Table Appendix A10:  Birth weight ratio	
if `table'==10 {
	
		*****************************************************	
		* TABLE A10: models 1 to 4 (Birth weight ratio - female/male)
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg birth_weight_fm past_group group past
		quietly est store model_1
		quietly outreg2 using  "Table_A10_Birth_weight_ratio.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg birth_weight_fm past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "Table_A10_Birth_weight_ratio.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg birth_weight_fm past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "Table_A10_Birth_weight_ratio.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg birth_weight_fm past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "Table_A10_Birth_weight_ratio.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A10_Birth_weight_ratio") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}


* Table Appendix A11:  Domestic violence ratio during pregnancy
if `table'==11 {
	
		*****************************************************	
		* TABLE A11: models 1 to 4 (Domestic violence ratio - # of violence/# of pregnancy)
		***************************************************** 		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg dv_rate01 past_group group past
		quietly est store model_1
		quietly outreg2 using  "Table_A11_Domestic_violence_ratio.xls", replace keep(past_group group past)
				
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg dv_rate01 past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "Table_A11_Domestic_violence_ratio.xls", append keep(past_group group past $xlist) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + survey weighting
		quietly xi: areg dv_rate01 past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3
		quietly outreg2 using  "Table_A11_Domestic_violence_ratio.xls", append keep(past_group group past $xlist)
	
	*Model 4: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) + self-created weighting (age, education, etc)
		quietly xi: areg dv_rate01 past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model_4
		quietly outreg2 using  "Table_A11_Domestic_violence_ratio.xls", append keep(past_group group past $xlist)
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A11_Domestic_violence_ratio") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
			
}

exit
