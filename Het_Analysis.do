*---------------------------------------------------------------*
cap which reghdfe
if _rc ssc install reghdfe, replace

cap which outreg2
if _rc ssc install outreg2, replace

*---------------------------------------------------------------*
* 0. Define CD and import the data
*---------------------------------------------------------------*

clear

cd "C:\Users\yegan\OneDrive - University of Oklahoma\Ghosh, Pallab K.'s files - Yeganeh\Political Participation and children health\arab_spring_women_outcomes_programs_stata\programs\stata\Yeganeh"

* Define the pathe of the results folder

local result_path "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res"

use "Combined_DHS_2005_2008_2014.dta", clear


*---------------------------------------------------------------*
* 0. Define the variables
*---------------------------------------------------------------*

destring TC_noborder, replace
des TC_noborder
g past_group = Time_dummy*TC_noborder 
des past_group


gen teen_preg = 0
replace teen_preg = 1 if Fir_bir_age < 20


gen fir_preg_year = Res_BY + (Fir_bir_age - 1)

gen no_edu = 0
replace no_edu = 1 if Res_edu == 0

gen primary_edu = 0
replace primary_edu = 1 if Res_edu == 1

gen secondary_edu = 0
replace secondary_edu = 1 if Res_edu == 2

gen postsecondaty_edu = 0
replace postsecondaty_edu = 1 if Res_edu == 3



global x1list "Poorest Poorer Middle Richer Respondent_work"

global x2list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age"

global x3list "Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age"

global x4list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"
			
global x5list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"		
		
		
* Check Stata version (useful for troubleshooting)
display "Stata version: " c(stata_version)

* Remove potentially broken / mismatched installs
cap ado uninstall reghdfe
cap ado uninstall ftools
cap ado uninstall ivreghdfe

* Reinstall dependencies first, then reghdfe
ssc install ftools, replace
ssc install reghdfe, replace

* COMPILE ftools (this is the missing step!)
ftools, compile

* Refresh Mata libraries (good practice after updates)
mata: mata mlib index

* Install the require package
ssc install require, replace

*---------------------------------------------------------------*
* 1A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*
eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
*---------------------------------------------------------------*
* 1A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
*---------------------------------------------------------------*
* 1A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	

*---------------------------------------------------------------*
* 1A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

*---------------------------------------------------------------*
* 1A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*



eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
**** Heterogenous Analysis	
*---------------------------------------------------------------*
* Define teenage pregnancy age categories
*---------------------------------------------------------------*

gen very_early_preg = 0
replace very_early_preg = 1 if Fir_bir_age < 16

gen early_teen_preg = 0
replace early_teen_preg = 1 if Fir_bir_age >= 16 & Fir_bir_age < 18

gen late_teen_preg = 0
replace late_teen_preg = 1 if Fir_bir_age >= 18 & Fir_bir_age < 20


*---------------------------------------------------------------*
* PANEL A: Very Early Pregnancy (< 16 years old)
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Export results for very early pregnancy
* Then your export command
esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/very_early_pregnancy.csv", ///
    ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* PANEL B: Early Teen Pregnancy (16-17 years old)
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Export results for very early pregnancy
* Then your export command
esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/early_pregnancy.csv", ///
    ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace


*---------------------------------------------------------------*
* PANEL C: Late Teen Pregnancy (18-19 years old)
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Export results for very early pregnancy
* Then your export command
esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/late_pregnancy.csv", ///
    ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace


*---------------------------------------------------------------*
* SUMMARY: Compare coefficients across age groups
*---------------------------------------------------------------*

* You can also create a comparison table
eststo clear

* Specification 5 (most comprehensive) for all three outcomes
eststo very_early: reghdfe very_early_preg past_group TC_noborder $x5list ///
    [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo early_teen: reghdfe early_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo late_teen: reghdfe late_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab very_early early_teen late_teen using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/age_group_comparison.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Very Early (<16)" "Early Teen (16-17)" "Late Teen (18-19)") ///
    replace
	
	
*---------------------------------------------------------------*
*---------------------------------------------------------------*
* HETEROGENEITY ANALYSIS: SEPARATE REGRESSIONS BY SUBGROUPS
*---------------------------------------------------------------*

*===============================================================
* PART 1: WEALTH QUINTILE HETEROGENEITY
*===============================================================

*---------------------------------------------------------------*
* Poorest Quintile
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Poorest == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Poorest == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Poorest == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Poorest == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Poorest == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/wealth_poorest.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* Poorer Quintile
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Poorer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Poorer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Poorer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Poorer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Poorer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/wealth_poorer.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* Middle Quintile
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Middle == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Middle == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Middle == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Middle == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Middle == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/wealth_middle.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* Richer Quintile
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Richer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Richer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Richer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Richer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Richer == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/wealth_richer.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* Richest Quintile
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Poorest == 0 & Poorer == 0 & Middle == 0 & Richer == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Poorest == 0 & Poorer == 0 & Middle == 0 & Richer == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Poorest == 0 & Poorer == 0 & Middle == 0 & Richer == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Poorest == 0 & Poorer == 0 & Middle == 0 & Richer == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Poorest == 0 & Poorer == 0 & Middle == 0 & Richer == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)


*---------------------------------------------------------------*
* Export wealth heterogeneity results
*---------------------------------------------------------------*

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/wealth_richest.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

	
*---------------------------------------------------------------*
* WEALTH COMPARISON TABLE (Specification 5)
*---------------------------------------------------------------*
	
eststo clear

eststo poorest: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Poorest == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo poorer: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Poorer == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo middle: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Middle == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo richer: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Richer == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo richest: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Poorest == 0 & Poorer == 0 & Middle == 0 & Richer == 0, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab poorest poorer middle richer richest using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/wealth_comparison.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Poorest" "Poorer" "Middle" "Richer" "Richest") ///
    replace

*---------------------------------------------------------------*
* Heterogeneity Analysis by Education Level
*---------------------------------------------------------------*

* First, verify education variable coding
tab Res_edu
tab no_edu
tab primary_edu
tab secondary_edu
tab postsecondaty_edu

* Note: postsecondary is the reference group (omitted category)


*---------------------------------------------------------------*
* Create interaction terms: Treatment × Education Groups
*---------------------------------------------------------------*

* Interactions with past_group (DiD treatment effect)
gen past_group_noedu = past_group * no_edu
gen past_group_primary = past_group * primary_edu
gen past_group_secondary = past_group * secondary_edu

* Interactions with TC_noborder (treatment intensity)
gen TC_noedu = TC_noborder * no_edu
gen TC_primary = TC_noborder * primary_edu
gen TC_secondary = TC_noborder * secondary_edu


*---------------------------------------------------------------*
* Run education heterogeneity models for all 5 specifications
* Reference group: Postsecondary education
*---------------------------------------------------------------*

eststo clear

* Specification 1 - Basic controls (wealth + work)
eststo: reghdfe teen_preg ///
    past_group past_group_noedu past_group_primary past_group_secondary ///
    TC_noborder TC_noedu TC_primary TC_secondary ///
    Poorest Poorer Middle Richer Respondent_work ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2 - Add respondent age (but education is already in interactions)
eststo: reghdfe teen_preg ///
    past_group past_group_noedu past_group_primary past_group_secondary ///
    TC_noborder TC_noedu TC_primary TC_secondary ///
    Poorest Poorer Middle Richer Respondent_work Res_age ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3 - Add husband characteristics
eststo: reghdfe teen_preg ///
    past_group past_group_noedu past_group_primary past_group_secondary ///
    TC_noborder TC_noedu TC_primary TC_secondary ///
    Poorest Poorer Middle Richer Respondent_work ///
    Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4 - Add family characteristics
eststo: reghdfe teen_preg ///
    past_group past_group_noedu past_group_primary past_group_secondary ///
    TC_noborder TC_noedu TC_primary TC_secondary ///
    Poorest Poorer Middle Richer Respondent_work Res_age ///
    Birth_order_number Religion ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5 (Full model) - All controls
eststo: reghdfe teen_preg ///
    past_group past_group_noedu past_group_primary past_group_secondary ///
    TC_noborder TC_noedu TC_primary TC_secondary ///
    Poorest Poorer Middle Richer Respondent_work Res_age ///
    Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age ///
    Birth_order_number Religion ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)


*---------------------------------------------------------------*
* Export education heterogeneity results
*---------------------------------------------------------------*

local result_path "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res"

* Export key interaction terms only
esttab using "`result_path'/education_interactions.csv", ///
    keep(past_group past_group_noedu past_group_primary past_group_secondary ///
         TC_noborder TC_noedu TC_primary TC_secondary) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("(1)" "(2)" "(3)" "(4)" "(5)") ///
    title("Heterogeneity Analysis: Treatment Effects by Education Level") ///
    addnote("Reference group: Postsecondary education" ///
            "Standard errors clustered at Area_unit level in parentheses") ///
    replace

* Export full results
esttab using "`result_path'/education_interactions_full.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("(1)" "(2)" "(3)" "(4)" "(5)") ///
    replace


*---------------------------------------------------------------*
* Formal hypothesis tests for education heterogeneity
*---------------------------------------------------------------*

