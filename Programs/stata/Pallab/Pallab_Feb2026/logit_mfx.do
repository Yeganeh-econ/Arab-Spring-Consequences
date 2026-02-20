/*==============================================================================
  Logit Model and Marginal Effects for Teen Pregnancy
  Table 5 Part I (Logit Coefficients) & Table 5 Part II (Marginal Effects)

  Matching OLS Table 5 specifications exactly:
  - 5 progressive specifications with reghdfe-equivalent fixed effects
  - pweight = weight, cluster(Area_unit), absorb(Area_unit Res_BY)

  Authors: Karbalaei, Demir, Ghosh
  Date: February 2026
==============================================================================*/

clear all
set more off
set matsize 5000

* Load data
use "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Data/model_data/Combined_DHS_2005_2008_2014.dta", clear

local outpath "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Draft/Draft1/Feb_2026"

*===============================================================================
* Variable construction (matching Pallab's original do-file)
*===============================================================================

* Teen pregnancy indicator
gen teen_preg = 0
replace teen_preg = 1 if Fir_bir_age < 20

* Destring TC_noborder
destring TC_noborder, replace

* Create DiD interaction
gen past_group = Time_dummy * TC_noborder

* Education dummies from Res_edu
gen no_edu = (Res_edu == 0)
gen primary_edu = (Res_edu == 1)
gen secondary_edu = (Res_edu == 2)

*===============================================================================
* Define control variable lists (matching Table 5 exactly)
*===============================================================================

global x1list "Poorest Poorer Middle Richer Respondent_work"
global x2list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age"
global x3list "Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age"
global x4list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"
global x5list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

*===============================================================================
* LOGIT MODELS with Fixed Effects
* Using i.Area_unit i.Res_BY as FE (logit cannot use absorb)
*===============================================================================

* Open output files
tempname fh_logit fh_mfx
file open `fh_logit' using "`outpath'/logit_coefficients.csv", write replace
file open `fh_mfx' using "`outpath'/logit_marginal_effects.csv", write replace

file write `fh_logit' "Variable,Spec1_coef,Spec1_se,Spec2_coef,Spec2_se,Spec3_coef,Spec3_se,Spec4_coef,Spec4_se,Spec5_coef,Spec5_se" _n
file write `fh_mfx' "Variable,Spec1_mfx,Spec1_se,Spec2_mfx,Spec2_se,Spec3_mfx,Spec3_se,Spec4_mfx,Spec4_se,Spec5_mfx,Spec5_se" _n

*-------------------------------------------------------
* Specification 1: Baseline
*-------------------------------------------------------
display "Running Spec 1..."
logit teen_preg past_group TC_noborder $x1list ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit) nolog

* Store logit coefficients
local vars1 "past_group TC_noborder Poorest Poorer Middle Richer Respondent_work"
foreach v of local vars1 {
    local b1_`v' = string(_b[`v'], "%9.3f")
    local se1_`v' = string(_se[`v'], "%9.3f")
}
local n1 = e(N)
local pr2_1 = string(e(r2_p), "%9.3f")

* Marginal effects
margins, dydx(past_group TC_noborder $x1list) post
foreach v of local vars1 {
    local m1_`v' = string(_b[`v'], "%9.3f")
    local mse1_`v' = string(_se[`v'], "%9.3f")
}

*-------------------------------------------------------
* Specification 2: + Respondent education & age
*-------------------------------------------------------
display "Running Spec 2..."
logit teen_preg past_group TC_noborder $x2list ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit) nolog

local vars2 "past_group TC_noborder Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age"
foreach v of local vars2 {
    local b2_`v' = string(_b[`v'], "%9.3f")
    local se2_`v' = string(_se[`v'], "%9.3f")
}
local n2 = e(N)
local pr2_2 = string(e(r2_p), "%9.3f")

margins, dydx(past_group TC_noborder $x2list) post
foreach v of local vars2 {
    local m2_`v' = string(_b[`v'], "%9.3f")
    local mse2_`v' = string(_se[`v'], "%9.3f")
}

