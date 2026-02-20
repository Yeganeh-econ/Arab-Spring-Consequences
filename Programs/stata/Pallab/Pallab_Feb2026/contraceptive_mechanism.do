/*==============================================================================
  Contraceptive Mechanism Analysis
  Run Yeganeh's contraceptive regressions (full spec) and save results to CSV
  Date: February 2026
==============================================================================*/

clear all
set more off
set matsize 10000

* Load data
use "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Data/model_data/Combined_DHS_2005_2008_2014_extended.dta", clear

local outpath "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Draft/Draft1/Feb_2026"

*===============================================================================
* Variables already exist in extended dataset:
* past_group, no_edu, primary_edu, secondary_edu
* using_any_contraceptive, using_modern, using_traditional
* using_pill, using_iud, using_injection
*===============================================================================

*===============================================================================
* Full control list (matching Spec 5)
*===============================================================================

global x5list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

*===============================================================================
* Run full specification regressions for all contraceptive outcomes
*===============================================================================

* 1. Any contraceptive
reg using_any_contraceptive past_group TC_noborder $x5list i.Area_unit i.Res_BY [pweight = weight], vce(cluster Area_unit)
local any_b_pg = string(_b[past_group], "%9.3f")
local any_se_pg = string(_se[past_group], "%9.3f")
local any_b_tc = string(_b[TC_noborder], "%9.3f")
local any_se_tc = string(_se[TC_noborder], "%9.3f")
local any_n = e(N)
local any_r2 = string(e(r2_a), "%9.3f")

* 2. Modern
reg using_modern past_group TC_noborder $x5list i.Area_unit i.Res_BY [pweight = weight], vce(cluster Area_unit)
local mod_b_pg = string(_b[past_group], "%9.3f")
local mod_se_pg = string(_se[past_group], "%9.3f")
local mod_b_tc = string(_b[TC_noborder], "%9.3f")
local mod_se_tc = string(_se[TC_noborder], "%9.3f")
local mod_n = e(N)
local mod_r2 = string(e(r2_a), "%9.3f")

* 3. Traditional
reg using_traditional past_group TC_noborder $x5list i.Area_unit i.Res_BY [pweight = weight], vce(cluster Area_unit)
local trad_b_pg = string(_b[past_group], "%9.3f")
local trad_se_pg = string(_se[past_group], "%9.3f")
local trad_b_tc = string(_b[TC_noborder], "%9.3f")
local trad_se_tc = string(_se[TC_noborder], "%9.3f")
local trad_n = e(N)
local trad_r2 = string(e(r2_a), "%9.3f")

* 4. Pill
reg using_pill past_group TC_noborder $x5list i.Area_unit i.Res_BY [pweight = weight], vce(cluster Area_unit)
local pill_b_pg = string(_b[past_group], "%9.3f")
local pill_se_pg = string(_se[past_group], "%9.3f")
local pill_b_tc = string(_b[TC_noborder], "%9.3f")
local pill_se_tc = string(_se[TC_noborder], "%9.3f")
local pill_n = e(N)
local pill_r2 = string(e(r2_a), "%9.3f")

* 5. IUD
reg using_iud past_group TC_noborder $x5list i.Area_unit i.Res_BY [pweight = weight], vce(cluster Area_unit)
local iud_b_pg = string(_b[past_group], "%9.3f")
local iud_se_pg = string(_se[past_group], "%9.3f")
local iud_b_tc = string(_b[TC_noborder], "%9.3f")
local iud_se_tc = string(_se[TC_noborder], "%9.3f")
local iud_n = e(N)
local iud_r2 = string(e(r2_a), "%9.3f")

* 6. Injection
reg using_injection past_group TC_noborder $x5list i.Area_unit i.Res_BY [pweight = weight], vce(cluster Area_unit)
local inj_b_pg = string(_b[past_group], "%9.3f")
local inj_se_pg = string(_se[past_group], "%9.3f")
local inj_b_tc = string(_b[TC_noborder], "%9.3f")
local inj_se_tc = string(_se[TC_noborder], "%9.3f")
local inj_n = e(N)
local inj_r2 = string(e(r2_a), "%9.3f")

*===============================================================================
* Summary stats for contraceptive variables
*===============================================================================
sum using_any_contraceptive using_modern using_traditional using_pill using_iud using_injection [aw=weight]

*===============================================================================
* Write results to CSV
*===============================================================================

tempname fh
file open `fh' using "`outpath'/contraceptive_mechanism.csv", write replace

* Header
file write `fh' "Variable,Any_coef,Any_se,Modern_coef,Modern_se,Traditional_coef,Traditional_se,Pill_coef,Pill_se,IUD_coef,IUD_se,Injection_coef,Injection_se" _n

* Treatment variables
file write `fh' "past_group,`any_b_pg',`any_se_pg',`mod_b_pg',`mod_se_pg',`trad_b_pg',`trad_se_pg',`pill_b_pg',`pill_se_pg',`iud_b_pg',`iud_se_pg',`inj_b_pg',`inj_se_pg'" _n
file write `fh' "TC_noborder,`any_b_tc',`any_se_tc',`mod_b_tc',`mod_se_tc',`trad_b_tc',`trad_se_tc',`pill_b_tc',`pill_se_tc',`iud_b_tc',`iud_se_tc',`inj_b_tc',`inj_se_tc'" _n

* Model fit
file write `fh' "Observations,`any_n',,`mod_n',,`trad_n',,`pill_n',,`iud_n',,`inj_n'," _n
file write `fh' "Adj_R2,`any_r2',,`mod_r2',,`trad_r2',,`pill_r2',,`iud_r2',,`inj_r2'," _n

file close `fh'

display ""
display "============================================"
display "Contraceptive mechanism results saved to:"
display "  contraceptive_mechanism.csv"
display "============================================"
display ""
display "Summary of treatment effects (past_group):"
display "  Any contraceptive:   `any_b_pg' (`any_se_pg')"
display "  Modern:              `mod_b_pg' (`mod_se_pg')"
display "  Traditional:         `trad_b_pg' (`trad_se_pg')"
display "  Pill:                `pill_b_pg' (`pill_se_pg')"
display "  IUD:                 `iud_b_pg' (`iud_se_pg')"
display "  Injection:           `inj_b_pg' (`inj_se_pg')"