* Use specification 5 (most comprehensive)
quietly reghdfe teen_preg ///
    past_group past_group_noedu past_group_primary past_group_secondary ///
    TC_noborder TC_noedu TC_primary TC_secondary ///
    Poorest Poorer Middle Richer Respondent_work Res_age ///
    Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age ///
    Birth_order_number Religion ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Test joint significance of all education interactions
test past_group_noedu past_group_primary past_group_secondary

* Test if no education differs from postsecondary
test past_group_noedu = 0

* Test if there's a monotonic education gradient
test past_group_noedu = past_group_primary = past_group_secondary

* Test no education vs primary education
test past_group_noedu = past_group_primary

* Test primary vs secondary education
test past_group_primary = past_group_secondary

* Test secondary vs postsecondary (reference)
test past_group_secondary = 0

* Calculate actual treatment effects for each education group
lincom past_group                          // Postsecondary (reference)
lincom past_group + past_group_noedu       // No education
lincom past_group + past_group_primary     // Primary education
lincom past_group + past_group_secondary   // Secondary education


*---------------------------------------------------------------*
* Calculate teenage pregnancy rates by treatment status and time period
*---------------------------------------------------------------*

* First, let's understand the key variables:
* - teen_preg: 1 if first birth < 20
* - TC_noborder: Treatment group (high protest intensity areas)
* - Time_dummy: Post-treatment period (1 = after Arab Spring 2011, 0 = before)

*---------------------------------------------------------------*
* Calculate teenage pregnancy rates by treatment status and time period
*---------------------------------------------------------------*

* First, let's understand the key variables:
* - teen_preg: 1 if first birth < 20
* - TC_noborder: Treatment group (high protest intensity areas)
* - Time_dummy: Post-treatment period (1 = after Arab Spring 2011, 0 = before)

* Display the variable structure
display "======================================================================"
display "KEY VARIABLES"
display "======================================================================"
tab Time_dummy, missing
tab TC_noborder, missing
tab teen_preg, missing

*---------------------------------------------------------------*
* Method 1: Simple cross-tabulation
*---------------------------------------------------------------*

display ""
display "======================================================================"
display "TEEN PREGNANCY RATES: Treatment vs Control, Before vs After"
display "======================================================================"

* Overall rates
tab Time_dummy teen_preg, row nofreq
display ""

* By treatment status
display "CONTROL GROUP (TC_noborder = 0):"
tab Time_dummy teen_preg if TC_noborder == 0, row nofreq
display ""

display "TREATMENT GROUP (TC_noborder = 1):"
tab Time_dummy teen_preg if TC_noborder == 1, row nofreq
display ""

*---------------------------------------------------------------*
* Method 2: Detailed means with standard errors
*---------------------------------------------------------------*

* Control group, before
mean teen_preg [pweight=weight] if TC_noborder == 0 & Time_dummy == 0
matrix control_before = e(b)
local cb = control_before[1,1]

* Control group, after
mean teen_preg [pweight=weight] if TC_noborder == 0 & Time_dummy == 1
matrix control_after = e(b)
local ca = control_after[1,1]

* Treatment group, before
mean teen_preg [pweight=weight] if TC_noborder == 1 & Time_dummy == 0
matrix treat_before = e(b)
local tb = treat_before[1,1]

* Treatment group, after
mean teen_preg [pweight=weight] if TC_noborder == 1 & Time_dummy == 1
matrix treat_after = e(b)
local ta = treat_after[1,1]

