clear all
capture log close
set more off

***************************************************************
* Figure 4: Trend of Missing Women Before and After the Arab Spring
* This graph displays the average missing women indicator by year for:
*    - Control areas (tgover_ur==0) shown in black
*    - Treatment areas (tgover_ur==1) shown in blue
* A vertical dashed line is added at 2011, 2012, and 2013 to mark the Arab Spring period.
***************************************************************

* Load the data and collapse by region and year to obtain the mean missing women indicator
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
collapse (mean) missingwomen1, by(tgover_ur year)

* Generate the DID common trend graph for missing women
twoway ///
    (line missingwomen1 year if tgover_ur==0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected missingwomen1 year if tgover_ur==0, msymbol(X) lcolor(black) mcolor(black)) ///
    (line missingwomen1 year if tgover_ur==1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected missingwomen1 year if tgover_ur==1, msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) label(2 "Control areas") label(4 "Treatment areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle("Year") ytitle("Missing Women")

* Export Figure 4 to PDF
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure4_common_trend.pdf", replace

***************************************************************
* Figure 6: Vaccination Female-to-Male Ratio
* This graph plots the mean female-to-male vaccination ratio by year for:
*    - Control areas (tgover_ur==0) in black
*    - Treatment areas (tgover_ur==1) in blue
* Observations with missing vaccination data are dropped. The vertical dashed
* lines at 2011, 2012, and 2013 mark the Arab Spring period.
***************************************************************

* Reload the data (to restore original dataset) and drop observations with missing vaccination data
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_UR.dta", clear
drop if vaccination == .

* Collapse data to compute the mean female-to-male vaccination ratio by region and year
collapse (mean) vac_rate01_fm, by(tgover_ur year)

* Generate the vaccination ratio graph
twoway ///
    (line vac_rate01_fm year if tgover_ur==0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected vac_rate01_fm year if tgover_ur==0, msymbol(X) lcolor(black) mcolor(black)) ///
    (line vac_rate01_fm year if tgover_ur==1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected vac_rate01_fm year if tgover_ur==1, msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) label(2 "Control areas") label(4 "Treatment areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle("Year") ytitle("Vaccination Rate (Female-to-Male Ratio)")

* Export Figure 6 to PDF
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure6_Influencial Channels_vacfm_ratio.pdf", replace


********************************************************************************
* The following is the individual channel variables common trend check
********************************************************************************
* Figiure A2, DV Trend Graph,  A3, Health Decision, and A4, Purchase Decision in Appendix Section
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR.dta", clear

* Define the results folder path
local results_path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\"

bysort caseid clusterid hhid rlineid: gen n = _n
drop if (n != 1 & year_indicator == 2014)

* Basic recodes and covariates:
gen tgover_ur_noborder = tgover_ur
replace tgover_ur_noborder = . if inlist(tgover_ur, 45,46,47,48,49,50)
gen group = tgover_ur_noborder
gen past  = (year_indicator >= 2011)

* Recode attitudes toward women:
replace visit_ternary  = 1 if visit_ternary  == 2 
replace pur_ternary    = 1 if pur_ternary    == 2
replace health_ternary = 1 if health_ternary == 2

* Figiure A2 in Appendix Section: Combined DV Trend Graph
preserve
* Create indicator for no tolerance violation (tol_vio_1 equals 0)
gen tol_vio_flag = (tol_vio_1 == 1)

* Compute overall, treatment, and control group rates by year
bysort year_indicator: egen tol_vio_rate   = mean(tol_vio_flag)
bysort year_indicator: egen tol_vio_rate_t = mean(cond(group == 1, tol_vio_flag, .))
bysort year_indicator: egen tol_vio_rate_c = mean(cond(group == 0, tol_vio_flag, .))

* Collapse data so that each observation represents one year
collapse (mean) tol_vio_rate tol_vio_rate_t tol_vio_rate_c, by(year_indicator)

* Create one combined graph with all three series in one coordinate system.
* Each line uses a distinct color, marker shape, and line pattern.
twoway ///
    (connected tol_vio_rate   year_indicator, lcolor(blue)   lpattern(solid) lwidth(medium) msymbol(circle)   mcolor(blue)) ///
    (connected tol_vio_rate_t year_indicator, lcolor(red)    lpattern(dash)  lwidth(medium) msymbol(triangle) mcolor(red)) ///
    (connected tol_vio_rate_c year_indicator, lcolor(green)  lpattern(dot)   lwidth(medium) msymbol(square)   mcolor(green)) ///
    , xline(2011, lpattern(dash)) ///
      legend(order(1 "Aggregate" 2 "Treatment" 3 "Control") ///
             position(6) ring(1) cols(1)) ///
      graphregion(color(white)) ///
      xtitle("Year") ytitle("Domestic Violation Rate")

graph export "`results_path'AppenFigA2_DV_Combined.pdf", replace

restore 

* Figiure A3 in Appendix Section: Combined Health Decision Trend Graph
preserve
    * Create indicator for women making their own health decision (health_ternary equals 1)
    gen health_flag = (health_ternary == 1)
    
    * Compute overall, treatment, and control group rates by year
    bysort year_indicator: egen health_ternary_rate   = mean(health_flag)
    bysort year_indicator: egen health_ternary_rate_t = mean(cond(group == 1, health_flag, .))
    bysort year_indicator: egen health_ternary_rate_c = mean(cond(group == 0, health_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) health_ternary_rate health_ternary_rate_t health_ternary_rate_c, by(year_indicator)

* Create one combined graph with all three series in one coordinate system.
* Each line uses a distinct color, marker shape, and line pattern.
twoway ///
    (connected health_ternary_rate   year_indicator, lcolor(blue)   lpattern(solid) lwidth(medium) msymbol(circle)   mcolor(blue)) ///
    (connected health_ternary_rate_t year_indicator, lcolor(red)    lpattern(dash)  lwidth(medium) msymbol(triangle) mcolor(red)) ///
    (connected health_ternary_rate_c year_indicator, lcolor(green)  lpattern(dot)   lwidth(medium) msymbol(square)   mcolor(green)) ///
    , xline(2011, lpattern(dash)) ///
      legend(order(1 "Aggregate" 2 "Treatment" 3 "Control") ///
             position(6) ring(1) cols(1)) ///
      graphregion(color(white)) ///
      xtitle("Year") ytitle("Health Decision Rate")
	  
graph export "`results_path'AppenFigA3_HealthDecision_Combined.pdf", replace

restore 

* Figiure A4 in Appendix Section: Purchase Decision Analysis Trend Graph
preserve
    * Create indicator for women making their own purchase decision (pur_ternary equals 1)
    gen purchase_flag = (pur_ternary == 1)
    
    * Compute overall, treatment, and control group rates by year
    bysort year_indicator: egen pur_ternary_rate   = mean(purchase_flag)
    bysort year_indicator: egen pur_ternary_rate_t = mean(cond(group == 1, purchase_flag, .))
    bysort year_indicator: egen pur_ternary_rate_c = mean(cond(group == 0, purchase_flag, .))
    
    * Collapse data so each observation represents one year
    collapse (mean) pur_ternary_rate pur_ternary_rate_t pur_ternary_rate_c, by(year_indicator)

* Create one combined graph with all three series in one coordinate system.
* Each line uses a distinct color, marker shape, and line pattern.
twoway ///
    (connected pur_ternary_rate   year_indicator, lcolor(blue)   lpattern(solid) lwidth(medium) msymbol(circle)   mcolor(blue)) ///
    (connected pur_ternary_rate_t year_indicator, lcolor(red)    lpattern(dash)  lwidth(medium) msymbol(triangle) mcolor(red)) ///
    (connected pur_ternary_rate_c year_indicator, lcolor(green)  lpattern(dot)   lwidth(medium) msymbol(square)   mcolor(green)) ///
    , xline(2011, lpattern(dash)) ///
      legend(order(1 "Aggregate" 2 "Treatment" 3 "Control") ///
             position(6) ring(1) cols(1)) ///
      graphregion(color(white)) ///
      xtitle("Year") ytitle("Health Decision Rate")
	  
graph export "`results_path'AppenFigA4_PurchaseDecision_Combined.pdf", replace

restore 

exit