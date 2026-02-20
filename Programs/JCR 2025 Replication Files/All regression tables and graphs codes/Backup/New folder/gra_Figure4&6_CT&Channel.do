
										
clear all
capture log close
set more off

		local user=3  // 1: Firat Demir, 2: Pallab Ghosh, 3 Zhengang Xu, 4 Editor
		if `user'==1 {
		local path "C:\Users\hugue\Dropbox\Workspace\1.Projects\Women\"
		}
		if `user'==2 {
		local path "C:\Users\deboutin\Dropbox\H. Research\En cours\Women\" 
		}
		if `user'==3 {
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\" 
		}
		if `user'==4 {
		local path "..." 
		}

		cd "`path'"		
* Figure 4. Missing women trend before and after the Arab Spring
	*Ray's missing women calculations in different age groups - DID Common Trend Checking	
use "cr_master_UR.dta", clear	
		collapse (mean) missingwomen1, by(tgover_ur year)
		
		twoway (line missingwomen1 year if tgover_ur==0, xline(2011 2012 2013, lp(dash))  lcolor(black) mcolor(black)) (connected missingwomen1 year if tgover_ur==0, msymbol(X)  lcolor(black) mcolor(black)) ///
		(line missingwomen1 year if tgover_ur==1, xline(2011 2012 2013, lp(dash)) lcolor(blue)  mcolor(blue)) (connected missingwomen1 year if tgover_ur==1, msymbol(d) lcolor(blue)  mcolor(blue) lp(dash)) ///
		, graphregion(color(white)) legend(order (2 4) label(2 "control areas") label(4 "treatment areas")) xtitle(Year) ytitle(Missing women)
		graph export "Figure4_common_trend_ray'smeasure.pdf", replace
		
* Vaccination ratio (All graphs in two sections)
* Figure 6. Possible influencial channels - vaccination female/male ratio
use "cr_master_UR.dta", clear
drop if vaccination == .
collapse (mean) vac_rate01_fm, by(tgover_ur year)

* Vac graph (f/m vaccination ratio overall)
twoway ///
    (line vac_rate01_fm year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected vac_rate01_fm year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line vac_rate01_fm year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected vac_rate01_fm year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(Vaccination) name(Vac_Relative_Ratio, replace)

* Ratio of female vacation
use "cr_master_UR.dta", clear
drop if vaccination == .
collapse (mean) vac_rate01_f, by(tgover_ur year)

twoway ///
    (line vac_rate01_f year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected vac_rate01_f year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line vac_rate01_f year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected vac_rate01_f year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(Female Vaccination) name(Female_Vac_Relative_Ratio, replace)
	
* Ratio of male vacation
use "cr_master_UR.dta", clear
drop if vaccination == .
collapse (mean) vac_rate01_m, by(tgover_ur year)

twoway ///
    (line vac_rate01_m year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected vac_rate01_m year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line vac_rate01_m year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected vac_rate01_m year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(Male Vaccination) name(Male_Vac_Relative_Ratio, replace)	
	
graph combine Vac_Relative_Ratio Female_Vac_Relative_Ratio Male_Vac_Relative_Ratio, cols(2) name(combined_graph, replace)
graph export "Vacination_R.pdf", replace

* Labor force participation-overall
use "cr_master_UR.dta", clear
drop if work_rate == .
collapse (mean) work_rate missingwomen1 relativeDHSDR1, by(tgover_ur year_indicator year)

twoway ///
    (line work_rate year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected work_rate year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line work_rate year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected work_rate year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(LP Rate(Overall)) name(LP_Overall_graph, replace)

* Labor force participation-overall in different age groups
* age15 to age24
use "cr_master_UR.dta", clear
drop if work_rate_1524 == .
collapse (mean) work_rate_1524, by(tgover_ur year_indicator year)

twoway ///
    (line work_rate_1524 year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected work_rate_1524 year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line work_rate_1524 year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected work_rate_1524 year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(LP Rate(15-24)) name(LP_1524_graph, replace)
	
* age25 to age34
use "cr_master_UR.dta", clear
drop if work_rate_2534 == .
collapse (mean) work_rate_2534, by(tgover_ur year_indicator year)

twoway ///
    (line work_rate_2534 year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected work_rate_2534 year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line work_rate_2534 year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected work_rate_2534 year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(LP Rate(25-34)) name(LP_2534_graph, replace)
		
* age35 to age49
use "cr_master_UR.dta", clear
drop if work_rate_3549 == .
collapse (mean) work_rate_3549, by(tgover_ur year_indicator year)

twoway ///
    (line work_rate_3549 year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected work_rate_3549 year if tgover_ur == 1 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(d) lcolor(blue) mcolor(blue)) ///
    (line work_rate_3549 year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected work_rate_3549 year if tgover_ur == 0 & ((year==2008 & year_indicator==2008)| year==2014), msymbol(X) lcolor(black) mcolor(black)) ///   
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(LP Rate(35-49)) name(LP_3549_graph, replace)
	
* combine all labor participation graphs
graph combine LP_Overall_graph LP_1524_graph LP_2534_graph LP_3549_graph, cols(2) name(LP_combined_graph, replace)
graph export "LP.pdf", replace	
	

* Domestic violence - overall
use "cr_master_UR.dta", clear
drop if dv_rate01 == .
collapse (mean) dv_rate01, by(tgover_ur year)
* Overall
twoway ///
    (line dv_rate01 year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected dv_rate01 year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
	(line dv_rate01 year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected dv_rate01 year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(Overall DV Ratio) name(DV_overall, replace)

* Domestic violence - different age groups
use "cr_master_UR.dta", clear
drop if dv_rate15 == .
collapse (mean) dv_rate15, by(tgover_ur year)
twoway ///
    (line dv_rate15 year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected dv_rate15 year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
	(line dv_rate15 year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected dv_rate15 year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(DV Ratio 15-24) name(DV_1524, replace)
	
use "cr_master_UR.dta", clear
drop if dv_rate25 == .
collapse (mean) dv_rate25, by(tgover_ur year)
twoway ///
    (line dv_rate25 year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected dv_rate25 year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
	(line dv_rate25 year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected dv_rate25 year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(DV Ratio 25-34) name(DV_2534, replace)
	
use "cr_master_UR.dta", clear
drop if dv_rate35 == .
collapse (mean) dv_rate35, by(tgover_ur year)
twoway ///
    (line dv_rate35 year if tgover_ur == 1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected dv_rate35 year if tgover_ur == 1, msymbol(d) lcolor(blue) mcolor(blue)) ///
	(line dv_rate35 year if tgover_ur == 0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected dv_rate35 year if tgover_ur == 0, msymbol(X) lcolor(black) mcolor(black)) ///
    , graphregion(color(white)) legend(col(1) order (2 "treatment areas" 4 "control areas") size(small) position(6)) ///
    xtitle(Year) ytitle(DV Ratio 35-49) name(DV_3549, replace)	
	
graph combine DV_overall DV_1524 DV_2534 DV_3549, cols(2) name(DV_combined, replace)
graph export "DV_Ratio.pdf", replace
********************************************************************************
********************************************************************************
* Next Step Average Birth Space between children



exit

*
browse governates_ur year year_indicator work_num p_govur work_rate work_num_1524 p_govur_1524 work_rate_1524 work_num_2534 p_govur_2534 work_rate_2534 work_num_3549 p_govur_3549 work_rate_3549