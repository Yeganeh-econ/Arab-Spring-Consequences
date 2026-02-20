***   Political Participation and Missing Women: Evidence from the Egyptian Protests of 2011-2014 Full Tables***

*                                          Regressions Tables
*                     (including the calculation of the number of missing women per 100,000)
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
		local path "C:\Users\zheng\Dropbox\Political participation and children_helath\Data\Cleaned data\DHS\" 
		}
		if `user'==4 {
		local path "..." 
		}
		
		
*               CHOOSE HERE THE TABLE YOU WISH TO RUN: 
*======================================================================================
local table=1

				/*
				first number correspond to order of table generation in this dofile:
				
				Table 5: 				
				*/
				
				local tab ="Main_results"

*               GETTING THE DATA READY  : 
*======================================================================================		
				* COVARIATES : 
		global xlist "Poorest Poorer Middle Richer Respondent_work No_education Primary Secondary Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"
				
		cd "`path'"
		use "Combined_DHS_2005_2008_2014.dta", clear

		destring TC_noborder, replace
		des TC_noborder
		g past_group = Time_dummy*TC_noborder 
		des past_group
		

		
		reg Preceding_birth_interval_months past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates)
		reg Fir_bir_age past_group past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates)
		reg AgeofFirstMarriage past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates)
		reg Teen_mom_rate past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates)
		reg Chi_num TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates)
		
		* reg Preceding_birth_interval_months past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates)
		* reg Preceding_birth_interval_months past_group TC_noborder Time_dummy

exit

*               REGRESSION TABLES  : 
*======================================================================================	
*Table 1: Effect of Egyptian Protests on Missing Women
*Table 1 Panel A: Missing women	
if `table'==1 {
	
		*****************************************************	
		* TABLE 1: models 1 to 5 ()
		***************************************************** 				
	*Model 1 Baseline: birth_interval_months
		quietly xi: reg Preceding_birth_interval_months past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates) absorb(Governates)
		quietly est store model_1
		quietly outreg2 using  "Table1_`tab'_UR.xls", append keep(past_group group past $xlist) 

		g mw_model1 = _b[past_group]
		
		
	*Model 2 Baseline: Fir_bir_age
		quietly xi: reg Fir_bir_age past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates) absorb(Governates)
		quietly est store model_2
		quietly outreg2 using  "Table1_`tab'_UR.xls", append keep(past_group group past $xlist) 

		g mw_model2 = _b[past_group]
		
		
	*Model 3 Baseline: Age of First Marriage
		quietly xi: reg Age_of_First_Marriage past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates) absorb(Governates)
		quietly est store model_3
		quietly outreg2 using  "Table1_`tab'_UR.xls", append keep(past_group group past $xlist) 

		g mw_model3 = _b[past_group]
		
	*Model 4 Baseline: Age of First Marriage
		quietly xi: reg Teen_mom_rate past_group TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates) absorb(Governates)
		quietly est store model_4
		quietly outreg2 using  "Table1_`tab'_UR.xls", append keep(past_group group past $xlist) 

		g mw_model4 = _b[past_group]

	*Model 5 Baseline: Age of First Marriage
		quietly xi: reg Chi_num TC_noborder Time_dummy $xlist [pweight=weight], cluster(Governates) absorb(Governates)
		quietly est store model_5
		quietly outreg2 using  "Table1_`tab'_UR.xls", append keep(past_group group past $xlist) 

		g mw_model5 = _b[past_group]

		
		est tab model model_2 model_3 model_4 model_5, keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
		
		save "`path'\Table1_baseline.dta", replace
		
		restore
				
}


