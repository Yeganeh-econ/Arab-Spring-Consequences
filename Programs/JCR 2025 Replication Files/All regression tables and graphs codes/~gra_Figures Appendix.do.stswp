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
				
* Vaccination ratio (Graphs divided into two sections)
* Appendix Figure 1. Possible Influential Channels - Vaccination Female Ratio, Vaccination Male Ratio, and Relative Vaccination Female-to-Male Ratio

* Ratio of Female Vaccinations
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
	
* Ratio of Male Vaccinations
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
	
graph combine Female_Vac_Relative_Ratio Male_Vac_Relative_Ratio, cols(2) name(combined_graph, replace)
graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure6_fandm_vac_rate.pdf", replace

	
exit