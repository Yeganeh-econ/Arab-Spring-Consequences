clear all
set more off
use "/Users/pallab.ghosh/Documents/GitHub/Arab-Spring-Consequences/Data/model_data/Combined_DHS_2005_2008_2014.dta", clear
gen teen_preg = (Fir_bir_age < 20 & Fir_bir_age != .)
capture destring TC_noborder, replace
capture confirm variable past_group
if _rc != 0 {
    gen past_group = (Time_dummy == 1)
}
* Check what past_group should actually be -- look at Pallab's do files
summarize teen_preg past_group TC_noborder No_education Primary Secondary Res_age Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion
* Quick test: replicate Spec 1
reg teen_preg past_group TC_noborder Poorest Poorer Middle Richer Respondent_work, robust
