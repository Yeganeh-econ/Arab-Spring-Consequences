***   Political Participation and Missing Women: Evidence from the Egyptian Protests of 2011-2014 ***

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
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\" 
		}
		if `user'==4 {
		local path "..." 
		}
		
		
*               CHOOSE HERE THE TABLE YOU WISH TO RUN: 
*======================================================================================
local table=5.1

				/*
				first number correspond to order of table generation in this dofile:
				
				Table 5: Effect of Egyptian Protests on Missing Women
					table=5.1 Table 5 Panel A: Missing women			 			- Baseline in Table 5 Panel A
					table=5.2 Table 5 Panel B: Placebo: 2007–2010		 	 		- Placebo test on baseline regression in Table 5 Panel B
				
				
				Table 6: Different Phases of Egyptian Protests and Missing Women				
				
				Table 7: Robustness Analysis: Clustering choice
				
				Table 8: Robustness Analysis                                         - Different subsamples and sample selections				
				*/
				
				local tab ="PostxControls"

*               GETTING THE DATA READY  : 
*======================================================================================
			
				* COVARIATES : 
		global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"
				
		global xlist_age19 "wealthrate191 wealthrate192 wealthrate193 wealthrate194 reponsewrate19 nb_child reponseedurate190 reponseedurate191 reponseedurate192 age age_husband hwrate19 hedurate190 hedurate191 hedurate192 b_ord religionrate19"	

		global xlist_age1019 "wealthrate10191 wealthrate10192 wealthrate10193 wealthrate10194 reponsewrate1019 nb_child reponseedurate10190 reponseedurate10191 reponseedurate10192 age age_husband hwrate1019 hedurate10190 hedurate10191 hedurate10192 b_ord religionrate1019"
	
		global xlist_age2029 "wealthrate20291 wealthrate20292 wealthrate20293 wealthrate20294 reponsewrate2029 nb_child reponseedurate20290 reponseedurate20291 reponseedurate20292 age age_husband hwrate2029 hedurate20290 hedurate20291 hedurate20292 b_ord religionrate2029"
		
		cd "`path'"
		use "cr_master_UR.dta", clear

g pwealthrate11=past*wealthrate11 
g pwealthrate12=past*wealthrate12 
g pwealthrate13=past*wealthrate13 
g pwealthrate14=past*wealthrate14 
g preponsewrate1=past*reponsewrate1 
g pnb_child=past*nb_child 
g preponseedurate10=past*reponseedurate10 
g preponseedurate11 =past*reponseedurate11 
g preponseedurate12=past*reponseedurate12 
g page=past*age 
g page_husband=past*age_husband 
g phwrate1=past*hwrate1 
g phedurate10=past*hedurate10 
g phedurate11=past*hedurate11 
g phedurate12=past*hedurate12 
g pb_ord=past*b_ord 
g preligionrate1=past*religionrate1

global xlistpxc "pwealthrate11 pwealthrate12 pwealthrate13 pwealthrate14 preponsewrate1 pnb_child preponseedurate10 preponseedurate11 preponseedurate12 page page_husband phwrate1 phedurate10 phedurate11 phedurate12 pb_ord preligionrate1"

* The following new variables are only foe placebo test
g pl_wealthrate11=past_placebo*wealthrate11 
g pl_wealthrate12=past_placebo*wealthrate12 
g pl_wealthrate13=past_placebo*wealthrate13 
g pl_wealthrate14=past_placebo*wealthrate14 
g pl_reponsewrate1=past_placebo*reponsewrate1 
g pl_nb_child=past_placebo*nb_child 
g pl_reponseedurate10=past_placebo*reponseedurate10 
g pl_reponseedurate11 =past_placebo*reponseedurate11 
g pl_reponseedurate12=past_placebo*reponseedurate12 
g pl_age=past_placebo*age 
g pl_age_husband=past_placebo*age_husband 
g pl_hwrate1=past_placebo*hwrate1 
g pl_hedurate10=past_placebo*hedurate10 
g pl_hedurate11=past_placebo*hedurate11 
g pl_hedurate12=past_placebo*hedurate12 
g pl_b_ord=past_placebo*b_ord 
g pl_religionrate1=past_placebo*religionrate1

