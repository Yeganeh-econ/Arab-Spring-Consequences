* Consolidate all children's information
clear all
capture log close
set more off

* Append
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem1.dta",clear
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem2"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem3"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem4"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem5"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem6"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem7"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem8"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem9"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem10"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem11"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem12"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem13"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem14"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem15"
	
	replace v152=. if v152>97 //Code 98 represents "do not know"
	g husbage=2014-s804y
	
	replace dr_visit=. if dr_visit==98
	replace birth_weight=. if birth_weight==9996 | birth_weight==9998
	
	* Retain relevant variables
	keep caseid v001 v002 v003 v004 v005 v006 v007 v008 v009 v010 v011 v012 ///
	v136 v138 v155 b_ord b_ordtw b_mon b_yr b_cmc b_gender b_alive bdd_time ///
	bdd_month bal_age b_livewith b_inforcom b_interL b_interC b_inforck b_omitck ///
	b_line deathyear dage s804c s804y s804m v106 v149 v701 v714 v704 v705 s808 ///
	sgov v024 v025 v151 v152 s921a v130 v201 v219 v005 husbage v131 v190 v137 v730 ///
	visit_both v743d visit_alone pur_both v743b pur_alone health_both v743a ///
	health_alone excision g116 excision_noinfl tol_vio v744a v744b v744c v744d v744e ///
	tol_vio_noinfl v811 v812 v813 v814 visit_ternary pur_ternary health_ternary ///
	marriagedur v023 vaccination dv_preg dr_visit birth_weight pregnecy

	rename (caseid v001 v002 v003 v004 v005 v006 v007 v008 v009 v010 v011 v012 ///
	v136 v138 v155 s804c s804y s804m v106 v701 v714 sgov v024 v025 ///
	v151 v152 v130 v219 v705 v131 v190 v137 v730 v023) (caseid clusterid hhid rlineid area weight ///
	interviewm interviewy interviewd birthm birthy birthcmc age hhsize ///
	femalesize lcapbility hcmc hbirthy hbirthm education heducation work ///
	governorate region1 region2 hhgender hhage religion totalliving hwork ///
	ethnicity weath_index nb_child age_husband governates_ur)
	

	* Define all border governorates, where 29 represents Luxor.
	g border_index= (governorate==31| governorate==32| governorate==33| governorate==34| governorate==35)
	label var border_index "border index for border governorate"
	label define border_indexd 1 "border governorate" 0 "non border governorate"
	label values border_index border_indexd

	* Employment status index
	g husband_work= (hwork!=0)
	label var husband_work "husband work or not"
	label define husband_workd 1 "husband works" 0 "husband does not work"
	label values husband_work husband_workd
	
	* Religion index
	replace religion=. if religion==96
	label var religion "Muslem or Christian"
	label define religiond 1 "Muslem" 2 "Christian"
	label values religion religiond	
	
	* Death age approximates to an integer.
	replace dage=8 if dage>7 & dage<8
	replace dage=9 if dage>8 & dage<9
	replace dage=12 if dage>11 & dage<12
	replace dage=24 if dage>23 & dage<24
	
	* Death year approximates to an integer. 
	replace deathyear=2008 if deathyear>2007 & deathyear<2008
	replace deathyear=2013 if deathyear>2013 & deathyear<2014
		
