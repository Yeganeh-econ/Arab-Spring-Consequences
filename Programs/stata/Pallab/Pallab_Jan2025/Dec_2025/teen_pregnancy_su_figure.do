

gen teen_preg = 0
replace teen_preg = 1 if Fir_bir_age < 20


gen first_preg_year = Res_BY + Fir_bir_age
bysort first_preg_year TC_noborder

collapse (mean) teen_preg, by(TC_noborder first_preg_year)

* Create a variable teen_preg_rate which is the average teen_preg per 100 women in a governate

* Calculate average by governorate and merge back
* Method 1: Using tag to identify unique caseids
bysort Governates first_preg_year caseid: gen tag = (_n == 1)
bysort Governates first_preg_year: egen total_women = total(tag)
drop tag

* Label the variable
label variable total_women "Total unique women by governorate and year"

* First calculate the rate per 100 women (if you have total_women variable)
generate teen_preg_rate = (teen_preg / total_women) * 100

* Then calculate average by governorate and year
bysort Governates first_preg_year: egen avg_teen_preg_rate = mean(teen_preg_rate)

* Label the variable
label variable avg_teen_preg_rate "Average teen pregnancy rate per 100 women by governorate and year"
