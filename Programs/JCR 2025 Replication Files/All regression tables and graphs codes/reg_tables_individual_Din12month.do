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
local table=8.1
				/*
				first number correspond to order of table generation in this dofile:
				
				Table A8: 
					table A8.1 Triple DID:  Dep - Effect of Egyptian Protests on Probabilities of Death of Age01 Children
					table A8.2 Regular reg: Dep - Whether a kid was dead within 12 months of birth not triple difference in differences		 	 		
					table A8.3 probit:      Dep - Whether a kid was dead within 12 months of birth not triple difference in differences		 	 		
					table A8.4 logit:       Dep - Whether a kid was dead within 12 months of birth not triple difference in differences
				
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
			
* COVARIATES : 
	keep if year_indicator==2014
		global xlist1 "work b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
		global xlist2 "b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
	
	
  * All basic dummies and interactions
	g tgover_ur_noborder=tgover_ur
	replace tgover_ur_noborder=. if tgover_ur==45| tgover_ur==46| tgover_ur==47| tgover_ur==48| tgover_ur==49| tgover_ur==50				
	g group=tgover_ur_noborder
	g past=(year>=2011) if year_indicator==2014
	g past0814=(year_indicator>=2011)
	replace b_gender=0 if b_gender==1 //male
	replace b_gender=1 if b_gender==2 //female
		
	g triple=past*group*b_gender
	g past_group=past*group
	g gender_group=b_gender*group
	g gender_past=b_gender*past
	
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
		
*               REGRESSION TABLES (INDIVIDUALS)  : 
*======================================================================================	
* Table A8.1: Triple Effect of Egyptian Protests on Probabilities of Death of Age01 Children
* TABLE A8.1: Triple All dummies regressions: * Dep Var: A Dummy Variable whether a kid was dead within 12 months of birth
if `table'==8.1 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: reg d_12m_indicator triple past_group gender_group gender_past group past b_gender
		quietly est store model_raw
		quietly outreg2 using "Table_`tab'A8.1.xls", replace keep(triple past_group gender_group gender_past group past b_gender) dec(3) pdec(3)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg d_12m_indicator triple past_group gender_group gender_past group past $xlist1
		quietly est store model_2
		quietly outreg2 using "Table_`tab'A8.1.xls", append keep(triple past_group gender_group gender_past group past $xlist1) dec(3) pdec(3)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: areg d_12m_indicator triple past_group gender_group gender_past past $xlist1, cluster(clusterid) absorb(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "Table_`tab'A8.1.xls", append keep(triple past_group gender_group gender_past group past $xlist1) dec(3) pdec(3)

	*Model 4: model 3 + PS reweighting
		quietly xi: areg d_12m_indicator triple past_group gender_group gender_past past $xlist1 [pweight=psweightL], cluster(clusterid) absorb(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "Table_`tab'A8.1.xls", append keep(triple past_group gender_group gender_past group past $xlist1) dec(3) pdec(3)

	*Model 5: model 3 + survey weighting
		quietly xi: areg d_12m_indicator triple past_group gender_group gender_past past $xlist1 [pweight=weight], cluster(clusterid) absorb(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "Table_`tab'A8.1.xls", append keep(triple past_group gender_group gender_past group past $xlist1) dec(3) pdec(3)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg d_12m_indicator triple past_group gender_group gender_past past $xlist1 [pweight=share_pop], cluster(clusterid) absorb(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "Table_`tab'A8.1.xls", append keep(d_12m_indicator triple past_group gender_group gender_past group past  $xlist1) dec(3) pdec(3)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(triple past_group gender_group gender_past group past $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
						
}

* TABLE A8.2: Regular reg All dummies regressions: * Dep Var: A Dummy Variable whether a kid was dead within 12 months of birth not triple difference in differences
if `table'==8.2 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: reg d_12m_indicator past_group group past
		quietly est store model_raw
		quietly outreg2 using "Table_`tab'A8.2.xls", replace keep(past_group group past) dec(3) pdec(3)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg d_12m_indicator past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "Table_`tab'A8.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: areg d_12m_indicator past_group past  $xlist1, cluster(clusterid) absorb(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "Table_`tab'A8.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3)

	*Model 4: model 3 + PS reweighting
		quietly xi: areg d_12m_indicator past_group past  $xlist1 [pweight=psweightL], cluster(clusterid) absorb(clusterid)
		quietly est store m3_psr
		quietly outreg2 using  "Table_`tab'A8.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3)

	*Model 5: model 3 + survey weighting
		quietly xi: areg d_12m_indicator past_group past  $xlist1 [pweight=weight], cluster(clusterid) absorb(clusterid)
		quietly est store m1_sw
		quietly outreg2 using  "Table_`tab'A8.2.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg d_12m_indicator past_group past  $xlist1 [pweight=share_pop], cluster(clusterid) absorb(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "Table_`tab'A8.2.xls", append keep(d_12m_indicator past_group group past   $xlist1) dec(3) pdec(3)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past  $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
						
}

* TABLE A8.3: All dummies regressions: * Dep Var: A Dummy Variable whether a kid was dead within 12 months of birth non_linear-probit
if `table'==8.3 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: probit d_12m_indicator past_group group past
		quietly est store model_raw
		quietly outreg2 using "Table_`tab'A8.3.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: probit d_12m_indicator past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "Table_`tab'A8.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: probit d_12m_indicator past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "Table_`tab'A8.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: probit d_12m_indicator past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid)
		quietly est store m3_psr 
		quietly outreg2 using  "Table_`tab'A8.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: probit d_12m_indicator past_group past group  $xlist1 [pweight=weight], cluster(clusterid) 
		quietly est store m1_sw
		quietly outreg2 using  "Table_`tab'A8.3.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: probit d_12m_indicator past_group past group  $xlist1 [pweight=share_pop], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "Table_`tab'A8.3.xls", append keep(d_12m_indicator past_group group past   $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past  $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)								
}


* TABLE A8.4: All dummies regressions: * Dep Var: A Dummy Variable whether a kid was dead within 12 months of birth non_linear-logit
if `table'==8.4 {	

	*Model 1 Raw: (All dummies and interactons)
		quietly xi: logit d_12m_indicator past_group group past
		quietly est store model_raw
		quietly outreg2 using "Table_`tab'A8.4.xls", replace keep(past_group group past) dec(3) pdec(3) e(r2_p)
			
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: logit d_12m_indicator past_group group past  $xlist1
		quietly est store model_2
		quietly outreg2 using "Table_`tab'A8.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: logit d_12m_indicator past_group past group  $xlist1, cluster(clusterid)
		quietly est store model_3baseline
		quietly outreg2 using "Table_`tab'A8.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 4: model 3 + PS reweighting
		quietly xi: logit d_12m_indicator past_group past group  $xlist1 [pweight=psweightL], cluster(clusterid) 
		quietly est store m3_psr
		quietly outreg2 using  "Table_`tab'A8.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 5: model 3 + survey weighting
		quietly xi: logit d_12m_indicator past_group past group  $xlist1 [pweight=weight], cluster(clusterid) 
		quietly est store m1_sw
		quietly outreg2 using  "Table_`tab'A8.4.xls", append keep(past_group group past  $xlist1) dec(3) pdec(3) e(r2_p)

	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: logit d_12m_indicator past_group past group  $xlist1 [pweight=share_pop], cluster(clusterid)
		quietly est store model3_sweight
		quietly outreg2 using  "Table_`tab'A8.4.xls", append keep(d_12m_indicator past_group group past   $xlist1) dec(3) pdec(3) e(r2_p)
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past  $xlist1) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
}

exit