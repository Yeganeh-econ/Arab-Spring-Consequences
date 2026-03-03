cap which reghdfe
if _rc ssc install reghdfe, replace

cap which outreg2
if _rc ssc install outreg2, replace

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
* Analysis: Treatment Effect on Intention to Circumcise Daughter
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Step 1: Explore the variable and missingness
*---------------------------------------------------------------*

display "========================================================="
display "Data Exploration: intend_circum_daughter"
display "========================================================="

* Check variable type and values
describe intend_circum_daughter
codebook intend_circum_daughter, compact

* Count missing values
count if missing(intend_circum_daughter)
scalar miss_count = r(N)
count
scalar total_count = r(N)
scalar miss_pct = (miss_count / total_count) * 100

display " "
display "Missing values: " miss_count " out of " total_count " (" %4.2f miss_pct "%)"

* Frequency distribution
display " "
display "Value distribution (including missing):"
tabulate intend_circum_daughter, missing

* Check if it's binary
display " "
display "Unique values (non-missing):"
tabulate intend_circum_daughter

* Summary statistics
summarize intend_circum_daughter, detail

* Cross-tab with treatment
display " "
display "Distribution by treatment group:"
tabulate past_group intend_circum_daughter, row missing

*---------------------------------------------------------------*
* Step 2: Check missingness patterns
*---------------------------------------------------------------*

display " "
display "========================================================="
display "Missingness Analysis"
display "========================================================="

* Create missing indicator
gen miss_circum = missing(intend_circum_daughter)
label variable miss_circum "Missing circumcision intention"

* Check if missingness is related to treatment
tabulate past_group miss_circum, row chi2
tabulate TC_noborder miss_circum, row chi2

* Check if missingness is related to key covariates
display " "
display "Missingness by key variables:"
tabulate Poorest miss_circum, row
tabulate no_edu miss_circum, row
tabulate Respondent_work miss_circum, row

* Summary by missingness status
bysort miss_circum: summarize past_group TC_noborder Res_age [aweight=weight]	
	
	
	
	
	
*---------------------------------------------------------------*
* Cross-tabulation: Treatment x Circumcision Intention
* Original coding: 0=No, 1=Yes, 8=Unsure
*---------------------------------------------------------------*

display "========================================================="
display "Circumcision Intention by Treatment Group"
display "========================================================="

* Simple cross-tabulation with row percentages
tabulate past_group intend_circum_daughter if !missing(intend_circum_daughter) ///
    [aweight=weight], row

display " "
display "Note: Row percentages show the distribution within each treatment group"
display "      0 = No, 1 = Yes, 8 = Unsure"
display "========================================================="
	
	
	
gen oppose_circum_ordered = .
replace oppose_circum_ordered = 1 if intend_circum_daughter == 0  // No → 2
replace oppose_circum_ordered = 1 if intend_circum_daughter == 8  // Unsure → 1
replace oppose_circum_ordered = 0 if intend_circum_daughter == 1  // Yes → 0

label variable oppose_circum_ordered "Opposition to circumcision (0=Yes, 1=Unsure, 2=No)"
label define oppose_ord 0 "Supports" 1 "Unsure" 2 "Opposes"
label values oppose_circum_ordered oppose_ord

* Expected result: Positive treatment effect
* Interpretation: Treatment increases opposition level	
	
	
	
	
* Verify the recoding
display " "
display "Original variable distribution:"
tabulate intend_circum_daughter, missing

display " "
display "New ordered variable distribution:"
tabulate oppose_circum_ordered, missing

display " "
display "Cross-check:"
tabulate intend_circum_daughter oppose_circum_ordered, missing

*---------------------------------------------------------------*
* Step 2: Descriptive statistics by treatment
*---------------------------------------------------------------*

display " "
display "========================================================="
display "Opposition Level by Treatment Group"
display "========================================================="

* Mean opposition level
table past_group [aweight=weight], ///
    statistic(mean oppose_circum_ordered) ///
    statistic(sd oppose_circum_ordered) ///
    statistic(count oppose_circum_ordered)

* Distribution across categories
tabulate past_group oppose_circum_ordered [aweight=weight], row







*---------------------------------------------------------------*
* Panel A: Opposition to Circumcision - ALL WOMEN
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Define Control Variable Specifications for Circumcision
*---------------------------------------------------------------*

global x1_circum 
global x2_circum "Poorest Poorer Middle Richer no_edu primary_edu secondary_edu Res_age resp_circumcised"
global x3_circum "Poorest Poorer Middle Richer Husband_work Husband_no_education Husband_primary Husband_secondary"
global x4_circum "Poorest Poorer Middle Richer no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"
global x5_circum "Poorest Poorer Middle Richer no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Birth_order_number Religion resp_circumcised Urban_rural Respondent_work"

*---------------------------------------------------------------*
* Panel A: Opposition to Circumcision - ALL WOMEN
*---------------------------------------------------------------*

eststo clear

display "Panel A: Opposition to Circumcision (0=Yes, 1=Unsure, 1=No) - ALL WOMEN"
display "=========================================================================="

eststo circum_all_x1: reghdfe oppose_circum_ordered ///
    past_group TC_noborder $x1_circum ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo circum_all_x2: reghdfe oppose_circum_ordered ///
    past_group TC_noborder $x2_circum ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo circum_all_x3: reghdfe oppose_circum_ordered ///
    past_group TC_noborder $x3_circum ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo circum_all_x4: reghdfe oppose_circum_ordered ///
    past_group TC_noborder $x4_circum ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo circum_all_x5: reghdfe oppose_circum_ordered ///
    past_group TC_noborder $x5_circum ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab circum_all_x1 circum_all_x2 circum_all_x3 circum_all_x4 circum_all_x5, ///
    keep(past_group) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Opposition to Circumcision - ALL WOMEN") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

* Export Panel A to Excel
esttab circum_all_x1 circum_all_x2 circum_all_x3 circum_all_x4 circum_all_x5 ///
    using "C:/Users/yegan/OneDrive - University of Oklahoma/Desktop/Egypt/Res/AllWomen_Circumcision_intention_detailed_detailed.csv", ///
    replace ///
    cells(b(fmt(4) star) se(fmt(4) par) p(fmt(4)) t(fmt(4))) ///
    stats(N r2 r2_a, fmt(0 4 4) labels("Observations" "R-squared" "Adjusted R-squared")) ///
    title("Panel A: Treatment Effect on Opposition to Circumcision - ALL WOMEN") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    nonotes addnote("Cells: Coefficient (starred) | SE (parentheses) | p-value | t-statistic" ///
                    "*** p<0.01, ** p<0.05, * p<0.10" ///
                    "Outcome: 0=Supports circumcision, 1=Unsure, 2=Opposes circumcision" ///
                    "Sample: ALL WOMEN")

