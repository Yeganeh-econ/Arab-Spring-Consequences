*****
***************
***************************
**** Contraceptive Use
*---------------------------------------------------------------*
* Explore current_contraceptive variable
*---------------------------------------------------------------*

* 1. Check the overall distribution of current_contraceptive
tab current_contraceptive, missing

* 2. See the value labels
codebook current_contraceptive

* 3. Check distribution by TC_noborder (treatment group)
tab current_contraceptive TC_noborder, missing row col

* 4. With percentages - row percentages (within each contraceptive method)
tab current_contraceptive TC_noborder, missing row

* 5. With percentages - column percentages (within each TC_noborder group)
tab current_contraceptive TC_noborder, missing col

* 6. Check distribution by TC_noborder and survey year (Stata 17+ syntax)
table Sample_year TC_noborder, statistic(mean current_contraceptive) nformat(%9.2f)

* 7. More detailed breakdown by year and treatment
tab current_contraceptive TC_noborder if Sample_year == 2005, missing col
tab current_contraceptive TC_noborder if Sample_year == 2008, missing col
tab current_contraceptive TC_noborder if Sample_year == 2014, missing col

*---------------------------------------------------------------*
* Summary statistics with weights (since you're using weights in regressions)
*---------------------------------------------------------------*

* 8. Weighted distribution overall
tab current_contraceptive [aweight = weight], missing

* 9. Weighted distribution by TC_noborder
tab current_contraceptive TC_noborder [aweight = weight], missing col

* 10. Create a binary indicator for "using any contraceptive"
gen using_contraceptive = (current_contraceptive > 0 & current_contraceptive != .)
label variable using_contraceptive "Using any contraceptive method"
label define using_contraceptive 0 "Not using" 1 "Using"
label values using_contraceptive using_contraceptive

* 11. Check contraceptive use rate by treatment group
tab using_contraceptive TC_noborder [aweight = weight], missing col

* 12. Summary by treatment group
bysort TC_noborder: summarize using_contraceptive [aweight = weight]

*---------------------------------------------------------------*
* Visualizations (optional)
*---------------------------------------------------------------*

* 13. Bar graph of contraceptive use by treatment status
graph bar (mean) using_contraceptive [aweight = weight], ///
    over(TC_noborder) ///
    ytitle("Proportion using contraceptives") ///
    title("Contraceptive Use by Treatment Group") ///
    ylabel(0(.1)1, format(%3.1f))

* 14. Bar graph by year and treatment
graph bar (mean) using_contraceptive [aweight = weight], ///
    over(TC_noborder) over(Sample_year) ///
    ytitle("Proportion using contraceptives") ///
    title("Contraceptive Use by Treatment Group and Year") ///
    ylabel(0(.1)1, format(%3.1f))
	
	
*---------------------------------------------------------------*
* Prepare data for plotting contraceptive trends by year (with weights)
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Visualizations: Contraceptive Use Trends Over Time
*---------------------------------------------------------------*

*---------------------------------------------------------------*
* Figure 1: Line graph of major contraceptive methods over time
*---------------------------------------------------------------*
preserve

* Create indicator variables with CORRECT codes
gen not_using = (current_contraceptive==0)
gen pill = (current_contraceptive==1)
gen iud = (current_contraceptive==2)
gen injection = (current_contraceptive==3)
gen diaphragm = (current_contraceptive==4)
gen condom = (current_contraceptive==5)
gen female_steril = (current_contraceptive==6)
gen male_steril = (current_contraceptive==7)
gen periodic_abst = (current_contraceptive==8)
gen withdrawal = (current_contraceptive==9)
gen other = (current_contraceptive==10)
gen norplant = (current_contraceptive==11)
gen abstinence = (current_contraceptive==12)
gen lam = (current_contraceptive==13)
gen female_condom = (current_contraceptive==14)
gen foam_jelly = (current_contraceptive==15)
gen diaphragm_foam = (current_contraceptive==17)
gen breastfeeding = (current_contraceptive==18)
gen specific_3 = (current_contraceptive==19)
gen specific_4 = (current_contraceptive==20)

* Collapse by year
collapse (mean) not_using pill iud injection diaphragm condom ///
                female_steril male_steril periodic_abst withdrawal ///
                other norplant abstinence lam female_condom foam_jelly ///
                diaphragm_foam breastfeeding specific_3 specific_4 ///
         [pweight=weight], by(Sample_year)

* Convert to percentages
foreach var in not_using pill iud injection diaphragm condom ///
               female_steril male_steril periodic_abst withdrawal ///
               other norplant abstinence lam female_condom foam_jelly ///
               diaphragm_foam breastfeeding specific_3 specific_4 {
    replace `var' = `var' * 100
}

* Plot major methods
twoway (line pill Sample_year, lwidth(thick) lcolor(blue)) ///
       (line iud Sample_year, lwidth(thick) lcolor(red)) ///
       (line injection Sample_year, lwidth(thick) lcolor(green)) ///
       (line periodic_abst Sample_year, lwidth(thick) lcolor(orange)) ///
       (line withdrawal Sample_year, lwidth(thick) lcolor(purple)) ///
       (line breastfeeding Sample_year, lwidth(thick) lcolor(pink)) ///
       (line not_using Sample_year, lwidth(thick) lcolor(gray) lpattern(dash)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(10)50, format(%3.0f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Trends in Contraceptive Use Over Time") ///
    legend(order(1 "Pill" 2 "IUD" 3 "Injection" ///
                 4 "Periodic Abstinence" 5 "Withdrawal" ///
                 6 "Breastfeeding" 7 "Not Using") ///
           rows(2) position(6)) ///
    graphregion(color(white)) bgcolor(white)
graph export "contraceptive_trends_line.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 2: Stacked bar chart by year
*---------------------------------------------------------------*
preserve

* Create method categories
gen method_cat = .
replace method_cat = 1 if current_contraceptive == 0    // Not using
replace method_cat = 2 if current_contraceptive == 1    // Pill
replace method_cat = 3 if current_contraceptive == 2    // IUD
replace method_cat = 4 if current_contraceptive == 3    // Injections
replace method_cat = 5 if inlist(current_contraceptive, 5, 11)  // Condom, Norplant
replace method_cat = 6 if inlist(current_contraceptive, 6, 7)   // Sterilization
replace method_cat = 7 if current_contraceptive == 8    // Periodic abstinence
replace method_cat = 8 if current_contraceptive == 9    // Withdrawal
replace method_cat = 9 if current_contraceptive == 18   // Breastfeeding
replace method_cat = 10 if inlist(current_contraceptive, 4, 10, 12, 13, 14, 15, 17, 19, 20)  // Other

label define method_cat 1 "Not Using" 2 "Pill" 3 "IUD" ///
                        4 "Injection" 5 "Condom/Implants" ///
                        6 "Sterilization" 7 "Periodic Abstinence" ///
                        8 "Withdrawal" 9 "Breastfeeding" 10 "Other"
label values method_cat method_cat

graph bar [pweight=weight], over(method_cat) over(Sample_year) ///
    asyvars percentages stack ///
    title("Distribution of Contraceptive Methods by Year") ///
    ytitle("Percentage (%)") ///
    legend(rows(3) position(6) size(small)) ///
    graphregion(color(white)) bgcolor(white) ///
    bar(1, color(gs12)) bar(2, color(blue)) bar(3, color(red)) ///
    bar(4, color(green)) bar(5, color(orange)) bar(6, color(navy)) ///
    bar(7, color(purple)) bar(8, color(yellow)) bar(9, color(pink)) ///
    bar(10, color(brown))
graph export "contraceptive_distribution_stacked.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 3: Panel plot by treatment group (including traditional)
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen pill = (current_contraceptive==1)
gen iud = (current_contraceptive==2)
gen injection = (current_contraceptive==3)
gen periodic_abst = (current_contraceptive==8)
gen withdrawal = (current_contraceptive==9)
gen norplant = (current_contraceptive==11)
gen breastfeeding = (current_contraceptive==18)
gen modern = inlist(current_contraceptive,1,2,3,5,6,7,11)
gen traditional = inlist(current_contraceptive,8,9)

* Collapse by year and treatment
collapse (mean) pill iud injection periodic_abst withdrawal ///
                norplant breastfeeding modern traditional ///
         [pweight=weight], by(Sample_year TC_noborder)

* Keep only treatment and control groups
keep if inlist(TC_noborder, 0, 1)

* Convert to percentages
foreach var in pill iud injection periodic_abst withdrawal ///
               norplant breastfeeding modern traditional {
    replace `var' = `var' * 100
}

* Plot by treatment group
twoway (line pill Sample_year if TC_noborder==0, lwidth(thick) lcolor(blue)) ///
       (line pill Sample_year if TC_noborder==1, lwidth(thick) lcolor(blue) lpattern(dash)) ///
       (line iud Sample_year if TC_noborder==0, lwidth(thick) lcolor(red)) ///
       (line iud Sample_year if TC_noborder==1, lwidth(thick) lcolor(red) lpattern(dash)) ///
       (line injection Sample_year if TC_noborder==0, lwidth(thick) lcolor(green)) ///
       (line injection Sample_year if TC_noborder==1, lwidth(thick) lcolor(green) lpattern(dash)) ///
       (line periodic_abst Sample_year if TC_noborder==0, lwidth(thick) lcolor(orange)) ///
       (line periodic_abst Sample_year if TC_noborder==1, lwidth(thick) lcolor(orange) lpattern(dash)) ///
       (line withdrawal Sample_year if TC_noborder==0, lwidth(thick) lcolor(purple)) ///
       (line withdrawal Sample_year if TC_noborder==1, lwidth(thick) lcolor(purple) lpattern(dash)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(5)35, format(%3.0f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Contraceptive Use Trends by Treatment Group") ///
    legend(order(1 "Pill (Control)" 2 "Pill (Treatment)" ///
                 3 "IUD (Control)" 4 "IUD (Treatment)" ///
                 5 "Injection (Control)" 6 "Injection (Treatment)" ///
                 7 "Periodic Abs (Control)" 8 "Periodic Abs (Treatment)" ///
                 9 "Withdrawal (Control)" 10 "Withdrawal (Treatment)") ///
           rows(5) position(6) size(vsmall)) ///
    graphregion(color(white)) bgcolor(white)
graph export "contraceptive_trends_by_treatment.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 4: Individual method trends (bar chart)
*---------------------------------------------------------------*
preserve

* Create indicators for all major methods with correct codes
gen pill = (current_contraceptive == 1) * 100
gen iud = (current_contraceptive == 2) * 100
gen injection = (current_contraceptive == 3) * 100
gen condom = (current_contraceptive == 5) * 100
gen sterilization = inlist(current_contraceptive, 6, 7) * 100
gen norplant = (current_contraceptive == 11) * 100
gen periodic_abst = (current_contraceptive == 8) * 100
gen withdrawal = (current_contraceptive == 9) * 100
gen breastfeeding = (current_contraceptive == 18) * 100

* Collapse by year and treatment
collapse (mean) pill iud injection condom sterilization norplant ///
               periodic_abst withdrawal breastfeeding ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)

* Panel bar chart
graph bar pill iud injection sterilization norplant ///
          periodic_abst withdrawal breastfeeding, ///
    over(Sample_year) over(TC_noborder, relabel(1 "Control" 2 "Treatment")) ///
    asyvars ///
    ytitle("Percentage (%)") ///
    title("Contraceptive Method Use by Treatment Group and Year") ///
    legend(rows(2) position(6) size(vsmall) ///
           order(1 "Pill" 2 "IUD" 3 "Injection" 4 "Sterilization" ///
                 5 "Implants" 6 "Periodic Abs" 7 "Withdrawal" 8 "Breastfeeding")) ///
    graphregion(color(white)) bgcolor(white)
graph export "contraceptive_panel_by_treatment.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 5: Modern vs Traditional methods comparison
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen not_using = (current_contraceptive==0)
gen modern = inlist(current_contraceptive,1,2,3,5,6,7,11,14)
gen traditional = inlist(current_contraceptive,8,9)
gen breastfeeding = (current_contraceptive==18)
gen other = inlist(current_contraceptive,4,10,12,13,15,17,19,20)

* Collapse by year and treatment
collapse (mean) not_using modern traditional breastfeeding other ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)

* Convert to percentages
foreach var in not_using modern traditional breastfeeding other {
    replace `var' = `var' * 100
}

* Grouped bar chart
graph bar modern traditional breastfeeding other not_using, ///
    over(TC_noborder, relabel(1 "Control" 2 "Treatment")) ///
    over(Sample_year) ///
    asyvars ///
    ytitle("Percentage (%)") ///
    ylabel(0(20)100) ///
    title("Contraceptive Use Categories Over Time") ///
    subtitle("By Treatment Group") ///
    legend(order(1 "Modern Methods" 2 "Traditional Methods" ///
                 3 "Breastfeeding" 4 "Other" 5 "Not Using") ///
           rows(1) position(6) size(vsmall)) ///
    graphregion(color(white)) bgcolor(white) ///
    bar(1, color(dkgreen)) bar(2, color(orange)) ///
    bar(3, color(pink)) bar(4, color(brown)) bar(5, color(gs10))
graph export "contraceptive_categories_grouped.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 6: Traditional methods detailed comparison
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen periodic_abst = (current_contraceptive==8)
gen withdrawal = (current_contraceptive==9)
gen traditional = inlist(current_contraceptive,8,9)

* Collapse by year and treatment
collapse (mean) periodic_abst withdrawal traditional ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)
replace periodic_abst = periodic_abst * 100
replace withdrawal = withdrawal * 100
replace traditional = traditional * 100

* Plot traditional methods
twoway (connected periodic_abst Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(orange) mcolor(orange)) ///
       (connected periodic_abst Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(orange) mcolor(orange) ///
            lpattern(dash) msymbol(triangle)) ///
       (connected withdrawal Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(purple) mcolor(purple)) ///
       (connected withdrawal Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(purple) mcolor(purple) ///
            lpattern(dash) msymbol(triangle)) ///
       (connected traditional Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(brown) mcolor(brown)) ///
       (connected traditional Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(brown) mcolor(brown) ///
            lpattern(dash) msymbol(triangle)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(0.2)1, format(%3.1f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Traditional Contraceptive Methods Over Time") ///
    subtitle("Control vs Treatment Group") ///
    legend(order(1 "Periodic Abs (Control)" 2 "Periodic Abs (Treatment)" ///
                 3 "Withdrawal (Control)" 4 "Withdrawal (Treatment)" ///
                 5 "All Traditional (Control)" 6 "All Traditional (Treatment)") ///
           rows(3) position(6) size(small)) ///
    graphregion(color(white)) bgcolor(white)
graph export "traditional_methods_detailed.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 7: Modern vs Traditional - DiD style
*---------------------------------------------------------------*
preserve

* Create indicator variables with correct codes
gen modern = inlist(current_contraceptive,1,2,3,5,6,7,11,14)
gen traditional = inlist(current_contraceptive,8,9)

* Collapse by year and treatment
collapse (mean) modern traditional ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)
replace modern = modern * 100
replace traditional = traditional * 100

twoway (connected modern Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(blue) mcolor(blue)) ///
       (connected modern Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(red) mcolor(red) ///
            lpattern(dash) msymbol(triangle)) ///
       (connected traditional Sample_year if TC_noborder==0, ///
            lwidth(thick) msize(large) lcolor(blue) mcolor(blue) ///
            lpattern(shortdash) msymbol(square)) ///
       (connected traditional Sample_year if TC_noborder==1, ///
            lwidth(thick) msize(large) lcolor(red) mcolor(red) ///
            lpattern(shortdash_dot) msymbol(diamond)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(10)70, format(%3.0f)) ///
    ytitle("Contraceptive Use (%)") ///
    xtitle("Survey Year") ///
    title("Modern vs Traditional Contraceptive Use Over Time") ///
    subtitle("Control vs Treatment Group") ///
    legend(order(1 "Modern (Control)" 2 "Modern (Treatment)" ///
                 3 "Traditional (Control)" 4 "Traditional (Treatment)") ///
           rows(2) position(6)) ///
    graphregion(color(white)) bgcolor(white)
graph export "modern_vs_traditional_did.png", replace width(2000)

restore

*---------------------------------------------------------------*
* Figure 8: Top 5 methods comparison
*---------------------------------------------------------------*
preserve

* Create indicators for top 5 methods
gen pill = (current_contraceptive==1)
gen iud = (current_contraceptive==2)
gen injection = (current_contraceptive==3)
gen breastfeeding = (current_contraceptive==18)
gen norplant = (current_contraceptive==11)

* Collapse by year and treatment
collapse (mean) pill iud injection breastfeeding norplant ///
         [pweight=weight], by(Sample_year TC_noborder)

keep if inlist(TC_noborder, 0, 1)

* Convert to percentages
foreach var in pill iud injection breastfeeding norplant {
    replace `var' = `var' * 100
}

* Create combined plot
twoway (line pill Sample_year if TC_noborder==0, lwidth(thick) lcolor(blue)) ///
       (line pill Sample_year if TC_noborder==1, lwidth(thick) lcolor(blue) lpattern(dash)) ///
       (line iud Sample_year if TC_noborder==0, lwidth(thick) lcolor(red)) ///
       (line iud Sample_year if TC_noborder==1, lwidth(thick) lcolor(red) lpattern(dash)) ///
       (line injection Sample_year if TC_noborder==0, lwidth(thick) lcolor(green)) ///
       (line injection Sample_year if TC_noborder==1, lwidth(thick) lcolor(green) lpattern(dash)), ///
    xlabel(2005 2008 2014) ///
    ylabel(0(5)35, format(%3.0f)) ///
    ytitle("Percentage (%)") ///
    xtitle("Survey Year") ///
    title("Top 3 Modern Contraceptive Methods by Treatment Group") ///
    legend(order(1 "Pill (Control)" 2 "Pill (Treatment)" ///
                 3 "IUD (Control)" 4 "IUD (Treatment)" ///
                 5 "Injection (Control)" 6 "Injection (Treatment)") ///
           rows(3) position(6) size(small)) ///
    graphregion(color(white)) bgcolor(white)
graph export "top3_methods_by_treatment.png", replace width(2000)

restore



*---------------------------------------------------------------*
* Treatment Effects on Contraceptive Use
* Using the same 5 specifications as teenage pregnancy analysis
*---------------------------------------------------------------*

* Ensure control variable globals are defined
global x1list "Poorest Poorer Middle Richer Respondent_work"
global x2list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age"
global x3list "Poorest Poorer Middle Richer Respondent_work Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age"
global x4list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Birth_order_number Religion"
global x5list "Poorest Poorer Middle Richer Respondent_work no_edu primary_edu secondary_edu Res_age Husband_work Husband_no_education Husband_primary Husband_secondary Husband_age Birth_order_number Religion"

*---------------------------------------------------------------*
* Create contraceptive use outcome variables
*---------------------------------------------------------------*

* Any contraceptive use (binary)
gen using_any_contraceptive = (current_contraceptive > 0 & current_contraceptive != .)
label variable using_any_contraceptive "Using any contraceptive method"

* Modern methods (binary)
gen using_modern = inlist(current_contraceptive,1,2,3,5,6,7,11,14) if current_contraceptive != .
label variable using_modern "Using modern contraceptive method"

* Traditional methods (binary)
gen using_traditional = inlist(current_contraceptive,8,9) if current_contraceptive != .
label variable using_traditional "Using traditional contraceptive method"

* Specific modern methods
gen using_pill = (current_contraceptive==1) if current_contraceptive != .
label variable using_pill "Using pill"

gen using_iud = (current_contraceptive==2) if current_contraceptive != .
label variable using_iud "Using IUD"

gen using_injection = (current_contraceptive==3) if current_contraceptive != .
label variable using_injection "Using injection"

gen using_implants = (current_contraceptive==11) if current_contraceptive != .
label variable using_implants "Using implants/Norplant"

* Specific traditional methods
gen using_periodic_abst = (current_contraceptive==8) if current_contraceptive != .
label variable using_periodic_abst "Using periodic abstinence"

gen using_withdrawal = (current_contraceptive==9) if current_contraceptive != .
label variable using_withdrawal "Using withdrawal"

*---------------------------------------------------------------*
* Panel A: Any Contraceptive Use (Main Outcome)
*---------------------------------------------------------------*

* Clear stored estimates
eststo clear

* Specification 1: Wealth + Respondent work
eststo any_x1: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2: Add respondent education + age
eststo any_x2: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3: Add husband characteristics
eststo any_x3: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4: Respondent + birth order + religion
eststo any_x4: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5: Full specification
eststo any_x5: reghdfe using_any_contraceptive ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results table for any contraceptive use
esttab any_x1 any_x2 any_x3 any_x4 any_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Any Contraceptive Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area_unit level" ///
                     "All specifications include Area_unit and birth year FE")


*---------------------------------------------------------------*
* Panel B: Modern Contraceptive Use
*---------------------------------------------------------------*

eststo clear

* Specification 1
eststo modern_x1: reghdfe using_modern ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2
eststo modern_x2: reghdfe using_modern ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3
eststo modern_x3: reghdfe using_modern ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4
eststo modern_x4: reghdfe using_modern ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5
eststo modern_x5: reghdfe using_modern ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results
esttab modern_x1 modern_x2 modern_x3 modern_x4 modern_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Modern Contraceptive Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Panel C: Traditional Contraceptive Use
*---------------------------------------------------------------*

eststo clear

* Specification 1
eststo trad_x1: reghdfe using_traditional ///
    past_group TC_noborder $x1list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 2
eststo trad_x2: reghdfe using_traditional ///
    past_group TC_noborder $x2list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 3
eststo trad_x3: reghdfe using_traditional ///
    past_group TC_noborder $x3list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 4
eststo trad_x4: reghdfe using_traditional ///
    past_group TC_noborder $x4list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Specification 5
eststo trad_x5: reghdfe using_traditional ///
    past_group TC_noborder $x5list ///
    [pweight = weight], ///
    absorb(Area_unit Res_BY) ///
    vce(cluster Area_unit)

* Display results
esttab trad_x1 trad_x2 trad_x3 trad_x4 trad_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Traditional Contraceptive Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Panel D: Specific Modern Methods (Pill, IUD, Injection)
*---------------------------------------------------------------*

eststo clear

* Pill - all 5 specifications
eststo pill_x1: reghdfe using_pill past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x2: reghdfe using_pill past_group TC_noborder $x2list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x3: reghdfe using_pill past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x4: reghdfe using_pill past_group TC_noborder $x4list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill_x5: reghdfe using_pill past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display pill results
esttab pill_x1 pill_x2 pill_x3 pill_x4 pill_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Pill Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

eststo clear

* IUD - all 5 specifications
eststo iud_x1: reghdfe using_iud past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x2: reghdfe using_iud past_group TC_noborder $x2list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x3: reghdfe using_iud past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x4: reghdfe using_iud past_group TC_noborder $x4list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud_x5: reghdfe using_iud past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display IUD results
esttab iud_x1 iud_x2 iud_x3 iud_x4 iud_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on IUD Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

eststo clear

* Injection - all 5 specifications
eststo inj_x1: reghdfe using_injection past_group TC_noborder $x1list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x2: reghdfe using_injection past_group TC_noborder $x2list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x3: reghdfe using_injection past_group TC_noborder $x3list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x4: reghdfe using_injection past_group TC_noborder $x4list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo inj_x5: reghdfe using_injection past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display injection results
esttab inj_x1 inj_x2 inj_x3 inj_x4 inj_x5, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effect on Injection Use") ///
    mtitles("Spec 1" "Spec 2" "Spec 3" "Spec 4" "Spec 5") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared"))

*---------------------------------------------------------------*
* Combined Table: All Outcomes with Full Specification (x5)
*---------------------------------------------------------------*

eststo clear

* Run full specification for all outcomes
eststo any: reghdfe using_any_contraceptive past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo modern: reghdfe using_modern past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo traditional: reghdfe using_traditional past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo pill: reghdfe using_pill past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo iud: reghdfe using_iud past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)
eststo injection: reghdfe using_injection past_group TC_noborder $x5list [pweight = weight], absorb(Area_unit Res_BY) vce(cluster Area_unit)

* Display combined table
esttab any modern traditional pill iud injection, ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effects on Contraceptive Use - Full Specification") ///
    mtitles("Any" "Modern" "Traditional" "Pill" "IUD" "Injection") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area_unit level" ///
                     "All specifications include full controls (x5list)" ///
                     "Area_unit and birth year fixed effects included")

