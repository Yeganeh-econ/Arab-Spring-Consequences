
*---------------------------------------------------------------*
* 0. Install needed packages (run once)
*---------------------------------------------------------------*
cap which reghdfe
if _rc ssc install reghdfe, replace

cap which outreg2
if _rc ssc install outreg2, replace

*---------------------------------------------------------------*
* 0. Define CD and import the data
*---------------------------------------------------------------*

clear

cd "/Users/paghosh/Dropbox/D/Study/My_Papers/OU/Development/Political Participation and children health/arab_spring_women_outcomes_programs_stata/data/model_data"

* Define the pathe of the results folder

local result_path "/Users/paghosh/Dropbox/D/Study/My_Papers/OU/Development/Political Participation and children health/arab_spring_women_outcomes_programs_stata/programs/stata/Pallab/Dec_2025/Results"

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
		
		
// * Check Stata version (useful for troubleshooting)
// display "Stata version: " c(stata_version)
//
// * Remove potentially broken / mismatched installs
// cap ado uninstall reghdfe
// cap ado uninstall ftools
// cap ado uninstall ivreghdfe
//
// * Reinstall dependencies first, then reghdfe
// ssc install ftools, replace
// ssc install reghdfe, replace
//
// * Refresh Mata libraries (good practice after updates)
// mata: mata mlib index
//		
	
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

	
*---------------------------------------------------------------*
* 2. Export results to Excel
*---------------------------------------------------------------*

* Display regression results on screen

esttab, se ar2

* 3. Export regression table to CSV (Excel-readable)

esttab est1 est2 est3 est4 est5 using "`result_path'/teen_preg_reg_results_Jan7.csv", ///
    label ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ar2 ///
    b(3) ///
    replace
	
eststo clear		

cd "/Users/paghosh/Dropbox/D/Study/My_Papers/OU/Development/Political Participation and children health/arab_spring_women_outcomes_programs_stata/programs/stata/Pallab/Jan_2026/results"


esttab using teen_preg_reg_results_Jan7.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace



		
		
*---------------------------------------------------------------*
* 1. Fixed-effects logit model (binary outcome)
*---------------------------------------------------------------*
* teen_preg is 0/1
* FE: Area_unit and first_child_birth_year
* pweights and clustered SE at Area_unit level

eststo clear

eststo logit_fe: ///
    logit teen_preg ///
        past_group TC_noborder $x5list ///
        i.Area_unit i.Res_BY ///
        [pweight = weight], ///
        vce(cluster Area_unit)

*---------------------------------------------------------------*
* 2. Average marginal effects from the logit model
*---------------------------------------------------------------*
* Report marginal effects for treatment variables (and optionally controls)

eststo logit_mfx: ///
    margins, dydx(past_group TC_noborder $x5list) post

* Now `logit_mfx` contains dy/dx, SE, z, p-values, etc.

*---------------------------------------------------------------*
* 3. (Optional) Export marginal effects to a table
*---------------------------------------------------------------*
* Example with esttab -> CSV (Excel-readable)

esttab logit_mfx using "teen_preg_logit_mfx.csv", ///
    replace ///
    title("Teen Pregnancy – Logit Marginal Effects") ///
    cells("dy/dx se p") ///
    b(3) se(3)		
		
		
		
*---------------------------------------------------------------*
* 1.2. Related Outcome Variable: Age of First birth
*---------------------------------------------------------------*	
		
*---------------------------------------------------------------*
* 1.2.A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe Fir_bir_age ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	
*---------------------------------------------------------------*
* 1.2.B. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe Fir_bir_age ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
*---------------------------------------------------------------*
* 1.2.C. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe Fir_bir_age ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	

*---------------------------------------------------------------*
* 1.2.D. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe Fir_bir_age ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

*---------------------------------------------------------------*
* 1.2.E. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*



eststo: reghdfe Fir_bir_age ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)		
		
esttab using Age_of_firsbirth_results_all.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace	
	
eststo clear		
		
		
		
*---------------------------------------------------------------*
* 3. Exploring Mechanism
*---------------------------------------------------------------*		
		
// cd "/Users/paghosh/Dropbox/D/Study/My_Papers/OU/Development/Political Participation and children health/arab_spring_women_outcomes_programs_stata/programs/stata/Pallab/Jan_2026/results"
		
*---------------------------------------------------------------*
* 3.1 Mechanism: Age of First Marriage
*---------------------------------------------------------------*


*---------------------------------------------------------------*
* 3.1.A. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	
*---------------------------------------------------------------*
* 3.1.B. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
*---------------------------------------------------------------*
* 3.1.C. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	

