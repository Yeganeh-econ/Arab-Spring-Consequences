***   Political Participation and Missing Women: Evidence from the Egyptian Protests of 2011-2014 ***

*                                          Regressions Tables Individuals
******************************************************************************************************

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
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS"
		}
		if `user'==4 {
		local path "..." 
		}
		
		
*               CHOOSE HERE THE TABLE YOU WISH TO RUN: 
*======================================================================================
local table=10.3
				/*
				first number correspond to order of table generation in this dofile:
				
				Table A9: 				
					table A9.1 probit: Dep - whether Responsdent in Labor Force
					table A9.2 logit:  Dep - whether Responsdent in Labor Force		
					
								
				Table A10: 				
					table A10.1 probit: Dep - whether the women can make the decision to visit her family 
					table A10.2 logit:  Dep - whether the women can make the decision to visit her family 
					table A10.3 probit: Dep - whether the women can make the decision to purchase 
					table A10.4 logit:  Dep - whether the women can make the decision to purchase 
					table A10.5 probit: Dep - whether the women can make the decision about their own health 
					table A10.6 logit:  Dep - whether the women can make the decision about their own health 			
				*/
				
				local tab ="Individuals"

*               GETTING THE DATA READY  : 
*======================================================================================
			
		cd "`path'"			
		use "tem_master_age1_UR.dta", clear
		
		g past=(year_indicator>=2011)
		
		bysort caseid clusterid hhid rlineid: gen n = _n
		drop if (n!=1 & year_indicator==2014)

		g p_work = past*work
		g p_b_gender = past*b_gender 
		g p_age = past*age 
		g p_age_husband = past*age_husband 
		g p_husband_work = past*husband_work 
		g p_b_ord = past*b_ord 
		g p_nb_child = past*nb_child 
		g p_religion = past*religion 
		g p_noeducation = past*noeducation 
		g p_primary = past*primary 
		g p_secondary = past*secondary 
		g p_h_noeducation = past*h_noeducation 
		g p_h_primary = past*h_primary 
		g p_h_secondary = past*h_secondary 
		g p_poorest = past*poorest 
		g p_poorer = past*poorer 
		g p_middle = past*middle 
		g p_richer = past*richer
			
* COVARIATES : 
		global xlist1 "work b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
		
		global xlistpxc "p_work p_b_gender p_age p_age_husband p_husband_work p_b_ord p_nb_child p_religion p_noeducation p_primary p_secondary p_h_noeducation p_h_primary p_h_secondary p_poorest p_poorer p_middle p_richer"
		global xlist2 "b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
	
  * All basic dummies and interactions
	g tgover_ur_noborder=tgover_ur
	replace tgover_ur_noborder=. if tgover_ur==45| tgover_ur==46| tgover_ur==47| tgover_ur==48| tgover_ur==49| tgover_ur==50				
	g group=tgover_ur_noborder
	
	replace b_gender=0 if b_gender==1 //male
	replace b_gender=1 if b_gender==2 //female
		
	g past_group=past*group
	
 * Attidute to women 	
	replace visit_ternary=1 if visit_ternary==2 
	replace pur_ternary=1 if  pur_ternary==2
	replace health_ternary=1 if health_ternary==2
	
	*missing values solution
	replace wealthrate11=0 if wealthrate11==.
	replace wealthrate12=0 if wealthrate12==.	
	replace wealthrate13=0 if wealthrate13==.
	replace wealthrate14=0 if wealthrate14==.
					
* Gender redefine				
	replace b_gender = (b_gender==1)
	
	label var b_gender "Kid gender"
	label define b_genderL 1 "female kid" 0 "male kid"
	labe values b_gender b_genderL
		
	*Estimate the weights from propensity score matching
	logit tgover_ur past i.weath_index nb_child i.education i.heducation age age_husband husband_work //These variables are the same as the governates level but at the invidiaul level
	
	predict Lps
	replace Lps=1 if tgover_ur==1
				
	*PS weight
	g psweightL=1/(1-Lps) if tgover_ur==0
	replace psweightL=1 if tgover_ur==1


* Dep Var: A Dummy Variable for Domestic violence
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* Table A5: Logit Model: Effects of Egyptian Protests on Domestic Violence During Pregnancy (Full Table 7 in the Main Text)
* Disagree with any kind of domestic violence=1

