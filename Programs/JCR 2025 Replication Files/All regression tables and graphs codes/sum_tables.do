*All summary tables
clear all
capture log close
set maxvar 8000
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
		
*Table 1: Summary Statistics
*Aggregate observations information
	use "cr_master_UR", clear
						
	drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35 //border governates
		
	count
	g N=r(N)
	
	*religion rename
	rename religionrate1 muslim_rate		
	rename religionrate1_christian christian_rate	
	rename religionrate1_unknown unknownreligion_rate		
	
	collapse (mean) reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13 hedurate10 hedurate11 hedurate12 hedurate13 reponsewrate1 hwork_char10 ///
	hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899 hhfemale_rate ///
	muslim_rate christian_rate unknownreligion_rate urbanrate1 age hhsize femalesize hhage v201 husbage weath_index N (sd) sdage=age sdhhsize=hhsize sdfemalesize=femalesize ///
	sdhhage=hhage sdv201=v201 sdhusbage=husbage sdweath_index=weath_index
	
	*renmae respondents' education
	rename (reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13) (r_noeducation r_primary r_secondary r_higher)
	
	*rename respondents' husbands' job
	rename (hedurate10 hedurate11 hedurate12 hedurate13) (h_noeducation h_primary h_secondary h_higher)
	
	*husbands' work
	rename (hwork_char10 hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899) ///
	(h_nowork h_tech h_clerial h_sale h_selfagric h_employeeagric h_services h_skilled h_unskilled h_unknown)
		
	rename (v201 sdv201) (all_children_ever_born sdall_children_ever_born)
	
	xpose,clear v
	move _varname v1
	
	rename v1 aggre_index
	
	g ID=_n
	sort ID
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_aggregate",replace

*Treatment group information
	use "cr_master_UR", clear
	
	drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35 //border governates
	
	keep if tgover==1 
	
	count
	g N=r(N)
	
	*religion rename
	rename religionrate1 muslim_rate		
	rename religionrate1_christian christian_rate	
	rename religionrate1_unknown unknownreligion_rate
	
	collapse (mean) reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13 hedurate10 hedurate11 hedurate12 hedurate13 reponsewrate1 hwork_char10 ///
	hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899 hhfemale_rate ///
	muslim_rate christian_rate unknownreligion_rate urbanrate1 age hhsize femalesize hhage v201 husbage weath_index N (sd) sdage=age sdhhsize=hhsize sdfemalesize=femalesize ///
	sdhhage=hhage sdv201=v201 sdhusbage=husbage sdweath_index=weath_index
	
	*renmae respondents' education
	rename (reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13) (r_noeducation r_primary r_secondary r_higher)
	
	*rename respondents' husbands' job
	rename (hedurate10 hedurate11 hedurate12 hedurate13) (h_noeducation h_primary h_secondary h_higher)
	
	*husbands' work
	rename (hwork_char10 hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899) ///
	(h_nowork h_tech h_clerial h_sale h_selfagric h_employeeagric h_services h_skilled h_unskilled h_unknown)
		
	rename (v201 sdv201) (all_children_ever_born sdall_children_ever_born)
	
	xpose,clear v
	move _varname v1
	
	rename v1 treatment_preindex
	
	g ID=_n
	sort ID

	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_treatment",replace
	