* Export combined table to LaTeX
esttab any modern traditional pill iud injection using "table_contraceptive_all_outcomes.tex", ///
    replace booktabs ///
    keep(TC_noborder) ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    title("Treatment Effects on Contraceptive Use - Full Specification") ///
    mtitles("Any" "Modern" "Traditional" "Pill" "IUD" "Injection") ///
    stats(N r2_a, fmt(0 3) labels("Observations" "Adjusted R-squared")) ///
    nonotes addnotes("Robust standard errors clustered at Area\_unit level" ///
                     "All specifications include full controls" ///
                     "Area\_unit and birth year fixed effects included")

*---------------------------------------------------------------*
* Summary statistics for contraceptive outcomes
*---------------------------------------------------------------*

* Overall means
summarize using_any_contraceptive using_modern using_traditional ///
         using_pill using_iud using_injection [aweight=weight]

* By treatment group
bysort TC_noborder: summarize using_any_contraceptive using_modern using_traditional ///
                               using_pill using_iud using_injection [aweight=weight]

* Create summary table
eststo clear
estpost tabstat using_any_contraceptive using_modern using_traditional ///
                using_pill using_iud using_injection [aweight=weight], ///
                by(TC_noborder) statistics(mean sd) columns(statistics)

esttab using "table_contraceptive_summary.tex", replace ///
    cells("mean(fmt(3)) sd(fmt(3))") ///
    title("Summary Statistics: Contraceptive Use by Treatment Group") ///
    nonumber nomtitle noobs booktabs