* Display the 2x2 table
display ""
display "======================================================================"
display "TEEN PREGNANCY RATES (Weighted Means)"
display "======================================================================"
display "                           Before (2005/2008)    After (2014)      Change"
display "----------------------------------------------------------------------"
display "Control (Low Protest)      " %6.4f `cb' "              " %6.4f `ca' "        " %6.4f (`ca' - `cb')
display "Treatment (High Protest)   " %6.4f `tb' "              " %6.4f `ta' "        " %6.4f (`ta' - `tb')
display "----------------------------------------------------------------------"
display "Difference (T - C)         " %6.4f (`tb' - `cb') "              " %6.4f (`ta' - `ca') "        " %6.4f ((`ta' - `ca') - (`tb' - `cb'))
display "======================================================================"
display ""
display "DiD Estimate (raw): " %6.4f ((`ta' - `ca') - (`tb' - `cb'))
display "(This is the 'difference-in-differences' without controls)"
display "======================================================================"

*---------------------------------------------------------------*
* Method 3: Sample sizes for each cell
*---------------------------------------------------------------*

display ""
display "======================================================================"
display "SAMPLE SIZES"
display "======================================================================"

count if TC_noborder == 0 & Time_dummy == 0
local n_cb = r(N)
count if TC_noborder == 0 & Time_dummy == 1
local n_ca = r(N)
count if TC_noborder == 1 & Time_dummy == 0
local n_tb = r(N)
count if TC_noborder == 1 & Time_dummy == 1
local n_ta = r(N)

display "                           Before (2005/2008)    After (2014)"
display "----------------------------------------------------------------------"
display "Control (Low Protest)      " %8.0f `n_cb' "              " %8.0f `n_ca'
display "Treatment (High Protest)   " %8.0f `n_tb' "              " %8.0f `n_ta'
display "======================================================================"

*---------------------------------------------------------------*
* Method 4: Summary statistics
*---------------------------------------------------------------*

display ""
display "======================================================================"
display "TEEN PREGNANCY RATES BY SURVEY YEAR"
display "======================================================================"

* By survey year and treatment
table Res_BY TC_noborder, statistic(mean teen_preg) nformat(%6.4f)

***************
*===============================================================
* PART 2: URBAN/RURAL HETEROGENEITY
*===============================================================

*---------------------------------------------------------------*
* Rural Areas
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/rural.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* Urban Areas
*---------------------------------------------------------------*

eststo clear

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/urban.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* URBAN/RURAL COMPARISON TABLE (Specification 5)
*---------------------------------------------------------------*

eststo clear

eststo rural: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban: reghdfe teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab rural urban using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/urban_rural_comparison.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Rural" "Urban") ///
    replace

	
	
	
	
	
*===============================================================
* URBAN/RURAL HETEROGENEITY WITHIN EACH AGE GROUP
*===============================================================

*---------------------------------------------------------------
* PART 1: VERY EARLY PREGNANCY (<16) - RURAL vs URBAN
*---------------------------------------------------------------

eststo clear

* Rural - Very Early Pregnancy
eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/veryearly_rural.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

* Urban - Very Early Pregnancy
eststo clear

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe very_early_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/veryearly_urban.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

* Comparison Table - Very Early Pregnancy (Spec 5)
eststo clear

eststo rural_veryearly: reghdfe very_early_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban_veryearly: reghdfe very_early_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab rural_veryearly urban_veryearly using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/veryearly_comparison.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Rural <16" "Urban <16") ///
    replace

*---------------------------------------------------------------
* PART 2: EARLY TEEN PREGNANCY (16-17) - RURAL vs URBAN
*---------------------------------------------------------------

eststo clear

* Rural - Early Teen Pregnancy
eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/earlyteen_rural.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

* Urban - Early Teen Pregnancy
eststo clear

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe early_teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/earlyteen_urban.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

* Comparison Table - Early Teen Pregnancy (Spec 5)
eststo clear

eststo rural_earlyteen: reghdfe early_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban_earlyteen: reghdfe early_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab rural_earlyteen urban_earlyteen using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/earlyteen_comparison.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Rural 16-17" "Urban 16-17") ///
    replace

*---------------------------------------------------------------
* PART 3: LATE TEEN PREGNANCY (18-19) - RURAL vs URBAN
*---------------------------------------------------------------

eststo clear

* Rural - Late Teen Pregnancy
eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/lateteen_rural.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

* Urban - Late Teen Pregnancy
eststo clear

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x1list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x2list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x3list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x4list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo: reghdfe late_teen_preg ///
    past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/lateteen_urban.csv", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

* Comparison Table - Late Teen Pregnancy (Spec 5)
eststo clear

eststo rural_lateteen: reghdfe late_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban_lateteen: reghdfe late_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab rural_lateteen urban_lateteen using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/lateteen_comparison.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Rural 18-19" "Urban 18-19") ///
    replace

*---------------------------------------------------------------
* PART 4: COMPREHENSIVE COMPARISON TABLE
*---------------------------------------------------------------

eststo clear

* All six combinations (3 age groups × 2 residence types)
eststo rural_very: reghdfe very_early_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban_very: reghdfe very_early_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo rural_early: reghdfe early_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban_early: reghdfe early_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo rural_late: reghdfe late_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 0, absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo urban_late: reghdfe late_teen_preg past_group TC_noborder $x5list ///
    [pweight = weight] if Urban_rural == 1, absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab rural_very urban_very rural_early urban_early rural_late urban_late ///
    using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/age_urban_rural_comprehensive.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    mtitles("Rural <16" "Urban <16" "Rural 16-17" "Urban 16-17" "Rural 18-19" "Urban 18-19") ///
    replace

*===============================================================
* SUMMARY
*===============================================================

display ""
display "======================================================================"
display "AGE × URBAN/RURAL HETEROGENEITY ANALYSIS COMPLETE"
display "======================================================================"
display "Files created:"
display "  Very Early (<16): veryearly_rural.csv, veryearly_urban.csv, veryearly_comparison.csv"
display "  Early Teen (16-17): earlyteen_rural.csv, earlyteen_urban.csv, earlyteen_comparison.csv"
display "  Late Teen (18-19): lateteen_rural.csv, lateteen_urban.csv, lateteen_comparison.csv"
display "  Comprehensive: age_urban_rural_comprehensive.csv"
display "======================================================================"
	
	
	
	
	
	
	
**** LOAD THE MASTER COMBINED DATASET
use "Combined_DHS_2005_2008_2014.dta", clear

**** Add some variables for 2005 observations
* Keep only 2005 rows, merge in selected 2005 variables by caseid
preserve
keep if Sample_year == 2005
merge m:1 caseid using ///
    "C:\Users\yegan\OneDrive - University of Oklahoma\Egypt\Eg2005\2005.dta", ///
    keepusing(s801 s802 s811 s817 s818a s818b s818c s818d ///
              s807_1 s807_2 s807_3 s807_4 s807_5 s807_6 s807_7 ///
              s809_1 s809_2 s809_3 s809_4 s809_5 s809_6 s809_7 ///
              v312) ///
    keep(master match) nogenerate

* Rename variables for consistency across years

rename s801 resp_circumcised
rename s802 resp_circum_age
rename s811 intend_circum_daughter
rename s817 men_want_circum_continue
rename s818a husband_prefer_circum
rename s818b circum_prevents_adultery
rename s818c circum_difficult_childbirth
rename s818d circum_can_cause_death

* Rename daughter circumcision variables
rename s807_1 daughter1_circumcised
rename s807_2 daughter2_circumcised
rename s807_3 daughter3_circumcised
rename s807_4 daughter4_circumcised
rename s807_5 daughter5_circumcised
rename s807_6 daughter6_circumcised
rename s807_7 daughter7_circumcised

rename s809_1 daughter1_circum_age
rename s809_2 daughter2_circum_age
rename s809_3 daughter3_circum_age
rename s809_4 daughter4_circum_age
rename s809_5 daughter5_circum_age
rename s809_6 daughter6_circum_age
rename s809_7 daughter7_circum_age

* Rename contraceptive method variable
rename v312 current_contraceptive

* Label renamed variables

label variable resp_circumcised "Respondent circumcised"
label variable resp_circum_age "Age at circumcision (respondent)"
label variable intend_circum_daughter "Intend to have daughter(s) circumcised in future"
label variable men_want_circum_continue "Thinks that men want circumcision to continue"
label variable husband_prefer_circum "Husband will prefer his wife to be circumcised"
label variable circum_prevents_adultery "Circumcision prevents adultery"
label variable circum_difficult_childbirth "Circumcision makes childbirth more difficult"
label variable circum_can_cause_death "Circumcision can lead to girl's death"

* Label daughter circumcision variables
label variable daughter1_circumcised "Daughter 1 circumcised"
label variable daughter2_circumcised "Daughter 2 circumcised"
label variable daughter3_circumcised "Daughter 3 circumcised"
label variable daughter4_circumcised "Daughter 4 circumcised"
label variable daughter5_circumcised "Daughter 5 circumcised"
label variable daughter6_circumcised "Daughter 6 circumcised"
label variable daughter7_circumcised "Daughter 7 circumcised"

label variable daughter1_circum_age "Age of daughter 1 when circumcised"
label variable daughter2_circum_age "Age of daughter 2 when circumcised"
label variable daughter3_circum_age "Age of daughter 3 when circumcised"
label variable daughter4_circum_age "Age of daughter 4 when circumcised"
label variable daughter5_circum_age "Age of daughter 5 when circumcised"
label variable daughter6_circum_age "Age of daughter 6 when circumcised"
label variable daughter7_circum_age "Age of daughter 7 when circumcised"

* Label contraceptive method variable
label variable current_contraceptive "Current contraceptive method"

* Define value labels for 2005 contraceptive methods
label define contraceptive_2005 ///
    0 "Not using" ///
    1 "Pill" ///
    2 "IUD" ///
    3 "Injections" ///
    4 "Diaphragm" ///
    5 "Condom" ///
    6 "Female sterilization" ///
    7 "Male sterilization" ///
    8 "Periodic abstinence" ///
    9 "Withdrawal" ///
    10 "Other" ///
    11 "Norplant" ///
    12 "Abstinence" ///
    13 "Lactational amenorrhea" ///
    14 "Female condom" ///
    15 "Foam or jelly" ///
    17 "Diaphragm/foam/jelly" ///
    18 "Prolonged breastfeeding" ///
    19 "Specific method 3" ///
    20 "Specific method 4"
    
label values current_contraceptive contraceptive_2005

* Save the 2005 merged data temporarily
tempfile merged_2005
save `merged_2005', replace
restore

**** Add some variables for 2008 observations
preserve
keep if Sample_year == 2008
merge m:1 caseid using ///
    "C:\Users\yegan\OneDrive - University of Oklahoma\Egypt\Eg2008\2008.dta", ///
    keepusing( s920 s921a s921b s921c s921d g102 g106 g108 g116 ///
              s909_1 s909_2 s909_3 s909_4 s909_5 s909_6 s909_7 ///
              s911_1 s911_2 s911_3 s911_4 s911_5 s911_6 s911_7 ///
              v312) ///
    keep(master match) nogenerate

* Rename variables for consistency across years
rename g102 resp_circumcised
rename g106 resp_circum_age
rename g108 num_daughters_circumcised
rename g116 intend_circum_daughter
rename s920 men_want_circum_continue
rename s921a husband_prefer_circum
rename s921b circum_prevents_adultery
rename s921c circum_difficult_childbirth
rename s921d circum_can_cause_death

* Rename daughter circumcision variables
rename s909_1 daughter1_circumcised
rename s909_2 daughter2_circumcised
rename s909_3 daughter3_circumcised
rename s909_4 daughter4_circumcised
rename s909_5 daughter5_circumcised
rename s909_6 daughter6_circumcised
rename s909_7 daughter7_circumcised

rename s911_1 daughter1_circum_age
rename s911_2 daughter2_circum_age
rename s911_3 daughter3_circum_age
rename s911_4 daughter4_circum_age
rename s911_5 daughter5_circum_age
rename s911_6 daughter6_circum_age
rename s911_7 daughter7_circum_age

* Rename contraceptive method variable
rename v312 current_contraceptive

* Label renamed variables
label variable resp_circumcised "Respondent circumcised"
label variable resp_circum_age "Age at circumcision (respondent)"
label variable num_daughters_circumcised "Number of daughters circumcised"
label variable intend_circum_daughter "Intend to have daughter(s) circumcised in future"
label variable men_want_circum_continue "Thinks that men want circumcision to continue"
label variable husband_prefer_circum "Husband will prefer his wife to be circumcised"
label variable circum_prevents_adultery "Circumcision prevents adultery"
label variable circum_difficult_childbirth "Circumcision makes childbirth more difficult"
label variable circum_can_cause_death "Circumcision can lead to girl's death"

* Label daughter circumcision variables
label variable daughter1_circumcised "Daughter 1 circumcised"
label variable daughter2_circumcised "Daughter 2 circumcised"
label variable daughter3_circumcised "Daughter 3 circumcised"
label variable daughter4_circumcised "Daughter 4 circumcised"
label variable daughter5_circumcised "Daughter 5 circumcised"
label variable daughter6_circumcised "Daughter 6 circumcised"
label variable daughter7_circumcised "Daughter 7 circumcised"

label variable daughter1_circum_age "Age of daughter 1 when circumcised"
label variable daughter2_circum_age "Age of daughter 2 when circumcised"
label variable daughter3_circum_age "Age of daughter 3 when circumcised"
label variable daughter4_circum_age "Age of daughter 4 when circumcised"
label variable daughter5_circum_age "Age of daughter 5 when circumcised"
label variable daughter6_circum_age "Age of daughter 6 when circumcised"
label variable daughter7_circum_age "Age of daughter 7 when circumcised"

* Label contraceptive method variable
label variable current_contraceptive "Current contraceptive method"

* Define value labels for 2008 contraceptive methods
label define contraceptive_2008 ///
    0 "Not using" ///
    1 "Pill" ///
    2 "IUD" ///
    3 "Injections" ///
    5 "Condom" ///
    6 "Female sterilization" ///
    8 "Periodic abstinence" ///
    9 "Withdrawal" ///
    10 "Other" ///
    11 "Norplant" ///
    17 "Diaphragm/foam/jelly" ///
    18 "Prolonged breastfeeding"
    
label values current_contraceptive contraceptive_2008

* Save the 2008 merged data temporarily
tempfile merged_2008
save `merged_2008', replace
restore

**** Add some variables for 2014 observations
preserve
keep if Sample_year == 2014
merge m:1 caseid using ///
    "C:\Users\yegan\OneDrive - University of Oklahoma\Egypt\Eg2014\2014.dta", ///
    keepusing(s920 s921a s921b s921c s921d g102 g106 g116 ///
              g121_01 g121_02 g121_03 g121_04 g121_05 g121_06 g121_07 g121_08 ///
              g121_09 g121_10 g121_11 g121_12 g121_13 g121_14 g121_15 g121_16 ///
              g121_17 g121_18 g121_19 g121_20 ///
              g122_01 g122_02 g122_03 g122_04 g122_05 g122_06 g122_07 g122_08 ///
              g122_09 g122_10 g122_11 g122_12 g122_13 g122_14 g122_15 g122_16 ///
              g122_17 g122_18 g122_19 g122_20 ///
              v312) ///
    keep(master match) nogenerate

* Rename variables for consistency across years

rename g102 resp_circumcised
rename g106 resp_circum_age
rename g116 intend_circum_daughter
rename s920 men_want_circum_continue
rename s921a husband_prefer_circum
rename s921b circum_prevents_adultery
rename s921c circum_difficult_childbirth
rename s921d circum_can_cause_death

* Rename daughter circumcision variables (g121 series)
rename g121_01 daughter1_circumcised
rename g121_02 daughter2_circumcised
rename g121_03 daughter3_circumcised
rename g121_04 daughter4_circumcised
rename g121_05 daughter5_circumcised
rename g121_06 daughter6_circumcised
rename g121_07 daughter7_circumcised
rename g121_08 daughter8_circumcised
rename g121_09 daughter9_circumcised
rename g121_10 daughter10_circumcised
rename g121_11 daughter11_circumcised
rename g121_12 daughter12_circumcised
rename g121_13 daughter13_circumcised
rename g121_14 daughter14_circumcised
rename g121_15 daughter15_circumcised
rename g121_16 daughter16_circumcised
rename g121_17 daughter17_circumcised
rename g121_18 daughter18_circumcised
rename g121_19 daughter19_circumcised
rename g121_20 daughter20_circumcised

* Rename daughter circumcision age variables (g122 series)
rename g122_01 daughter1_circum_age
rename g122_02 daughter2_circum_age
rename g122_03 daughter3_circum_age
rename g122_04 daughter4_circum_age
rename g122_05 daughter5_circum_age
rename g122_06 daughter6_circum_age
rename g122_07 daughter7_circum_age
rename g122_08 daughter8_circum_age
rename g122_09 daughter9_circum_age
rename g122_10 daughter10_circum_age
rename g122_11 daughter11_circum_age
rename g122_12 daughter12_circum_age
rename g122_13 daughter13_circum_age
rename g122_14 daughter14_circum_age
rename g122_15 daughter15_circum_age
rename g122_16 daughter16_circum_age
rename g122_17 daughter17_circum_age
rename g122_18 daughter18_circum_age
rename g122_19 daughter19_circum_age
rename g122_20 daughter20_circum_age

* Rename contraceptive method variable
rename v312 current_contraceptive

* Label renamed variables
label variable resp_circumcised "Respondent circumcised"
label variable resp_circum_age "Age at circumcision (respondent)"
label variable intend_circum_daughter "Intends to have daughter(s) circumcised in future"
label variable men_want_circum_continue "Thinks that men wants circumcision to continue or end"
label variable husband_prefer_circum "Husband will prefer his wife to be circumcised"
label variable circum_prevents_adultery "Circumcision prevents adultery"
label variable circum_difficult_childbirth "Circumcision makes childbirth more difficult"
label variable circum_can_cause_death "Circumcision can lead to girl's death"

* Label daughter circumcision variables
forvalues i = 1/20 {
    label variable daughter`i'_circumcised "Daughter `i' circumcised"
    label variable daughter`i'_circum_age "Age of daughter `i' when circumcised"
}

* Label contraceptive method variable
label variable current_contraceptive "Current contraceptive method"

* Define value labels for 2014 contraceptive methods
label define contraceptive_2014 ///
    0 "Not using" ///
    1 "Pill" ///
    2 "IUD" ///
    4 "Diaphragm/Foam/Jelly" ///
    5 "Condom" ///
    6 "Female sterilization" ///
    8 "Periodic abstinence" ///
    9 "Withdrawal" ///
    10 "Other" ///
    11 "Implants/Norplant" ///
    18 "Injection (3 monthly)" ///
    19 "Injection (monthly)" ///
    20 "Prolonged breastfeeding"
    
label values current_contraceptive contraceptive_2014

* Save the 2014 merged data temporarily
tempfile merged_2014
save `merged_2014', replace
restore

**** Combine all years back together
use `merged_2005', clear
append using `merged_2008'
append using `merged_2014'

* Sort by year and caseid
sort Sample_year caseid

* Save the final combined dataset
save "Combined_DHS_2005_2008_2014_extended.dta", replace

* Verify the merge and renamed variables
tab Sample_year, missing
by Sample_year: summarize resp_circumcised resp_circum_age
by Sample_year: summarize intend_circum_daughter 

* Check daughter circumcision variables
by Sample_year: tab daughter1_circumcised, missing
by Sample_year: summarize daughter1_circum_age daughter2_circum_age daughter3_circum_age

* Check contraceptive method distribution
tab current_contraceptive Sample_year, missing row	
	
	
	
	
	
use "Combined_DHS_2005_2008_2014_extended", clear





*------------------------------------------------------------*
* 1) Teen Wife indicator (based on age at first birth)
*------------------------------------------------------------*
gen byte teen_wife = (AgeofFirstMarriage < 20) if !missing(AgeofFirstMarriage)
label define teen_wife 0 "Not teen wife" 1 "Teen wife"
label values teen_wife teen_wife

*------------------------------------------------------------*
* 2) Age gap between husband and respondent
*    (positive => husband older)
*------------------------------------------------------------*
gen age_gap = Husband_age - Res_age if !missing(Husband_age, Res_age)

* Optional: indicator for missing age gap
gen byte miss_age_gap = missing(age_gap)

*------------------------------------------------------------*
* 3) Explore age gap among teen mothers
*------------------------------------------------------------*
summ age_gap if teen_wife==1, detail
tab miss_age_gap if teen_wife==1

* Percentiles / distribution (more readable than detail sometimes)
_pctile age_gap if teen_wife==1, p(1 5 10 25 50 75 90 95 99)
return list



*------------------------------------------------------------*
* 4) Useful bins for age gap among teen wives
*------------------------------------------------------------*
gen gap_grp = .
replace gap_grp = 1 if age_gap <= -3
replace gap_grp = 2 if inrange(age_gap, -2, 2)
replace gap_grp = 3 if inrange(age_gap, 3, 7)
replace gap_grp = 4 if age_gap >= 8 & age_gap < .