*Table 5 Panel B: Placebo: 2007–2010
if `table'==5.2 {

		*****************************************************	
		* TABLE 5 Panel B: models 1 to 8 (placebo estimations(panel B))
		***************************************************** 
		preserve
		drop if year>2010

		* Average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
			
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg missingwomen1 past_group_placebo group past_placebo
		quietly est store model_raw_placebo
		quietly outreg2 using  "Table5B_`tab'_placebo.xls", replace keep(past_group_placebo group past_placebo)
		
		g mw_model1 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000		
		
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg missingwomen1 past_group_placebo group past_placebo $xlist
		quietly est store model_2_placebo
		quietly outreg2 using  "Table5B_`tab'_placebo.xls", append keep(past_group_placebo group past_placebo $xlist)

		g mw_model2 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_2		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000

	*Model 3: baseline: model 1 + Governates (`group' captured by Governates dummies)
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist, cluster(Governates) absorb(Governates)
		quietly est store model_3baseline_placebo
		quietly outreg2 using  "Table5B_`tab'_placebo.xls", append keep(past_group_placebo past_placebo $xlist) 
		
		g mw_model3 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
	*Model 4: model 3 + PS reweighting
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist [pweight=psweightL_placebo], cluster(Governates) absorb(Governates)
		quietly est store m3_psr_placebo
		quietly outreg2 using  "Table5B_`tab'_placebo.xls", append keep(past_group_placebo past_placebo $xlist)
		
		g mw_model4 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000
				
	*Model 5: model 3 + survey weighting                          
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist [pweight=weight], cluster(Governates) absorb(Governates)
		quietly est store m1_swplacebo
		quietly outreg2 using  "Table5B_`tab'_placebo.xls", append keep(past_group_placebo past_placebo $xlist)

		g mw_model5 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000
	                                                                                     
	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist [pweight=share_pop], cluster(Governates) absorb(Governates)
		quietly est store model3_sweight_placebo
		quietly outreg2 using  "Table5B_`tab'_placebo.xls", append keep(past_group_placebo past_placebo $xlist)

		g mw_model6 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_6		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
		est tab model_raw_placebo model_2_placebo model_3baseline_placebo m3_psr_placebo m1_swplacebo model3_sweight_placebo, keep(past_group_placebo) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
	
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "`path'\Table5B_missing_women_placebo_appendix.dta", replace
		
		restore
		
}


*Table 6: Different Phases of Egyptian Protests and Missing Women
if `table'==6 {
		
		*Phase 1 (incl. urban) + survey weighting		
			*Average number of women before the Arab Spring in Phase1
			preserve
			
			egen ave_women_DHS_age1_phase1=mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
				

			*Treatment and control groups in phase1
			replace group = tgover1
			replace past_group = past*group
			
			quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
			quietly est store bl_sw_phase1
			quietly outreg2 using  "Table6_Phases_mw_appendix.xls", replace keep(past_group past $xlist)
		
			g mw_model1 = _b[past_group]
					
			*Calculate the missing women changes in phase1		
			g mw_index_model1 = mw_model1/ave_women_DHS_age1_phase1	
			g missingw_model1 = mw_index_model1*100000	

			
		*Phase 2 (incl. urban) + survey weighting
			*Average number of women before Phase2

			egen ave_women_DHS_age1_phase2=mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010| year==2011)			
			
			*Treatment and control groups in phase2
			replace group = tgover2d
			replace past = (year>=2012)
			replace past_group=past*group
			
			quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
			quietly est store bl_sw_phase2
			quietly outreg2 using  "Table6_Phases_mw_appendix.xls", append keep(past_group past $xlist)	
			
			g mw_model2 = _b[past_group]
					
			*Calculate the missing women changes in phase2		
			g mw_index_model2 = mw_model2/ave_women_DHS_age1_phase2	
			g missingw_model2 = mw_index_model2*100000	
			
			
		*Phase 3 (incl. urban) + survey weighting
			*Average number of women before Phase3

			egen ave_women_DHS_age1_phase3=mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010| year==2011| year==2012)	
			
			*Treatment and control groups in phase3
			replace group = tgover3d
			replace past = (year>=2013)
			replace past_group=past*group

			quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
			quietly est store bl_sw_phase3
			quietly outreg2 using  "Table6_Phases_mw_appendix.xls", append keep(past_group past $xlist)	
			
			g mw_model3 = _b[past_group]
					
			*Calculate the missing women changes in phase3		
			g mw_index_model3 = mw_model3/ave_women_DHS_age1_phase3	
			g missingw_model3 = mw_index_model3*100000	
			
			
		*Phase 4 (incl. urban) + survey weighting
			*Average number of women before Phase4

			egen ave_women_DHS_age1_phase4=mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010| year==2011| year==2012| year==2013)	
			
			*Treatment and control groups in phase4
			replace group = tgover4d
			replace past = (year>=2014)
			replace past_group=past*group

			quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
			quietly est store bl_sw_phase4
			quietly outreg2 using  "Table6_Phases_mw_appendix.xls", append keep(past_group past $xlist)	
			
			g mw_model4 = _b[past_group]
					
			*Calculate the missing women changes in phase4		
			g mw_index_model4 = mw_model4/ave_women_DHS_age1_phase4	
			g missingw_model4 = mw_index_model4*100000	
			
			
			est tab bl_sw_phase1 bl_sw_phase2 bl_sw_phase3 bl_sw_phase4, keep(past_group) title("Phases") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
			*The number of missing women per 100,000 women
			collapse (mean) missingw_model1 missingw_model2 missingw_model3 missingw_model4
			
			save "`path'\Table6_missing_women_phases_appendix.dta", replace	
	
			restore
			
}


