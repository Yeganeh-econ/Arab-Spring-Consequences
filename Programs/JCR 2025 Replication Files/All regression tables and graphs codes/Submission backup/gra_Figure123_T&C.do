* Verification of the classification of treatment and control groups for injuries and arrests
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
		local path "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned revolution\" 
		}
		if `user'==4 {
		local path "..." 
		}

		cd "`path'"
*Figure 1. Group Classification - Aggregate Level (All Phases Together)
*All Arab Spring Events - Deaths, Injuries, Arrests
use "tem_revolution", clear

	twoway (scatter nGovernates de_agg, xline(1.175647, lp(dash) lcolor(black)) mcolor(black) msymbol(sh) mlabsize(vsmall)) ///
	(scatter nGovernates inj_agg, xline(14.08108, lp(dash) lcolor(blue)) mcolor(blue) msymbol(dh) mlabsize(vsmall)) ///
	(scatter nGovernates arr_agg, xline(36.5512, lp(dash) lcolor(purple)) mcolor(purple) msymbol(th) mlabsize(vsmall)) ///
	(scatter nGovernates total_agg, xline(47.54137, lp(dash) lcolor(orange)) mcolor(orange) msymbol(o) mlabsize(vsmall)), ///
	graphregion(color(white)) legend(col(4) order (1 2 3 4) label(1 "Fatalities") label(2 "Injured") label(3 "Arrests") label(4 "Total")) ///
	xlabel(1 14 36 44, add custom labcolor(black) angle(75) labsize(tiny)) ylabel(30 "Suez" 29 "Port said" 28 "Cairo" 27 "Alexandria" 26 "Ismailia" 25 "Menia" 24 "Giza" 23 "Damietta" 22 "Fayoum" 21 "Beni suef" 15 "Kafr elsheikh" 14 "Dakahlia" 13 "Gharbia" 12 "Asyout" 11 "Sharkia" 10 "Behera" 9 "Aswan" 8 "Luxur" 7 "Suhag" 6 "Kalyoubia" 5 "Minoufia" 4 "Qena", ///
	labsize(vsmall) angle(0)) xtitle("Case for 100,000 people") ytitle(Control                     Treatment) saving("gra_cla_entiretime", replace) 
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure1_Control and Treatment Group Classification.pdf", replace

*Figure 2. Control and Treatment Groups by Fatalities in Different Phases of Egyptian Protests
	*Phase 1 of the Arab Spring - Fatality Information Only
use "tem_revolution", clear

	replace nGovernates = 2 if Governates == "Menia"
	replace nGovernates = 3 if Governates == "Damietta"
	
	replace nGovernates = 23 if Governates == "Gharbia"
	replace nGovernates = 25 if Governates == "Behera"
	replace nGovernates = 31 if Governates == "Minoufia"
	
	twoway (scatter nGovernates de_ph1, xline(0.430865, lp(dash) lcolor(black)) mcolor(black) msymbol(t) msize(tiny) mlabsize(vsmall)), ///
	graphregion(color(white)) legend (on order(1 "Fatalities")) xlabel(0.43, add custom labcolor(black) angle(75) labsize(vsmall))  ylabel(30 "Suez" 29 "Port said" 28 "Cairo" 27 "Alexandria" 26 "Ismailia" 2 "Menia" 24 "Giza" 3 "Damietta" 22 "Fayoum" 21 "Beni suef" 15 "Kafr elsheikh" 14 "Dakahlia" 23 "Gharbia" 12 "Asyout" 11 "Sharkia" 25 "Behera" 9 "Aswan" 8 "Luxur" 7 "Suhag" 6 "Kalyoubia" 31 "Minoufia" 4 "Qena", ///
	labsize(tiny) angle(0)) xtitle("Case for 100,000 people in Phase 1") ytitle(Control            Treatment) saving("Figure2_phase1", replace)
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure2_phase1.pdf", replace

	* Phase 2 of the Arab Spring - Fatalities
use "tem_revolution", clear
	
	replace nGovernates = 1 if Governates == "Alexandria"
	replace nGovernates = 2 if Governates == "Beni suef"
	replace nGovernates = 3 if Governates == "Fayoum"
	
	replace nGovernates = 22 if Governates == "Aswan"
	replace nGovernates = 27 if Governates == "Gharbia"
	replace nGovernates = 21 if Governates == "Luxur"
	replace nGovernates = 31 if Governates == "Suhag"
	
	twoway (scatter nGovernates de_ph2, xline(0.1484878, lp(dash) lcolor(blue)) mcolor(blue) msymbol(d) msize(tiny) mlabsize(vsmall)), ///
	graphregion(color(white)) legend(on order(1 "Fatalities")) ///
	xlabel(0.15, add custom labcolor(blue) angle(75) labsize(vsmall)) ylabel(30 "Suez" 29 "Port said" 28 "Cairo" 1 "Alexandria" 26 "Ismailia" 25 "Menia" 24 "Giza" 23 "Damietta" 3 "Fayoum" 2 "Beni suef" 15 "Kafr elsheikh" 14 "Dakahlia" 27 "Gharbia" 12 "Asyout" 11 "Sharkia" 10 "Behera" 22 "Aswan" 21 "Luxur" 31 "Suhag" 6 "Kalyoubia" 5 "Minoufia" 4 "Qena", ///
	labsize(tiny) angle(0)) xtitle("Case for 100,000 people in Phase 2") ytitle(Control            Treatment) saving("Figure2_phase2", replace) 
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure2_phase2.pdf", replace
		
	* Phase 3 of the Arab Spring - Fatalities