label define gap_grp 1 "H younger (<=-3)" 2 "Close (-2..2)" 3 "H older (3..7)" 4 "H much older (8+)"
label values gap_grp gap_grp

tab gap_grp if teen_wife==1, missing

*------------------------------------------------------------*
* 5) Compare age-gap distribution: teen mothers vs others
*------------------------------------------------------------*
summ age_gap if teen_wife==1
summ age_gap if teen_wife==0

tab gap_grp teen_wife, row missing



global x1_gap "Poorest Poorer Middle Richer Respondent_work"

global x2_gap "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age"

global x3_gap "Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary"

global x4_gap "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"

global x5_gap "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Birth_order_number Religion"




eststo clear

eststo: reghdfe age_gap ///
    past_group TC_noborder $x1_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo: reghdfe age_gap ///
    past_group TC_noborder $x2_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo: reghdfe age_gap ///
    past_group TC_noborder $x3_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo: reghdfe age_gap ///
    past_group TC_noborder $x4_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo: reghdfe age_gap ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/agegap_teenwife.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace



*---------------------------------------------------------------*
* Decomposing Age Gap: Husband vs Wife Marriage Age
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Step 1: Construct husband's age at marriage
*---------------------------------------------------------------*

* Wife's age at marriage (already have this)
* rename AgeofFirstMarriage wife_age_marriage

* Husband's age at marriage
* Logic: age_gap = husband_current - wife_current
*        At marriage: age_gap_at_marriage = husband_age_marriage - wife_age_marriage
*        If they married each other at time of first marriage:
*        husband_age_marriage = age_gap + wife_age_marriage

gen husband_age_marriage = age_gap + AgeofFirstMarriage ///
    if !missing(age_gap, AgeofFirstMarriage)
label variable husband_age_marriage "Husband's age at (respondent's first) marriage"

* Alternative: using current ages and marriage duration
* If you have years since marriage:
* gen husband_age_marriage_alt = Husband_age - years_since_marriage

*---------------------------------------------------------------*
* Step 2: Check the construction makes sense
*---------------------------------------------------------------*

* Summary statistics
summarize AgeofFirstMarriage husband_age_marriage age_gap if teen_wife==1, detail

* Verify the relationship
* age_gap should equal husband_age_marriage - wife_age_marriage
gen check_gap = husband_age_marriage - AgeofFirstMarriage
compare age_gap check_gap if teen_wife==1
* Should be identical

drop check_gap

* Distribution by treatment
bysort past_group: summarize AgeofFirstMarriage husband_age_marriage age_gap ///
    if teen_wife==1 [aweight=weight]

*---------------------------------------------------------------*
* Step 3: Run regressions for WIFE's age at marriage
*---------------------------------------------------------------*

eststo clear

display "Panel A: Wife's Age at Marriage (AgeofFirstMarriage)"
display "========================================================="

eststo wife_x1: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x1_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x2: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x2_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x3: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x3_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x4: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x4_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x5: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab wife_x1 wife_x2 wife_x3 wife_x4 wife_x5, ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Wife's Age at Marriage") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Step 4: Run regressions for HUSBAND's age at marriage
*---------------------------------------------------------------*

eststo clear

display "Panel B: Husband's Age at Marriage"
display "========================================================="

