***   Political Participation and Missing Women: Evidence from the Egyptian Protests of 2011-2014 ***
*                          Regressions Tables (Including Missing Women per 100,000)
******************************************************************************************************

clear all
capture log close
set more off

* Define User and File Path
local user=3  // 1: Firat Demir, 2: Pallab Ghosh, 3: Zhengang Xu, 4: Editor
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

* Choose the Table to Run
local table=2.11

local tab = "Fixed_year"

* Define Covariates
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"

* Load Data
cd "`path'"
use "cr_master_UR.dta", clear

* R&R Round 1, Comment 1d: Remove the time dummy variable "past" and incorporate year fixed effects in all subsequent regressions.
*****************************************************************************************
* Table 2.11: Effect of Egyptian Protests on Missing Women - Added Year Fixed Effects & Removed Time Dummy Variable
*****************************************************************************************

if `table'==2.11 {

    * Compute Averages for Treatment Group Before Arab Spring
    egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & inlist(year, 2007, 2008, 2009, 2010)

    * Model 1: Basic Model (Group & DID Interaction Term)
    quietly reg missingwomen1 past_group group i.year, cluster(governates_ur)
    est store model_raw
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_UR.xls", replace keep(past_group group) 

    * Calculate Missing Women Index for Model 1
    gen mw_model1 = _b[past_group]
    gen mw_index_model1 = mw_model1 / ave_women_DHS_age1
    gen missingw_model1 = mw_index_model1 * 100000

    * Model 2: Add Control Variables
    quietly reg missingwomen1 past_group group $xlist i.year, cluster(governates_ur)
    est store model_2
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_UR.xls", append keep(past_group group $xlist)

    gen mw_model2 = _b[past_group]
    gen mw_index_model2 = mw_model2 / ave_women_DHS_age1
    gen missingw_model2 = mw_index_model2 * 100000

    * Model 3: Add Governorate Fixed Effects
    quietly areg missingwomen1 past_group $xlist i.year, absorb(governates_ur) cluster(governates_ur)
    est store model_3baseline
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_UR.xls", append keep(past_group $xlist)

    gen mw_model3 = _b[past_group]
    gen mw_index_model3 = mw_model3 / ave_women_DHS_age1
    gen missingw_model3 = mw_index_model3 * 100000

    * Model 4: Add Propensity Score Reweighting
    quietly areg missingwomen1 past_group $xlist i.year [pweight=psweightL], absorb(governates_ur) cluster(governates_ur)
    est store m3_psr
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_UR.xls", append keep(past_group $xlist)

    gen mw_model4 = _b[past_group]
    gen mw_index_model4 = mw_model4 / ave_women_DHS_age1
    gen missingw_model4 = mw_index_model4 * 100000

    * Model 5: Add Survey Weights
    quietly areg missingwomen1 past_group $xlist i.year [pweight=weight], absorb(governates_ur) cluster(governates_ur)
    est store m1_sw
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_UR.xls", append keep(past_group $xlist)

    gen mw_model5 = _b[past_group]
    gen mw_index_model5 = mw_model5 / ave_women_DHS_age1
    gen missingw_model5 = mw_index_model5 * 100000

    * Model 6: Add Custom Weighting
    quietly areg missingwomen1 past_group $xlist i.year [pweight=share_pop], absorb(governates_ur) cluster(governates_ur)
    est store model3_sweight
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_UR.xls", append keep(past_group $xlist)

    gen mw_model6 = _b[past_group]
    gen mw_index_model6 = mw_model6 / ave_women_DHS_age1
    gen missingw_model6 = mw_index_model6 * 100000

    * Summarize Model Results
    est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

    * Save Final Results
    collapse (mean) ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
    save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table21A_`tab'_missing_women.dta", replace
}

*****************************************************************************************
* Table 2.2: Placebo Test (2007–2010) - Added Year Fixed Effects & Removed Time Dummy Variable
*****************************************************************************************

if `table'==2.2 {

    preserve
    
    * Restrict dataset to the pre-2011 period (2007-2010)
    drop if year > 2010

    * Compute Averages for Treatment Group Before Arab Spring
    egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & inlist(year, 2007, 2008, 2009, 2010)

    * Model 1: Basic Model (Group & DID Interaction Term)
    quietly reg missingwomen1 past_group_placebo group i.year, cluster(governates_ur)
    est store model_raw_placebo
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_`tab'_placebo.xls", replace keep(past_group_placebo group) 

    * Calculate Missing Women Index for Model 1
    gen mw_model1 = _b[past_group_placebo]
    gen mw_index_model1 = mw_model1 / ave_women_DHS_age1
    gen missingw_model1 = mw_index_model1 * 100000

    * Model 2: Add Control Variables
    quietly reg missingwomen1 past_group_placebo group $xlist i.year, cluster(governates_ur)
    est store model_2_placebo
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_`tab'_placebo.xls", append keep(past_group_placebo group $xlist)

    gen mw_model2 = _b[past_group_placebo]
    gen mw_index_model2 = mw_model2 / ave_women_DHS_age1
    gen missingw_model2 = mw_index_model2 * 100000

    * Model 3: Add Governorate Fixed Effects
    quietly areg missingwomen1 past_group_placebo $xlist i.year, absorb(governates_ur) cluster(governates_ur)
    est store model_3baseline_placebo
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_`tab'_placebo.xls", append keep(past_group_placebo $xlist)

    gen mw_model3 = _b[past_group_placebo]
    gen mw_index_model3 = mw_model3 / ave_women_DHS_age1
    gen missingw_model3 = mw_index_model3 * 100000

    * Model 4: Add Propensity Score Reweighting
    quietly areg missingwomen1 past_group_placebo $xlist i.year [pweight=psweightL_placebo], absorb(governates_ur) cluster(governates_ur)
    est store m3_psr_placebo
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_`tab'_placebo.xls", append keep(past_group_placebo $xlist)

    gen mw_model4 = _b[past_group_placebo]
    gen mw_index_model4 = mw_model4 / ave_women_DHS_age1
    gen missingw_model4 = mw_index_model4 * 100000

    * Model 5: Add Survey Weights
    quietly areg missingwomen1 past_group_placebo $xlist i.year [pweight=weight], absorb(governates_ur) cluster(governates_ur)
    est store m1_sw_placebo
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_`tab'_placebo.xls", append keep(past_group_placebo $xlist)

    gen mw_model5 = _b[past_group_placebo]
    gen mw_index_model5 = mw_model5 / ave_women_DHS_age1
    gen missingw_model5 = mw_index_model5 * 100000

    * Model 6: Add Custom Weighting
    quietly areg missingwomen1 past_group_placebo $xlist i.year [pweight=share_pop], absorb(governates_ur) cluster(governates_ur)
    est store model3_sweight_placebo
    outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_`tab'_placebo.xls", append keep(past_group_placebo $xlist)

    gen mw_model6 = _b[past_group_placebo]
    gen mw_index_model6 = mw_model6 / ave_women_DHS_age1
    gen missingw_model6 = mw_index_model6 * 100000

    * Summarize Model Results
    est tab model_raw_placebo model_2_placebo model_3baseline_placebo m3_psr_placebo m1_sw_placebo model3_sweight_placebo, keep(past_group_placebo) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

    * Save Final Results
    collapse (mean) ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
    save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table22B_missing_women_placebo.dta", replace

    restore
}

*Table 2.3 in Appendix for Table 5 in main paper: removed governates around the treatment and control group classification edge 
if `table'==2.3 {
	
		*****************************************************	
		* TABLE 5 Panel A: models 1 to 6 (missing women estimations)
		***************************************************** 		
		* Average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgoverRR==1 & (year==2007| year==2008| year==2009| year==2010)
		egen ave_missingwomen_before = rmean(missingwomen1) if past==0
		egen ave_missingwomen_after = rmean(missingwomen1) if past==1
		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		*Treatment and control groups in phase1
		replace group = tgoverRR
		replace past_group = past*group
				
		quietly xi: reg missingwomen1 past_group group past
		quietly est store model_raw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_`tab'_UR.xls", replace keep(past_group group past)
		
		g mw_model1 = _b[past_group]		
		
		* Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		*Treatment and control groups in phase1
		replace group = tgoverRR
		replace past_group = past*group
		
		quietly xi: reg missingwomen1 past_group past group $xlist
		quietly est store model_2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_`tab'_UR.xls", append keep(past_group group past $xlist) 

		g mw_model2 = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		*Treatment and control groups in phase1
		replace group = tgoverRR
		replace past_group = past*group
		
		quietly xi: areg missingwomen1 past_group past $xlist, cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3baseline
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_`tab'_UR.xls", append keep(past_group group past $xlist)

		g mw_model3 = _b[past_group]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
	*Model 4: model 3 + PS reweighting
		*Treatment and control groups in phase1
		replace group = tgoverRR
		replace past_group = past*group
		
		quietly xi: areg missingwomen1 past_group past $xlist [pweight=psweightL], cluster(governates_ur) absorb(governates_ur)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_`tab'_UR.xls", append keep(past_group group past $xlist)

		g mw_model4 = _b[past_group]
				
		* Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000
		
	*Model 5: model 3 + survey weighting
		*Treatment and control groups in phase1
		replace group = tgoverRR
		replace past_group = past*group
		
		quietly xi: areg missingwomen1 past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_`tab'_UR.xls", append keep(past_group group past $xlist)

		g mw_model5 = _b[past_group]
				
		* Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000
		
	*Model 6: model 3 + self-created weighting (age, education, etc)
		*Treatment and control groups in phase1
		replace group = tgoverRR
		replace past_group = past*group
		
		quietly xi: areg missingwomen1 past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_`tab'_UR.xls", append keep(past_group group past $xlist)

		g mw_model6 = _b[past_group]
				
		* Calculate the missing women changes in model_6		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group) title("`tab'") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
		
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 ave_missingwomen_before ave_missingwomen_after missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2.3A_missing_women.dta", replace
		
}


