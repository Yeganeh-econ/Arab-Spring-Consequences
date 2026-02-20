* Individual information for checking influence channels - different governates urban and rural levels
clear all
capture log close
set more off

use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\source\DHS raw\DHS 2008\EGIR5ADT\EGIR5AFL.dta"
	
	keep v001 v002 v003 v004 v714 v025 sgovern v012 v743d v743b v743a
	drop if sgovern==34| sgovern==35
	
	rename (v025 sgovern v714 v012) (urban_rural08 governates08 work08 age)
	
	* Aggregate labor-force participation	
	g tgover_ur_P08=.
	g tgover_ur_LB08=.
	g tgover_ur_LB_Rate08=.
	
	* Population count
	forvalues j = 1 / 2 {
	foreach k of numlist 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
			qui count if  urban_rural08== `j' &  governates08== `k'
			replace tgover_ur_P08 = r(N) if urban_rural08== `j' &  governates08== `k'
	}
	}

	* Labor force count
	forvalues i=0 / 1 {
	forvalues j = 1 / 2 {
	foreach k of numlist 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
			qui count if  urban_rural08== `j' &  governates08== `k' & work08==`i'
			replace tgover_ur_LB08 = r(N) if urban_rural08== `j' &  governates08== `k'
	}
	}
	}
	
	* Labor force participation rate
	forvalues j = 1 / 2 {
	foreach k of numlist 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
			
			replace tgover_ur_LB_Rate08 = tgover_ur_LB08/tgover_ur_P08 if urban_rural08== `j' &  governates08== `k'
	}
	}	
	
	* Labor force participation rates across different age groups	
	local i_list 1524 2534 3549

	foreach i in `i_list' {
		* Initialize variables
		g tgover_ur_P08_`i' = .
		g tgover_ur_LB08_`i' = .
		g tgover_ur_LB_Rate08_`i' = .

		* Define age range based on i
		local age_start = .
		local age_end = .

		if `i' == 1524 {
			local age_start = 15
			local age_end = 24
		}
		else if `i' == 2534 {
			local age_start = 25
			local age_end = 34
		}
		else if `i' == 3549 {
			local age_start = 35
			local age_end = 49
		}

		* Loop for population count of individuals aged 15-25
		forvalues j = 1 / 2 {
			foreach k in 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
				qui count if urban_rural08 == `j' & governates08 == `k' & (age >= `age_start' & age <= `age_end')
				replace tgover_ur_P08_`i' = r(N) if urban_rural08 == `j' & governates08 == `k'
		}
		}

		* Loop for labor force count
		forvalues j = 1 / 2 {
			foreach k in 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
				qui count if urban_rural08 == `j' & governates08 == `k' & work08 == 1 & (age >= `age_start' & age <= `age_end')
				replace tgover_ur_LB08_`i' = r(N) if urban_rural08 == `j' & governates08 == `k'
		}
		}

		* Loop for labor force participation rate
		forvalues j = 1 / 2 {
			foreach k in 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
				replace tgover_ur_LB_Rate08_`i' = tgover_ur_LB08_`i' / tgover_ur_P08_`i' if urban_rural08 == `j' & governates08 == `k'
		}
		}
	    }

	* Maintain the first row of repeated labor force participation rates
	bysort governates08 urban_rural08: g r=_n
	keep if r==1
	
	
	* Assign the same codes for the governorates in 2008 to those in 2014
	g mer_gover=.
	replace mer_gover= 1 if governates08==1 & urban_rural08==1
	replace mer_gover= 3 if governates08==2 & urban_rural08==1
	replace mer_gover= 4 if governates08==2 & urban_rural08==2
	replace mer_gover= 5 if governates08==3 & urban_rural08==1
	replace mer_gover= 7 if governates08==4 & urban_rural08==1
	replace mer_gover= 9 if governates08==11 & urban_rural08==1
	replace mer_gover= 10 if governates08==11 & urban_rural08==2
	replace mer_gover= 11 if governates08==12 & urban_rural08==1
	replace mer_gover= 12 if governates08==12 & urban_rural08==2
	replace mer_gover= 13 if governates08==13 & urban_rural08==1
	replace mer_gover= 14 if governates08==13 & urban_rural08==2
	replace mer_gover= 15 if governates08==14 & urban_rural08==1
	replace mer_gover= 16 if governates08==14 & urban_rural08==2
	replace mer_gover= 17 if governates08==15 & urban_rural08==1
	replace mer_gover= 18 if governates08==15 & urban_rural08==2
	replace mer_gover= 19 if governates08==16 & urban_rural08==1
	replace mer_gover= 20 if governates08==16 & urban_rural08==2
	replace mer_gover= 21 if governates08==17 & urban_rural08==1
	replace mer_gover= 22 if governates08==17 & urban_rural08==2
	replace mer_gover= 23 if governates08==18 & urban_rural08==1
	replace mer_gover= 24 if governates08==18 & urban_rural08==2
	replace mer_gover= 25 if governates08==19 & urban_rural08==1
	replace mer_gover= 26 if governates08==19 & urban_rural08==2
	replace mer_gover= 27 if governates08==21 & urban_rural08==1
	replace mer_gover= 28 if governates08==21 & urban_rural08==2
	replace mer_gover= 29 if governates08==22 & urban_rural08==1
	replace mer_gover= 30 if governates08==22 & urban_rural08==2
	replace mer_gover= 31 if governates08==23 & urban_rural08==1
	replace mer_gover= 32 if governates08==23 & urban_rural08==2
	replace mer_gover= 33 if governates08==24 & urban_rural08==1
	replace mer_gover= 34 if governates08==24 & urban_rural08==2
	replace mer_gover= 35 if governates08==25 & urban_rural08==1
	replace mer_gover= 36 if governates08==25 & urban_rural08==2
	replace mer_gover= 37 if governates08==26 & urban_rural08==1
	replace mer_gover= 38 if governates08==26 & urban_rural08==2
	replace mer_gover= 39 if governates08==27 & urban_rural08==1
	replace mer_gover= 40 if governates08==27 & urban_rural08==2
	replace mer_gover= 41 if governates08==28 & urban_rural08==1
	replace mer_gover= 42 if governates08==28 & urban_rural08==2
	replace mer_gover= 43 if governates08==29 & urban_rural08==1
	replace mer_gover= 44 if governates08==29 & urban_rural08==2
	replace mer_gover= 45 if governates08==31 & urban_rural08==1
	replace mer_gover= 46 if governates08==31 & urban_rural08==2
	replace mer_gover= 47 if governates08==32 & urban_rural08==1
	replace mer_gover= 48 if governates08==32 & urban_rural08==2
	replace mer_gover= 49 if governates08==33 & urban_rural08==1
	replace mer_gover= 50 if governates08==33 & urban_rural08==2
	
	g year=2008
	
	* Ensure consistent naming conventions when appending with the 2014 DHS data
	rename mer_gover governates_ur
	g urban=(urban_rural08==1)
	drop urban_rural08
	rename work08 work
	
	* Aggregate 
	rename (v001 v002 v003 v004) (clusterid hhid rlineid area) //because of keeping the first row, this information is not important now
	rename tgover_ur_P08 p_govur
	rename tgover_ur_LB08 work_num
	rename tgover_ur_LB_Rate08 work_rate
	
	* Different age groups
	foreach i in 1524 2534 3549 {
		rename tgover_ur_P08_`i' p_govur_`i'
		rename tgover_ur_LB08_`i' work_num_`i'
		rename tgover_ur_LB_Rate08_`i' work_rate_`i'
	}
	
	* Generate indices for the treatment and control groups
	* Create dummy variables for treatment and control areas based on urban and rural levels as per DHS2014
	recode governates_ur (1 3 4 5 7 9 10 25 26 27 28 29 30 31 32 33 34=1) (11 12 13 14 15 16 17 18 19 20 21 22 23 24 35 36 37 38 39 40 41 42 43 44=0), gen (tgover_ur)
	label var tgover_ur "treatment ares"
	label define tgover_urtd 1 "treated" 0 "control"
	label values tgover_ur tgover_urtd
	
	* Indicator for 2008 data
	g year_indicator=2008
	