eststo husb_x1: reghdfe husband_age_marriage ///
    past_group TC_noborder $x1_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x2: reghdfe husband_age_marriage ///
    past_group TC_noborder $x2_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x3: reghdfe husband_age_marriage ///
    past_group TC_noborder $x3_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x4: reghdfe husband_age_marriage ///
    past_group TC_noborder $x4_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x5: reghdfe husband_age_marriage ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab husb_x1 husb_x2 husb_x3 husb_x4 husb_x5, ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Husband's Age at Marriage") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Step 5: Combined table showing all three outcomes
*---------------------------------------------------------------*

eststo clear

* Re-run all three with full specification for comparison
eststo gap: reghdfe age_gap ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husband: reghdfe husband_age_marriage ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display combined table
esttab gap wife husband, ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Age Gap Decomposition - Full Specification") ///
    mtitles("Age Gap" "Wife Age" "Husband Age") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Sample: Teen wives (married before age 20)" ///
                     "Age Gap = Husband Age at Marriage - Wife Age at Marriage" ///
                     "past_group coefficient shows treatment effect")

* Export to LaTeX
esttab gap wife husband using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/agegap_decomposition.tex", ///
    replace booktabs ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Age Gap Decomposition Among Teen Wives") ///
    mtitles("Age Gap" "Wife Age" "Husband Age") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Sample: Teen wives (married before age 20)" ///
                     "Age Gap = Husband Age - Wife Age at marriage" ///
                     "Full specification with all controls")

* Export to CSV
esttab gap wife husband using "C:/Users/yegan/OneDrive - University of Oklahoma/Egypt/Res/agegap_decomposition.csv", ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    stats(N r2_a, fmt(0 3)) ///
    replace

*---------------------------------------------------------------*
* Step 6: Verify the decomposition mathematically
*---------------------------------------------------------------*

* Extract coefficients from full specification
* Coefficient on age_gap should equal coefficient on husband minus coefficient on wife

* Store coefficients
eststo clear

quietly reghdfe age_gap past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1 & age_gap<., ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)
local coef_gap = _b[past_group]

quietly reghdfe AgeofFirstMarriage past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1, ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)
local coef_wife = _b[past_group]

quietly reghdfe husband_age_marriage past_group TC_noborder $x5_gap ///
    [pweight = weight] if teen_wife==1 & !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)
local coef_husband = _b[past_group]

* Check decomposition
local implied_gap = `coef_husband' - `coef_wife'

display ""
display "DECOMPOSITION CHECK:"
display "===================="
display "Direct effect on age gap: " %6.3f `coef_gap'
display "Effect on husband age:    " %6.3f `coef_husband'
display "Effect on wife age:       " %6.3f `coef_wife'
display "Implied gap (H - W):      " %6.3f `implied_gap'
display "Difference:               " %6.3f (`coef_gap' - `implied_gap')
display ""

*---------------------------------------------------------------*
* Step 7: Calculate contributions to gap reduction
*---------------------------------------------------------------*

* If age gap decreased (negative past_group coefficient):
* - What % is due to wife marrying older?
* - What % is due to husband marrying younger?

if `coef_gap' < 0 {
    display "Age gap DECREASED by treatment"
    display ""
    
    * Contribution from wife marrying older (positive effect, reduces gap)
    local wife_contribution = -`coef_wife' / `coef_gap' * 100
    
    * Contribution from husband marrying younger (negative effect, reduces gap)
    local husband_contribution = `coef_husband' / `coef_gap' * 100
    
    display "Decomposition of gap reduction:"
    display "  Wife marrying older explains: " %5.1f `wife_contribution' "%"
    display "  Husband marrying younger explains: " %5.1f `husband_contribution' "%"
}

*---------------------------------------------------------------*
* Step 8: Summary statistics for interpretation
*---------------------------------------------------------------*

* Control group means
summarize age_gap if teen_wife==1 & past_group==0 [aweight=weight]
local gap_control_mean = r(mean)

summarize AgeofFirstMarriage if teen_wife==1 & past_group==0 [aweight=weight]
local wife_control_mean = r(mean)

summarize husband_age_marriage if teen_wife==1 & past_group==0 [aweight=weight]
local husband_control_mean = r(mean)