*Table 4.1 in Appendix for Table 6 in main paper: Different Phases of Egyptian Protests and Missing Women - removed governates around the treatment and control group classification edge 
if `table'==6.1 {
		
		*Phase 1 (incl. urban) + survey weighting		
			*Average number of women before the Arab Spring in Phase1
			preserve
			
			egen ave_women_DHS_age1_phase1=mean(dtpeople12) if tgover1R==1 & (year==2007| year==2008| year==2009| year==2010)
				

			*Treatment and control groups in phase1
			replace group = tgover1R
			replace past_group = past*group
			
			quietly xi: areg missingwomen1 past_group past $xlist, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase1
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6.1_Phases_mw.xls", replace keep(past_group past $xlist)
		
			g mw_model1 = _b[past_group]
					
			*Calculate the missing women changes in phase1		
			g mw_index_model1 = mw_model1/ave_women_DHS_age1_phase1	
			g missingw_model1 = mw_index_model1*100000	

			
		*Phase 2 (incl. urban) + survey weighting
			*Average number of women before Phase2

			egen ave_women_DHS_age1_phase2=mean(dtpeople12) if tgover2dR==1 & (year==2007| year==2008| year==2009| year==2010| year==2011)			
			
			*Treatment and control groups in phase2
			replace group = tgover2dR
			replace past = (year>=2012)
			replace past_group=past*group
			
			quietly xi: areg missingwomen1 past_group past $xlist, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase2
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6.1_Phases_mw.xls", append keep(past_group past $xlist)	
			
			g mw_model2 = _b[past_group]
					
			*Calculate the missing women changes in phase2		
			g mw_index_model2 = mw_model2/ave_women_DHS_age1_phase2	
			g missingw_model2 = mw_index_model2*100000	
			
			
		*Phase 3 (incl. urban) + survey weighting
			*Average number of women before Phase3

			egen ave_women_DHS_age1_phase3=mean(dtpeople12) if tgover3dR==1 & (year==2007| year==2008| year==2009| year==2010| year==2011| year==2012)	
			
			*Treatment and control groups in phase3
			replace group = tgover3dR
			replace past = (year>=2013)
			replace past_group=past*group

			quietly xi: areg missingwomen1 past_group past $xlist, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase3
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6.1_Phases_mw.xls", append keep(past_group past $xlist)	
			
			g mw_model3 = _b[past_group]
					
			*Calculate the missing women changes in phase3		
			g mw_index_model3 = mw_model3/ave_women_DHS_age1_phase3	
			g missingw_model3 = mw_index_model3*100000	
			
			
		*Phase 4 (incl. urban) + survey weighting
			*Average number of women before Phase4

			egen ave_women_DHS_age1_phase4=mean(dtpeople12) if tgover4dR==1 & (year==2007| year==2008| year==2009| year==2010| year==2011| year==2012| year==2013)	
			
			*Treatment and control groups in phase4
			replace group = tgover4dR
			replace past = (year>=2014)
			replace past_group=past*group

			quietly xi: areg missingwomen1 past_group past $xlist, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase4
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6.1_Phases_mw.xls", append keep(past_group past $xlist)	
			
			g mw_model4 = _b[past_group]
					
			*Calculate the missing women changes in phase4		
			g mw_index_model4 = mw_model4/ave_women_DHS_age1_phase4	
			g missingw_model4 = mw_index_model4*100000	
			
			
			est tab bl_sw_phase1 bl_sw_phase2 bl_sw_phase3 bl_sw_phase4, keep(past_group) title("Phases") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
			*The number of missing women per 100,000 women
			collapse (mean) missingw_model1 missingw_model2 missingw_model3 missingw_model4
			
			save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6.1_missing_women_phases.dta", replace	
	
			restore
			
}

* R&R Round 1, Comment 2:
* This graph visualizes the **predicted trend of missing women** based on the interaction 
* between the post dummy variable and year fixed effects.
*    - The control areas (tgover_ur==0) are represented in black.
*    - The treatment areas (tgover_ur==1) are represented in blue.
*    - Vertical dashed lines mark 2011, 2012, and 2013 (Arab Spring period).
clear all
capture log close
set more off

use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
* Run the regression to obtain predicted missing women values
drop if tgover_ur > 1
quietly areg missingwomen1 past_group $xlist i.past#i.year [pweight=weight], ///
	absorb(governates_ur) cluster(governates_ur)

* Ensure the predicted variable does not already exist
cap drop missingwomen1_predicted

* Generate predicted values for missing women
predict missingwomen1_predicted

* Display first 10 observations to verify predictions
list missingwomen1 missingwomen1_predicted year tgover_ur if _n <= 10  

* Collapse the data to obtain the **mean predicted missing women** by year and treatment group
collapse (mean) missingwomen1_predicted, by(tgover_ur year)

* Generate the DID common trend graph using **predicted missing women values**
twoway /// 
    (line missingwomen1_predicted year if tgover_ur==0, ///
        xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(black) mcolor(black)) ///  
    (connected missingwomen1_predicted year if tgover_ur==0, ///
        msymbol(X) lcolor(black) mcolor(black)) ///  
    (line missingwomen1_predicted year if tgover_ur==1, ///
        xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(blue) mcolor(blue)) ///  
    (connected missingwomen1_predicted year if tgover_ur==1, ///
        msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///  
    graphregion(color(white)) ///  
    legend(order(2 4) label(2 "Control Areas") label(4 "Treatment Areas") ///
           position(6) ring(1) cols(1)) ///  
    xtitle("Year") ytitle("Predicted Missing Women")  

* Export the updated Figure using the correct predicted data
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure4A1_Predicted_MissingWomen_Trend.pdf", replace

************************************************************************************************************
*===========================================================
* Predicting Missing Women and Visualizing Common Trend
*===========================================================
* This code predicts the missing women values using a regression model
* and generates a common trend graph using the predicted values.
* The graph only includes the treatment group (tgover_ur==1).
*===========================================================

* Clear the environment and close any open logs
clear all
capture log close
set more off

* Load the cleaned data file
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear

* Run the regression to obtain predicted missing women values
quietly areg missingwomen1 past_group $xlist i.past#i.year [pweight=weight], ///
    absorb(governates_ur) cluster(governates_ur)

* Ensure the predicted variable does not already exist
cap drop missingwomen1_predicted

* Generate predicted values for missing women
predict missingwomen1_predicted

* Display the first 10 observations to verify predictions
list missingwomen1 missingwomen1_predicted year tgover_ur if _n <= 10  

* Collapse the data to obtain the mean predicted missing women by year and treatment group
collapse (mean) missingwomen1_predicted, by(tgover_ur year)

* Generate the DID common trend graph using predicted missing women values for tgover_ur==1
twoway ///
    (line missingwomen1_predicted year if tgover_ur==1, /// 
        xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(blue) mcolor(blue)) ///  
    (connected missingwomen1_predicted year if tgover_ur==1, /// 
        msymbol(d) lcolor(blue) mcolor(blue)), ///  
    graphregion(color(white)) /// 
    legend(order(1) label(1 "Treatment Areas") /// 
           position(6) ring(1) cols(1)) ///  
    xtitle("Year") ytitle("Predicted Missing Women")

* Export the updated figure to PDF
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure4A1_Treatment_Predicted_MissingWomen_Trend.pdf", replace



****************************************************************************************************************

* Table A1.1: Summary of Individual-Level Variables 
clear all
capture log close
set more off

* Define user-specific file paths * GETTING THE DATA READY:

use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta"

* Define the results folder path
local results_path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\"

bysort caseid clusterid hhid rlineid: gen n = _n
drop if (n != 1 & year_indicator == 2014)

* Basic recodes and covariates:
g tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45,46,47,48,49,50)
g group = tgover_ur_noborder
g past = (year_indicator >= 2011)

* Recode attitudes toward women:
replace visit_ternary = 1 if visit_ternary == 2 
replace pur_ternary   = 1 if pur_ternary   == 2
replace health_ternary= 1 if health_ternary  == 2

**************************************************************
* Block 1: Tolerance Violation Analysis
**************************************************************
preserve
    * Create indicator for domestic violation (tol_vio_1 equals 1)
    g tol_vio_flag = (tol_vio_1 == 1)
    
    * Compute overall, treatment, and control group rates
    egen tol_vio_rate   = mean(tol_vio_flag)
    egen tol_vio_rate_t = mean(cond(group == 1, tol_vio_flag, .))
    egen tol_vio_rate_c = mean(cond(group == 0, tol_vio_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) tol_vio_rate tol_vio_rate_t tol_vio_rate_c
    
    * Export the collapsed results to Excel
    export excel using "`results_path'tol_violation_results.xlsx", firstrow(variables) replace
