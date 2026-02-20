/*==============================================================================
  Difference-in-Differences Summary Statistics Table

  "Revolution and Reproduction: How the Arab Spring Reshaped Marriage
   and Fertility in Egypt"

  Authors: Karbalaei, Demir, Ghosh
  Date: February 2026

  Structure: Pre/Post means for Treatment/Control + DiD with t-stats
==============================================================================*/

clear all
set more off

* Load data
use "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Data/model_data/Combined_DHS_2005_2008_2014.dta", clear

local outpath "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Draft/Draft1/Feb_2026"

*===============================================================================
* Generate variables
*===============================================================================

* Teen pregnancy indicator
gen teen_preg = (Fir_bir_age < 20 & Fir_bir_age != .)

* Destring TC_noborder
capture destring TC_noborder, replace

* Keep only observations with valid treatment assignment
keep if TC_noborder != .

*===============================================================================
* DiD Summary Statistics
*===============================================================================

tempname fh
file open `fh' using "`outpath'/summary_stats_did.csv", write replace

file write `fh' "Variable,Pre_Control_Mean,Pre_Control_SD,Pre_Treat_Mean,Pre_Treat_SD,Post_Control_Mean,Post_Control_SD,Post_Treat_Mean,Post_Treat_SD,DiD,DiD_tstat" _n

foreach var in teen_preg Fir_bir_age AgeofFirstMarriage ///
    No_education Primary Secondary ///
    Res_age Respondent_work Husband_age Husband_work ///
    Husband_no_education Husband_primary Husband_secondary ///
    Poorest Poorer Middle Richer ///
    Birth_order_number Religion Terminated_birth {

    capture {
        * Pre-period, Control group (Time_dummy==0, TC_noborder==0)
        quietly summarize `var' if Time_dummy == 0 & TC_noborder == 0
        local pre_c_n = r(N)
        local pre_c_mean = r(mean)
        local pre_c_sd = r(sd)
        local pre_c_mean_s = string(r(mean), "%9.3f")
        local pre_c_sd_s = string(r(sd), "%9.3f")

        * Pre-period, Treatment group (Time_dummy==0, TC_noborder==1)
        quietly summarize `var' if Time_dummy == 0 & TC_noborder == 1
        local pre_t_n = r(N)
        local pre_t_mean = r(mean)
        local pre_t_sd = r(sd)
        local pre_t_mean_s = string(r(mean), "%9.3f")
        local pre_t_sd_s = string(r(sd), "%9.3f")

        * Post-period, Control group (Time_dummy==1, TC_noborder==0)
        quietly summarize `var' if Time_dummy == 1 & TC_noborder == 0
        local post_c_n = r(N)
        local post_c_mean = r(mean)
        local post_c_sd = r(sd)
        local post_c_mean_s = string(r(mean), "%9.3f")
        local post_c_sd_s = string(r(sd), "%9.3f")

        * Post-period, Treatment group (Time_dummy==1, TC_noborder==1)
        quietly summarize `var' if Time_dummy == 1 & TC_noborder == 1
        local post_t_n = r(N)
        local post_t_mean = r(mean)
        local post_t_sd = r(sd)
        local post_t_mean_s = string(r(mean), "%9.3f")
        local post_t_sd_s = string(r(sd), "%9.3f")

        * Compute DiD = (Post_T - Pre_T) - (Post_C - Pre_C)
        local did = (`post_t_mean' - `pre_t_mean') - (`post_c_mean' - `pre_c_mean')
        local did_s = string(`did', "%9.3f")

        * Compute t-stat for DiD using regression:
        * Regress var on TC_noborder, Time_dummy, TC_noborder*Time_dummy
        * The interaction coefficient is the DiD, and its t-stat is what we need
        gen _interaction = TC_noborder * Time_dummy
        quietly reg `var' TC_noborder Time_dummy _interaction, robust
        local did_coef = _b[_interaction]
        local did_se = _se[_interaction]
        local did_t = `did_coef' / `did_se'
        local did_t_s = string(`did_t', "%9.3f")
        local did_coef_s = string(`did_coef', "%9.3f")
        drop _interaction

        file write `fh' "`var',`pre_c_mean_s',`pre_c_sd_s',`pre_t_mean_s',`pre_t_sd_s',`post_c_mean_s',`post_c_sd_s',`post_t_mean_s',`post_t_sd_s',`did_coef_s',`did_t_s'" _n
    }
}

file close `fh'

display "DiD summary statistics exported successfully."