display ""
display "Control Group Means (Teen Wives):"
display "  Age gap: " %5.2f `gap_control_mean' " years"
display "  Wife age at marriage: " %5.2f `wife_control_mean' " years"
display "  Husband age at marriage: " %5.2f `husband_control_mean' " years"
display ""

* Percentage effects
display "Percentage effects (relative to control mean):"
display "  Age gap: " %5.1f (`coef_gap'/`gap_control_mean'*100) "%"
display "  Wife age: " %5.1f (`coef_wife'/`wife_control_mean'*100) "%"
display "  Husband age: " %5.1f (`coef_husband'/`husband_control_mean'*100) "%"
	

	
*---------------------------------------------------------------*
* Explore current_contraceptive variable
*---------------------------------------------------------------*

* 1. Check the overall distribution of current_contraceptive
tab current_contraceptive, missing

* 2. See the value labels
codebook current_contraceptive

* 3. Check distribution by TC_noborder (treatment group)
tab current_contraceptive TC_noborder, missing row col

* 4. With percentages - row percentages (within each contraceptive method)
tab current_contraceptive TC_noborder, missing row

* 5. With percentages - column percentages (within each TC_noborder group)
tab current_contraceptive TC_noborder, missing col

* 6. Check distribution by TC_noborder and survey year (Stata 17+ syntax)
table Sample_year TC_noborder, statistic(mean current_contraceptive) nformat(%9.2f)

* 7. More detailed breakdown by year and treatment
tab current_contraceptive TC_noborder if Sample_year == 2005, missing col
tab current_contraceptive TC_noborder if Sample_year == 2008, missing col
tab current_contraceptive TC_noborder if Sample_year == 2014, missing col

*---------------------------------------------------------------*
* Summary statistics with weights (since you're using weights in regressions)
*---------------------------------------------------------------*

* 8. Weighted distribution overall
tab current_contraceptive [aweight = weight], missing

* 9. Weighted distribution by TC_noborder
tab current_contraceptive TC_noborder [aweight = weight], missing col

* 10. Create a binary indicator for "using any contraceptive"
gen using_contraceptive = (current_contraceptive > 0 & current_contraceptive != .)
label variable using_contraceptive "Using any contraceptive method"
label define using_contraceptive 0 "Not using" 1 "Using"
label values using_contraceptive using_contraceptive

* 11. Check contraceptive use rate by treatment group
tab using_contraceptive TC_noborder [aweight = weight], missing col

* 12. Summary by treatment group
bysort TC_noborder: summarize using_contraceptive [aweight = weight]

*---------------------------------------------------------------*
* Visualizations (optional)
*---------------------------------------------------------------*

* 13. Bar graph of contraceptive use by treatment status
graph bar (mean) using_contraceptive [aweight = weight], ///
    over(TC_noborder) ///
    ytitle("Proportion using contraceptives") ///
    title("Contraceptive Use by Treatment Group") ///
    ylabel(0(.1)1, format(%3.1f))

* 14. Bar graph by year and treatment
graph bar (mean) using_contraceptive [aweight = weight], ///
    over(TC_noborder) over(Sample_year) ///
    ytitle("Proportion using contraceptives") ///
    title("Contraceptive Use by Treatment Group and Year") ///
    ylabel(0(.1)1, format(%3.1f))
	
	
*---------------------------------------------------------------*
* Prepare data for plotting contraceptive trends by year (with weights)
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Visualizations: Contraceptive Use Trends Over Time
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Figure 1: Line graph of major contraceptive methods over time
*---------------------------------------------------------------*
preserve

* Create indicator variables with CORRECT codes
gen not_using = (current_contraceptive==0)
gen pill = (current_contraceptive==1)
gen iud = (current_contraceptive==2)
gen injection = (current_contraceptive==3)
gen diaphragm = (current_contraceptive==4)
gen condom = (current_contraceptive==5)
gen female_steril = (current_contraceptive==6)
gen male_steril = (current_contraceptive==7)
gen periodic_abst = (current_contraceptive==8)
gen withdrawal = (current_contraceptive==9)
gen other = (current_contraceptive==10)
gen norplant = (current_contraceptive==11)
gen abstinence = (current_contraceptive==12)
gen lam = (current_contraceptive==13)
gen female_condom = (current_contraceptive==14)
gen foam_jelly = (current_contraceptive==15)
gen diaphragm_foam = (current_contraceptive==17)
gen breastfeeding = (current_contraceptive==18)
gen specific_3 = (current_contraceptive==19)
gen specific_4 = (current_contraceptive==20)

* Collapse by year
collapse (mean) not_using pill iud injection diaphragm condom ///
                female_steril male_steril periodic_abst withdrawal ///
                other norplant abstinence lam female_condom foam_jelly ///
                diaphragm_foam breastfeeding specific_3 specific_4 ///
         [pweight=weight], by(Sample_year)

* Convert to percentages
foreach var in not_using pill iud injection diaphragm condom ///
               female_steril male_steril periodic_abst withdrawal ///
               other norplant abstinence lam female_condom foam_jelly ///
               diaphragm_foam breastfeeding specific_3 specific_4 {
    replace `var' = `var' * 100
}

* Plot major methods
twoway (line pill Sample_year, lwidth(thick) lcolor(blue)) ///
       (line iud Sample_year, lwidth(thick) lcolor(red)) ///
       (line injection Sample_year, lwidth(thick) lcolor(green)) ///
       (line periodic_abst Sample_year, lwidth(thick) lcolor(orange)) ///
       (line withdrawal Sample_year, lwidth(thick) lcolor(purple)) ///
       (line breastfeeding Sample_year, lwidth(thick) lcolor(pink)) ///
       (line not_using Sample_year, lwidth(thick) lcolor(gray) lpattern(dash)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(10)50, format(%3.0f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Trends in Contraceptive Use Over Time") ///
    legend(order(1 "Pill" 2 "IUD" 3 "Injection" ///
                 4 "Periodic Abstinence" 5 "Withdrawal" ///
                 6 "Breastfeeding" 7 "Not Using") ///
           rows(2) position(6)) ///
    graphregion(color(white)) bgcolor(white)
graph export "contraceptive_trends_line.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 2: Stacked bar chart by year
*---------------------------------------------------------------*
preserve

* Create method categories
gen method_cat = .
replace method_cat = 1 if current_contraceptive == 0    // Not using
replace method_cat = 2 if current_contraceptive == 1    // Pill
replace method_cat = 3 if current_contraceptive == 2    // IUD
replace method_cat = 4 if current_contraceptive == 3    // Injections
replace method_cat = 5 if inlist(current_contraceptive, 5, 11)  // Condom, Norplant
replace method_cat = 6 if inlist(current_contraceptive, 6, 7)   // Sterilization
replace method_cat = 7 if current_contraceptive == 8    // Periodic abstinence
replace method_cat = 8 if current_contraceptive == 9    // Withdrawal
replace method_cat = 9 if current_contraceptive == 18   // Breastfeeding
replace method_cat = 10 if inlist(current_contraceptive, 4, 10, 12, 13, 14, 15, 17, 19, 20)  // Other

label define method_cat 1 "Not Using" 2 "Pill" 3 "IUD" ///
                        4 "Injection" 5 "Condom/Implants" ///
                        6 "Sterilization" 7 "Periodic Abstinence" ///
                        8 "Withdrawal" 9 "Breastfeeding" 10 "Other"
label values method_cat method_cat

graph bar [pweight=weight], over(method_cat) over(Sample_year) ///
    asyvars percentages stack ///
    title("Distribution of Contraceptive Methods by Year") ///
    ytitle("Percentage (%)") ///
    legend(rows(3) position(6) size(small)) ///
    graphregion(color(white)) bgcolor(white) ///
    bar(1, color(gs12)) bar(2, color(blue)) bar(3, color(red)) ///
    bar(4, color(green)) bar(5, color(orange)) bar(6, color(navy)) ///
    bar(7, color(purple)) bar(8, color(yellow)) bar(9, color(pink)) ///
    bar(10, color(brown))
graph export "contraceptive_distribution_stacked.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 3: Panel plot by treatment group (including traditional)
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen pill = (current_contraceptive==1)
gen iud = (current_contraceptive==2)
gen injection = (current_contraceptive==3)
gen periodic_abst = (current_contraceptive==8)
gen withdrawal = (current_contraceptive==9)
gen norplant = (current_contraceptive==11)
gen breastfeeding = (current_contraceptive==18)
gen modern = inlist(current_contraceptive,1,2,3,5,6,7,11)
gen traditional = inlist(current_contraceptive,8,9)

* Collapse by year and treatment
collapse (mean) pill iud injection periodic_abst withdrawal ///
                norplant breastfeeding modern traditional ///
         [pweight=weight], by(Sample_year TC_noborder)

* Keep only treatment and control groups
keep if inlist(TC_noborder, 0, 1)

* Convert to percentages
foreach var in pill iud injection periodic_abst withdrawal ///
               norplant breastfeeding modern traditional {
    replace `var' = `var' * 100
}

* Plot by treatment group
twoway (line pill Sample_year if TC_noborder==0, lwidth(thick) lcolor(blue)) ///
       (line pill Sample_year if TC_noborder==1, lwidth(thick) lcolor(blue) lpattern(dash)) ///
       (line iud Sample_year if TC_noborder==0, lwidth(thick) lcolor(red)) ///
       (line iud Sample_year if TC_noborder==1, lwidth(thick) lcolor(red) lpattern(dash)) ///
       (line injection Sample_year if TC_noborder==0, lwidth(thick) lcolor(green)) ///
       (line injection Sample_year if TC_noborder==1, lwidth(thick) lcolor(green) lpattern(dash)) ///
       (line periodic_abst Sample_year if TC_noborder==0, lwidth(thick) lcolor(orange)) ///
       (line periodic_abst Sample_year if TC_noborder==1, lwidth(thick) lcolor(orange) lpattern(dash)) ///
       (line withdrawal Sample_year if TC_noborder==0, lwidth(thick) lcolor(purple)) ///
       (line withdrawal Sample_year if TC_noborder==1, lwidth(thick) lcolor(purple) lpattern(dash)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(5)35, format(%3.0f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Contraceptive Use Trends by Treatment Group") ///
    legend(order(1 "Pill (Control)" 2 "Pill (Treatment)" ///
                 3 "IUD (Control)" 4 "IUD (Treatment)" ///
                 5 "Injection (Control)" 6 "Injection (Treatment)" ///
                 7 "Periodic Abs (Control)" 8 "Periodic Abs (Treatment)" ///
                 9 "Withdrawal (Control)" 10 "Withdrawal (Treatment)") ///
           rows(5) position(6) size(vsmall)) ///
    graphregion(color(white)) bgcolor(white)
graph export "contraceptive_trends_by_treatment.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 4: Individual method trends (bar chart)
*---------------------------------------------------------------*
preserve

* Create indicators for all major methods with correct codes
gen pill = (current_contraceptive == 1) * 100
gen iud = (current_contraceptive == 2) * 100
gen injection = (current_contraceptive == 3) * 100
gen condom = (current_contraceptive == 5) * 100
gen sterilization = inlist(current_contraceptive, 6, 7) * 100
gen norplant = (current_contraceptive == 11) * 100
gen periodic_abst = (current_contraceptive == 8) * 100
gen withdrawal = (current_contraceptive == 9) * 100
gen breastfeeding = (current_contraceptive == 18) * 100

* Collapse by year and treatment
collapse (mean) pill iud injection condom sterilization norplant ///
               periodic_abst withdrawal breastfeeding ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)

* Panel bar chart
graph bar pill iud injection sterilization norplant ///
          periodic_abst withdrawal breastfeeding, ///
    over(Sample_year) over(TC_noborder, relabel(1 "Control" 2 "Treatment")) ///
    asyvars ///
    ytitle("Percentage (%)") ///
    title("Contraceptive Method Use by Treatment Group and Year") ///
    legend(rows(2) position(6) size(vsmall) ///
           order(1 "Pill" 2 "IUD" 3 "Injection" 4 "Sterilization" ///
                 5 "Implants" 6 "Periodic Abs" 7 "Withdrawal" 8 "Breastfeeding")) ///
    graphregion(color(white)) bgcolor(white)
graph export "contraceptive_panel_by_treatment.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 5: Modern vs Traditional methods comparison
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen not_using = (current_contraceptive==0)
gen modern = inlist(current_contraceptive,1,2,3,5,6,7,11,14)
gen traditional = inlist(current_contraceptive,8,9)
gen breastfeeding = (current_contraceptive==18)
gen other = inlist(current_contraceptive,4,10,12,13,15,17,19,20)

* Collapse by year and treatment
collapse (mean) not_using modern traditional breastfeeding other ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)

* Convert to percentages
foreach var in not_using modern traditional breastfeeding other {
    replace `var' = `var' * 100
}

* Grouped bar chart
graph bar modern traditional breastfeeding other not_using, ///
    over(TC_noborder, relabel(1 "Control" 2 "Treatment")) ///
    over(Sample_year) ///
    asyvars ///
    ytitle("Percentage (%)") ///
    ylabel(0(20)100) ///
    title("Contraceptive Use Categories Over Time") ///
    subtitle("By Treatment Group") ///
    legend(order(1 "Modern Methods" 2 "Traditional Methods" ///
                 3 "Breastfeeding" 4 "Other" 5 "Not Using") ///
           rows(1) position(6) size(vsmall)) ///
    graphregion(color(white)) bgcolor(white) ///
    bar(1, color(dkgreen)) bar(2, color(orange)) ///
    bar(3, color(pink)) bar(4, color(brown)) bar(5, color(gs10))
graph export "contraceptive_categories_grouped.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 6: Traditional methods detailed comparison
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen periodic_abst = (current_contraceptive==8)
gen withdrawal = (current_contraceptive==9)
gen traditional = inlist(current_contraceptive,8,9)

* Collapse by year and treatment
collapse (mean) periodic_abst withdrawal traditional ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)
replace periodic_abst = periodic_abst * 100
replace withdrawal = withdrawal * 100
replace traditional = traditional * 100

* Plot traditional methods
twoway (connected periodic_abst Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(orange) mcolor(orange)) ///
       (connected periodic_abst Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(orange) mcolor(orange) ///
            lpattern(dash) msymbol(triangle)) ///
       (connected withdrawal Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(purple) mcolor(purple)) ///
       (connected withdrawal Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(purple) mcolor(purple) ///
            lpattern(dash) msymbol(triangle)) ///
       (connected traditional Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(brown) mcolor(brown)) ///
       (connected traditional Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(brown) mcolor(brown) ///
            lpattern(dash) msymbol(triangle)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(0.2)1, format(%3.1f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Traditional Contraceptive Methods Over Time") ///
    subtitle("Control vs Treatment Group") ///
    legend(order(1 "Periodic Abs (Control)" 2 "Periodic Abs (Treatment)" ///
                 3 "Withdrawal (Control)" 4 "Withdrawal (Treatment)" ///
                 5 "All Traditional (Control)" 6 "All Traditional (Treatment)") ///
           rows(3) position(6) size(small)) ///
    graphregion(color(white)) bgcolor(white)
graph export "traditional_methods_detailed.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 7: Modern vs Traditional - DiD style
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen modern = inlist(current_contraceptive,1,2,3,5,6,7,11,14)
gen traditional = inlist(current_contraceptive,8,9)

* Collapse by year and treatment
collapse (mean) modern traditional ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)
replace modern = modern * 100
replace traditional = traditional * 100

twoway (connected modern Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(blue) mcolor(blue)) ///
       (connected modern Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(red) mcolor(red) ///
            lpattern(dash) msymbol(triangle)) ///
       (connected traditional Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(blue) mcolor(blue) ///
            lpattern(shortdash) msymbol(square)) ///
       (connected traditional Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(red) mcolor(red) ///
            lpattern(shortdash_dot) msymbol(diamond)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(10)70, format(%3.0f)) ///
    ytitle("Contraceptive Use (%)") ///
    xtitle("Survey Year") ///
    title("Modern vs Traditional Contraceptive Use Over Time") ///
    subtitle("Control vs Treatment Group") ///
    legend(order(1 "Modern (Control)" 2 "Modern (Treatment)" ///
                 3 "Traditional (Control)" 4 "Traditional (Treatment)") ///
           rows(2) position(6)) ///
    graphregion(color(white)) bgcolor(white)
graph export "modern_vs_traditional_did.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 8: Top 5 methods comparison
*---------------------------------------------------------------*
preserve

* Create indicators for top 5 methods
gen pill = (current_contraceptive==1)
gen iud = (current_contraceptive==2)
gen injection = (current_contraceptive==3)
gen breastfeeding = (current_contraceptive==18)
gen norplant = (current_contraceptive==11)

* Collapse by year and treatment
collapse (mean) pill iud injection breastfeeding norplant ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)

* Convert to percentages
foreach var in pill iud injection breastfeeding norplant {
    replace `var' = `var' * 100
}

* Create combined plot
twoway (line pill Sample_year if TC_noborder==0, lwidth(thick) lcolor(blue)) ///
       (line pill Sample_year if TC_noborder==1, lwidth(thick) lcolor(blue) lpattern(dash)) ///
       (line iud Sample_year if TC_noborder==0, lwidth(thick) lcolor(red)) ///
       (line iud Sample_year if TC_noborder==1, lwidth(thick) lcolor(red) lpattern(dash)) ///
       (line injection Sample_year if TC_noborder==0, lwidth(thick) lcolor(green)) ///
       (line injection Sample_year if TC_noborder==1, lwidth(thick) lcolor(green) lpattern(dash)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(5)35, format(%3.0f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Top 3 Modern Contraceptive Methods by Treatment Group") ///
    legend(order(1 "Pill (Control)" 2 "Pill (Treatment)" ///
                 3 "IUD (Control)" 4 "IUD (Treatment)" ///
                 5 "Injection (Control)" 6 "Injection (Treatment)") ///
           rows(3) position(6) size(small)) ///
    graphregion(color(white)) bgcolor(white)
graph export "top3_methods_by_treatment.png", replace width(2000)

restore



*---------------------------------------------------------------*
* Treatment Effects on Contraceptive Use
* Using the same 5 specifications as teenage pregnancy analysis
*---------------------------------------------------------------*

* Ensure control variable globals are defined
global x1list "Poorest Poorer Middle Richer Respondent_work"
global x2list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age"
global x3list "Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age"
global x4list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"
global x5list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

*---------------------------------------------------------------*
* Create contraceptive use outcome variables
*---------------------------------------------------------------*

* Any contraceptive use (binary)
gen using_any_contraceptive = (current_contraceptive > 0 & current_contraceptive != .)
label variable using_any_contraceptive "Using any contraceptive method"

* Modern methods (binary)
gen using_modern = inlist(current_contraceptive,1,2,3,5,6,7,11,14) if current_contraceptive != .
label variable using_modern "Using modern contraceptive method"

* Traditional methods (binary)
gen using_traditional = inlist(current_contraceptive,8,9) if current_contraceptive != .
label variable using_traditional "Using traditional contraceptive method"

* Specific modern methods
gen using_pill = (current_contraceptive==1) if current_contraceptive != .
label variable using_pill "Using pill"

gen using_iud = (current_contraceptive==2) if current_contraceptive != .
label variable using_iud "Using IUD"

gen using_injection = (current_contraceptive==3) if current_contraceptive != .
label variable using_injection "Using injection"

gen using_implants = (current_contraceptive==11) if current_contraceptive != .
label variable using_implants "Using implants/Norplant"

* Specific traditional methods
gen using_periodic_abst = (current_contraceptive==8) if current_contraceptive != .
label variable using_periodic_abst "Using periodic abstinence"

gen using_withdrawal = (current_contraceptive==9) if current_contraceptive != .
label variable using_withdrawal "Using withdrawal"

*---------------------------------------------------------------*
* Panel A: Any Contraceptive Use (Main Outcome)
*---------------------------------------------------------------*

* Clear stored estimates
eststo clear

* Specification 1: Wealth + Respondent work
eststo any_x1: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2: Add respondent education + age
eststo any_x2: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3: Add husband characteristics
eststo any_x3: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4: Respondent + birth order + religion
eststo any_x4: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5: Full specification
eststo any_x5: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results table for any contraceptive use
esttab any_x1 any_x2 any_x3 any_x4 any_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Any Contraceptive Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area_unit level" ///
                     "All specifications include Area_unit and birth year FE")


*---------------------------------------------------------------*
* Panel B: Modern Contraceptive Use
*---------------------------------------------------------------*

eststo clear

* Specification 1
eststo modern_x1: reghdfe using_modern ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2
eststo modern_x2: reghdfe using_modern ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3
eststo modern_x3: reghdfe using_modern ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4
eststo modern_x4: reghdfe using_modern ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5
eststo modern_x5: reghdfe using_modern ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results
esttab modern_x1 modern_x2 modern_x3 modern_x4 modern_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Modern Contraceptive Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Panel C: Traditional Contraceptive Use
*---------------------------------------------------------------*

eststo clear

* Specification 1
eststo trad_x1: reghdfe using_traditional ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2
eststo trad_x2: reghdfe using_traditional ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3
eststo trad_x3: reghdfe using_traditional ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4
eststo trad_x4: reghdfe using_traditional ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5
eststo trad_x5: reghdfe using_traditional ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results
esttab trad_x1 trad_x2 trad_x3 trad_x4 trad_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Traditional Contraceptive Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Panel D: Specific Modern Methods (Pill, IUD, Injection)
*---------------------------------------------------------------*

eststo clear

* Pill - all 5 specifications
eststo pill_x1: reghdfe using_pill past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x2: reghdfe using_pill past_group TC_noborder $x2list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x3: reghdfe using_pill past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x4: reghdfe using_pill past_group TC_noborder $x4list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x5: reghdfe using_pill past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display pill results
esttab pill_x1 pill_x2 pill_x3 pill_x4 pill_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Pill Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

eststo clear

* IUD - all 5 specifications
eststo iud_x1: reghdfe using_iud past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x2: reghdfe using_iud past_group TC_noborder $x2list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x3: reghdfe using_iud past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x4: reghdfe using_iud past_group TC_noborder $x4list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x5: reghdfe using_iud past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display IUD results
esttab iud_x1 iud_x2 iud_x3 iud_x4 iud_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on IUD Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

eststo clear

* Injection - all 5 specifications
eststo inj_x1: reghdfe using_injection past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x2: reghdfe using_injection past_group TC_noborder $x2list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x3: reghdfe using_injection past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x4: reghdfe using_injection past_group TC_noborder $x4list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x5: reghdfe using_injection past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display injection results
esttab inj_x1 inj_x2 inj_x3 inj_x4 inj_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Injection Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Combined Table: All Outcomes with Full Specification (x5)
*---------------------------------------------------------------*

eststo clear

* Run full specification for all outcomes
eststo any: reghdfe using_any_contraceptive past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo modern: reghdfe using_modern past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo traditional: reghdfe using_traditional past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill: reghdfe using_pill past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud: reghdfe using_iud past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo injection: reghdfe using_injection past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display combined table
esttab any modern traditional pill iud injection, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effects on Contraceptive Use - Full Specification") ///
    mtitles("Any" "Modern" "Traditional" "Pill" "IUD" "Injection") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area_unit level" ///
                     "All specifications include full controls (x5list)" ///
                     "Area_unit and birth year fixed effects included")

* Export combined table to LaTeX
esttab any modern traditional pill iud injection using "table_contraceptive_all_outcomes.tex", ///
    replace booktabs ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effects on Contraceptive Use - Full Specification") ///
    mtitles("Any" "Modern" "Traditional" "Pill" "IUD" "Injection") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area\_unit level" ///
                     "All specifications include full controls" ///
                     "Area\_unit and birth year fixed effects included")

*---------------------------------------------------------------*
* Summary statistics for contraceptive outcomes
*---------------------------------------------------------------*

* Overall means
summarize using_any_contraceptive using_modern using_traditional ///
         using_pill using_iud using_injection [aweight=weight]

* By treatment group
bysort TC_noborder: summarize using_any_contraceptive using_modern using_traditional ///
                               using_pill using_iud using_injection [aweight=weight]

* Create summary table
eststo clear
estpost tabstat using_any_contraceptive using_modern using_traditional ///
                using_pill using_iud using_injection [aweight=weight], ///
                by(TC_noborder) statistics(mean sd) columns(statistics)

esttab using "table_contraceptive_summary.tex", replace ///
    cells("mean(fmt(3)) sd(fmt(3))") ///
    title("Summary Statistics: Contraceptive Use by Treatment Group") ///
    nonumber nomtitle noobs booktabs





**** Mechanism: Education
* Original specifications (keep these)
global x1list "Poorest Poorer Middle Richer Respondent_work"
global x3list "Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age"

* Modified specifications (REMOVE education variables)
global x2_noedu "Poorest Poorer Middle Richer Respondent_work Res_age"
global x4_noedu "Poorest Poorer Middle Richer Respondent_work Res_age Birth_order_number Religion"
global x5_noedu "Poorest Poorer Middle Richer Respondent_work Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"




*---------------------------------------------------------------*
* Treatment Effects on Education Outcomes
* Testing Education as a Mechanism for Delayed Teenage Pregnancy
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Step 2: Create education outcome variables
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* CORRECTED Education Variable Construction
*---------------------------------------------------------------*

* Drop old variables
drop has_education completed_primary completed_secondary education_level

*---------------------------------------------------------------*
* Method 1: Strict definition (exclude unknowns)
*---------------------------------------------------------------*

* Any education (excludes unknowns where all three are 0)
gen has_education = (primary_edu == 1 | secondary_edu == 1) ///
    if (no_edu != . & primary_edu != . & secondary_edu != .)
label variable has_education "Has any education (primary or secondary)"

* Completed primary or higher (same as has_education in this coding)
gen completed_primary = (primary_edu == 1 | secondary_edu == 1) ///
    if (no_edu != . & primary_edu != . & secondary_edu != .)
label variable completed_primary "Completed at least primary education"

* Completed secondary
gen completed_secondary = (secondary_edu == 1) ///
    if (no_edu != . & primary_edu != . & secondary_edu != .)
label variable completed_secondary "Completed secondary education"

* Create categorical education level
gen education_level = .
replace education_level = 0 if no_edu == 1
replace education_level = 1 if primary_edu == 1
replace education_level = 2 if secondary_edu == 1
* Leave as missing if all three are 0
label educ_level 0 "No education" 1 "Primary" 2 "Secondary"
label values education_level educ_level


*---------------------------------------------------------------*
* Step 3: Check sample - describe education distribution
*---------------------------------------------------------------*

* Overall education distribution
tab education_level, missing
tab education_level Sample_year, col

* By treatment group
tab education_level TC_noborder, col missing
tab education_level past_group, col missing

* Summary statistics
summarize has_education completed_primary completed_secondary [aweight=weight]
bysort TC_noborder: summarize has_education completed_primary completed_secondary [aweight=weight]
bysort past_group: summarize has_education completed_primary completed_secondary [aweight=weight]









*---------------------------------------------------------------*
* Step 4: Sample selection decision
*---------------------------------------------------------------*

* OPTION A: Restrict to teenagers/young women (RECOMMENDED)
* This tests: Did treatment improve education among all teenagers?

* Create age restriction (adjust based on your research design)
* Option A1: Current teenagers (15-19)
gen is_teenager_now = (Res_age >= 15 & Res_age <= 19)

* Option A2: Was teenager during treatment period
* (You'll need to define this based on your treatment timing)
* gen was_teenager_treatment = (age at treatment was 15-19)

* OPTION B: Use same sample as teenage pregnancy analysis
* This tests: Among women who had teen births, did treated women have more education?
* (No additional sample restriction needed)

*---------------------------------------------------------------*
* RECOMMENDED: Run analyses on TEENAGE sample
*---------------------------------------------------------------*

* For this example, I'll use Option A1 (current teenagers)
* Adjust as needed for your specific design

preserve
keep if is_teenager_now == 1

display "Sample size for teenage education analysis: " _N

*---------------------------------------------------------------*
* Panel A: Has Any Education (vs No Education)
*---------------------------------------------------------------*

eststo clear

* Specification 1: Wealth + Respondent work
eststo edu_any_x1: reghdfe has_education ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2: Add age (NO education controls)
eststo edu_any_x2: reghdfe has_education ///
    past_group TC_noborder $x2_noedu ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3: Add husband characteristics
eststo edu_any_x3: reghdfe has_education ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4: Add birth order + religion (NO education)
eststo edu_any_x4: reghdfe has_education ///
    past_group TC_noborder $x4_noedu ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5: Full specification (NO education)
eststo edu_any_x5: reghdfe has_education ///
    past_group TC_noborder $x5_noedu ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results
esttab edu_any_x1 edu_any_x2 edu_any_x3 edu_any_x4 edu_any_x5, ///
    keep(past_group) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Having Any Education (Among Teenagers)") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Treatment effect = coefficient on past_group" ///
                     "Education controls excluded (testing education as outcome)" ///
                     "Sample restricted to teenagers (age 15-19)")

*---------------------------------------------------------------*
* Panel B: Completed Primary or Higher
*---------------------------------------------------------------*

eststo clear

eststo edu_prim_x1: reghdfe completed_primary past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_prim_x2: reghdfe completed_primary past_group TC_noborder $x2_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_prim_x3: reghdfe completed_primary past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_prim_x4: reghdfe completed_primary past_group TC_noborder $x4_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_prim_x5: reghdfe completed_primary past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab edu_prim_x1 edu_prim_x2 edu_prim_x3 edu_prim_x4 edu_prim_x5, ///
    keep(past_group) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Completing Primary Education") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Panel C: Completed Secondary or Higher
*---------------------------------------------------------------*

eststo clear

eststo edu_sec_x1: reghdfe completed_secondary past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_sec_x2: reghdfe completed_secondary past_group TC_noborder $x2_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_sec_x3: reghdfe completed_secondary past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_sec_x4: reghdfe completed_secondary past_group TC_noborder $x4_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo edu_sec_x5: reghdfe completed_secondary past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab edu_sec_x1 edu_sec_x2 edu_sec_x3 edu_sec_x4 edu_sec_x5, ///
    keep(past_group) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Completing Secondary Education") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

restore

*---------------------------------------------------------------*
* Combined Table: All Education Outcomes (Full Specification)
*---------------------------------------------------------------*

preserve
keep if is_teenager_now == 1

eststo clear

eststo any_edu: reghdfe has_education past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo prim_edu: reghdfe completed_primary past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo sec_edu: reghdfe completed_secondary past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display combined results
esttab any_edu prim_edu sec_edu, ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effects on Education Outcomes - Teenagers") ///
    mtitles("Any Education" "Primary+" "Secondary+") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area_unit level" ///
                     "Full specification excluding education controls" ///
                     "Sample: Teenagers aged 15-19")


restore

*---------------------------------------------------------------*
* ALTERNATIVE: Test on same sample as teenage pregnancy analysis
*---------------------------------------------------------------*

* If you want to test education among women who had teenage births:

preserve
* Apply whatever sample restrictions you used for teen pregnancy analysis
* keep if [your teenage pregnancy sample criteria]

eststo clear

eststo teen_birth_any: reghdfe has_education past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo teen_birth_prim: reghdfe completed_primary past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo teen_birth_sec: reghdfe completed_secondary past_group TC_noborder $x5_noedu [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab teen_birth_any teen_birth_prim teen_birth_sec, ///
    keep(past_group) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effects on Education - Among Women with Teenage Births") ///
    mtitles("Any Education" "Primary+" "Secondary+") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

restore

*---------------------------------------------------------------*
* Calculate control means for interpretation
*---------------------------------------------------------------*

preserve
keep if is_teenager_now == 1

* Control group means
summarize has_education if past_group==0 [aweight=weight]
local any_mean = r(mean)

summarize completed_primary if past_group==0 [aweight=weight]
local prim_mean = r(mean)

summarize completed_secondary if past_group==0 [aweight=weight]
local sec_mean = r(mean)

display "Control Group Means (Teenagers):"
display "  Any education: " %5.3f `any_mean'
display "  Primary+: " %5.3f `prim_mean'
display "  Secondary+: " %5.3f `sec_mean'

restore

*---------------------------------------------------------------*
* Interpretation framework
*---------------------------------------------------------------*

display ""
display "MECHANISM TEST INTERPRETATION:"
display "================================"
display ""
display "If past_group coefficient is:"
display "  - POSITIVE and SIGNIFICANT → Treatment increased education"
display "  - This supports education as mechanism for delayed teen pregnancy"
display ""
display "Expected pattern if education is the mechanism:"
display "  1. Treatment ↑ education (positive past_group coefficient here)"
display "  2. Treatment ↓ teen pregnancy (your previous result)"
display "  3. Higher education → lower teen pregnancy (mediation)"
display ""
display "Compare effect sizes:"
display "  - Check if education effects are large enough to explain"
display "    the teen pregnancy reduction"







save "Combined_DHS_2005_2008_2014_extended", replace
