restore

**************************************************************
* Block 2: Health Decision Analysis
**************************************************************
preserve
    * Create indicator for women making their own health decision (health_ternary equals 1)
    gen health_flag = (health_ternary == 1)
    
    * Compute overall, treatment, and control group rates by year
    egen health_ternary_rate   = mean(health_flag)
    egen health_ternary_rate_t = mean(cond(group == 1, health_flag, .))
    egen health_ternary_rate_c = mean(cond(group == 0, health_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) health_ternary_rate health_ternary_rate_t health_ternary_rate_c
    
    * Export the collapsed results to Excel
    export excel using "`results_path'health_decision_results.xlsx", firstrow(variables) replace
restore

**************************************************************
* Block 3: Purchase Decision Analysis
**************************************************************
preserve
    * Create indicator for women making their own purchase decision (pur_ternary equals 1)
    gen purchase_flag = (pur_ternary == 1)
    
    * Compute overall, treatment, and control group rates by year
    egen pur_ternary_rate   = mean(purchase_flag)
    egen pur_ternary_rate_t = mean(cond(group == 1, purchase_flag, .))
    egen pur_ternary_rate_c = mean(cond(group == 0, purchase_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) pur_ternary_rate pur_ternary_rate_t pur_ternary_rate_c
    
    * Export the collapsed results to Excel
    export excel using "`results_path'purchase_decision_results.xlsx", firstrow(variables) replace
restore

**************************************************************
* Block 4: Visiting Family Decision Analysis
**************************************************************
preserve
    * Create indicator for women visiting their own family members (visit_ternary equals 1)
    gen visit_flag = (visit_ternary == 1)
    
    * Compute overall, treatment, and control group rates by year
    egen vis_ternary_rate   = mean(visit_flag)
    egen vis_ternary_rate_t = mean(cond(group == 1, visit_flag, .))
    egen vis_ternary_rate_c = mean(cond(group == 0, visit_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) vis_ternary_rate vis_ternary_rate_t vis_ternary_rate_c
    
    * Export the collapsed results to Excel
    export excel using "`results_path'vis_family_decision_results.xlsx", firstrow(variables) replace
restore

**************************************************************
* Block 5: Combine All Excel Results into One Sheet
**************************************************************
* Import each of the exported Excel files, add a label for the summary type,
* append them together, and export a combined Excel file.

clear

* Import Tolerance Violation Results
import excel using "`results_path'tol_violation_results.xlsx", firstrow clear
gen Summary_Type = "Tolerance Violation Summary"
tempfile tol
save `tol'

* Import Health Decision Results
clear
import excel using "`results_path'health_decision_results.xlsx", firstrow clear
gen Summary_Type = "Health Decision Summary"
tempfile health
save `health'

* Import Purchase Decision Results
clear
import excel using "`results_path'purchase_decision_results.xlsx", firstrow clear
gen Summary_Type = "Purchase Decision Summary"
tempfile pur
save `pur'

* Import Visiting Family Decision Results
clear
import excel using "`results_path'vis_family_decision_results.xlsx", firstrow clear
gen Summary_Type = "Visiting Family Decision Summary"
tempfile vis
save `vis'

* Append all datasets into one combined dataset
use `tol', clear
append using `health'
append using `pur'
append using `vis'

* Export the combined results into one Excel file (one sheet)
export excel using "`results_path'Combined_Results.xlsx", firstrow(variables) replace

* Summary Table of Vaccination
**************************************************
* Load Data and Preliminary Cleaning
**************************************************
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
drop if vaccination == .

**************************************************
* Section 1: Aggregate Level Summary
**************************************************
preserve
    * Keep only aggregate observations (tgover_ur<=1)
    drop if tgover_ur > 1
    collapse (mean) vac_rate01_fm
    gen summary_type = "Aggregate"
    tempfile agg
    save "`agg'", replace
restore

**************************************************
* Section 2: Treatment and Control Groups Summary
**************************************************
preserve
    * Keep only observations for treatment and control groups (tgover_ur<=1)
    drop if tgover_ur > 1
    collapse (mean) vac_rate01_fm, by(tgover_ur)
    gen summary_type = "Treatment_Control"
    tempfile tc
    save "`tc'", replace
restore

**************************************************
* Combine the Results and Export to Excel
**************************************************
clear all
capture log close
set more off

* Load and append datasets
use "`agg'", clear
append using "`tc'"

* Reorder variables for clarity
order summary_type tgover_ur vac_rate01_fm

* Export the combined dataset to an Excel file
export excel using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Summary_Vaccination.xlsx", ///
firstrow(variables) replace

* Import the Excel file into Stata
import excel "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Summary_Vaccination.xlsx", ///
firstrow clear

* Run t-test regression for differences in tgover_ur
eststo clear
eststo: quietly reg vac_rate01_fm tgover_ur if !missing(tgover_ur)

* Export the regression results with significance stars
esttab using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Vaccination_TDiff.csv", ///
keep(tgover_ur) label se title("Vaccination Rate Differences by Treatment") replace starlevels(* 0.10 ** 0.05 *** 0.01)

***************************************************************************************************************************************
***************************************************************************************************************************************
* Table A5.1 below addresses Comment 4b
* ===================================================================================
* Table A5.1: Linear Probability Model (LPM) - Effect of Egyptian Protests on 
* Domestic Violence During Pregnancy
* ===================================================================================
* This script estimates the impact of Egyptian protests on domestic violence 
* during pregnancy using various regression models, including:
*   - Baseline regression (OLS)
*   - Model with governorate fixed effects
*   - Model with propensity score reweighting
*   - Model with survey weighting
*   - Model with self-created weighting
* ===================================================================================
For each of the following regressions, please calculate the predicted values and put each of these predicted values into different columns.
Then for each column of these predicted values, calculate the proportion of each of these predicted values that is bigger than 1 and the proportion of each of these predicted values that is smaller than 0.
Put these proportions into another independent individual excel file. give them good names to let me know which proportion is from which regressions.

clear all
capture log close
set more off

* Load dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta", clear

* Remove duplicate household observations for 2014
bysort caseid clusterid hhid rlineid: gen n = _n
drop if (n != 1 & year_indicator == 2014)

* Define covariate lists
global xlist1 "work b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
global xlist2 "b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"

* Define treatment and control group classifications
gen tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45, 46, 47, 48, 49, 50)
gen group = tgover_ur_noborder
gen past = (year_indicator >= 2011)

* Recode gender variable (0 = male, 1 = female)
replace b_gender = (b_gender == 2)
label var b_gender "Infant Gender"
label define b_genderL 1 "Female" 0 "Male"
label values b_gender b_genderL

* Interaction term for DiD
gen past_group = past * group

* Recode attitude variables
replace visit_ternary = 1 if visit_ternary == 2 
replace pur_ternary = 1 if pur_ternary == 2
replace health_ternary = 1 if health_ternary == 2

* Handle missing values for wealth indices
foreach var in wealthrate11 wealthrate12 wealthrate13 wealthrate14 {
    replace `var' = 0 if `var' == .
}

* Propensity Score Matching: Estimate Propensity Scores
logit tgover_ur past i.weath_index nb_child i.education i.heducation age age_husband husband_work

predict Lps
replace Lps = 1 if tgover_ur == 1

* Generate inverse probability weights
gen psweightL = 1 / (1 - Lps) if tgover_ur == 0
replace psweightL = 1 if tgover_ur == 1

* ===================================================================================
* REGRESSION TABLES: Effect of Protests on Domestic Violence During Pregnancy
* ===================================================================================
* Dependent Variable: A Dummy Variable Indicating Agreement with Domestic Violence
* ===================================================================================

local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\TableA5_LPM_DV_Pregnancy.xls"

* Model 1: Baseline Regression (Includes All Control Variables)
quietly reg tol_vio_1 past_group group past $xlist1
est store model_1
outreg2 using `output', replace keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2)

* Model 2: Baseline Model + Governorate Fixed Effects (Absorbing Governorates)
quietly reg tol_vio_1 past_group past group $xlist1, cluster(clusterid)
est store model_2
outreg2 using `output', append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2)

* Model 3: Model 2 + Propensity Score Reweighting
quietly reg tol_vio_1 past_group past group $xlist1 [pweight=psweightL], cluster(clusterid)
est store model_3
outreg2 using `output', append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2)

* Model 4: Model 2 + Survey Weights
quietly reg tol_vio_1 past_group past group $xlist1 [pweight=weight], cluster(clusterid)
est store model_4
outreg2 using `output', append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2)

* Model 5: Model 2 + Self-Defined Weights (Based on Demographics)
quietly reg tol_vio_1 past_group past group $xlist1 [pweight=share_pop_w], cluster(clusterid)
est store model_5
outreg2 using `output', append keep(past_group group past b_gender $xlist1) dec(3) pdec(3) e(r2)

* Summary Table for All Models
est tab model_1 model_2 model_3 model_4 model_5, ///
    keep(past_group group past $xlist1) ///
    title("Effect of Protests on Domestic Violence During Pregnancy") ///
    star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

* Based on the results in Table A5.1, we calculate the proportion of predicted 
* values that are greater than 1 and the proportion of predicted values that are less than 0.
clear all
capture log close
set more off

* Load dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta", clear

* Remove duplicate household observations for 2014
bysort caseid clusterid hhid rlineid: gen n = _n
drop if (n != 1 & year_indicator == 2014)

* Define covariate lists
global xlist1 "work b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"

* Define treatment and control group classifications
gen tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45, 46, 47, 48, 49, 50)
gen group = tgover_ur_noborder
gen past = (year_indicator >= 2011)

* Recode gender variable (0 = male, 1 = female)
replace b_gender = (b_gender == 2)
label var b_gender "Infant Gender"

* Interaction term for DiD
gen past_group = past * group

* Recode attitude variables
replace visit_ternary = 1 if visit_ternary == 2 
replace pur_ternary = 1 if pur_ternary == 2
replace health_ternary = 1 if health_ternary == 2

* Handle missing values for wealth indices
foreach var in wealthrate11 wealthrate12 wealthrate13 wealthrate14 {
    replace `var' = 0 if `var' == .
}

* Propensity Score Matching: Estimate Propensity Scores
logit tgover_ur past i.weath_index nb_child i.education i.heducation age age_husband husband_work

predict Lps
replace Lps = 1 if tgover_ur == 1

* Generate inverse probability weights
gen psweightL = 1 / (1 - Lps) if tgover_ur == 0
replace psweightL = 1 if tgover_ur == 1

* ===================================================================================
* REGRESSION MODELS & PREDICTED VALUES
* ===================================================================================

local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Predicted_Values_DV_Pregnancy.xlsx"

* Model 1: Baseline Regression
quietly reg tol_vio_1 past_group group past $xlist1
predict pred_model1
label var pred_model1 "Predicted Model 1"

* Model 2: Baseline Model + Governorate Fixed Effects
quietly reg tol_vio_1 past_group past group $xlist1, cluster(clusterid)
predict pred_model2
label var pred_model2 "Predicted Model 2"

* Model 3: Model 2 + Propensity Score Reweighting
quietly reg tol_vio_1 past_group past group $xlist1 [pweight=psweightL], cluster(clusterid)
predict pred_model3
label var pred_model3 "Predicted Model 3"

* Model 4: Model 2 + Survey Weights
quietly reg tol_vio_1 past_group past group $xlist1 [pweight=weight], cluster(clusterid)
predict pred_model4
label var pred_model4 "Predicted Model 4"

* Model 5: Model 2 + Self-Defined Weights
quietly reg tol_vio_1 past_group past group $xlist1 [pweight=share_pop_w], cluster(clusterid)
predict pred_model5
label var pred_model5 "Predicted Model 5"

* Count total, values >1, and values <0 for each predicted column
foreach model in pred_model1 pred_model2 pred_model3 pred_model4 pred_model5 {
    gen count_total_`model' = _N  // Total number of observations
    gen count_gt1_`model' = sum(`model' > 1)  // Cumulative count
    gen count_lt0_`model' = sum(`model' < 0)  // Cumulative count
}