*Control group
	use "cr_master_UR", clear
	
	drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35 //border governates
	
	keep if tgover==0 
	
	count
	g N=r(N)
	
	*religion rename
	rename religionrate1 muslim_rate		
	rename religionrate1_christian christian_rate	
	rename religionrate1_unknown unknownreligion_rate
	
	collapse (mean) reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13 hedurate10 hedurate11 hedurate12 hedurate13 reponsewrate1 hwork_char10 ///
	hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899 hhfemale_rate ///
	muslim_rate christian_rate unknownreligion_rate urbanrate1 age hhsize femalesize hhage v201 husbage weath_index N (sd) sdage=age sdhhsize=hhsize sdfemalesize=femalesize ///
	sdhhage=hhage sdv201=v201 sdhusbage=husbage sdweath_index=weath_index
	
	*renmae respondents' education
	rename (reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13) (r_noeducation r_primary r_secondary r_higher)
	
	*rename respondents' husbands' job
	rename (hedurate10 hedurate11 hedurate12 hedurate13) (h_noeducation h_primary h_secondary h_higher)
	
	*husbands' work
	rename (hwork_char10 hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899) ///
	(h_nowork h_tech h_clerial h_sale h_selfagric h_employeeagric h_services h_skilled h_unskilled h_unknown)
		
	rename (v201 sdv201) (all_children_ever_born sdall_children_ever_born)
	
	xpose,clear v
	move _varname v1
	
	rename v1 control_preindex
	
	g ID=_n
	sort ID
	
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_control",replace
		
*Merge these two datasets
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_aggregate",clear
	sort ID, stable
	merge 1:1 ID using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_treatment"
		keep if _m==3
		drop _m 
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\sum1",replace
	sort ID, stable
	merge 1:1 ID using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_control"
		keep if _m==3
		drop _m 
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1 Summary Statistics", replace
export excel using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1 Summary Statistics", firstrow(variables) replace

*Difference between treatment and control groups
	*use "tem_master_age1_UR", clear	
	use "cr_master_UR", clear
	
	*drop if tgover==.
	drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35
		
	*count if tgover==1
	*g Nt=r(N)
	
	*count if tgover==0	
	*g Nc=r(N)
	*religion rename
	rename religionrate1 muslim_rate		
	rename religionrate1_christian christian_rate	
	rename religionrate1_unknown unknownreligion_rate
	
	*renmae respondents' education
	rename (reponseedurate10 reponseedurate11 reponseedurate12 reponseedurate13) (r_noeducation r_primary r_secondary r_higher)
		
	*husbands' work
	rename (hwork_char10 hwork_char11 hwork_char12 hwork_char13 hwork_char14 hwork_char15 hwork_char17 hwork_char18 hwork_char19 hwork_char19899) ///
	(h_nowork h_tech h_clerial h_sale h_selfagric h_employeeagric h_services h_skilled h_unskilled h_unknown)
		
	rename (v201) (all_children_ever_born)
	
	local varlist1 r_noeducation r_primary r_secondary r_higher h_noeducation h_primary h_secondary h_higher reponsewrate1 h_nowork ///
	h_tech h_clerial h_sale h_selfagric h_employeeagric h_services h_skilled h_unskilled h_unknown hhfemale_rate ///
	muslim_rate christian_rate unknownreligion_rate urbanrate1 age hhsize femalesize hhage all_children_ever_born husbage weath_index	
	
	eststo clear
	foreach var of local varlist1 {
								eststo:quietly: reg `var' tgover
									}
	
	esttab,r2 se title(sum difference) keep(tgover)append starlevels(* 0.10 ** 0.05 *** 0.01)
	esttab using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table1_difference.csv", keep(tgover) label se title(sum difference) replace starlevels(* 0.10 ** 0.05 *** 0.01)
	
	
*Table 2: Summary Statistics on Reference Countries and Egypt
*national level indexes	
	use "cr_master_UR", clear

*DHS' relative death ratio, male death rate, female death rate by national wide
	drop if year<2007

		g dr1m_DHS_national=.
		g dr1f_DHS_national=.

	forvalues i=2007(1)2014{

		replace dr1m_DHS_national=drate_national11 if year==`i'
		replace dr1f_DHS_national=drate_national12 if year==`i'
		
	}
	
	bysort year : g drelative1_DHS_national=dr1f_DHS_national/dr1m_DHS_national
		
*Referenced countries - developed countries
		g drelative1_developed=.
		g dr1f_developed=.
		g dr1m_developed=.
			
	forvalues i=2007(1)2014 {
			
*Referenced countries - developed countires' relative death ratio, male death rate, female death rate
		replace drelative1_developed=d`i'21/d`i'11 if year==`i'
		replace dr1f_developed=d`i'21 if year==`i'
		replace dr1m_developed=d`i'11 if year==`i'
		
	}

		drop if tgover==.
		drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35	
				
		collapse (mean) dr1f_developed dr1m_developed drelative1_developed dr1f_DHS_national dr1m_DHS_national drelative1_DHS_national [aweight=weight] if dr1f_DHS_national!=. & dr1m_developed!=. , by (year)
		export excel using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table2_Summary Statistics of Death Ratios in the Reference Group and Egypt from 2007 to 2014", firstrow(variables) replace	