global pl_xlistpxc "pl_wealthrate11 pl_wealthrate12 pl_wealthrate13 pl_wealthrate14 pl_reponsewrate1 pl_nb_child pl_reponseedurate10 pl_reponseedurate11 pl_reponseedurate12 pl_age pl_age_husband pl_hwrate1 pl_hedurate10 pl_hedurate11 pl_hedurate12 pl_b_ord pl_religionrate1"


*               REGRESSION TABLES  : 
*======================================================================================	
*Table 5: Effect of Egyptian Protests on Missing Women
*Table 5 Panel A: Missing women	
if `table'==5.1 {
	
		*****************************************************	
		* TABLE 5 Panel A: models 1 to 6 (missing women estimations)
		***************************************************** 		
		* Average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
		egen ave_missingwomen_before = rmean(missingwomen1) if past==0
		egen ave_missingwomen_after = rmean(missingwomen1) if past==1
		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg missingwomen1 past_group group past
		quietly est store model_raw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_`tab'_UR_PXC.xls", replace keep(past_group group past)
		
		g mw_model1 = _b[past_group]		
		
		* Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg missingwomen1 past_group past group $xlist $xlistpxc
		quietly est store model_2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_`tab'_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc) 

		g mw_model2 = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: areg missingwomen1 past_group past $xlist $xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3baseline
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_`tab'_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model3 = _b[past_group]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
	*Model 4: model 3 + PS reweighting
		quietly xi: areg missingwomen1 past_group past $xlist $xlistpxc [pweight=psweightL], cluster(governates_ur) absorb(governates_ur)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_`tab'_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model4 = _b[past_group]
				
		* Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000
		
	*Model 5: model 3 + survey weighting
		quietly xi: areg missingwomen1 past_group past $xlist $xlistpxc [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_`tab'_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model5 = _b[past_group]
				
		* Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000
		
	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg missingwomen1 past_group group past $xlist $xlistpxc [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_`tab'_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model6 = _b[past_group]
				
		* Calculate the missing women changes in model_6		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
		
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 ave_missingwomen_before ave_missingwomen_after missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_missing_women_PXC.dta", replace
		
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
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_placebo_PXC.xls", replace keep(past_group_placebo group past_placebo)
		
		g mw_model1 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000		
		
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg missingwomen1 past_group_placebo group past_placebo $xlist $pl_xlistpxc
		quietly est store model_2_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_placebo_PXC.xls", append keep(past_group_placebo group past_placebo $xlist $pl_xlistpxc)

		g mw_model2 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_2		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000

	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3baseline_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc) 
		
		g mw_model3 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
	*Model 4: model 3 + PS reweighting
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc [pweight=psweightL_placebo], cluster(governates_ur) absorb(governates_ur)
		quietly est store m3_psr_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc)
		
		g mw_model4 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000
				
	*Model 5: model 3 + survey weighting                          
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store m1_swplacebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc)

		g mw_model5 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000
	                                                                                     
	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model3_sweight_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc)

		g mw_model6 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_6		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
		est tab model_raw_placebo model_2_placebo model_3baseline_placebo m3_psr_placebo m1_swplacebo model3_sweight_placebo, keep(past_group_placebo) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
	
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_`tab'_missing_women_placebo_PXC.dta", replace
		
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
			
			quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase1
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_`tab'_Phases_mw_PXC.xls", replace keep(past_group past $xlist $pl_xlistpxc)
		
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
			
			quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase2
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_`tab'_Phases_mw_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
			
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

			quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase3
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_`tab'_Phases_mw_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
			
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

			quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase4
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_`tab'_Phases_mw_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
			
			g mw_model4 = _b[past_group]
					
			*Calculate the missing women changes in phase4		
			g mw_index_model4 = mw_model4/ave_women_DHS_age1_phase4	
			g missingw_model4 = mw_index_model4*100000	
			
			
			est tab bl_sw_phase1 bl_sw_phase2 bl_sw_phase3 bl_sw_phase4, keep(past_group) title("Phases") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
			*The number of missing women per 100,000 women
			collapse (mean) missingw_model1 missingw_model2 missingw_model3 missingw_model4
			
			save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_`tab'_missing_women_phases_PXC.dta", replace	
	
			restore
			
}


*Table 8: Robustness Analysis: Clustering choice
if `table'==8 {
		
		preserve
		*Average number of women before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)		
		
	*cluster: governorates_urban and rural; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store baseline
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_cluster_PXC.xls",replace keep(past_group past $xlist $pl_xlistpxc) ctitle("Baseline")
				
		g mw_model1 = _b[past_group]
				
		*Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		

	*cluster: governorates_urban and rural; fixed effect: governorates (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governorate)
		quietly est store cluster1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("Clu: g_ur, FE: g")
				
		g mw_model2 = _b[past_group]
				
		*Calculate the missing women changes in model_2	
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000	
		
	
	*cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governorate) absorb(governates_ur)
		quietly est store cluster2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("Clu: g, FE: g_ur")		
				
		g mw_model3 = _b[past_group]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000	
		
		
	* BS800 cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, vce(bootstrap, cluster(governorate) reps(800) seed(10101) nodots) absorb(governates_ur)
		quietly est store boot1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("BS800 Clu: g, FE: g_ur")		
				
		g mw_model4 = _b[past_group]
				
		*Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000	
		
		
	*BS1000 cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, vce(bootstrap, cluster(governorate) reps(1000) seed(10101) nodots) absorb(governates_ur)
		quietly est store boot2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("BS1000 Clu: g, FE: g_ur")		
		
		g mw_model5 = _b[past_group]
				
		*Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000	
		
		
	*Wild BS (Roodman et al 2018), cluster: governorates; fixed effect: governorates_urban and rural baseline, Tab 1, col 3)		
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, vce(bootstrap, cluster(governorate)) absorb(governates_ur)
		boottest past_group , cluster(governorate) bootcluster(governorate) seed(999) nograph // override previous clustering
		est store boot3
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("wildBS Clu: g, FE: g_ur")		
				
		g mw_model6 = _b[past_group]
				
		*Calculate the missing women changes in model_1		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000	
		
		est tab baseline cluster1 cluster2 boot1 boot2 boot3, keep(past_group) star(0.1 0.05 0.01) stats(N r2) b(%7.3f) 
		est tab baseline cluster1 cluster2 boot1 boot2 boot3, keep(past_group) se  b(%7.3f)  se(%7.3f) 	// with std errors

		*The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_`tab'_missing_women_PXC.dta", replace
		
		restore
}


*Table 9: Robustness Analysis
if `table'==9 {

		*Average number of women before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)	

	*Model 1: Women aged 20-40. (Only 20 to 40 years old)
		preserve
		quietly xi: areg missingwomen12040 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample2040
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", replace keep(past_group past $xlist $pl_xlistpxc)
		restore
		
		g mw_model1 = _b[past_group]
				
		*Calculate the missing women changes in model_2		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		
		
	*Model 2: Interview: no husband. (without husband at the interview)
		preserve
		quietly xi: areg missingwomen1h past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_noh 
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)
		restore
		
		g mw_model2 = _b[past_group]
				
		*Calculate the missing women changes in model_3		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000	
		
		
	*Model 3: Interview: alone (Without anyone at the interview)
		preserve
		quietly xi: areg missingwomen1alone past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_alone
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)
		restore		
		
		g mw_model3 = _b[past_group]
				
		*Calculate the missing women changes in model_4		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
		
	*Model 4: Including border governates (Including the border governates)
		preserve
		quiet drop past_group
		rename past_group_border past_group
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_border
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)
		restore		
		
		g mw_model4 = _b[past_group]
				
		*Calculate the missing women changes in model_5		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000	
		
		
	*Model 5: SYPE TC classification
		preserve
		quiet drop past_group
		rename past_group_SYPE past_group
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_SYPE
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)
		restore	
		
		g mw_model5 = _b[past_group]
				
		*Calculate the missing women changes in model_6		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000	
		
	*Model 6: No Cairo
		preserve
		drop if governates_ur==1 //drop Cairo
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_noCairo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group group past $xlist $pl_xlistpxc) 
		restore	
		
		g mw_model6 = _b[past_group]
				
		*Calculate the missing women changes in model_9		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
	*Model 7: No Alexandria 
		preserve
		drop if governates_ur==3 
		drop if governates_ur==4 //drop Alexandria
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_noAlexandria 
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group group past $xlist $pl_xlistpxc) 
		restore	
		
		g mw_model7 = _b[past_group]
				
		*Calculate the missing women changes in model_10		
		g mw_index_model7 = mw_model7/ave_women_DHS_age1	
		g missingw_model7 = mw_index_model7*100000		

	*Model 8: Treatment and control groups by election results in 2012. 75% support of Moris
		preserve
		replace group = tgover_election75
		replace past_group = past*group
			
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_election75 
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc) 
		restore				
		g mw_model8 = _b[past_group]
				
		*Calculate the missing women changes in model_12		
		g mw_index_model8 = mw_model8/ave_women_DHS_age1	
		g missingw_model8 = mw_index_model8*100000

	est tab sample2040 sample_noh sample_alone sample_border sample_SYPE sample_noCairo sample_noAlexandria sample_election75 , keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6 missingw_model7 missingw_model8
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_`tab'_missing_women_robustness_PXC.dta", replace
		
		
}


*Table 10: Different Age Groups Analysis
if `table'==10 {

		* age1-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
		
		* age19-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age19 = mean(dtpeople192) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
	
		* age1019-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1019 = mean(dtpeople10192) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)

		* age2029-average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age2029 = mean(dtpeople20292) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
		
		
		*Model 1: age1 group - baseline result in table 5.1
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_`tab'_different_ages_PXC.xls", replace keep(past_group group past $xlist $pl_xlistpxc)

		g age1_model = _b[past_group]
				
		* Calculate the missing women changes in model_1		
		g mw_index_age1 = age1_model/ave_women_DHS_age1	
		g age1_missingw = mw_index_age1*100000
		
		*Model 2: age19 group		
		quietly xi: areg missingwomen19 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age19
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_`tab'_different_ages_PXC.xls",	append keep(past_group past $xlist $pl_xlistpxc)
		
		g age19_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age19 = age19_model/ave_women_DHS_age19	
		g age19_missingw = mw_index_age19*100000		
		
		*Model 3: age1019 group		
		quietly xi: areg missingwomen1019 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age1019
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_`tab'_different_ages_PXC.xls",	append keep(past_group past $xlist $pl_xlistpxc)
		
		g age1019_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age1019 = age1019_model/ave_women_DHS_age1019	
		g age1019_missingw = mw_index_age1019*100000		
		
		*Model 4: age2029 group		
		quietly xi: areg missingwomen2029 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age2029
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_`tab'_different_ages_PXC.xls",	append keep(past_group past $xlist $pl_xlistpxc)
		
		g age2029_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age2029 = age2029_model/ave_women_DHS_age2029	
		g age2029_missingw = mw_index_age2029*100000
		
		
		
		est tab age1 age19 age1019 age2029 , keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
		* The number of missing women per 100,000 women
		collapse (mean) age1_missingw age19_missingw age1019_missingw age2029_missingw 
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_`tab'_different_ages_PXC.dta", replace
	
		}


exit
	