*Table 7: Robustness Analysis: Clustering choice
if `table'==7 {
		
		preserve
		*Average number of women before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)		
		
	*cluster: governorates_urban and rural; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store baseline
		quietly outreg2 using  "Table7_cluster_appendix.xls",replace keep(past_group past $xlist) ctitle("Baseline")
				
		g mw_model1 = _b[past_group]
				
		*Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		

	*cluster: governorates_urban and rural; fixed effect: governorates (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(governorate)
		quietly est store cluster1
		quietly outreg2 using  "Table7_cluster_appendix.xls",append keep(past_group past $xlist) ctitle("Clu: g_ur, FE: g")
				
		g mw_model2 = _b[past_group]
				
		*Calculate the missing women changes in model_2	
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000	
		
	
	*cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(governorate) absorb(Governates)
		quietly est store cluster2
		quietly outreg2 using  "Table7_cluster_appendix.xls",append keep(past_group past $xlist) ctitle("Clu: g, FE: g_ur")		
				
		g mw_model3 = _b[past_group]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000	
		
		
	* BS800 cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist, vce(bootstrap, cluster(governorate) reps(800) seed(10101) nodots) absorb(Governates)
		quietly est store boot1
		quietly outreg2 using  "Table7_cluster_appendix.xls",append keep(past_group past $xlist) ctitle("BS800 Clu: g, FE: g_ur")		
				
		g mw_model4 = _b[past_group]
				
		*Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000	
		
		
	*BS1000 cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist, vce(bootstrap, cluster(governorate) reps(1000) seed(10101) nodots) absorb(Governates)
		quietly est store boot2
		quietly outreg2 using  "Table7_cluster_appendix.xls",append keep(past_group past $xlist) ctitle("BS1000 Clu: g, FE: g_ur")		
		
		g mw_model5 = _b[past_group]
				
		*Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000	
		
		
	*Wild BS (Roodman et al 2018), cluster: governorates; fixed effect: governorates_urban and rural baseline, Tab 1, col 3)		
		quietly xi: areg missingwomen1 past_group past $xlist, vce(bootstrap, cluster(governorate)) absorb(Governates)
		boottest past_group , cluster(governorate) bootcluster(governorate) seed(999) nograph // override previous clustering
		est store boot3
		quietly outreg2 using  "Table7_cluster_appendix.xls",append keep(past_group past $xlist) ctitle("wildBS Clu: g, FE: g_ur")		
				
		g mw_model6 = _b[past_group]
				
		*Calculate the missing women changes in model_1		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000	
		
		est tab baseline cluster1 cluster2 boot1 boot2 boot3, keep(past_group) star(0.1 0.05 0.01) stats(N r2) b(%7.3f) 
		est tab baseline cluster1 cluster2 boot1 boot2 boot3, keep(past_group) se  b(%7.3f)  se(%7.3f) 	// with std errors

		*The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "`path'\Table7_missing_women_appendix.dta", replace
		
		restore
}


