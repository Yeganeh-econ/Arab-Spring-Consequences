***   Political Participation and Missing Women: Evidence from the Egyptian Protests of 2011-2014 ***

* Regressions Tables Individuals
******************************************************************************************************

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
gen tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45,46,47,48,49,50)
gen group = tgover_ur_noborder
gen past = (year_indicator >= 2011)

* Recode attitudes toward women:
replace visit_ternary = 1 if visit_ternary == 2 
replace pur_ternary   = 1 if pur_ternary   == 2
replace health_ternary= 1 if health_ternary  == 2

**************************************************************
* Block 1: Tolerance Violation Analysis
**************************************************************
preserve
    * Create indicator for domestic violation (tol_vio_1 equals 1)
    gen tol_vio_flag = (tol_vio_1 == 1)
    
    * Compute overall, treatment, and control group rates by year
    bysort year_indicator: egen tol_vio_rate   = mean(tol_vio_flag)
    bysort year_indicator: egen tol_vio_rate_t = mean(cond(group == 1, tol_vio_flag, .))
    bysort year_indicator: egen tol_vio_rate_c = mean(cond(group == 0, tol_vio_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) tol_vio_rate tol_vio_rate_t tol_vio_rate_c, by(year_indicator)
    
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
    bysort year_indicator: egen health_ternary_rate   = mean(health_flag)
    bysort year_indicator: egen health_ternary_rate_t = mean(cond(group == 1, health_flag, .))
    bysort year_indicator: egen health_ternary_rate_c = mean(cond(group == 0, health_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) health_ternary_rate health_ternary_rate_t health_ternary_rate_c, by(year_indicator)
    
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
    bysort year_indicator: egen pur_ternary_rate   = mean(purchase_flag)
    bysort year_indicator: egen pur_ternary_rate_t = mean(cond(group == 1, purchase_flag, .))
    bysort year_indicator: egen pur_ternary_rate_c = mean(cond(group == 0, purchase_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) pur_ternary_rate pur_ternary_rate_t pur_ternary_rate_c, by(year_indicator)
    
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
    bysort year_indicator: egen vis_ternary_rate   = mean(visit_flag)
    bysort year_indicator: egen vis_ternary_rate_t = mean(cond(group == 1, visit_flag, .))
    bysort year_indicator: egen vis_ternary_rate_c = mean(cond(group == 0, visit_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) vis_ternary_rate vis_ternary_rate_t vis_ternary_rate_c, by(year_indicator)
    
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
    collapse (mean) vac_rate01_fm, by(year)
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
    collapse (mean) vac_rate01_fm, by(tgover_ur year)
    gen summary_type = "Treatment_Control"
    tempfile tc
    save "`tc'", replace
restore

**************************************************
* Combine the Results and Export to Excel
**************************************************
clear
use "`agg'", clear
append using "`tc'"

* Reorder variables for clarity
order summary_type year tgover_ur vac_rate01_fm

* Export the combined dataset to one Excel file (one sheet)
export excel using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Combined_Summary_Vaccination.xlsx", firstrow(variables) replace

exit
