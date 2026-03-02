**********
****************
********************
***** Age Gap in Extended Dataset

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


*** For all women
* Overall means
display "========================================================="
display "Mean Age at Marriage - All Sample"
display "========================================================="

* Mean age for wives (all women)
summarize AgeofFirstMarriage [aweight=weight], detail
scalar mean_wife_all = r(mean)
scalar sd_wife_all = r(sd)
scalar N_wife_all = r(N)

display "Mean age at marriage for WOMEN (all): " mean_wife_all
display "SD: " sd_wife_all
display "N: " N_wife_all

* Mean age for husbands (all men)
summarize husband_age_marriage if !missing(husband_age_marriage) [aweight=weight], detail
scalar mean_husb_all = r(mean)
scalar sd_husb_all = r(sd)
scalar N_husb_all = r(N)

display "Mean age at marriage for MEN (all): " mean_husb_all
display "SD: " sd_husb_all
display "N: " N_husb_all

* Mean age gap
summarize age_gap if !missing(age_gap) [aweight=weight], detail
scalar mean_gap_all = r(mean)
scalar sd_gap_all = r(sd)

display "Mean age gap (husband - wife): " mean_gap_all
display "SD: " sd_gap_all



*---------------------------------------------------------------*
* Mean Age at Marriage - Teen Wives and Their Husbands
*---------------------------------------------------------------*

display "========================================================="
display "Mean Age at Marriage - Teen Wives (teen_wife=1) and Their Husbands"
display "========================================================="

* Mean age for teen wives
summarize AgeofFirstMarriage if teen_wife==1 [aweight=weight], detail
scalar mean_wife_teen = r(mean)
scalar sd_wife_teen = r(sd)
scalar N_wife_teen = r(N)

display "Mean age at marriage for TEEN WIVES: " mean_wife_teen
display "SD: " sd_wife_teen
display "N: " N_wife_teen

* Mean age for husbands of teen wives
summarize husband_age_marriage if teen_wife==1 & !missing(husband_age_marriage) [aweight=weight], detail
scalar mean_husb_teen = r(mean)
scalar sd_husb_teen = r(sd)
scalar N_husb_teen = r(N)

display "Mean age at marriage for HUSBANDS of teen wives: " mean_husb_teen
display "SD: " sd_husb_teen
display "N: " N_husb_teen

* Mean age gap for teen wife couples
summarize age_gap if teen_wife==1 & !missing(age_gap) [aweight=weight], detail
scalar mean_gap_teen = r(mean)
scalar sd_gap_teen = r(sd)

display "Mean age gap (husband - wife) for teen marriages: " mean_gap_teen
display "SD: " sd_gap_teen






*---------------------------------------------------------------*
* Step 2: Check the construction makes sense
*---------------------------------------------------------------*
* Summary statistics
summarize AgeofFirstMarriage husband_age_marriage age_gap, detail

* Verify the relationship
* age_gap should equal husband_age_marriage - wife_age_marriage
gen check_gap = husband_age_marriage - AgeofFirstMarriage
* compare age_gap check_gap
* Should be identical
drop check_gap

* Distribution by treatment
bysort past_group: summarize AgeofFirstMarriage husband_age_marriage age_gap ///
    [aweight=weight]

*---------------------------------------------------------------*
* Step 3: Run regressions for WIFE's age at marriage
*---------------------------------------------------------------*
eststo clear
display "Panel A: Wife's Age at Marriage (AgeofFirstMarriage) - All Women"
display "========================================================="

eststo wife_x1: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x1_gap ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x2: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x2_gap ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x3: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x3_gap ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x4: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x4_gap ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo wife_x5: reghdfe AgeofFirstMarriage ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab wife_x1 wife_x2 wife_x3 wife_x4 wife_x5, ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Wife's Age at Marriage - All Women") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Step 4: Run regressions for HUSBAND's age at marriage
*---------------------------------------------------------------*
eststo clear
display "Panel B: Husband's Age at Marriage - All Women"
display "========================================================="

eststo husb_x1: reghdfe husband_age_marriage ///
    past_group TC_noborder $x1_gap ///
    [pweight = weight] if !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x2: reghdfe husband_age_marriage ///
    past_group TC_noborder $x2_gap ///
    [pweight = weight] if !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x3: reghdfe husband_age_marriage ///
    past_group TC_noborder $x3_gap ///
    [pweight = weight] if !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x4: reghdfe husband_age_marriage ///
    past_group TC_noborder $x4_gap ///
    [pweight = weight] if !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