* Keep only the last row to store the final count values
preserve
    keep if _n == _N
    keep count_total_pred_model1 count_gt1_pred_model1 count_lt0_pred_model1 ///
         count_total_pred_model2 count_gt1_pred_model2 count_lt0_pred_model2 ///
         count_total_pred_model3 count_gt1_pred_model3 count_lt0_pred_model3 ///
         count_total_pred_model4 count_gt1_pred_model4 count_lt0_pred_model4 ///
         count_total_pred_model5 count_gt1_pred_model5 count_lt0_pred_model5
    export excel using `output', firstrow(variables) replace
restore

*===========================================================
* Figure 6: Trend of Female-to-Male Infant Vaccination Ratio
*===========================================================
* This graph visualizes the mean predicted female-to-male vaccination ratio 
* across years for:
*    - Control areas (tgover_ur == 0) in black
*    - Treatment areas (tgover_ur == 1) in blue
* The vertical dashed lines at 2011, 2012, and 2013 indicate the Arab Spring period.
*===========================================================

clear all
capture log close
set more off

* Load dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear

* Drop observations with missing vaccination data
drop if vaccination == .

* Define covariates
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"

* Run regression to estimate the vaccination ratio
quietly areg vac_rate01_fm past_group past $xlist [pweight=weight], ///
    cluster(governates_ur) absorb(governates_ur)

* Remove existing predicted variable if it exists
cap drop vac_rate01_fm_predicted

* Generate predicted values for the female-to-male vaccination ratio
predict vac_rate01_fm_predicted

* Verify predictions by displaying the first 10 observations
list vac_rate01_fm vac_rate01_fm_predicted year tgover_ur if _n <= 10 

* Collapse data to calculate the mean predicted vaccination ratio by year and treatment group
collapse (mean) vac_rate01_fm_predicted, by(tgover_ur year)

* Plot the predicted vaccination ratio trend
twoway ///
    (line vac_rate01_fm_predicted year if tgover_ur == 0, ///
        xline(2011 2012 2013, lp(dash) lcolor(red)) ///
        lcolor(black) mcolor(black)) ///
    (connected vac_rate01_fm_predicted year if tgover_ur == 0, ///
        msymbol(X) lcolor(black) mcolor(black)) ///
    (line vac_rate01_fm_predicted year if tgover_ur == 1, ///
        xline(2011 2012 2013, lp(dash) lcolor(red)) ///
        lcolor(blue) mcolor(blue)) ///
    (connected vac_rate01_fm_predicted year if tgover_ur == 1, ///
        msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) label(2 "Control Areas") label(4 "Treatment Areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle("Year") ytitle("Vaccination Ratio (Female-to-Male)")

* Export the graph as a PDF
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure6_VacFM_Trend.pdf", replace

	
**************************************************************************************************************************************
*** Figure 4.1: Trend of Domestic Violence Before and After the Arab Spring ***
* This graph shows the average domestic violence rate by year for:
*    - Control areas (tgover_ur == 0) shown in black
*    - Treatment areas (tgover_ur == 1) shown in blue
* Vertical dashed lines at 2011, 2012, and 2013 mark the Arab Spring period.
**************************************************************************************************************************************

* Clear the environment and close any open logs
clear all
capture log close
set more off

* Load the data and collapse by region and year to obtain the mean domestic violence indicator
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta", clear
		
* Define treatment and control group classifications and basic dummies
gen tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45, 46, 47, 48, 49, 50)	
gen group = tgover_ur_noborder
gen past = (year_indicator >= 2011)

* Recode gender variables for consistency
replace b_gender = 0 if b_gender == 1  // Male
replace b_gender = 1 if b_gender == 2  // Female

* Generate interaction term for DiD analysis
gen past_group = past * group

* Redefine the gender variable and add labels
replace b_gender = (b_gender == 1)
label var b_gender "Infant Gender"
label define b_genderL 1 "Female" 0 "Male"
label values b_gender b_genderL

* Collapse data by treatment group and year, calculating the mean domestic violence rate
collapse (mean) tol_vio_1, by(tgover_ur year)

* Round the mean values to three decimal places
g tol_vio_11 = round(tol_vio_1, 0.001)

* Generate the trend graph for domestic violence rate (treatment vs. control)
twoway ///
    (line tol_vio_11 year if tgover_ur == 0, xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(black) mcolor(black)) ///
    (connected tol_vio_11 year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///
    (line tol_vio_11 year if tgover_ur == 1, xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(blue) mcolor(blue)) ///
    (connected tol_vio_11 year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) label(2 "Control Areas") label(4 "Treatment Areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle("Year") ytitle("Domestic Violence Rate") ///
    title("Trend of Domestic Violence Before and After the Arab Spring")

* Export the graph to PDF
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure41_DV_Trend.pdf", replace

**************************************************************************************************************************************
*** Figure 4.2: Conditional Trend of Domestic Violence ***
* This graph visualizes the trend of the mean predicted domestic violence rate by year for:
*    - Control areas (tgover_ur == 0) shown in black
*    - Treatment areas (tgover_ur == 1) shown in blue
* The vertical dashed lines at 2011, 2012, and 2013 indicate the Arab Spring period.
**************************************************************************************************************************************

* Clear the environment and close any open logs
clear all
capture log close
set more off

* Load the cleaned dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta", clear

* Remove duplicate household observations for 2014
bysort caseid clusterid hhid rlineid: gen n = _n
drop if (n != 1 & year_indicator == 2014)

* Define covariate lists for the regression models
global xlist1 "work b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"
global xlist2 "b_gender age age_husband husband_work b_ord nb_child religion noeducation primary secondary h_noeducation h_primary h_secondary poorest poorer middle richer"

* Define treatment and control group classifications and basic dummies
gen tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45, 46, 47, 48, 49, 50)
gen group = tgover_ur_noborder
gen past = (year_indicator >= 2011)

* Recode gender variables for consistency
replace b_gender = 0 if b_gender == 1  // Male
replace b_gender = 1 if b_gender == 2  // Female

* Generate interaction term for DiD analysis
gen past_group = past * group

* Adjust attitude variables towards women
replace visit_ternary = 1 if visit_ternary == 2
replace pur_ternary = 1 if pur_ternary == 2
replace health_ternary = 1 if health_ternary == 2

* Handle missing values in wealth rate variables
foreach var in wealthrate11 wealthrate12 wealthrate13 wealthrate14 {
    replace `var' = 0 if `var' == .
}