* TABLE A5: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision about their own health logit
if `table'==5 {	
	
	*Model 1 Baseline: including all control variables (age, education, etc)
		quietly xi: logit tol_vio_1 past_group group past  $xlist1 $xlistpxc
		quietly est store model_2
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA5PostxControls_Dom_Vio_Dur_Preg_PXC.xls", replace keep(past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p) 
		
	*Model 2: baseline model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 $xlistpxc, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA5PostxControls_Dom_Vio_Dur_Preg_PXC.xls", append keep(past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 3: model 2 + PS reweighting
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 $xlistpxc [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA5PostxControls_Dom_Vio_Dur_Preg_PXC.xls", append keep(past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 4: model 2 + survey weighting
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 $xlistpxc [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA5PostxControls_Dom_Vio_Dur_Preg_PXC.xls", append keep(work past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 5: model 2 + self-created weighting (age, education, etc)
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 $xlistpxc [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA5PostxControls_Dom_Vio_Dur_Preg_PXC.xls", append keep(work past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)
		
		est tab model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1 $xlistpxc) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

* Table A10.1: Logit Model: Effects of Egyptian Protests on Empowerment: Making Decisions About One's Own Health
if `table'==10.1 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit health_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.1PostxControls_Making_Deci_Health_PXC.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit health_ternary past_group group past  $xlist1 $xlistpxc
		quietly est store model_2
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.1PostxControls_Making_Deci_Health_PXC.xls", append keep(past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit health_ternary past_group past group  $xlist1 $xlistpxc, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.1PostxControls_Making_Deci_Health_PXC.xls", append keep(past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit health_ternary past_group past group  $xlist1 $xlistpxc [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.1PostxControls_Making_Deci_Health_PXC.xls", append keep(past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit health_ternary past_group past group  $xlist1 $xlistpxc [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.1PostxControls_Making_Deci_Health_PXC.xls", append keep(work past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit health_ternary past_group past group  $xlist1 $xlistpxc [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.1PostxControls_Making_Deci_Health_PXC.xls", append keep(work past_group group past b_gender $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1 $xlistpxc) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}


* Table A10.2: Logit Model: Effects of Egyptian Protests on Empowerment: Making Decisions to Purchase
if `table'==10.2 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit pur_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.2PostxControls_Making_Dec_Pur_PXC.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit pur_ternary past_group group past  $xlist1 $xlistpxc
		quietly est store model_2
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.2PostxControls_Making_Dec_Pur_PXC.xls", append keep(past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit pur_ternary past_group past group  $xlist1 $xlistpxc, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.2PostxControls_Making_Dec_Pur_PXC.xls", append keep(past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit pur_ternary past_group past group  $xlist1 $xlistpxc [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.2PostxControls_Making_Dec_Pur_PXC.xls", append keep(past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit pur_ternary past_group past group  $xlist1 $xlistpxc [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.2PostxControls_Making_Dec_Pur_PXC.xls", append keep(work past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit pur_ternary past_group past group  $xlist1 $xlistpxc [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.2PostxControls_Making_Dec_Pur_PXC.xls", append keep(work past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1 $xlistpxc) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

* Table A10.3: Logit Model: Effects of Egyptian Protests on Empowerment: Making Decision About Visiting One's Own Family Members
if `table'==10.3 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit visit_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.3PostxControls_Vis_Family_PXC.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit visit_ternary past_group group past  $xlist1 $xlistpxc
		quietly est store model_2
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.3PostxControls_Vis_Family_PXC.xls", append keep(past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit visit_ternary past_group past group  $xlist1 $xlistpxc, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.3PostxControls_Vis_Family_PXC.xls", append keep(past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit visit_ternary past_group past group  $xlist1 $xlistpxc [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.3PostxControls_Vis_Family_PXC.xls", append keep(past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit visit_ternary past_group past group  $xlist1 $xlistpxc [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.3PostxControls_Vis_Family_PXC.xls", append keep(work past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit visit_ternary past_group past group  $xlist1 $xlistpxc [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Appen_TableA10.3PostxControls_Vis_Family_PXC.xls", append keep(work past_group group past  $xlist1 $xlistpxc) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1 $xlistpxc) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

exit