* Calculation of dependent variables

	* Missing women at birth
	g esexratiob=.
	forvalues i=2000(1)2014 {
		
		count if b_gender==1 & b_yr==`i'
		g m`i'=r(N)
	
		count if b_gender==2 & b_yr==`i'
		g f`i'=r(N)
	
		g sexratiob`i'=m`i'/f`i'
		
		replace esexratiob=sexratiob`i' if b_yr==`i'
		
							}
													
	* Treatment and control area dummy variables using the JDE method
	recode governorate (1 2 3 4 11 19 21 22 23 24=1) (12 13 14 15 16 17 18 25 26 27 28 29=0), gen (tgover)	
	label var tgover "treatment ares"
	label define treatmentd 1 "treated" 0 "control"
	label values tgover treatmentd
	
	* Treatment and control area dummy variables - including border governorates
	recode governorate (1 2 3 4 19 21 22 23 24 31 32 33 34 35=1) (11 12 13 14 15 16 17 18 25 26 27 28 29=0), gen (tgover_border)	
	label var tgover_border "treatment ares"
	label define treatmentd_border 1 "treated" 0 "control"
	label values tgover_border treatmentd_border
	
	* Treatment and control area dummy variables - aggregate level, using own method
	recode governorate (1 2 3 4 11 18 19 21 22 23 24=1) (12 13 14 15 16 17 25 26 27 28 29=0), gen (tgover_agg)	
	label var tgover_agg "treatment ares"
	label define treatmentda 1 "treated" 0 "control"
	label values tgover_agg treatmentda
	
	* Treatment and control area dummy variables - Phase 1 death
	recode governorate (1 2 3 4 16 17 18 19 21 23 22=1) ( 11 12 13 14 15 16 24 25 26 27 28 29=0), gen (tgover1)	
	label var tgover1 "treatment ares"
	label define treatmentd1 1 "treated" 0 "control"
	label values tgover1 treatmentd1
	replace tgover1=. if tgover1==31| tgover1==32| tgover1==33	
	
	* Treatment and control area dummy variables - Phase 2 death
	recode governorate (1 3 4 11 16 19 21 24 26 28 29=1) ( 2 12 13 14 15 17 18 22 23 25 27=0), gen (tgover2d)	
	label var tgover2d "treatment ares"
	label define treatmentd2d 1 "treated" 0 "control"
	label values tgover2d treatmentd2d
	replace tgover2d=. if tgover2d==31| tgover2d==32| tgover2d==33
			
	* Treatment and control area dummy variables - Phase 2 injured
	recode governorate (1 2 3 4 11 12 13 16 17 19 21=1) (26 27 24 29 14 15 23 22 18 25 28=0), gen (tgover2j)	
	label var tgover2j "treatment ares"
	label define treatmentd2j 1 "treated" 0 "control"
	label values tgover2j treatmentd2j
	
	* Treatment and control area dummy variables - phase 3 death
	recode governorate (1 2 3 4 14 18 19 21 22 24 26=1) (11 12 13 15 16 17 23 25 27 28 29=0), gen (tgover3d)	
	label var tgover3d "treatment ares"
	label define treatmentd3d 1 "treated" 0 "control"
	label values tgover3d treatmentd3d
	replace tgover3d=. if tgover3d==31| tgover3d==32| tgover3d==33
			
	* Treatment and control area dummy variables - phase 3 injured
	recode governorate (1 2 3 4 18 19 12 13 11 16 23=1) (15 14 17 25 28 29 26 27 21 24 22=0), gen (tgover3j)	
	label var tgover3j "treatment ares"
	label define treatmentd3j 1 "treated" 0 "control"
	label values tgover3j treatmentd3j
	
	* Treatment and control area dummy variables - phase 3 arrested
	recode governorate (1 2 3 4 18 19 12 13 11 16 21=1) (15 14 17 25 28 29 26 27 23 24 22=0), gen (tgover3arr)	
	label var tgover3arr "treatment ares"
	label define treatmentd3arr 1 "treated" 0 "control"
	label values tgover3arr treatmentd3arr	
	
	* Treatment and control area dummy variables - phase 4 death
	recode governorate (26 4 3 1 2 19 24 21 11 23 22=1) (15 12 16 25 13 18 28 29 14 17 27=0), gen (tgover4d)	
	label var tgover4d "treatment ares"
	label define treatmentd4d 1 "treated" 0 "control"
	label values tgover4d treatmentd4d
	replace tgover4d=. if tgover4d==31| tgover4d==32| tgover4d==33
			
	* Treatment and control area dummy variables - phase 4 injured
	recode governorate (13 4 3 1 2 19 21 11 23=1) (15 12 16 25 18 28 29 26 14 17 27 24 22=0), gen (tgover4j)	
	label var tgover4j "treatment ares"
	label define treatmentd4j 1 "treated" 0 "control"
	label values tgover4j treatmentd4j	
	
	* Treatment and control area dummy variables - phase 4 arrested
	recode governorate (25 4 3 1 2 19 24 21 11 23 22=1) (15 12 16 13 18 28 29 26 14 17 27=0), gen (tgover4arr)	
	label var tgover4arr "treatment ares"
	label define treatmentd4arr 1 "treated" 0 "control"
	label values tgover4arr treatmentd4arr	

	* Treatment and control area dummy variables - quantile index for deaths
	recode governorate (1 21 19 3 4=1) (25 15 29 17 27 13 2 24 11 23 22 12 16 18 28 26 14=0), gen (tgover_q_d)	
	label var tgover_q_d "treatment ares"
	label define tgover_q_dd 1 "treated" 0 "control"
	label values tgover_q_d tgover_q_dd	
	
	* Treatment and control area dummy variables - quantile index for injuries
	recode governorate (2 1 19 3 4=1) (12 16 15 14 17 27 25 24 21 11 23 22 13 18 28 29 26=0), gen (tgover_q_j)	
	label var tgover_q_j "treatment ares"
	label define tgover_q_jd 1 "treated" 0 "control"
	label values tgover_q_j tgover_q_jd		
	
	* Treatment and control area dummy variables - quantile index for arrests
	recode governorate (1 21 24 3 4=1) (28 14 29 27 13 26 25 2 19 11 23 22 15 12 16 18 17=0), gen (tgover_q_a)	
	label var tgover_q_a "treatment ares"
	label define tgover_q_ad 1 "treated" 0 "control"
	label values tgover_q_a tgover_q_ad	
	
	* Treatment and control area dummy variables - quantile index for total cases
	recode governorate (2 1 19 3 4=1) (16 15 14 27 17 26 28 14 29 27 13 26 25 24 21 11 23 22 15 12 16 18 17=0), gen (tgover_q_t)	
	label var tgover_q_t "treatment ares"
	label define tgover_q_td 1 "treated" 0 "control"
	label values tgover_q_t tgover_q_td			
		
	* Treatment and control area dummy variables - SPYE data set
	recode governorate (1 2 3 4 21 11 13 14 17 19 23=1) (24 25 22 16 15 12 18 26 27 28 29=0), gen (tgover_SPYE)	
	label var tgover_SPYE "treatment ares"
	label define tgover_SPYEd 1 "treated" 0 "control"
	label values tgover_SPYE tgover_SPYEd	
	
	* The following two classification methods for treatment and control groups include the border governorates
	* Treatment and control area dummy variables for the 2012 election: Muslim Brotherhood-Morsi
	recode governorate (2 4 11 15 18 19 21 22 23 24 25 26 27 28 32 33=1) (1 3 12 13 14 16 17 29 31=0), gen (tgover_election)	
	label var tgover_election "treatment ares"
	label define treatment_election 1 "treated" 0 "control"
	label values tgover_election treatment_election	
	
	* Treatment and control area dummy variables for the 2012 election: 75% support for Muslim Brotherhood-Morsi
	recode governorate (23 33=1) (2 4 11 15 18 19 21 22 24 25 26 27 28 32 1 3 12 13 14 16 17 29 31=0), gen (tgover_election75)	
	
	label var tgover_election75 "treatment ares"
	label define treatment_election75 1 "treated" 0 "control"
	label values tgover_election75 treatment_election75	
	
	* Treatment and control area dummy variables - Governorates at urban and rural levels using JDE method, excluding border governorates
	recode governates_ur (1 3 4 5 7 9 10 25 26 27 28 29 30 31 32 33 34=1) (11 12 13 14 15 16 17 18 19 20 21 22 23 24 35 36 37 38 39 40 41 42 43 44=0), gen (tgover_ur)
	label var tgover_ur "treatment ares"
	label define tgover_urtd 1 "treated" 0 "control"
	label values tgover_ur tgover_urtd

	* Treatment and control area dummy variables - Governorates at urban and rural levels including border governorates
	recode governates_ur (1 3 4 5 7 25 26 27 28 29 30 31 32 33 34=1) (9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50=0), gen (tgover_ur_border)
	label var tgover_ur_border "treatment areas including borders"
	label define tgover_ur_bordertd 1 "treated" 0 "control"
	label values tgover_ur_border tgover_ur_bordertd
	
	*Triple differences - third dummy
	* classification 1
	recode education (1 2 3=1) (0=0), gen (t_edu)	
	label var t_edu "treatment ares"
	label define t_edud 1 "treated" 0 "control"
	label values t_edu t_edud	

	* classification 2
	recode education (2 3=1) (1 0=0), gen (t_edu2)	
	label var t_edu2 "treatment ares"
	label define t_edud2 1 "treated" 0 "control"
	label values t_edu2 t_edud2	

	* classification 3
	recode education (3=1) (2 1 0=0), gen (t_edu3)	
	label var t_edu3 "treatment ares"
	label define t_edud3 1 "treated" 0 "control"
	label values t_edu3 t_edud3	
	
	* Drop all non-necessary variables
	drop if b_ord==.
		
	* Based on the descriptions provided in the survey questions
	replace weight=weight/1000000
	
	* Remove unknown answers
	replace heducation=. if heducation==8| heducation==9
	replace work=. if work==9
	
	* Death rate in Egypt by age group and location in 2014.		
	forvalues i=2004(1)2014 {
		g kidage`i'=`i'-b_yr if  b_alive==1
		replace kidage`i'=dage if b_alive==0 & deathyear==`i'
	}
	
	* Replace negative values resulting from calculations.
	forvalues i=2004(1)2014 {
		
			replace kidage`i'=. if kidage`i'<0
	
	}

save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_append.dta", replace 

* Delete the temporary datasets
erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem1.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem2.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem3.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem4.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem5.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem6.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem7.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem8.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem9.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem10.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem11.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem12.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem13.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem14.dta"
	erase "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem15.dta"
	
exit

