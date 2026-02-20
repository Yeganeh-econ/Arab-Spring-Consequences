/*==============================================================================
  Summary Statistics for:
  "Revolution and Reproduction: How the Arab Spring Reshaped Marriage
   and Fertility in Egypt"

  Authors: Karbalaei, Demir, Ghosh
  Date: February 2026
==============================================================================*/

clear all
set more off

* Load data
use "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Data/model_data/Combined_DHS_2005_2008_2014.dta", clear

* Define output path
local outpath "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Draft/Draft1/Feb_2026"

*===============================================================================
* Generate key variables needed
*===============================================================================

* Teen pregnancy indicator (first birth age < 20)
gen teen_preg = (Fir_bir_age < 20 & Fir_bir_age != .)

* Destring TC_noborder if string
capture destring TC_noborder, replace

* Generate past_group indicator based on treatment status
* (use the variable if it exists, otherwise use Time_dummy and TC)
capture confirm variable past_group
if _rc != 0 {
    gen past_group = (Time_dummy == 1)
}

*===============================================================================
* PANEL A: Summary Statistics - Key Variables (Full Sample)
*===============================================================================

* Output summary statistics to a CSV for LaTeX
tempname fh
file open `fh' using "`outpath'/summary_stats.csv", write replace

* Header
file write `fh' "Variable,N,Mean,Std. Dev.,Min,Max" _n

* Loop through key outcome variables
foreach var in teen_preg Fir_bir_age AgeofFirstMarriage {
    quietly summarize `var'
    local n = r(N)
    local mean = string(r(mean), "%9.3f")
    local sd = string(r(sd), "%9.3f")
    local min = string(r(min), "%9.0f")
    local max = string(r(max), "%9.0f")
    file write `fh' "`var',`n',`mean',`sd',`min',`max'" _n
}

* Occupation variables
foreach var in UnskilledManual SkilledManual AgricselfEmployed {
    quietly summarize `var'
    local n = r(N)
    local mean = string(r(mean), "%9.3f")
    local sd = string(r(sd), "%9.3f")
    local min = string(r(min), "%9.0f")
    local max = string(r(max), "%9.0f")
    file write `fh' "`var',`n',`mean',`sd',`min',`max'" _n
}

* Education variables
foreach var in No_education Primary Secondary {
    quietly summarize `var'
    local n = r(N)
    local mean = string(r(mean), "%9.3f")
    local sd = string(r(sd), "%9.3f")
    local min = string(r(min), "%9.0f")
    local max = string(r(max), "%9.0f")
    file write `fh' "`var',`n',`mean',`sd',`min',`max'" _n
}

* Treatment variables
foreach var in TC_noborder Time_dummy {
    capture quietly summarize `var'
    if _rc == 0 {
        local n = r(N)
        local mean = string(r(mean), "%9.3f")
        local sd = string(r(sd), "%9.3f")
        local min = string(r(min), "%9.0f")
        local max = string(r(max), "%9.0f")
        file write `fh' "`var',`n',`mean',`sd',`min',`max'" _n
    }
}

* Control variables
foreach var in Res_age Respondent_work Husband_age Husband_work ///
    Poorest Poorer Middle Richer ///
    Husband_no_education Husband_primary Husband_secondary ///
    Birth_order_number Religion ///
    Terminated_birth {
    capture quietly summarize `var'
    if _rc == 0 {
        local n = r(N)
        local mean = string(r(mean), "%9.3f")
        local sd = string(r(sd), "%9.3f")
        local min = string(r(min), "%9.0f")
        local max = string(r(max), "%9.0f")
        file write `fh' "`var',`n',`mean',`sd',`min',`max'" _n
    }
}

file close `fh'

*===============================================================================
* PANEL B: Summary Statistics by Treatment/Control Group
*===============================================================================

tempname fh2
file open `fh2' using "`outpath'/summary_stats_by_group.csv", write replace

file write `fh2' "Variable,Treatment N,Treatment Mean,Treatment SD,Control N,Control Mean,Control SD" _n

foreach var in teen_preg Fir_bir_age AgeofFirstMarriage ///
    UnskilledManual SkilledManual AgricselfEmployed ///
    No_education Primary Secondary ///
    Res_age Respondent_work Birth_order_number {

    capture {
        quietly summarize `var' if TC_noborder == 1
        local tn = r(N)
        local tmean = string(r(mean), "%9.3f")
        local tsd = string(r(sd), "%9.3f")

        quietly summarize `var' if TC_noborder == 0
        local cn = r(N)
        local cmean = string(r(mean), "%9.3f")
        local csd = string(r(sd), "%9.3f")

        file write `fh2' "`var',`tn',`tmean',`tsd',`cn',`cmean',`csd'" _n
    }
}

file close `fh2'

*===============================================================================
* PANEL C: Summary by Survey Year
*===============================================================================

tempname fh3
file open `fh3' using "`outpath'/summary_stats_by_year.csv", write replace

file write `fh3' "Variable,2005 N,2005 Mean,2008 N,2008 Mean,2014 N,2014 Mean" _n

foreach var in teen_preg Fir_bir_age AgeofFirstMarriage ///
    UnskilledManual SkilledManual ///
    No_education Primary Secondary Res_age {

    capture {
        quietly summarize `var' if Sample_year == 2005
        local n05 = r(N)
        local m05 = string(r(mean), "%9.3f")

        quietly summarize `var' if Sample_year == 2008
        local n08 = r(N)
        local m08 = string(r(mean), "%9.3f")

        quietly summarize `var' if Sample_year == 2014
        local n14 = r(N)
        local m14 = string(r(mean), "%9.3f")

        file write `fh3' "`var',`n05',`m05',`n08',`m08',`n14',`m14'" _n
    }
}

file close `fh3'

display "Summary statistics exported successfully."
display "Files saved in: `outpath'"