*Table 8: Robustness Analysis
if `table'==8 {

		*Average number of women before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)	

	*Model 1: Women aged 20-40. (Only 20 to 40 years old)
		preserve
		quietly xi: areg missingwomen12040 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample2040
		quietly outreg2 using  "Table8_robustness_appendix.xls", replace keep(past_group past $xlist)
		restore
		
		g mw_model1 = _b[past_group]
				
		*Calculate the missing women changes in model_2		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		
		
	*Model 2: Interview: no husband. (without husband at the interview)
		preserve
		quietly xi: areg missingwomen1h past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_noh 
		quietly outreg2 using "Table8_robustness_appendix.xls", append keep(past_group past $xlist)
		restore
		
		g mw_model2 = _b[past_group]
				
		*Calculate the missing women changes in model_3		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000	
		
		
	*Model 3: Interview: alone (Without anyone at the interview)
		preserve
		quietly xi: areg missingwomen1alone past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_alone
		quietly outreg2 using "Table8_robustness_appendix.xls", append keep(past_group past $xlist)
		restore		
		
		g mw_model3 = _b[past_group]
				
		*Calculate the missing women changes in model_4		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
		
	*Model 4: Including border governates (Including the border governates)
		preserve
		quiet drop past_group
		rename past_group_border past_group
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_border
		quietly outreg2 using "Table8_robustness_appendix.xls", append keep(past_group past $xlist)
		restore		
		
		g mw_model4 = _b[past_group]
				
		*Calculate the missing women changes in model_5		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000	
		
		
	*Model 5: SYPE TC classification
		preserve
		quiet drop past_group
		rename past_group_SYPE past_group
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_SYPE
		quietly outreg2 using "Table8_robustness_appendix.xls", append keep(past_group past $xlist)
		restore	
		
		g mw_model5 = _b[past_group]
				
		*Calculate the missing women changes in model_6		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000	
		
	*Model 6: No Cairo
		preserve
		drop if Governates==1 //drop Cairo
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_noCairo
		quietly outreg2 using  "Table8_robustness_appendix.xls", append keep(past_group group past $xlist) 
		restore	
		
		g mw_model6 = _b[past_group]
				
		*Calculate the missing women changes in model_9		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
	*Model 7: No Alexandria 
		preserve
		drop if Governates==3 
		drop if Governates==4 //drop Alexandria
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_noAlexandria 
		quietly outreg2 using  "Table8_robustness_appendix.xls", append keep(past_group group past $xlist) 
		restore	
		
		g mw_model7 = _b[past_group]
				
		*Calculate the missing women changes in model_10		
		g mw_index_model7 = mw_model7/ave_women_DHS_age1	
		g missingw_model7 = mw_index_model7*100000		

	*Model 8: Treatment and control groups by election results in 2012. 75% support of Moris
		preserve
		replace group = tgover_election75
		replace past_group = past*group
			
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store sample_election75 
		quietly outreg2 using  "Table8_robustness_appendix.xls", append keep(past_group past $xlist) 
		restore				
		g mw_model8 = _b[past_group]
				
		*Calculate the missing women changes in model_12		
		g mw_index_model8 = mw_model8/ave_women_DHS_age1	
		g missingw_model8 = mw_index_model8*100000

	est tab sample2040 sample_noh sample_alone sample_border sample_SYPE sample_noCairo sample_noAlexandria sample_election75 , keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6 missingw_model7 missingw_model8
		
		save "`path'\Table8_missing_women_robustness_appendix.dta", replace
		
		
}


*Table 9: Different Age Groups Analysis
if `table'==9 {

		* age1-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
		
		* age19-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age19 = mean(dtpeople192) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
	
		* age1019-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1019 = mean(dtpeople10192) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)

		* age2029-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age2029 = mean(dtpeople20292) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
		
		
		*Model 1: age1 group - baseline result in table 5.1
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store age1
		quietly outreg2 using  "Table9_different_ages_appendix.xls", replace keep(past_group group past $xlist)

		g age1_model = _b[past_group]
				
		* Calculate the missing women changes in model_1		
		g mw_index_age1 = age1_model/ave_women_DHS_age1	
		g age1_missingw = mw_index_age1*100000
		
		*Model 2: age19 group		
		quietly xi: areg missingwomen19 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store age19
		quietly outreg2 using  "Table9_different_ages_appendix.xls",	append keep(past_group past $xlist)
		
		g age19_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age19 = age19_model/ave_women_DHS_age19	
		g age19_missingw = mw_index_age19*100000		
		
		*Model 3: age1019 group		
		quietly xi: areg missingwomen1019 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store age1019
		quietly outreg2 using  "Table9_different_ages_appendix.xls",	append keep(past_group past $xlist)
		
		g age1019_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age1019 = age1019_model/ave_women_DHS_age1019	
		g age1019_missingw = mw_index_age1019*100000		
		
		*Model 4: age2029 group		
		quietly xi: areg missingwomen2029 past_group past $xlist, cluster(Governates) absorb(Governates)
		quietly est store age2029
		quietly outreg2 using  "Table9_different_ages_appendix.xls",	append keep(past_group past $xlist)
		
		g age2029_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age2029 = age2029_model/ave_women_DHS_age2029	
		g age2029_missingw = mw_index_age2029*100000
		
		
		
		est tab age1 age19 age1019 age2029 , keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
		* The number of missing women per 100,000 women
		collapse (mean) age1_missingw age19_missingw age1019_missingw age2029_missingw 
		
		save "`path'\Table9_different_ages_appendix.dta", replace
	
		}


exit
	