/*==============================================================================
  Additional Mechanism Analysis for Teen Pregnancy

  Three new mechanisms:
  1. Spousal Age Gap (Husband_age - Res_age)
  2. Husband's Education (Partner Selection)
  3. Women's Labor Force Participation (Respondent_work)

  Using same specification as main model (Spec 5 equivalent with reghdfe)
  Authors: Karbalaei, Demir, Ghosh
  Date: February 2026
==============================================================================*/

clear all
set more off
set matsize 10000

* Load data
use "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Data/model_data/Combined_DHS_2005_2008_2014.dta", clear

local outpath "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Draft/Draft1/Feb_2026"

*===============================================================================
* Variable construction (matching main do-file)
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

* NEW: Spousal age gap
gen age_gap = Husband_age - Res_age
label variable age_gap "Spousal age gap (husband - respondent)"

*===============================================================================
* Full control list (matching Spec 5)
*===============================================================================

global fullcontrols "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

* For husband education outcomes, exclude husband education from controls
global controls_no_husbedu "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_age Birth_order_number Religion"

* For respondent work outcome, exclude respondent work from controls
global controls_no_reswork "Poorest Poorer Middle Richer no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

* For age gap outcome, exclude both individual ages (they mechanically determine the gap)
global controls_no_ages "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Husband_work Husband_no_education Husband_primary Husband_secondary Birth_order_number Religion"

*===============================================================================
* MECHANISM 1: Spousal Age Gap
*===============================================================================

display ""
display "============================================"
display "MECHANISM 1: Spousal Age Gap"
display "============================================"

* Summary stats for age gap
summarize age_gap, detail

* Regression: age gap as outcome
reg age_gap past_group TC_noborder $controls_no_ages ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit)

* Store results
local m1_b_pg = string(_b[past_group], "%9.3f")
local m1_se_pg = string(_se[past_group], "%9.3f")
local m1_b_tc = string(_b[TC_noborder], "%9.3f")
local m1_se_tc = string(_se[TC_noborder], "%9.3f")
local m1_b_poorest = string(_b[Poorest], "%9.3f")
local m1_se_poorest = string(_se[Poorest], "%9.3f")
local m1_b_reswork = string(_b[Respondent_work], "%9.3f")
local m1_se_reswork = string(_se[Respondent_work], "%9.3f")
local m1_b_noedu = string(_b[no_edu], "%9.3f")
local m1_se_noedu = string(_se[no_edu], "%9.3f")
local m1_b_priedu = string(_b[primary_edu], "%9.3f")
local m1_se_priedu = string(_se[primary_edu], "%9.3f")
local m1_b_secedu = string(_b[secondary_edu], "%9.3f")
local m1_se_secedu = string(_se[secondary_edu], "%9.3f")
local m1_b_bo = string(_b[Birth_order_number], "%9.3f")
local m1_se_bo = string(_se[Birth_order_number], "%9.3f")
local m1_b_rel = string(_b[Religion], "%9.3f")
local m1_se_rel = string(_se[Religion], "%9.3f")
local m1_n = e(N)
local m1_r2 = string(e(r2_a), "%9.3f")

*===============================================================================
* MECHANISM 2: Husband's Education (Partner Selection)
*===============================================================================

display ""
display "============================================"
display "MECHANISM 2: Husband's Education"
display "============================================"

* 2a: Husband no education
reg Husband_no_education past_group TC_noborder $controls_no_husbedu ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit)

local m2a_b_pg = string(_b[past_group], "%9.3f")
local m2a_se_pg = string(_se[past_group], "%9.3f")
local m2a_b_tc = string(_b[TC_noborder], "%9.3f")
local m2a_se_tc = string(_se[TC_noborder], "%9.3f")
local m2a_b_poorest = string(_b[Poorest], "%9.3f")
local m2a_se_poorest = string(_se[Poorest], "%9.3f")
local m2a_b_reswork = string(_b[Respondent_work], "%9.3f")
local m2a_se_reswork = string(_se[Respondent_work], "%9.3f")
local m2a_b_noedu = string(_b[no_edu], "%9.3f")
local m2a_se_noedu = string(_se[no_edu], "%9.3f")
local m2a_b_bo = string(_b[Birth_order_number], "%9.3f")
local m2a_se_bo = string(_se[Birth_order_number], "%9.3f")
local m2a_b_rel = string(_b[Religion], "%9.3f")
local m2a_se_rel = string(_se[Religion], "%9.3f")
local m2a_n = e(N)
local m2a_r2 = string(e(r2_a), "%9.3f")

* 2b: Husband primary
reg Husband_primary past_group TC_noborder $controls_no_husbedu ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit)

local m2b_b_pg = string(_b[past_group], "%9.3f")
local m2b_se_pg = string(_se[past_group], "%9.3f")
local m2b_b_tc = string(_b[TC_noborder], "%9.3f")
local m2b_se_tc = string(_se[TC_noborder], "%9.3f")
local m2b_n = e(N)
local m2b_r2 = string(e(r2_a), "%9.3f")

* 2c: Husband secondary
reg Husband_secondary past_group TC_noborder $controls_no_husbedu ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit)

local m2c_b_pg = string(_b[past_group], "%9.3f")
local m2c_se_pg = string(_se[past_group], "%9.3f")
local m2c_b_tc = string(_b[TC_noborder], "%9.3f")
local m2c_se_tc = string(_se[TC_noborder], "%9.3f")
local m2c_n = e(N)
local m2c_r2 = string(e(r2_a), "%9.3f")