* Redefine the gender variable and add labels
replace b_gender = (b_gender == 1)
label var b_gender "Infant Gender"
label define b_genderL 1 "Female" 0 "Male"
label values b_gender b_genderL

* Estimate the propensity scores using logistic regression
logit tgover_ur past i.weath_index nb_child i.education i.heducation age age_husband husband_work

* Generate predicted values from the logistic regression
predict Lps
replace Lps = 1 if tgover_ur == 1

* Create propensity score weights
gen psweightL = 1 / (1 - Lps) if tgover_ur == 0
replace psweightL = 1 if tgover_ur == 1

* Perform logistic regression to estimate the predicted domestic violence rate
quietly xi: logit tol_vio_1 past_group past group $xlist1 [pweight=weight], cluster(clusterid)

* Drop existing predicted variable if it exists
cap drop tol_vio_1_predicted

* Generate predicted values for domestic violence rate
predict tol_vio_1_predicted

* Display the first 10 observations to verify predictions
list tol_vio_1 tol_vio_1_predicted year tgover_ur if _n <= 10

* Collapse data to calculate the mean predicted domestic violence rate by year and treatment group
collapse (mean) tol_vio_1_predicted, by(tgover_ur year)

* Generate the conditional trend graph for predicted domestic violence rate
twoway ///
    (line tol_vio_1_predicted year if tgover_ur == 0, xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(black) mcolor(black)) ///
    (connected tol_vio_1_predicted year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///
    (line tol_vio_1_predicted year if tgover_ur == 1, xline(2011 2012 2013, lp(dash) lcolor(red)) lcolor(blue) mcolor(blue)) ///
    (connected tol_vio_1_predicted year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) label(2 "Control Areas") label(4 "Treatment Areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle("Year") ytitle("Predicted Domestic Violence Rate") ///
    title("Conditional Trend of Domestic Violence")

* Export the graph as a PDF
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure42_DV_Conditional_Trend.pdf", replace


* Response to Reviewer 1 – Comment 5a
clear all
capture log close
set more off
		
		use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
		
		* COVARIATES : 
		global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"
		
* TableA9.1: Effect of Egyptian Protests on Female Children's Vaccination Rate	
	
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
			

* TableA9.2: Effect of Egyptian Protests on Male Children's Vaccination Rate	
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
		
		est tab model_1 model_2 model_3 model_4, keep(past_group) title("AppendixTable_A9.2_Mvacc_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
	
	
* Table A2.1: Regressions Tables with Post X Controls from line870 to line1478
* Table A2.1: Regressions Tables with Year Fixed Effects X Controls
* (including the calculation of the number of missing women per 100,000)

use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
* COVARIATES : 
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"
				
global xlist_age19 "wealthrate191 wealthrate192 wealthrate193 wealthrate194 reponsewrate19 nb_child reponseedurate190 reponseedurate191 reponseedurate192 age age_husband hwrate19 hedurate190 hedurate191 hedurate192 b_ord religionrate19"	

global xlist_age1019 "wealthrate10191 wealthrate10192 wealthrate10193 wealthrate10194 reponsewrate1019 nb_child reponseedurate10190 reponseedurate10191 reponseedurate10192 age age_husband hwrate1019 hedurate10190 hedurate10191 hedurate10192 b_ord religionrate1019"
	
global xlist_age2029 "wealthrate20291 wealthrate20292 wealthrate20293 wealthrate20294 reponsewrate2029 nb_child reponseedurate20290 reponseedurate20291 reponseedurate20292 age age_husband hwrate2029 hedurate20290 hedurate20291 hedurate20292 b_ord religionrate2029"
		
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
preserve
* Table A2.1: Full Table of Table 5 Panel A in Manuscript with Post X Controls
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
		egen ave_missingwomen_before = rmean(missingwomen1) if past==0
		egen ave_missingwomen_after = rmean(missingwomen1) if past==1
		
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg missingwomen1 past_group group past
		quietly est store model_raw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_PostxControls_UR_PXC.xls", replace keep(past_group group past)
		
		g mw_model1 = _b[past_group]		
		
		* Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg missingwomen1 past_group past group $xlist $xlistpxc
		quietly est store model_2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_PostxControls_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc) 

		g mw_model2 = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000
		
	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: areg missingwomen1 past_group past $xlist $xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3baseline
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_PostxControls_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model3 = _b[past_group]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
	*Model 4: model 3 + PS reweighting
		quietly xi: areg missingwomen1 past_group past $xlist $xlistpxc [pweight=psweightL], cluster(governates_ur) absorb(governates_ur)
		quietly est store m3_psr
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_PostxControls_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model4 = _b[past_group]
				
		* Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000
		
	*Model 5: model 3 + survey weighting
		quietly xi: areg missingwomen1 past_group past $xlist $xlistpxc [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store m1_sw
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_PostxControls_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model5 = _b[past_group]
				
		* Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000
		
	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg missingwomen1 past_group group past $xlist $xlistpxc [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model3_sweight
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_PostxControls_UR_PXC.xls", append keep(past_group group past $xlist $xlistpxc)

		g mw_model6 = _b[past_group]
				
		* Calculate the missing women changes in model_6		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
		
		est tab model_raw model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group) title("PostxControls") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
		
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 ave_missingwomen_before ave_missingwomen_after missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_missing_women_PXC.dta", replace
		
restore		

		*****************************************************	
		* TABLE A3.1 For Panel B of Table 5 in Manuscript
		***************************************************** 
preserve
		drop if year>2010

		* Average number of women in treatment group before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
			
	*Model 1 Raw: (only area group dummy, time dummy, and DID interaction term)
		quietly xi: reg missingwomen1 past_group_placebo group past_placebo
		quietly est store model_raw_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_placebo_PXC.xls", replace keep(past_group_placebo group past_placebo)
		
		g mw_model1 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000		
		
	*Model 2 Baseline: model 1 + all control variables (age, education, etc)
		quietly xi: reg missingwomen1 past_group_placebo group past_placebo $xlist $pl_xlistpxc
		quietly est store model_2_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_placebo_PXC.xls", append keep(past_group_placebo group past_placebo $xlist $pl_xlistpxc)

		g mw_model2 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_2		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000

	*Model 3: baseline: model 1 + governates_ur (`group' captured by governates_ur dummies)
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store model_3baseline_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc) 
		
		g mw_model3 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
	*Model 4: model 3 + PS reweighting
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc [pweight=psweightL_placebo], cluster(governates_ur) absorb(governates_ur)
		quietly est store m3_psr_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc)
		
		g mw_model4 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000
				
	*Model 5: model 3 + survey weighting                          
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc [pweight=weight], cluster(governates_ur) absorb(governates_ur)
		quietly est store m1_swplacebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc)

		g mw_model5 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000
	                                                                                     
	*Model 6: model 3 + self-created weighting (age, education, etc)
		quietly xi: areg missingwomen1 past_group_placebo past_placebo $xlist $pl_xlistpxc [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
		quietly est store model3_sweight_placebo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_placebo_PXC.xls", append keep(past_group_placebo past_placebo $xlist $pl_xlistpxc)

		g mw_model6 = _b[past_group_placebo]
				
		* Calculate the missing women changes in model_6		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
		est tab model_raw_placebo model_2_placebo model_3baseline_placebo m3_psr_placebo m1_swplacebo model3_sweight_placebo, keep(past_group_placebo) title("PostxControls") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
	
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5B_PostxControls_missing_women_placebo_PXC.dta", replace
		
restore

*Table 6: Different Phases of Egyptian Protests and Missing Women PostxControls	
		*Phase 1 (incl. urban) + survey weighting		
			*Average number of women before the Arab Spring in Phase1
preserve
			
			egen ave_women_DHS_age1_phase1=mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)
				

			*Treatment and control groups in phase1
			replace group = tgover1
			replace past_group = past*group
			
			quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
			quietly est store bl_sw_phase1
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_PostxControls_Phases_mw_PXC.xls", replace keep(past_group past $xlist $pl_xlistpxc)
		
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
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_PostxControls_Phases_mw_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
			
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
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_PostxControls_Phases_mw_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
			
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
			quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_PostxControls_Phases_mw_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
			
			g mw_model4 = _b[past_group]
					
			*Calculate the missing women changes in phase4		
			g mw_index_model4 = mw_model4/ave_women_DHS_age1_phase4	
			g missingw_model4 = mw_index_model4*100000	
			
			
			est tab bl_sw_phase1 bl_sw_phase2 bl_sw_phase3 bl_sw_phase4, keep(past_group) title("Phases") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
			*The number of missing women per 100,000 women
			collapse (mean) missingw_model1 missingw_model2 missingw_model3 missingw_model4
			
			save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table6_PostxControls_missing_women_phases_PXC.dta", replace	
	
restore
			

*Table 8: Robustness Analysis: Clustering choice PostxControls
preserve
		*Average number of women before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)		
		
	*cluster: governorates_urban and rural; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store baseline
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_cluster_PXC.xls",replace keep(past_group past $xlist $pl_xlistpxc) ctitle("Baseline")
				
		g mw_model1 = _b[past_group]
				
		*Calculate the missing women changes in model_1		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		

	*cluster: governorates_urban and rural; fixed effect: governorates (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governorate)
		quietly est store cluster1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("Clu: g_ur, FE: g")
				
		g mw_model2 = _b[past_group]
				
		*Calculate the missing women changes in model_2	
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000	
		
	
	*cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governorate) absorb(governates_ur)
		quietly est store cluster2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("Clu: g, FE: g_ur")		
				
		g mw_model3 = _b[past_group]
				
		* Calculate the missing women changes in model_3		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000	
		
		
	* BS800 cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, vce(bootstrap, cluster(governorate) reps(800) seed(10101) nodots) absorb(governates_ur)
		quietly est store boot1
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("BS800 Clu: g, FE: g_ur")		
				
		g mw_model4 = _b[past_group]
				
		*Calculate the missing women changes in model_4		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000	
		
		
	*BS1000 cluster: governorates; fixed effect: governorates_urban and rural (baseline, Tab 1, col 3)
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, vce(bootstrap, cluster(governorate) reps(1000) seed(10101) nodots) absorb(governates_ur)
		quietly est store boot2
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("BS1000 Clu: g, FE: g_ur")		
		
		g mw_model5 = _b[past_group]
				
		*Calculate the missing women changes in model_5		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000	
		
		
	*Wild BS (Roodman et al 2018), cluster: governorates; fixed effect: governorates_urban and rural baseline, Tab 1, col 3)		
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, vce(bootstrap, cluster(governorate)) absorb(governates_ur)
		boottest past_group , cluster(governorate) bootcluster(governorate) seed(999) nograph // override previous clustering
		est store boot3
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_cluster_PXC.xls",append keep(past_group past $xlist $pl_xlistpxc) ctitle("wildBS Clu: g, FE: g_ur")		
				
		g mw_model6 = _b[past_group]
				
		*Calculate the missing women changes in model_1		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000	
		
		est tab baseline cluster1 cluster2 boot1 boot2 boot3, keep(past_group) star(0.1 0.05 0.01) stats(N r2) b(%7.3f) 
		est tab baseline cluster1 cluster2 boot1 boot2 boot3, keep(past_group) se  b(%7.3f)  se(%7.3f) 	// with std errors

		*The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table8_PostxControls_missing_women_PXC.dta", replace
		
restore



*Table 9: Robustness Analysis
preserve
		*Average number of women before the Arab Spring
		egen ave_women_DHS_age1 = mean(dtpeople12) if tgover==1 & (year==2007| year==2008| year==2009| year==2010)	

	*Model 1: Women aged 20-40. (Only 20 to 40 years old)

		quietly xi: areg missingwomen12040 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample2040
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", replace keep(past_group past $xlist $pl_xlistpxc)
		
		g mw_model1 = _b[past_group]
				
		*Calculate the missing women changes in model_2		
		g mw_index_model1 = mw_model1/ave_women_DHS_age1	
		g missingw_model1 = mw_index_model1*100000	
		
		
	*Model 2: Interview: no husband. (without husband at the interview)
		quietly xi: areg missingwomen1h past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_noh 
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)
		
		g mw_model2 = _b[past_group]
				
		*Calculate the missing women changes in model_3		
		g mw_index_model2 = mw_model2/ave_women_DHS_age1	
		g missingw_model2 = mw_index_model2*100000	
		
		
	*Model 3: Interview: alone (Without anyone at the interview)
		quietly xi: areg missingwomen1alone past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_alone
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
		
		g mw_model3 = _b[past_group]
				
		*Calculate the missing women changes in model_4		
		g mw_index_model3 = mw_model3/ave_women_DHS_age1	
		g missingw_model3 = mw_index_model3*100000
		
		
	*Model 4: Including border governates (Including the border governates)
		quiet drop past_group
		rename past_group_border past_group
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_border
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)	
		
		g mw_model4 = _b[past_group]
				
		*Calculate the missing women changes in model_5		
		g mw_index_model4 = mw_model4/ave_women_DHS_age1	
		g missingw_model4 = mw_index_model4*100000	
		
		
	*Model 5: SYPE TC classification
		quiet drop past_group
		rename past_group_SYPE past_group
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_SYPE
		quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc)
		
		g mw_model5 = _b[past_group]
				
		*Calculate the missing women changes in model_6		
		g mw_index_model5 = mw_model5/ave_women_DHS_age1	
		g missingw_model5 = mw_index_model5*100000	
		
	*Model 6: No Cairo
		drop if governates_ur==1 //drop Cairo
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_noCairo
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group group past $xlist $pl_xlistpxc) 
		
		g mw_model6 = _b[past_group]
				
		*Calculate the missing women changes in model_9		
		g mw_index_model6 = mw_model6/ave_women_DHS_age1	
		g missingw_model6 = mw_index_model6*100000
		
	*Model 7: No Alexandria 
		drop if governates_ur==3 
		drop if governates_ur==4 //drop Alexandria
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_noAlexandria 
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group group past $xlist $pl_xlistpxc) 
		
		g mw_model7 = _b[past_group]
				
		*Calculate the missing women changes in model_10		
		g mw_index_model7 = mw_model7/ave_women_DHS_age1	
		g missingw_model7 = mw_index_model7*100000		

	*Model 8: Treatment and control groups by election results in 2012. 75% support of Moris
		replace group = tgover_election75
		replace past_group = past*group
			
		quietly xi: areg missingwomen1 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store sample_election75 
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_robustness_PXC.xls", append keep(past_group past $xlist $pl_xlistpxc) 			
		g mw_model8 = _b[past_group]
				
		*Calculate the missing women changes in model_12		
		g mw_index_model8 = mw_model8/ave_women_DHS_age1	
		g missingw_model8 = mw_index_model8*100000

	est tab sample2040 sample_noh sample_alone sample_border sample_SYPE sample_noCairo sample_noAlexandria sample_election75 , keep(past_group) title("PostxControls") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
		* The number of missing women per 100,000 women
		collapse (mean)  ave_women_DHS_age1 missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6 missingw_model7 missingw_model8
	
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table9_PostxControls_missing_women_robustness_PXC.dta", replace
restore			

*Table 10: Different Age Groups Analysis
preserve
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
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_PostxControls_different_ages_PXC.xls", replace keep(past_group group past $xlist $pl_xlistpxc)

		g age1_model = _b[past_group]
				
		* Calculate the missing women changes in model_1		
		g mw_index_age1 = age1_model/ave_women_DHS_age1	
		g age1_missingw = mw_index_age1*100000
		
		*Model 2: age19 group		
		quietly xi: areg missingwomen19 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age19
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_PostxControls_different_ages_PXC.xls",	append keep(past_group past $xlist $pl_xlistpxc)
		
		g age19_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age19 = age19_model/ave_women_DHS_age19	
		g age19_missingw = mw_index_age19*100000		
		
		*Model 3: age1019 group		
		quietly xi: areg missingwomen1019 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age1019
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_PostxControls_different_ages_PXC.xls",	append keep(past_group past $xlist $pl_xlistpxc)
		
		g age1019_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age1019 = age1019_model/ave_women_DHS_age1019	
		g age1019_missingw = mw_index_age1019*100000		
		
		*Model 4: age2029 group		
		quietly xi: areg missingwomen2029 past_group past $xlist $pl_xlistpxc, cluster(governates_ur) absorb(governates_ur)
		quietly est store age2029
		quietly outreg2 using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_PostxControls_different_ages_PXC.xls",	append keep(past_group past $xlist $pl_xlistpxc)
		
		g age2029_model = _b[past_group]
				
		* Calculate the missing women changes in model_2		
		g mw_index_age2029 = age2029_model/ave_women_DHS_age2029	
		g age2029_missingw = mw_index_age2029*100000
		
		
		
		est tab age1 age19 age1019 age2029 , keep(past_group) title("PostxControls") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)
			
		* The number of missing women per 100,000 women
		collapse (mean) age1_missingw age19_missingw age1019_missingw age2029_missingw 
		
		save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table10_PostxControls_different_ages_PXC.dta", replace
restore	

* Table A5.1 Full Table of Table 7 with Post X Controls
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta", clear
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
* Table A5.1 with PostxControls: Logit Model: Effects of Egyptian Protests on Domestic Violence During Pregnancy (Full Table 7 in the Main Text)
* Disagree with any kind of domestic violence=1

* TABLE A5: All dummies regressions: * Dep Var: A Dummy Variable whether the women can make the decision about their own health logit

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
		
		est tab model_2 model_3baseline m3_psr m1_sw model3_sweight, keep(past_group group past $xlist1 $xlistpxc) title("Individuals") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)		
					
*************************************************************************************************************************************************
*************************************************************************************************************************************************
		
* ==================================================================================
* SECTION: REGRESSIONS WITH YEAR FIXED EFFECTS (REPLACING TIME DUMMY "PAST") AND  "YEAR FIXED EFFECTS" X "CONTROLS"
* ==================================================================================
* Table A2.2: 
clear all
capture log close
set more off

* Load the dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear

* ===================================================================================
* Define Control Variables
* ===================================================================================
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"

* ===================================================================================
* Create Interaction Terms: Control Variables × Year Fixed Effects
* ===================================================================================
foreach var in $xlist {
    gen `var'_year = `var' * year
}

* Store the interaction terms in a global macro
global xlist_year ""
foreach var in $xlist {
    global xlist_year "$xlist_year `var'_year"
}

* ===================================================================================
* REGRESSION TABLES
* ===================================================================================

* Preserve the dataset state
preserve

* Table A2.1: Full Table for Table 5 Panel A (Using Year Fixed Effects)
egen ave_women_DHS_age1 = mean(dtpeople12) if tgover == 1 & inlist(year, 2007, 2008, 2009, 2010)
egen ave_missingwomen_before = rmean(missingwomen1) if past == 0
egen ave_missingwomen_after = rmean(missingwomen1) if past == 1

* Model 1: Basic DID Specification
quietly xi: reg missingwomen1 past_group group year
est store model_raw
outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_UR_YearFE.xls", replace keep(past_group group year)

gen mw_model1 = _b[past_group]
gen mw_index_model1 = mw_model1 / ave_women_DHS_age1
gen missingw_model1 = mw_index_model1 * 100000

* Model 2: Adding Control Variables with Year Fixed Effects
quietly xi: reg missingwomen1 past_group year group $xlist $xlist_year
est store model_2
outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_UR_YearFE.xls", append keep(past_group group year $xlist $xlist_year)

gen mw_model2 = _b[past_group]
gen mw_index_model2 = mw_model2 / ave_women_DHS_age1
gen missingw_model2 = mw_index_model2 * 100000

* Model 3: Adding Governorate Fixed Effects
quietly xi: areg missingwomen1 past_group year $xlist $xlist_year, absorb(governates_ur) cluster(governates_ur)
est store model_3
outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_UR_YearFE.xls", append keep(past_group group year $xlist $xlist_year)

gen mw_model3 = _b[past_group]
gen mw_index_model3 = mw_model3 / ave_women_DHS_age1
gen missingw_model3 = mw_index_model3 * 100000

* Model 4: Propensity Score Reweighting
quietly xi: areg missingwomen1 past_group year $xlist $xlist_year [pweight=psweightL], absorb(governates_ur) cluster(governates_ur)
est store model_4
outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_UR_YearFE.xls", append keep(past_group group year $xlist $xlist_year)

gen mw_model4 = _b[past_group]
gen mw_index_model4 = mw_model4 / ave_women_DHS_age1
gen missingw_model4 = mw_index_model4 * 100000

* Model 5: Survey Weights
quietly xi: areg missingwomen1 past_group year $xlist $xlist_year [pweight=weight], absorb(governates_ur) cluster(governates_ur)
est store model_5
outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_UR_YearFE.xls", append keep(past_group group year $xlist $xlist_year)

gen mw_model5 = _b[past_group]
gen mw_index_model5 = mw_model5 / ave_women_DHS_age1
gen missingw_model5 = mw_index_model5 * 100000

* Model 6: Self-Created Weighting (Age, Education, etc.)
quietly xi: areg missingwomen1 past_group year group $xlist $xlist_year [pweight=share_pop], absorb(governates_ur) cluster(governates_ur)
est store model_6
outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_UR_YearFE.xls", append keep(past_group group year $xlist $xlist_year)

gen mw_model6 = _b[past_group]
gen mw_index_model6 = mw_model6 / ave_women_DHS_age1
gen missingw_model6 = mw_index_model6 * 100000

* Export Summary Statistics
est tab model_raw model_2 model_3 model_4 model_5 model_6, keep(past_group) title("Year Fixed Effects Models") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

collapse (mean) ave_women_DHS_age1 ave_missingwomen_before ave_missingwomen_after missingw_model1 missingw_model2 missingw_model3 missingw_model4 missingw_model5 missingw_model6
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table5A_missing_women_YearFE.dta", replace

restore

exit

************************************************************************************************************************************************************************
************************************************************************************************************************************************************************

***   Political Participation and Missing Women: Evidence from the Egyptian Protests of 2011-2014 Full Tables***

*                                          Regressions Tables For Appendix Governates LEVEL
*         
******************************************************************************************************
**************************************************************************************************************
*** Table A9: Effect of Egyptian Protests on Children's Vaccination Rate (Female-to-Male) ***
* This script estimates the impact of Egyptian protests on the vaccination rate of children (female-to-male ratio).
* The following models are estimated:
*   - Model 1: Baseline with area group dummy, time dummy, and DID interaction term
*   - Model 2: Model 1 + control variables (age, education, etc.)
*   - Model 3: Model 1 + governates_ur dummies + survey weighting
*   - Model 4: Model 1 + governates_ur dummies + self-created weighting (age, education, etc.)
**************************************************************************************************************

* Clear environment and close logs
clear all
capture log close
set more off

* Load the cleaned DHS dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear

* Define covariate list for the models
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"

* Exclude years 2012 and 2013 from the analysis as per requirements
drop if (year == 2013 | year == 2012)

***************************************************************
* Estimating the Effect of Egyptian Protests on Vaccination Rate
***************************************************************

* Model 1: Baseline model with area group dummy, time dummy, and DID interaction term
quietly xi: reg vac_rate01_fm past_group group past
quietly est store model_1
quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", replace keep(past_group group past)

* Model 2: Baseline model + all control variables (age, education, etc.)
quietly xi: reg vac_rate01_fm past_group past group $xlist
quietly est store model_2
quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", append keep(past_group group past $xlist)

* Model 3: Baseline model + governates_ur dummies + survey weighting
quietly xi: areg vac_rate01_fm past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
quietly est store model_3
quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", append keep(past_group group past $xlist)

* Model 4: Baseline model + governates_ur dummies + self-created weighting (age, education, etc.)
quietly xi: areg vac_rate01_fm past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
quietly est store model_4
quietly outreg2 using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate.xls", append keep(past_group group past $xlist)

* Summary of all models: Displaying the estimated coefficients and statistics
est tab model_1 model_2 model_3 model_4, keep(past_group) title("Effect of Protests on Vaccination Rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

* Exit the program


**************************************************************************************************************
*** Table A9: Effect of Egyptian Protests on Children's Vaccination Rate (Female-to-Male) ***
* This script estimates the impact of Egyptian protests on the vaccination rate of children (female-to-male ratio).
* The following models are estimated:
*   - Model 1: Baseline with area group dummy, time dummy, and DID interaction term
*   - Model 2: Model 1 + control variables (age, education, etc.)
*   - Model 3: Model 1 + governates_ur dummies + survey weighting
*   - Model 4: Model 1 + governates_ur dummies + self-created weighting (age, education, etc.)
* Runs the regressions for three cases:
*   1. Dropping year 2012
*   2. Dropping year 2013
*   3. Dropping both years 2012 and 2013
**************************************************************************************************************

* Clear environment and close logs
clear all
capture log close
set more off

* Define covariate list for the models
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"

* Loop over the three cases: dropping year 2012, dropping year 2013, dropping both years
foreach yearset in 2012 2013 both {
    
    * Load the cleaned DHS dataset
    use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear

    * Drop the specified years based on the iteration
    if "`yearset'" == "2012" {
        drop if year == 2012
        local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate_drop2012.xls"
    }
    else if "`yearset'" == "2013" {
        drop if year == 2013
        local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate_drop2013.xls"
    }
    else if "`yearset'" == "both" {
        drop if (year == 2012 | year == 2013)
        local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate_drop2012_2013.xls"
    }

    ***************************************************************
    * Estimating the Effect of Egyptian Protests on Vaccination Rate
    ***************************************************************

    * Model 1: Baseline model with area group dummy, time dummy, and DID interaction term
    quietly xi: reg vac_rate01_fm past_group group past
    quietly est store model_1
    quietly outreg2 using `output', replace keep(past_group group past)

    * Model 2: Baseline model + all control variables (age, education, etc.)
    quietly xi: reg vac_rate01_fm past_group past group $xlist
    quietly est store model_2
    quietly outreg2 using `output', append keep(past_group group past $xlist)

    * Model 3: Baseline model + governates_ur dummies + survey weighting
    quietly xi: areg vac_rate01_fm past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
    quietly est store model_3
    quietly outreg2 using `output', append keep(past_group group past $xlist)

    * Model 4: Baseline model + governates_ur dummies + self-created weighting (age, education, etc.)
    quietly xi: areg vac_rate01_fm past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
    quietly est store model_4
    quietly outreg2 using `output', append keep(past_group group past $xlist)

    * Summary of all models: Displaying the estimated coefficients and statistics
    est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A9_Vaccine_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

}

* Exit the program

**************************************************************************************************************
*** Table A9: Effect of Egyptian Protests on Children's Vaccination Rate (Female-to-Male) ***
* This script estimates the impact of Egyptian protests on the vaccination rate of children (female-to-male ratio).
* The following models are estimated:
*   - Model 1: Baseline with area group dummy, time dummy, and DID interaction term
*   - Model 2: Model 1 + control variables (age, education, etc.)
*   - Model 3: Model 1 + governates_ur dummies + survey weighting
*   - Model 4: Model 1 + governates_ur dummies + self-created weighting (age, education, etc.)
* Runs the regressions for three cases:
*   1. Replace year 2012 values with year 2011 values
*   2. Replace year 2013 values with year 2011 values
*   3. Replace both year 2012 and 2013 values with year 2011 values
**************************************************************************************************************

* Clear environment and close logs
clear all
capture log close
set more off

* Define covariate list for the models
global xlist "wealthrate11 wealthrate12 wealthrate13 wealthrate14 reponsewrate1 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 b_ord religionrate1"

* Loop over the three cases: replacing year 2012, replacing year 2013, replacing both years
foreach scenario in replace2012 replace2013 replaceboth {
    
    * Load the cleaned DHS dataset
    use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear

    * Replace values based on the scenario
    if "`scenario'" == "replace2012" {
        replace vac_rate01_fm = vac_rate01_fm[_n-1] if year == 2012
        local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate_replace2012.xls"
    }
    else if "`scenario'" == "replace2013" {
        replace vac_rate01_fm = vac_rate01_fm[_n-1] if year == 2013
        local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate_replace2013.xls"
    }
    else if "`scenario'" == "replaceboth" {
        replace vac_rate01_fm = vac_rate01_fm[_n-1] if year == 2012 | year == 2013
        local output "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\AppendixTable_A9_Vaccine_rate_replace2012_2013.xls"
    }

    ***************************************************************
    * Estimating the Effect of Egyptian Protests on Vaccination Rate
    ***************************************************************

    * Model 1: Baseline model with area group dummy, time dummy, and DID interaction term
    quietly xi: reg vac_rate01_fm past_group group past
    quietly est store model_1
    quietly outreg2 using `output', replace keep(past_group group past)

    * Model 2: Baseline model + all control variables (age, education, etc.)
    quietly xi: reg vac_rate01_fm past_group past group $xlist
    quietly est store model_2
    quietly outreg2 using `output', append keep(past_group group past $xlist)

    * Model 3: Baseline model + governates_ur dummies + survey weighting
    quietly xi: areg vac_rate01_fm past_group past $xlist [pweight=weight], cluster(governates_ur) absorb(governates_ur)
    quietly est store model_3
    quietly outreg2 using `output', append keep(past_group group past $xlist)

    * Model 4: Baseline model + governates_ur dummies + self-created weighting (age, education, etc.)
    quietly xi: areg vac_rate01_fm past_group group past $xlist [pweight=share_pop], cluster(governates_ur) absorb(governates_ur)
    quietly est store model_4
    quietly outreg2 using `output', append keep(past_group group past $xlist)

    * Summary of all models: Displaying the estimated coefficients and statistics
    est tab model_1 model_2 model_3 model_4, keep(past_group) title("Table_A9_Vaccine_rate") star(0.1 0.05 0.01) stats(N r2) b(%7.3f)

}

* Exit the program
exit

*===============================================================
* Summary Tables for Different Governorates
* Calculating Missing Women (Age 0-1) for Each Year and Governorate
*===============================================================
* Clear environment and close logs
clear all
capture log close
set more off

* Load the dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR", clear

* Initialize variables for population, death counts, and death rates
gen pop_male_01 = .
gen pop_female_01 = .
gen death_male_01 = .
gen death_female_01 = .
gen rate_male_01 = .
gen rate_female_01 = .

* Loop through years and governorates to calculate missing women for age group 0-1
forvalues i = 2007/2014 {
    forvalues j = 1/2 {
        foreach k of numlist 1	3  4  5  7	9	10	11	12	13	14	15	16	17	18	19	20	21	22	23	24	25	26	27	28	29	30	31	32	33	34	35	36	37	38	39	40	41	42	43	44	45	46	47	48	49	50  {
            
            * Calculate the number of people (age 0-1) by gender in each governorate and year
            count if b_gender == `j' & (kidage`i' == 0 | kidage`i' == 1) & governates_ur == `k' & year == `i'
            if `j' == 1 {
                replace pop_male_01 = r(N) if governates_ur == `k' & year == `i'
            }
            else {
                replace pop_female_01 = r(N) if governates_ur == `k' & year == `i'
            }

            * Calculate the number of deaths (age 0-1) by gender in each governorate and year
            count if b_gender == `j' & deathyear == `i' & (dage == 0 | dage == 1) & governates_ur == `k' & b_alive == 0
            if `j' == 1 {
                replace death_male_01 = r(N) if governates_ur == `k' & year == `i'
            }
            else {
                replace death_female_01 = r(N) if governates_ur == `k' & year == `i'
            }

            * Calculate the death rate for each group
            if `j' == 1 {
                replace rate_male_01 = death_male_01 / pop_male_01 if pop_male_01 > 0
            }
            else {
                replace rate_female_01 = death_female_01 / pop_female_01 if pop_female_01 > 0
            }
        }
    }
}

* Save the updated dataset for individual channel check
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR1", replace




* Create the dataset for urban and rural levels of different governorates for the analysis of missing women
 use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR1", clear

    drop _merge 

	* Collapse the data by governorates_ur and year
	ds caseid governates_ur year, not
	collapse (mean) `r(varlist)', by(governates_ur year)
	
	* Remove missing values
	replace wealthrate11=0 if wealthrate11==.
	replace wealthrate12=0 if wealthrate12==.	
	replace wealthrate13=0 if wealthrate13==.
	replace wealthrate14=0 if wealthrate14==.
	
	replace reponseedurate10=0 if reponseedurate10==.
	replace reponseedurate11=0 if reponseedurate11==.	
	replace reponseedurate12=0 if reponseedurate12==.
	
	replace hedurate10=0 if hedurate10==.
	
	* It's advisable to calculate the relative death ratio after collapsing the data
	g relativeDHSDR1=drate12/drate11
	
	sort governates_ur year b_gender

	* Independent dummy variables
	g past=(year>=2011)
	
	* Treatment and control dummy variables excluding border governorates
	g tgover_ur_noborder=tgover_ur
	replace tgover_ur_noborder=. if tgover_ur==45| tgover_ur==46| tgover_ur==47| tgover_ur==48| tgover_ur==49| tgover_ur==50				
	g group=tgover_ur_noborder
	g past_group=past*group
	
	* Treatment and control group classification based on SPYE
	g group_SPYE=tgover_SPYE
	replace group_SPYE=. if tgover_SPYE==31| tgover_SPYE==32| tgover_SPYE==33
	g past_group_SYPE=past*group_SPYE
	
	* Vaccination ratio between girls and boys
	g vac_rate01_fm=vac_rate01_f/vac_rate01_m

	* Birth-weight ratio between girls and boys
	g birth_weight_fm=birth_weightf/birth_weightm
		
	* Estimate weights using propensity score matching
	logit tgover_ur past wealthrate11 wealthrate12 wealthrate13 wealthrate14 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 	
	
	predict Lps
	replace Lps=1 if tgover_ur==1
				
	* PS weight
	g psweightL=1/(1-Lps) if tgover_ur==0
	replace psweightL=1 if tgover_ur==1
		
	* Aggregate-level dummy including border governorates
	g group_border=tgover_ur_border
	g past_group_border=past*group_border
				
	* Placebo variables
	g past_placebo=(year>=2010)
	g past_group_placebo=past_placebo*group
								
	* Estimate weights using propensity score matching
	logit tgover_ur past_placebo wealthrate11 wealthrate12 wealthrate13 wealthrate14 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12  	
	predict Lps_placebo
	replace Lps_placebo=1 if tgover_ur==1
				
	* Creation of weights
	g psweightL_placebo=1/(1-Lps_placebo) if tgover_ur==0
	replace psweightL_placebo=1 if tgover_ur==1			

	*For merge
	g ID=_n
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1_UR2007", replace

* Load the dataset
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1_UR2007.dta", clear

* Keep only the desired columns
keep governates_ur year rate_male_01 rate_female_01

* Export the selected columns to an Excel file
export excel using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\cr_master_age1_UR2007_selected.xlsx", ///
    firstrow(variables) replace

* Display a success message
display "Selected columns have been successfully exported to Excel."

*************************************************************************************************************************************************
* could you please provide a summary of the male and female death rate data and show the differences in female death rates between rural and urban areas, both before and after the Arab Spring?

* These summary statistics would help us to explain the underlying factors contributing to the higher female death rate in Egypt compared to males. Our intuition is that the gender disparity is more pronounced in rural areas than urban ones, and that is driving the high female/male death * ratio (or missing women). 
















