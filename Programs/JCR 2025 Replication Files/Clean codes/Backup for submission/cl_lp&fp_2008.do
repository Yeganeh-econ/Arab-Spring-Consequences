* Individual information for checking influence channels
clear all
capture log close
set more off
	
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\source\DHS raw\DHS 2008\EGIR5ADT\EGIR5AFL.dta"
	keep caseid v001 v002 v003 v004 v005 v714 v025 sgovern v012 v743d v743b v743a b4_01 v730 v705 bord_01 v137 v130 v106 v701 v190 v744a v744b v744c v744d v744e v811 v812 v813 v814
	drop if sgovern==34| sgovern==35 //drop border gonverates
	
	rename (v025 sgovern v714 v012 b4_01 v730 v705 bord_01 v137 v130 v106 v701 v190 v005) (urban_rural08 governates08 work08 age b_gender age_husband hwork b_ord nb_child religion education heducation weath_index weight)
		
	* Calculate survey weights based on the descriptions provided in the survey questions 
	replace weight=weight/1000000
	
	* Employment status index
	g husband_work= (hwork!=0)
	replace husband_work=. if hwork>=98
	label var husband_work "husband work or not"
	label define husband_workd 1 "husband works" 0 "husband does not work"
	label values husband_work husband_workd
	
	* Religious affiliation index
	replace religion=0 if religion==2
	replace religion=. if religion==99
	label var religion "Muslem or Christian"
	label define religiond 1 "Muslem" 0 "Christian"
	label values religion religiond	

	* Dummy variables for education levels
	g noeducation= (education==0)
	g primary= (education==1)
	g secondary= (education==2)
	g higher= (education==3)
	
	* Dummy variables for husband's education levels
	g h_noeducation= (heducation==0)
	g h_primary= (heducation==1)
	g h_secondary= (heducation==2)
	g h_higher= (heducation==3)
	
	* Dummy variables for wealth index
	g poorest= (weath_index==1)
	g poorer= (weath_index==2)
	g middle= (weath_index==3)
	g richer= (weath_index==4)	
	g richest= (weath_index==4)		
	
	* Aggregate labor force participation rate	
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

		* Loop for 15-25 population count
		forvalues j = 1 / 2 {
			foreach k in 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
				qui count if urban_rural08 == `j' & governates08 == `k' & (age >= `age_start' & age <= `age_end')
				replace tgover_ur_P08_`i' = r(N) if urban_rural08 == `j' & governates08 == `k'
			}
		}

		* Loop for labor count
		forvalues j = 1 / 2 {
			foreach k in 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
				qui count if urban_rural08 == `j' & governates08 == `k' & work08 == 1 & (age >= `age_start' & age <= `age_end')
				replace tgover_ur_LB08_`i' = r(N) if urban_rural08 == `j' & governates08 == `k'
			}
		}

		* Loop for labor participation rate
		forvalues j = 1 / 2 {
			foreach k in 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 34 35 {
				replace tgover_ur_LB_Rate08_`i' = tgover_ur_LB08_`i' / tgover_ur_P08_`i' if urban_rural08 == `j' & governates08 == `k'
			}
		}
	}

	* Assign the governorates in 2008 the same codes as those in 2014.
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
	* Create dummy variables for treatment and control areas based on urban and rural levels, excluding border governorates, for JDE data
	recode governates_ur (1 3 4 5 7 9 10 25 26 27 28 29 30 31 32 33 34=1) (11 12 13 14 15 16 17 18 19 20 21 22 23 24 35 36 37 38 39 40 41 42 43 44=0), gen (tgover_ur)
	label var tgover_ur "treatment ares"
	label define tgover_urtd 1 "treated" 0 "control"
	label values tgover_ur tgover_urtd
	
	* Indicator for 2008 data
	g year_indicator=2008
	
* Measurement of women's family power
	* Ternary dummy variables
		* Visit to family or relatives 
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
	
	g Egy_population_indiweight=75193567 //From Egypt's Census

	* Measurement of domestic violence
	* Tolerance towards domestic violence
		* "Disagree with any kind of domestic violence" coded as 1
		g tol_vio=1 if v744a==0| v744b==0| v744c==0| v744d==0| v744e==0
		replace tol_vio=0 if v744a==1 & v744b==1 & v744c==1 & v744d==1 & v744e==1
		replace tol_vio=. if tol_vio>1
		
		label var tol_vio "tolerance of domestic violence"
		label define tol_viod 1 "do not tolerance any domestic violence " 0 "tolerance domestic violence" 99 "no information"
		label values tol_vio tol_viod
		
		* "Disagree with any kind of domestic violence" coded as 1, with the condition of "no men during interview"
		g tol_vio_noinfl=1 if (v744a==0| v744b==0| v744c==0| v744d==0| v744e==0) & (v811==0 & v812==0 & v813==0 & v814==0)
		replace tol_vio_noinfl=0 if (v744a==1 & v744b==1 & v744c==1 & v744d==1 & v744e==1) & (v811==0 & v812==0 & v813==0 & v814==0)
		replace tol_vio_noinfl=. if tol_vio_noinfl>1
		
		label var tol_vio_noinfl "tolerance of domestic violence no men finluence"
		label define tol_vio_noinfld 1 "do not tolerance any domestic violence no men finluence" 0 "tolerance domestic violence no men finluence" 99 "no information"
		label values tol_vio_noinfl tol_vio_noinfld	
	
	
	* Share_pop weight
	g tpeople1_w=.
	
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
		count if governates_ur==`k'
		replace tpeople1_w=r(N) if governates_ur==`k'
	
	}
	
	* Share of population used as weights
	g share_pop_w=.
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
	replace share_pop_w=tpeople1/Egy_population if governates_ur==`k'
	
	}
   
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\lpfp_2008.dta", replace
	
exit
	