eststo husb_x5: reghdfe husband_age_marriage ///
    past_group TC_noborder $x5_gap ///
    [pweight = weight] if !missing(husband_age_marriage), ///
    absorb(Area_unit Res_BY) vce(cluster Area_unit)

esttab husb_x1 husb_x2 husb_x3 husb_x4 husb_x5, ///
    keep(past_group TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Husband's Age at Marriage - All Women") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))



* Check for Negative Age Gaps Among Teen Wives
*---------------------------------------------------------------*

* Count observations with negative age gap for teen wives
count if age_gap < 0 & teen_wife == 1 & !missing(age_gap)
scalar neg_gap_teen = r(N)


* Show distribution of negative age gaps
display "Distribution of NEGATIVE age gaps among teen wives:"
display "========================================================="
summarize age_gap if age_gap < 0 & teen_wife == 1, detail







*---------------------------------------------------------------*
* Analyze Husbands in Negative Age Gap Teen Marriages
*---------------------------------------------------------------*

* First, let's see the data
display "========================================================="
display "Teen Wives with NEGATIVE Age Gaps (Wife Older than Husband)"
display "========================================================="

* List some examples
list AgeofFirstMarriage husband_age_marriage age_gap Res_BY ///
    if age_gap < 0 & teen_wife == 1 & !missing(age_gap) ///
    in 1/20, clean

* Summary statistics for husbands in these marriages
display " "
display "Summary Statistics: Husbands' Age at Marriage (negative age gap cases)"
summarize husband_age_marriage if age_gap < 0 & teen_wife == 1, detail

display " "
display "Summary Statistics: Birth Year (Res_BY) for these cases"
summarize Res_BY if age_gap < 0 & teen_wife == 1, detail

*---------------------------------------------------------------*
* Create dataset for export
*---------------------------------------------------------------*

* Preserve the original data
preserve

* Keep only negative age gap teen wife cases
keep if age_gap < 0 & teen_wife == 1 & !missing(age_gap)

* Keep relevant variables
keep AgeofFirstMarriage husband_age_marriage age_gap Res_BY ///
    Area_unit past_group TC_noborder weight ///
    Poorest Poorer Middle Richer ///
    no_edu primary_edu secondary_edu postsecondary_edu

* Generate additional useful variables
gen wife_age = AgeofFirstMarriage
gen husband_age = husband_age_marriage
gen wife_older_by = abs(age_gap)

* Label variables clearly
label variable wife_age "Wife's Age at Marriage"
label variable husband_age "Husband's Age at Marriage"
label variable wife_older_by "Years Wife is Older"
label variable Res_BY "Birth Year"
label variable age_gap "Age Gap (Husband - Wife)"

* Sort by how much older the wife is
gsort -wife_older_by

* Export to Excel - Individual observations
export excel using "negative_agegap_teen_marriages.xlsx", ///
    sheet("Individual Cases") firstrow(varlabels) replace

display " "
display "========================================================="
display "Exported individual cases to: negative_agegap_teen_marriages.xlsx"
display "Sheet name: Individual Cases"
display "========================================================="

* Restore original data
restore

*---------------------------------------------------------------*
* Create Summary Tables for Excel
*---------------------------------------------------------------*

* Summary statistics by birth year
preserve
keep if age_gap < 0 & teen_wife == 1 & !missing(age_gap)

collapse (count) n_cases=age_gap ///
         (mean) mean_wife_age=AgeofFirstMarriage ///
                mean_husband_age=husband_age_marriage ///
                mean_age_gap=age_gap ///
         (sd) sd_wife_age=AgeofFirstMarriage ///
              sd_husband_age=husband_age_marriage ///
         (min) min_wife_age=AgeofFirstMarriage ///
               min_husband_age=husband_age_marriage ///
         (max) max_wife_age=AgeofFirstMarriage ///
               max_husband_age=husband_age_marriage, ///
         by(Res_BY)

* Label variables
label variable n_cases "Number of Cases"
label variable mean_wife_age "Mean Wife Age"
label variable mean_husband_age "Mean Husband Age"
label variable mean_age_gap "Mean Age Gap"

* Export summary by birth year
export excel using "negative_agegap_teen_marriages.xlsx", ///
    sheet("Summary by Birth Year") firstrow(varlabels) sheetmodify

display "Added sheet: Summary by Birth Year"

restore

*---------------------------------------------------------------*
* Frequency distribution of husband's age
*---------------------------------------------------------------*

preserve
keep if age_gap < 0 & teen_wife == 1 & !missing(age_gap)

* Create frequency table of husband's age
contract husband_age_marriage, freq(frequency)
rename husband_age_marriage Husband_Age
sort Husband_Age

* Calculate percentage
egen total = sum(frequency)
gen percentage = (frequency / total) * 100
drop total

label variable Husband_Age "Husband's Age at Marriage"
label variable frequency "Frequency"
label variable percentage "Percentage"

* Export frequency distribution
export excel using "negative_agegap_teen_marriages.xlsx", ///
    sheet("Husband Age Distribution") firstrow(varlabels) sheetmodify

display "Added sheet: Husband Age Distribution"

restore

*---------------------------------------------------------------*
* Summary statistics table
*---------------------------------------------------------------*

preserve

* Create a summary statistics matrix
matrix summary = J(8, 3, .)

* Calculate statistics for teen wives with negative age gap
quietly {
    sum AgeofFirstMarriage if age_gap < 0 & teen_wife == 1
    matrix summary[1,1] = r(mean)
    matrix summary[2,1] = r(sd)
    matrix summary[3,1] = r(min)
    matrix summary[4,1] = r(max)
    
    sum husband_age_marriage if age_gap < 0 & teen_wife == 1
    matrix summary[1,2] = r(mean)
    matrix summary[2,2] = r(sd)
    matrix summary[3,2] = r(min)
    matrix summary[4,2] = r(max)
    
    sum age_gap if age_gap < 0 & teen_wife == 1
    matrix summary[1,3] = r(mean)
    matrix summary[2,3] = r(sd)
    matrix summary[3,3] = r(min)
    matrix summary[4,3] = r(max)
    
    count if age_gap < 0 & teen_wife == 1 & !missing(age_gap)
    matrix summary[5,1] = r(N)
    matrix summary[5,2] = r(N)
    matrix summary[5,3] = r(N)
    
    count if teen_wife == 1 & !missing(age_gap)
    matrix summary[6,1] = r(N)
    
    scalar pct = (summary[5,1] / summary[6,1]) * 100
    matrix summary[7,1] = pct
}

* Convert matrix to dataset
clear
svmat summary
gen row = _n
gen label = ""
replace label = "Mean" if row == 1
replace label = "SD" if row == 2
replace label = "Min" if row == 3
replace label = "Max" if row == 4
replace label = "N (negative gap)" if row == 5
replace label = "N (all teen wives)" if row == 6
replace label = "% with negative gap" if row == 7

order label
rename summary1 Wife_Age
rename summary2 Husband_Age
rename summary3 Age_Gap

* Export overall summary
export excel using "negative_agegap_teen_marriages.xlsx", ///
    sheet("Overall Summary") firstrow(variables) sheetmodify

display "Added sheet: Overall Summary"
display "========================================================="
display "All sheets exported successfully!"
display "File: negative_agegap_teen_marriages.xlsx"
display "========================================================="

restore

*---------------------------------------------------------------*
* Display key findings
*---------------------------------------------------------------*

quietly {
    count if age_gap < 0 & teen_wife == 1 & !missing(age_gap)
    scalar neg_count = r(N)
    
    sum husband_age_marriage if age_gap < 0 & teen_wife == 1
    scalar mean_husb = r(mean)
    scalar min_husb = r(min)
    scalar max_husb = r(max)
    
    sum age_gap if age_gap < 0 & teen_wife == 1
    scalar mean_gap = r(mean)
}

display " "
display "KEY FINDINGS:"
display "========================================================="
display "Total teen wives with negative age gap: " neg_count
display "Mean husband age in these marriages: " %4.2f mean_husb " years"
display "Range of husband ages: " min_husb " to " max_husb " years"
display "Mean age gap: " %4.2f mean_gap " (wife older by " %4.2f abs(mean_gap) " years)"
display "========================================================="












*---------------------------------------------------------------*
* Step 2: Check the construction makes sense
*---------------------------------------------------------------*

* Summary statistics
summarize AgeofFirstMarriage husband_age_marriage age_gap if teen_wife==1, detail

* Verify the relationship
* age_gap should equal husband_age_marriage - wife_age_marriage
gen check_gap = husband_age_marriage - AgeofFirstMarriage
* compare age_gap check_gap if teen_wife==1
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