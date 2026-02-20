* Figure 4
* Figure 6								
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
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\" 
		}
		if `user'==4 {
		local path "..." 
		}

		cd "`path'"		
		
* Figure 4. Trend of missing women before and after the Arab Spring
	* Difference-in-Differences (DID) Common Trend Checking

use "cr_master_UR.dta", clear
collapse (mean) missingwomen1, by(tgover_ur year)

twoway ///
    (line missingwomen1 year if tgover_ur==0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected missingwomen1 year if tgover_ur==0, msymbol(X) lcolor(black) mcolor(black)) ///
    (line missingwomen1 year if tgover_ur==1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected missingwomen1 year if tgover_ur==1, msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) ///
           label(2 "control areas") label(4 "treatment areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle(Year) ytitle("Missing women")

graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure4_common_trend.pdf", replace


* Figure 6 Vaccination Female-to-Male Ratio
use "cr_master_UR.dta", clear
drop if vaccination == .
collapse (mean) vac_rate01_fm, by(tgover_ur year)

twoway ///
    (line vac_rate01_fm year if tgover_ur==0, xline(2011 2012 2013, lp(dash)) lcolor(black) mcolor(black)) ///
    (connected vac_rate01_fm year if tgover_ur==0, msymbol(X) lcolor(black) mcolor(black)) ///
    (line vac_rate01_fm year if tgover_ur==1, xline(2011 2012 2013, lp(dash)) lcolor(blue) mcolor(blue)) ///
    (connected vac_rate01_fm year if tgover_ur==1, msymbol(d) lcolor(blue) mcolor(blue) lp(dash)), ///
    graphregion(color(white)) ///
    legend(order(2 4) ///
		   label(2 "control areas") label(4 "treatment areas") ///
           position(6) ring(1) cols(1)) ///
    xtitle(Year) ytitle(Vaccination)

graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure6_Influencial Channels_vacfm_ratio.pdf", replace

exit