*===============================================================================
* MECHANISM 3: Women's Labor Force Participation
*===============================================================================

display ""
display "============================================"
display "MECHANISM 3: Women's Employment"
display "============================================"

reg Respondent_work past_group TC_noborder $controls_no_reswork ///
    i.Area_unit i.Res_BY ///
    [pweight = weight], ///
    vce(cluster Area_unit)

local m3_b_pg = string(_b[past_group], "%9.3f")
local m3_se_pg = string(_se[past_group], "%9.3f")
local m3_b_tc = string(_b[TC_noborder], "%9.3f")
local m3_se_tc = string(_se[TC_noborder], "%9.3f")
local m3_b_poorest = string(_b[Poorest], "%9.3f")
local m3_se_poorest = string(_se[Poorest], "%9.3f")
local m3_b_noedu = string(_b[no_edu], "%9.3f")
local m3_se_noedu = string(_se[no_edu], "%9.3f")
local m3_b_secedu = string(_b[secondary_edu], "%9.3f")
local m3_se_secedu = string(_se[secondary_edu], "%9.3f")
local m3_b_resage = string(_b[Res_age], "%9.3f")
local m3_se_resage = string(_se[Res_age], "%9.3f")
local m3_b_husbnoedu = string(_b[Husband_no_education], "%9.3f")
local m3_se_husbnoedu = string(_se[Husband_no_education], "%9.3f")
local m3_b_bo = string(_b[Birth_order_number], "%9.3f")
local m3_se_bo = string(_se[Birth_order_number], "%9.3f")
local m3_b_rel = string(_b[Religion], "%9.3f")
local m3_se_rel = string(_se[Religion], "%9.3f")
local m3_n = e(N)
local m3_r2 = string(e(r2_a), "%9.3f")

*===============================================================================
* Write results to CSV
*===============================================================================

tempname fh
file open `fh' using "`outpath'/mechanism_additional.csv", write replace

* Header
file write `fh' "Variable,AgeGap_coef,AgeGap_se,HusbNoEdu_coef,HusbNoEdu_se,HusbPri_coef,HusbPri_se,HusbSec_coef,HusbSec_se,RespWork_coef,RespWork_se" _n

* Treatment variables
file write `fh' "past_group,`m1_b_pg',`m1_se_pg',`m2a_b_pg',`m2a_se_pg',`m2b_b_pg',`m2b_se_pg',`m2c_b_pg',`m2c_se_pg',`m3_b_pg',`m3_se_pg'" _n
file write `fh' "TC_noborder,`m1_b_tc',`m1_se_tc',`m2a_b_tc',`m2a_se_tc',`m2b_b_tc',`m2b_se_tc',`m2c_b_tc',`m2c_se_tc',`m3_b_tc',`m3_se_tc'" _n

* Selected controls for age gap
file write `fh' "Poorest,`m1_b_poorest',`m1_se_poorest',`m2a_b_poorest',`m2a_se_poorest',,,,,,`m3_b_poorest',`m3_se_poorest'" _n
file write `fh' "Resp_work,`m1_b_reswork',`m1_se_reswork',`m2a_b_reswork',`m2a_se_reswork',,,,,," _n
file write `fh' "No_education,`m1_b_noedu',`m1_se_noedu',`m2a_b_noedu',`m2a_se_noedu',,,,,,`m3_b_noedu',`m3_se_noedu'" _n
file write `fh' "Primary_edu,`m1_b_priedu',`m1_se_priedu',,,,,,,,," _n
file write `fh' "Secondary_edu,`m1_b_secedu',`m1_se_secedu',,,,,,,,`m3_b_secedu',`m3_se_secedu'" _n
file write `fh' "Res_age,,,,,,,,,,`m3_b_resage',`m3_se_resage'" _n
file write `fh' "Husb_no_edu,,,,,,,,,,`m3_b_husbnoedu',`m3_se_husbnoedu'" _n
file write `fh' "Birth_order,`m1_b_bo',`m1_se_bo',`m2a_b_bo',`m2a_se_bo',,,,,,`m3_b_bo',`m3_se_bo'" _n
file write `fh' "Religion,`m1_b_rel',`m1_se_rel',`m2a_b_rel',`m2a_se_rel',,,,,,`m3_b_rel',`m3_se_rel'" _n

* Model fit
file write `fh' "Observations,`m1_n',,`m2a_n',,`m2b_n',,`m2c_n',,`m3_n'," _n
file write `fh' "Adj_R2,`m1_r2',,`m2a_r2',,`m2b_r2',,`m2c_r2',,`m3_r2'," _n

file close `fh'

display ""
display "============================================"
display "Additional mechanism results saved to:"
display "  mechanism_additional.csv"
display "============================================"
display ""
display "Summary of treatment effects (past_group):"
display "  Age gap:              `m1_b_pg' (`m1_se_pg')"
display "  Husb no education:    `m2a_b_pg' (`m2a_se_pg')"
display "  Husb primary:         `m2b_b_pg' (`m2b_se_pg')"
display "  Husb secondary:       `m2c_b_pg' (`m2c_se_pg')"
display "  Respondent work:      `m3_b_pg' (`m3_se_pg')"
