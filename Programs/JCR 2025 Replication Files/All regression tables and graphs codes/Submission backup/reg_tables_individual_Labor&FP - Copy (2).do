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
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\Codes\Publication code"
		}
		if `user'==4 {
		local path "..." 
		}
		
		
*               CHOOSE HERE THE TABLE YOU WISH TO RUN: 
*======================================================================================
local table=9.1
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
		
		bysort caseid clusterid hhid rlineid: gen n = _n
		drop if (n!=1 & year_indicator==2014)
		 
* COVARIATES : 
		global xlist1 "work b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
		global xlist2 "b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
	
  * All basic dummies and interactions
	g tgover_ur_noborder=tgover_ur
	replace tgover_ur_noborder=. if tgover_ur==45| tgover_ur==46| tgover_ur==47| tgover_ur==48| tgover_ur==49| tgover_ur==50				
	g group=tgover_ur_noborder
	g past=(year_indicator>=2011)
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

   
* Dep Var: A Dummy Variable for Labor Force Participation
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* Table A9.1: Effect of Egyptian Protests on Labor Force Participation Probit Model
* TABLE A9.1: All dummies regressions: * Dep Var: A Dummy Variable whether Responsdent in Labor Force
if `table'==9.1 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit work past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA9.1.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit work past_group group past $xlist2
		quietly est store model_2
		quietly outreg2 using "TableA9.1.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: probit work past_group past group $xlist2, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA9.1.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit work past_group past group $xlist2 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA9.1.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit work past_group past group $xlist2 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA9.1.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit work past_group past group $xlist2 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA9.1.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist2) title("`tab'") star(0.1 0.05 0.01) stats(N r2 r2_p) b(%7.3f)		
					
}


* TABLE A9.2: All dummies regressions: * Dep Var: A Dummy Variable whether Responsdent in Labor Force Logit Model
if `table'==9.2 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit work past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA9.2.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit work past_group group past $xlist2
		quietly est store model_2
		quietly outreg2 using "TableA9.2.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit work past_group past group $xlist2, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA9.2.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit work past_group past group $xlist2 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA9.2.xls", append keep(past_group group past $xlist2) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit work past_group past group $xlist2 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA9.2.xls", append keep(work past_group group past $xlist2) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit work past_group past group $xlist2 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA9.2.xls", append keep(work past_group group past $xlist2) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist2) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}


* Dep Var: A Dummy Variable for Attidute at Women
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* TABLE A10.1: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision to visit her family
if `table'==10.1 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit visit_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA10.1.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit visit_ternary past_group group past $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA10.1.xls", append keep(past_group group past $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: probit visit_ternary past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA10.1.xls", append keep(past_group group past $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit visit_ternary past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA10.1.xls", append keep(past_group group past $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit visit_ternary past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA10.1.xls", append keep(work past_group group past $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit visit_ternary past_group past group $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA10.1.xls", append keep(work past_group group past $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past b_gender $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}
	

* TABLE A10.2: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision to visit her family Logit
if `table'==10.2 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit visit_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA10.2.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit visit_ternary past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA10.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit visit_ternary past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA10.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit visit_ternary past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA10.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit visit_ternary past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA10.2.xls", append keep(work past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit visit_ternary past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA10.2.xls", append keep(work past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}


* Dep Var: A Dummy Variable for Purchase Decision
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* TABLE A10.3: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision to purchase probit 
if `table'==10.3 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit pur_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA10.3.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit pur_ternary past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA10.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: probit pur_ternary past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA10.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit pur_ternary past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA10.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit pur_ternary past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA10.3.xls", append keep(work past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit pur_ternary past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA10.3.xls", append keep(work past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

	
* TABLE A10.4: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision to purchase logit
if `table'==10.4 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit pur_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA10.4.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit pur_ternary past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA10.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit pur_ternary past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA10.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit pur_ternary past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA10.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit pur_ternary past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA10.4.xls", append keep(work past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit pur_ternary past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA10.4.xls", append keep(work past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}


* Dep Var: A Dummy Variable for Purchase Decision
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* TABLE A10.5: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision about their own health probit 
if `table'==10.5 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit health_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA10.5.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit health_ternary past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA10.5.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: probit health_ternary past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA10.5.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit health_ternary past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA10.5.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit health_ternary past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA10.5.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit health_ternary past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA10.5.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

* TABLE A10.6: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision about their own health probit
if `table'==10.6 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit health_ternary past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA10.6.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit health_ternary past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA10.6.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit health_ternary past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA10.6.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit health_ternary past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA10.6.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit health_ternary past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA10.6.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit health_ternary past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA10.6.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}


* Dep Var: A Dummy Variable for Domestic violence
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* TABLE A11.1: All dummies regressions: * Dep Var: A Dummy Variable - Domestic violence
* Disagree with any kind of domestic violence=1
if `table'==11.1 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit tol_vio_1 past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA11.1.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit tol_vio_1 past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA11.1.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: probit tol_vio_1 past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA11.1.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit tol_vio_1 past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA11.1.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit tol_vio_1 past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA11.1.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit tol_vio_1 past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA11.1.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

* TABLE A11.2: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision about their own health logit
if `table'==11.2 {	

	*Model 1 Raw: (All dummies and interactons)
		*quietly xi: logit tol_vio_1 past_group group past
		*quietly est store model_raw
		*quietly outreg2 using "TableA11.2.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit tol_vio_1 past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA11.2.xls", replace keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit tol_vio_1 past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA11.2.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA11.2.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA11.2.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit tol_vio_1 past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA11.2.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

***********************************************************************************************

* Dep Var: A Dummy Variable for Domestic violence without other persons's influcence during interview
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* TABLE A11.3: All dummies regressions: * Dep Var: A Dummy Variable - Domestic violence
* Disagree with any kind of domestic violence=1
if `table'==11.3 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit tol_vio_noinfl_1 past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA11.3.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit tol_vio_noinfl_1 past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA11.3.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: probit tol_vio_noinfl_1 past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA11.3.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit tol_vio_noinfl_1 past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA11.3.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit tol_vio_noinfl_1 past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA11.3.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit tol_vio_noinfl_1 past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA11.3.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

* TABLE A11.4: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision about their own health logit
if `table'==11.4 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit tol_vio_noinfl_1 past_group group past
		quietly est store model_raw
		quietly outreg2 using "TableA11.4.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit tol_vio_noinfl_1 past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "TableA11.4.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p) 
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies) - absorb (clusterid) and group highly corralated
		quietly xi: logit tol_vio_noinfl_1 past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "TableA11.4.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit tol_vio_noinfl_1 past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "TableA11.4.xls", append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit tol_vio_noinfl_1 past_group past group  $xlist1 [pweight=weight], cluster(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "TableA11.4.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit tol_vio_noinfl_1 past_group past group  $xlist1 [pweight=share_pop_w], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "TableA11.4.xls", append keep(work past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
}

exit