* Measurement of women's family power
	* Ternary dummies
		* Visit family or relative  
		g visit_ternary=0 if v743d==4 | v743d==5 | v743d==6 | v743d==.
		replace visit_ternary=1 if v743d==2
		replace visit_ternary=2 if v743d==1

		label var visit_ternary "ternary visiting family or relative"
		label define visit_ternaryd 0 "husband decided alone" 1 "decided jointly" 2 "wife decided alone"
		label values visit_ternary visit_ternaryd
		
		* Main purchase decision
		g pur_ternary=0 if v743b==4 | v743b==5 | v743b==6 | v743b==.
		replace pur_ternary=1 if v743b==2
		replace pur_ternary=2 if v743b==1
		
		label var pur_ternary "ternary household purchase decision"
		label define pur_ternaryd 0 "husband decided alone" 1 "decided jointly" 2 "wife decided alone"
		label values pur_ternary pur_ternaryd		
		
		* Respondent health condition
		g health_ternary=0 if v743a==4 | v743a==5 | v743a==6 | v743a==.
		replace health_ternary=1 if v743a==2
		replace health_ternary=2 if v743a==1

		label var health_ternary "response health condition decision"
		label define health_ternaryd 0 "husband decided alone" 1 "decided jointly" 2 "wife decided alone"
		label values health_ternary health_ternaryd			
	

save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\lp_2008.dta", replace
	
exit
	