*-------------------------------------------------------
* Specification 3: + Husband characteristics
*-------------------------------------------------------
display "Running Spec 3..."
logit teen_preg past_group TC_noborder $x3list ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit) nolog

local vars3 "past_group TC_noborder Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age"
foreach v of local vars3 {
    local b3_`v' = string(_b[`v'], "%9.3f")
    local se3_`v' = string(_se[`v'], "%9.3f")
}
local n3 = e(N)
local pr2_3 = string(e(r2_p), "%9.3f")

margins, dydx(past_group TC_noborder $x3list) post
foreach v of local vars3 {
    local m3_`v' = string(_b[`v'], "%9.3f")
    local mse3_`v' = string(_se[`v'], "%9.3f")
}

*-------------------------------------------------------
* Specification 4: + Birth order & religion
*-------------------------------------------------------
display "Running Spec 4..."
logit teen_preg past_group TC_noborder $x4list ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit) nolog

local vars4 "past_group TC_noborder Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"
foreach v of local vars4 {
    local b4_`v' = string(_b[`v'], "%9.3f")
    local se4_`v' = string(_se[`v'], "%9.3f")
}
local n4 = e(N)
local pr2_4 = string(e(r2_p), "%9.3f")

margins, dydx(past_group TC_noborder $x4list) post
foreach v of local vars4 {
    local m4_`v' = string(_b[`v'], "%9.3f")
    local mse4_`v' = string(_se[`v'], "%9.3f")
}

*-------------------------------------------------------
* Specification 5: Full model
*-------------------------------------------------------
display "Running Spec 5..."
logit teen_preg past_group TC_noborder $x5list ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit) nolog

local vars5 "past_group TC_noborder Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"
foreach v of local vars5 {
    local b5_`v' = string(_b[`v'], "%9.3f")
    local se5_`v' = string(_se[`v'], "%9.3f")
}
local n5 = e(N)
local pr2_5 = string(e(r2_p), "%9.3f")

margins, dydx(past_group TC_noborder $x5list) post
foreach v of local vars5 {
    local m5_`v' = string(_b[`v'], "%9.3f")
    local mse5_`v' = string(_se[`v'], "%9.3f")
}

*===============================================================================
* Write all results to CSV files
*===============================================================================

* All variables in order
local allvars "past_group TC_noborder Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

foreach v of local allvars {
    * Initialize empty values for specs where variable is not included
    forvalues s = 1/5 {
        capture local test = "`b`s'_`v''"
        if _rc != 0 | "`b`s'_`v''" == "" {
            local b`s'_`v' ""
            local se`s'_`v' ""
            local m`s'_`v' ""
            local mse`s'_`v' ""
        }
    }

    file write `fh_logit' "`v',`b1_`v'',`se1_`v'',`b2_`v'',`se2_`v'',`b3_`v'',`se3_`v'',`b4_`v'',`se4_`v'',`b5_`v'',`se5_`v''" _n
    file write `fh_mfx' "`v',`m1_`v'',`mse1_`v'',`m2_`v'',`mse2_`v'',`m3_`v'',`mse3_`v'',`m4_`v'',`mse4_`v'',`m5_`v'',`mse5_`v''" _n
}

* Add model fit rows
file write `fh_logit' "Observations,`n1',,`n2',,`n3',,`n4',,`n5'," _n
file write `fh_logit' "Pseudo_R2,`pr2_1',,`pr2_2',,`pr2_3',,`pr2_4',,`pr2_5'," _n

file write `fh_mfx' "Observations,`n1',,`n2',,`n3',,`n4',,`n5'," _n
file write `fh_mfx' "Pseudo_R2,`pr2_1',,`pr2_2',,`pr2_3',,`pr2_4',,`pr2_5'," _n

file close `fh_logit'
file close `fh_mfx'

display ""
display "============================================"
display "Logit coefficients saved to: logit_coefficients.csv"
display "Marginal effects saved to:  logit_marginal_effects.csv"
display "============================================"