*---------------------------------------------------------------*
* 3.1.D. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*

eststo: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

*---------------------------------------------------------------*
* 3.1.E. Teen pregnancy regression with absorbed fixed effects
*---------------------------------------------------------------*
	
		
eststo: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

// esttab, se ar2

esttab using "`result_path'/Age_of_firstmarriage_results_Dec19.csv", ///
    label ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ar2 ///
    b(3) ///
    replace
	
esttab using Age_of_firstmarriage_results_all.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace	
	
eststo clear	



*---------------------------------------------------------------*
* 3.2 Mechanism: Years of Schooling
*---------------------------------------------------------------*	


global x6list "Respondent_work Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"	
		
eststo: reghdfe no_edu ///
    past_group TC_noborder $x6list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	eststo: reghdfe primary_edu ///
    past_group TC_noborder $x6list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	eststo: reghdfe secondary_edu ///
    past_group TC_noborder $x6list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	eststo: reghdfe postsecondaty_edu ///
    past_group TC_noborder $x6list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)	
	

	

// esttab, se ar2

esttab using "`result_path'/teen_preg_regression_results_Dec19.csv", ///
    label ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    se ar2 ///
    b(3) ///
    replace
	
	
esttab using Schooling_results_all.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace		
	
eststo clear	



*---------------------------------------------------------------*
* 3.2 Mechanism: Lower Unskilled Manual Job
*---------------------------------------------------------------*	

// global x6list "Respondent_work Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"	

use "Combined_DHS_2005_2008_2014.dta", clear

// keep if Res_age < 20

gen unskill_manual = 0
replace unskill_manual = 1 if UnskilledManual > 1

gen skill_manual = 0
replace skill_manual = 1 if SkilledManual > 1


gen agr_self_employed = 0
replace agr_self_employed = 1 if AgricselfEmployed > 1

gen agr_employed = 0
replace agr_employed = 1 if AgricEmployee > 1

gen service_sector = 0
replace service_sector = 1 if Services > 1

		
eststo: reghdfe unskill_manual ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
eststo: reghdfe skill_manual ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)	
	
eststo: reghdfe agr_self_employed ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)		
	
// eststo: reghdfe agr_employed ///
//     past_group TC_noborder $x5list ///
//     [pweight = weight], ///
//     absorb(Area_unit Res_BY) ///
//     vce(cluster Area_unit)
//	
//	
// eststo: reghdfe service_sector ///
//     past_group TC_noborder $x5list ///
//     [pweight = weight], ///
//     absorb(Area_unit Res_BY) ///
//     vce(cluster Area_unit)		
	

cd "/Users/paghosh/Dropbox/D/Study/My_Papers/OU/Development/Political Participation and children health/arab_spring_women_outcomes_programs_stata/programs/stata/Pallab/Jan_2026/results"

	
esttab using Occupation_results_all.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace		
	
eststo clear


*---------------------------------------------------------------*
* 3.2 Mechanism: Lower Miscarriage Rate
*---------------------------------------------------------------*	


global x6list "Respondent_work Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"	
		
eststo: reghdfe Terminated_birth ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)
	
	
	
esttab using Miscarriage_prob_results_all.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace		
	



*---------------------------------------------------------------*
* 3.2 Mechanism: Lower Miscarriage Rate
*---------------------------------------------------------------*	


global x7list "Respondent_work no_edu primary_edu secondary_edu Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"	
		
eststo: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

eststo clear	
	
esttab using Miscarriage Rate_results_teen.csv, label star(* 0.10 ** 0.05 *** 0.01) se ar2 b(3) replace	





	
		
		
		
gen teen_preg = 0
replace teen_preg = 1 if Fir_bir_age < 20

reg teen_preg past_group TC_noborder i.Area_unit i.Sample_year $xlist [pweight=weight], cluster(Area_unit)


reg teen_preg past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)

reg Fir_bir_age past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)


reg AgeofFirstMarriage past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)

reg Mon_breastfeeding past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)



reg Preceding_birth_interval_months past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)

reg Terminated_birth past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)


reg Primary past_group TC_noborder i.Governates i.Sample_year [pweight=weight], cluster(Governates)

reg Secondary past_group TC_noborder i.Governates i.Sample_year [pweight=weight], cluster(Governates)

reg WomenSecondarySchoolRate past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)


reg Edu_yrs past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)



reg Bir_size past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)

reg Bir_weight past_group TC_noborder i.Governates i.Sample_year $xlist [pweight=weight], cluster(Governates)