*Table 3: Summary Statistics of Death Ratios in High- and Low-Protest Areas in Egypt 
	*treatment and control group indexes
	
	*treatment group	
	use "cr_master_UR", clear
	
		drop if tgover==.
		drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35
				
		sort tgover year
		
		*keep if tgover==1
		keep if tgover_ur==1
				
		bysort year : g drelative1_DHS=ddrate12/ddrate11
		*replace ddrate1`j'=dndeath1`j'/dtpeople1`j'
			
		collapse (mean) ddrate12 ddrate11 drelative1_DHS muw1 piw1 missingwomen1, by (tgover_ur year)
		rename (ddrate12 ddrate11 drelative1_DHS muw1 piw1 missingwomen1) (FemaleDR_T MaleDR_T RelativeDR_T Muw_T Pi_T Missingwomen_T)
		
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table3_treatment",replace

	*control group	
	use "cr_master_UR", clear
		drop if tgover==.
		drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35
				
		sort tgover year
		
		*keep if tgover==0
		keep if tgover_ur==0
		
		bysort year : g drelative1_DHS=ddrate12/ddrate11
			
		collapse (mean) ddrate12 ddrate11 drelative1_DHS muw1 piw1 missingwomen1, by (tgover_ur year)
		rename (ddrate12 ddrate11 drelative1_DHS muw1 piw1 missingwomen1) (FemaleDR_C MaleDR_C RelativeDR_C Muw_C Pi_C Missingwomen_C)
		
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table3_control",replace

	*Merge these two datasets
	use "Table3_treatment", clear
	
		sort year, stable
		merge 1:1 year using "Table3_control"

		keep if _m==3
		drop _m 
	
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table 3_Summary Statistics of Death Ratios in High- and Low-Protest Areas in Egypt ", replace
	export excel using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table 3_Summary Statistics of Death Ratios in High- and Low-Protest Areas in Egypt ", firstrow(variables) replace	
	
	
*Table 4: Differences in Death Ratios in Protest Areas in Egypt	
	use "cr_master_UR", clear
	
		drop if tgover==.
		drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35
				
		sort tgover year
			
		sort tgover year
		
		bysort year : g drelative1_DHS=ddrate12/ddrate11

		rename (ddrate12 ddrate11 drelative1_DHS muw1 piw1 missingwomen1) (FemaleDR_C MaleDR_C RelativeDR_C Muw_C Pi_C Missingwomen_C)	
		local varlist1 FemaleDR_C MaleDR_C RelativeDR_C Muw_C Pi_C Missingwomen_C

		svyset [pweight=weight], strata(tgover)
		eststo clear
		foreach var of local varlist1 {
		forvalues i=2007(1)2014	{
						
									eststo:quietly reg `var' tgover if year==`i'
		}
		}
		
		esttab,r2 se title(sum difference) keep(tgover)append starlevels(* 0.10 ** 0.05 *** 0.01)
		esttab using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\results\Table 4_Differences in Death Ratios in High- and Low-Protest Areas in Egypt.csv", keep(tgover) label se title(sum difference) replace starlevels(* 0.10 ** 0.05 *** 0.01)
		
	
	exit 