use "tem_revolution", clear
	
	*For classification visual
	replace nGovernates = 3 if Governates == "Fayoum"
	replace nGovernates = 2 if Governates == "Damietta"	
	
	replace nGovernates = 22 if Governates == "Suhag"
	replace nGovernates = 23 if Governates == "Behera"
	replace nGovernates = 31 if Governates == "Kalyoubia"

	twoway (scatter nGovernates de_ph3, xline(0.2014573, lp(dash) lcolor(red)) xscale(range(0 9)) mcolor(red) msymbol(o) msize(tiny) mlabsize(vsmall)), ///
	graphregion(color(white)) legend( on order(1 "Fatalities")) ///
	xlabel(0.20, add custom labcolor(red) angle(75) labsize(vsmall)) ylabel(30 "Suez" 29 "Port said" 28 "Cairo" 27 "Alexandria" 26 "Ismailia" 25 "Menia" 24 "Giza" 2 "Damietta" 3 "Fayoum" 21 "Beni suef" 15 "Kafr elsheikh" 14 "Dakahlia" 13 "Gharbia" 12 "Asyout" 11 "Sharkia" 23 "Behera" 9 "Aswan" 8 "Luxur" 22 "Suhag" 31 "Kalyoubia" 5 "Minoufia" 4 "Qena", ///
	labsize(tiny) angle(0)) xtitle("Case for 100,000 people in Phase 3") ytitle(Control            Treatment) saving("Figure2_phase3", replace) 
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure2_phase3.pdf", replace
	
	* Phase 4 of the Arab Spring - Fatalities
use "tem_revolution", clear
	
	replace nGovernates = 31 if Governates == "Suhag"

	twoway (scatter nGovernates de_ph4, xline(0.6713603, lp(dash) lcolor(purple)) mcolor(purple) msymbol(S) msize(tiny) mlabsize(vsmall)), ///
	graphregion(color(white)) legend( on order(1 "Fatalities")) xlabel(0.67, add custom labcolor(purple) angle(75) labsize(vsmall)) ylabel(30 "Suez" 29 "Port said" 28 "Cairo" 27 "Alexandria" 26 "Ismailia" 25 "Menia" 24 "Giza" 23 "Damietta" 22 "Fayoum" 21 "Beni suef" 15 "Kafr elsheikh" 14 "Dakahlia" 13 "Gharbia" 12 "Asyout" 11 "Sharkia" 10 "Behera" 9 "Aswan" 8 "Luxur" 31 "Suhag" 6 "Kalyoubia" 5 "Minoufia" 4 "Qena", ///
	labsize(tiny) angle(0)) xtitle("Case for 100,000 people in Phase 4") ytitle(Control            Treatment) saving("Figure2_phase4", replace) 
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure2_phase4.pdf", replace
		
	*combine all different graphs together
	gr combine "Figure2_phase1.gph" "Figure2_phase2.gph" "Figure2_phase3.gph" "Figure2_phase4.gph"
	
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure2_Control and Treatment Groups in Different Phases of Egyptian Protests.pdf", replace

* Figure 3. Group Classification from SYPE
* This graph further validates the treatment and control groups using another dataset.
* The following "replace" codes are for visualization purposes only; no other changes are made
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned SYPE\cr_SYPE", clear

	*treatment group classification
	replace governates = 41 if governates == 1
	replace governates = 40 if governates == 2
	replace governates = 39 if governates == 3
	replace governates = 38 if governates == 4
	replace governates = 37 if governates == 6
	replace governates = 36 if governates == 11
	replace governates = 35 if governates == 13
	replace governates = 34 if governates == 14
	replace governates = 33 if governates == 17
	replace governates = 32 if governates == 19
	replace governates = 31 if governates == 23
	
	*control group classification
	replace governates = 19 if governates == 12
	replace governates = 20 if governates == 15
	replace governates = 21 if governates == 16
	replace governates = 23 if governates == 25
	replace governates = 17 if governates == 26
	replace governates = 16 if governates == 27
	replace governates = 15 if governates == 28
	replace governates = 14 if governates == 29
	
	twoway (scatter governates protest_intensity, xline(0.0734824, lp(dash) lcolor(blue)) mcolor(blue) msymbol(t) mlabsize(vsmall)), ///
	graphregion(color(white)) legend (on order(1 "Protest participation intensity")) xlabel(0.073, add custom labcolor(blue) angle(75) labsize(vsmall)) ylabel(41 "Cairo" 40 "Alexandria" 39 "Port said" 38 "Suez" 37 "Giza" 36 "Damietta" 35 "Sharkia" 34 "Kalyoubia" 33 "Minoufia" 32 "Ismailia" 31 "Fayoum" 14 "Luxur" 15 "Aswan" 16 "Qena" 17 "Suhag" 18 "Behera" 19 "Dakahlia" 20 "Kafr elsheikh" 21 "Gharbia"  22 "Beni suef" 24 "Menia" 23 "Asyout", labsize(vsmall) angle(0)) ytitle(Control                           Treatment) saving("Figure3_SYPE", replace)
	graph export "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Figure3_Control and Treatment Group Groups using SYPE.pdf", replace

exit