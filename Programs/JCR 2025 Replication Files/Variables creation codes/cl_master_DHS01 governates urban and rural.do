* Compute all measurements
clear all
capture log close
set more off
set maxvar 32767		

* Age group 1: Children aged from 0 to 1
	forvalues i=2007(1)2014 {
	
		use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_append", clear
		keep if kidage`i'==0| kidage`i'==1
			
		g year=`i'
		
		save  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age`i'_1_UR", replace
		
	}
											
	use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2007_1_UR", clear	
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2008_1_UR"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2009_1_UR"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2010_1_UR"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2011_1_UR"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2012_1_UR"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2013_1_UR"
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age2014_1_UR"		
	
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR", replace
	
	* Erase all temperary data sets
	forvalues i=2007(1)2014 {
		
		erase  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_age`i'_1_UR.dta"
		
	}
	
	sort governates_ur year b_gender
	replace religion=0 if religion==2
	
	label var religion "Muslim or Christian religious belief"
	label define religionname 1 "Muslim" 0 "Christian"
	label values religion religionname	
	
* Calculation of missing women
	forvalues j=1(1)2 {
		
					g tpeople1`j'=.
					g ndeath1`j'=.
					g drate1`j'=.	
	
					* Calculations for the marriage less than 4 years group
					g tpeople1m`j'=.
					g ndeath1m`j'=.
					g drate1m`j'=.
					
					* For women aged 20-40 (inclusive)
					g tpeople12040`j'=.
					g ndeath12040`j'=.
					g drate12040`j'=.

					* Whether the husband was present and listening during the survey interview
					g tpeople1h`j'=.
					g ndeath1h`j'=.
					g drate1h`j'=.
					  
					* Interview conducted alone (without anyone present)
					g tpeople1alone`j'=.
					g ndeath1alone`j'=.
					g drate1alone`j'=.					

					* Calculation at the national level 
					g tpeople_national1`j'=.
					g ndeath_national1`j'=.
					g drate_national1`j'=.
					
	}
	
	forvalues i=2007(1)2014 {
	forvalues j=1(1)2 {
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
					
					* Death rate by gender in different governorates, categorized by urban and rural areas
					count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & governates_ur==`k' & year==`i' 
					replace tpeople1`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & governates_ur==`k' & b_alive==0
					replace ndeath1`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					replace drate1`j'=ndeath1`j'/tpeople1`j' if b_gender==`j' & governates_ur==`k' & year==`i'

					* Death rate for males and females in different governorates, stratified by urban and rural areas, for marriages of less than 4 years
					count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & governates_ur==`k' & year==`i' & marriagedur<4
					replace tpeople1m`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & governates_ur==`k' & b_alive==0 & marriagedur<4
					replace ndeath1m`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					replace drate1m`j'=ndeath1m`j'/tpeople1m`j' if b_gender==`j' & governates_ur==`k' & year==`i'
					
					* Death rate for males and females in different governorates, stratified by urban and rural areas, for women aged 20-40 (inclusive)
					count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & governates_ur==`k' & year==`i' & age>=20 & age<=40
					replace tpeople12040`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & governates_ur==`k' & b_alive==0 & age>=20 & age<=40
					replace ndeath12040`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					replace drate12040`j'=ndeath12040`j'/tpeople12040`j' if b_gender==`j' & governates_ur==`k' & year==`i'			

					* Whether the husband was listening during the survey interview
					count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & governates_ur==`k' & year==`i' & v812==0
					replace tpeople1h`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & governates_ur==`k' & b_alive==0 & v812==0
					replace ndeath1h`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					replace drate1h`j'=ndeath1h`j'/tpeople1h`j' if b_gender==`j' & governates_ur==`k' & year==`i'
					
					* Interview conducted alone (without anyone present)
					count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & governates_ur==`k' & year==`i' & v811==0 & v813==0 & v814==0
					replace tpeople1alone`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & governates_ur==`k' & b_alive==0 & v811==0 & v813==0 & v814==0
					replace ndeath1alone`j'=r(N) if b_gender==`j' & governates_ur==`k' & year==`i'
					
					replace drate1alone`j'=ndeath1alone`j'/tpeople1alone`j' if b_gender==`j' & governates_ur==`k' & year==`i'					
										
					* Death rate for males and females across the entire nation
					count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & year==`i'
					replace tpeople_national1`j'=r(N) if b_gender==`j' & year==`i'
					
					count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & b_alive==0
					replace ndeath_national1`j'=r(N) if b_gender==`j' & year==`i'
				
					replace drate_national1`j'=ndeath_national1`j'/tpeople_national1`j' if b_gender==`j' & year==`i'									
	}
	}
	}	
				
	g sexratio=.
	g lgsexratio=.
	
	replace sexratio=tpeople12/tpeople11 //female devided by male
	replace lgsexratio=log(sexratio)
	
* Summary tables	
	* Treatment and control areas, excluding border governorates	
			g dtpeople11=.
			g dtpeople12=.
			
			g dndeath11=.
			g dndeath12=.
			
			g ddrate11=.			
			g ddrate12=.
			
	* Treatment and control areas, including border governorates											
			g dtpeople1_border1=.
			g dtpeople1_border2=.
			
			g dndeath1_border1=.
			g dndeath1_border2=.
			
			g ddrate1_border1=.
			g ddrate1_border2=.	
					
	* Age 0-1: Calculation of missing women in this age group
	forvalues i=2007(1)2014{
	forvalues j=1(1)2 {
	foreach k of numlist 0 1 {
					
			* Male and female death rates in treatment and control areas, excluding border governorates
			count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & tgover==`k' & year==`i'
			replace dtpeople1`j'=r(N) if b_gender==`j' & tgover==`k' & year==`i'
					
			count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & tgover==`k' & b_alive==0
			replace dndeath1`j'=r(N) if b_gender==`j' & year==`i' & tgover==`k'
					
			replace ddrate1`j'=dndeath1`j'/dtpeople1`j'
					
			* Male and female death rates in treatment and control areas, including border governorates
			count if b_gender==`j' & (kidage`i'==0 | kidage`i'==1) & tgover_border==`k' & year==`i'
			replace dtpeople1_border`j'=r(N) if b_gender==`j' & tgover_border==`k' & year==`i'
					
			count if b_gender==`j' & deathyear==`i' & (dage==0 | dage==1) & tgover_border==`k' & b_alive==0
			replace dndeath1_border`j'=r(N) if b_gender==`j' & year==`i' & tgover_border==`k'
					
			replace ddrate1_border`j'=dndeath1_border`j'/dtpeople1_border`j'		
				
	}
	}
	}
	
	gen id=_n

	* Merge with developed reference governorates, categorized by urban and rural areas
	merge m:1 id using  "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned Developed\agg_developedindex_WRages"
	
	forvalues i=2007(1)2014 {
	forvalues j=1(1)2 {
			
		replace d`i'`j'1=d`i'`j'1[_n-1] if d`i'`j'1==. 
										
	}
	}

	* Total population in DHS
	g tpeople1=.
	
	forvalues i=2007(1)2014{
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
		count if year==`i' & (kidage`i'==0 | kidage`i'==1) & governates_ur==`k'
		replace tpeople1=r(N) if year==`i' & governates_ur==`k'
	
	}
	}
	
	* Population at the national level from the census in Egypt
	g Egy_population=69303902 if year==2004
	replace Egy_population=70653326 if year==2005	
	replace Egy_population=72008901 if year==2006		
	replace Egy_population=73643587 if year==2007
	replace Egy_population=75193567 if year==2008
	replace Egy_population=76925139 if year==2009	
	replace Egy_population=78684622 if year==2010		
	replace Egy_population=80529566 if year==2011	
	replace Egy_population=82549977 if year==2012	
	replace Egy_population=84628982 if year==2013	
	replace Egy_population=86813723 if year==2014
	
	* Weights derived from the share of population
	g share_pop=.
	forvalues i=2007(1)2014{
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
	replace share_pop=tpeople1/Egy_population if year==`i' & governates_ur==`k'
	
	}
	}

	* Population information for Egypt in different years across various governorates
	* Cairo
	g governates_popu=7707866 if year==2004 & governorate==1 	   //2004
	replace governates_popu=7839943 if year==2005 & governorate==1 //2005
	replace governates_popu=7968042 if year==2006 & governorate==1 //2006	
	replace governates_popu=7988657 if year==2007 & governorate==1 //2007	
	replace governates_popu=8114855 if year==2008 & governorate==1 //2008	
	replace governates_popu=8306493 if year==2009 & governorate==1 //2009	
	replace governates_popu=8482515 if year==2010 & governorate==1 //2010	
	replace governates_popu=8657909 if year==2011 & governorate==1 //2011	
	replace governates_popu=8825725 if year==2012 & governorate==1 //2012	
	replace governates_popu=9002783 if year==2013 & governorate==1 //2013
	replace governates_popu=9183581 if year==2014 & governorate==1 //2014	

	* Alexandria
	replace governates_popu=3790062 if year==2004 & governorate==2 //2004
	replace governates_popu=3855993 if year==2005 & governorate==2 //2005
	replace governates_popu=3919290 if year==2006 & governorate==2 //2006	
	replace governates_popu=4164750 if year==2007 & governorate==2 //2007	
	replace governates_popu=4238100 if year==2008 & governorate==2 //2008	
	replace governates_popu=4316741 if year==2009 & governorate==2 //2009	
	replace governates_popu=4397946 if year==2010 & governorate==2 //2010	
	replace governates_popu=4463887 if year==2011 & governorate==2 //2011	
	replace governates_popu=4564979 if year==2012 & governorate==2 //2012	
	replace governates_popu=4658381 if year==2013 & governorate==2 //2013
	replace governates_popu=4760374 if year==2014 & governorate==2 //2014	
	
	* Port Said
	replace governates_popu=532809 if year==2004 & governorate==3 // 2004
	replace governates_popu=541618 if year==2005 & governorate==3 // 2005
	replace governates_popu=550113 if year==2006 & governorate==3 // 2006	
	replace governates_popu=576599 if year==2007 & governorate==3 // 2007	
	replace governates_popu=587850 if year==2008 & governorate==3 // 2008	
	replace governates_popu=599182 if year==2009 & governorate==3 // 2009	
	replace governates_popu=610537 if year==2010 & governorate==3 // 2010	
	replace governates_popu=621899 if year==2011 & governorate==3 // 2011	
	replace governates_popu=633905 if year==2012 & governorate==3 // 2012	
	replace governates_popu=646461 if year==2013 & governorate==3 // 2013
	replace governates_popu=659677 if year==2014 & governorate==3 // 2014

	* Suez
	replace governates_popu=485612 if year==2004 & governorate==4 // 2004
	replace governates_popu=495307 if year==2005 & governorate==4 // 2005
	replace governates_popu=505188 if year==2006 & governorate==4 // 2006	
	replace governates_popu=518557 if year==2007 & governorate==4 // 2007	
	replace governates_popu=530092 if year==2008 & governorate==4 // 2008	
	replace governates_popu=542822 if year==2009 & governorate==4 // 2009	
	replace governates_popu=556323 if year==2010 & governorate==4 // 2010	
	replace governates_popu=569398 if year==2011 & governorate==4 // 2011	
	replace governates_popu=584145 if year==2012 & governorate==4 // 2012	
	replace governates_popu=599320 if year==2013 & governorate==4 // 2013
	replace governates_popu=614885 if year==2014 & governorate==4 // 2014

	* Damietta
	replace governates_popu=1070297 if year==2004 & governorate==11 // 2004
	replace governates_popu=1092740 if year==2005 & governorate==11 // 2005
	replace governates_popu=1115628 if year==2006 & governorate==11 // 2006	
	replace governates_popu=1112163 if year==2007 & governorate==11 // 2007	
	replace governates_popu=1137209 if year==2008 & governorate==11 // 2008	
	replace governates_popu=1165936 if year==2009 & governorate==11 // 2009	
	replace governates_popu=1194886 if year==2010 & governorate==11 // 2010	
	replace governates_popu=1224536 if year==2011 & governorate==11 // 2011	
	replace governates_popu=1254971 if year==2012 & governorate==11 // 2012	
	replace governates_popu=1284710 if year==2013 & governorate==11 // 2013
	replace governates_popu=1315151 if year==2014 & governorate==11 // 2014
	
	* Dakahlia
	replace governates_popu=4892981 if year==2004 & governorate==12 // 2004
	replace governates_popu=4984198 if year==2005 & governorate==12 // 2005
	replace governates_popu=5077668 if year==2006 & governorate==12 // 2006	
	replace governates_popu=5044050 if year==2007 & governorate==12 // 2007	
	replace governates_popu=5138672 if year==2008 & governorate==12 // 2008	
	replace governates_popu=5261453 if year==2009 & governorate==12 // 2009	
	replace governates_popu=5378383 if year==2010 & governorate==12 // 2010	
	replace governates_popu=5497225 if year==2011 & governorate==12 // 2011	
	replace governates_popu=5623639 if year==2012 & governorate==12 // 2012	
	replace governates_popu=5748965 if year==2013 & governorate==12 // 2013
	replace governates_popu=5880255 if year==2014 & governorate==12 // 2014

	* Sharkia
	replace governates_popu=5071161 if year==2004 & governorate==13 // 2004
	replace governates_popu=5176660 if year==2005 & governorate==13 // 2005
	replace governates_popu=5283317 if year==2006 & governorate==13 // 2006	
	replace governates_popu=5426303 if year==2007 & governorate==13 // 2007	
	replace governates_popu=5544536 if year==2008 & governorate==13 // 2008	
	replace governates_popu=5666980 if year==2009 & governorate==13 // 2009	
	replace governates_popu=5802845 if year==2010 & governorate==13 // 2010	
	replace governates_popu=5940540 if year==2011 & governorate==13 // 2011	
	replace governates_popu=6091249 if year==2012 & governorate==13 // 2012	
	replace governates_popu=6242810 if year==2013 & governorate==13 // 2013
	replace governates_popu=6401587 if year==2014 & governorate==13 // 2014
	
	* Kalyubia
	replace governates_popu=3836211 if year==2004 & governorate==14 // 2004
	replace governates_popu=3907547 if year==2005 & governorate==14 // 2005
	replace governates_popu=3980960 if year==2006 & governorate==14 // 2006	
	replace governates_popu=4300328 if year==2007 & governorate==14 // 2007	
	replace governates_popu=4395184 if year==2008 & governorate==14 // 2008	
	replace governates_popu=4493375 if year==2009 & governorate==14 // 2009	
	replace governates_popu=4595313 if year==2010 & governorate==14 // 2010	
	replace governates_popu=4698615 if year==2011 & governorate==14 // 2011	
	replace governates_popu=4811673 if year==2012 & governorate==14 // 2012	
	replace governates_popu=4926148 if year==2013 & governorate==14 // 2013
	replace governates_popu=5043846 if year==2014 & governorate==14 // 2014
	
	* Kafr el-sheikh
	replace governates_popu=2557474 if year==2004 & governorate==15 // 2004
	replace governates_popu=2608966 if year==2005 & governorate==15 // 2005
	replace governates_popu=2654060 if year==2006 & governorate==15 // 2006	
	replace governates_popu=2653144 if year==2007 & governorate==15 // 2007	
	replace governates_popu=2708258 if year==2008 & governorate==15 // 2008	
	replace governates_popu=2776350 if year==2009 & governorate==15 // 2009	
	replace governates_popu=2840662 if year==2010 & governorate==15 // 2010	
	replace governates_popu=2905891 if year==2011 & governorate==15 // 2011	
	replace governates_popu=2979258 if year==2012 & governorate==15 // 2012	
	replace governates_popu=3054770 if year==2013 & governorate==15 // 2013
	replace governates_popu=3131991 if year==2014 & governorate==15 // 2014
	
	* Gharbia
	replace governates_popu=3898567 if year==2004 & governorate==16 // 2004
	replace governates_popu=3968300 if year==2005 & governorate==16 // 2005
	replace governates_popu=4038791 if year==2006 & governorate==16 // 2006	
	replace governates_popu=4055091 if year==2007 & governorate==16 // 2007	
	replace governates_popu=4136016 if year==2008 & governorate==16 // 2008	
	replace governates_popu=4216534 if year==2009 & governorate==16 // 2009	
	replace governates_popu=4304173 if year==2010 & governorate==16 // 2010	
	replace governates_popu=4394179 if year==2011 & governorate==16 // 2011	
	replace governates_popu=4491977 if year==2012 & governorate==16 // 2012	
	replace governates_popu=4592222 if year==2013 & governorate==16 // 2013
	replace governates_popu=4697668 if year==2014 & governorate==16 // 2014
	
	* Menoufia
	replace governates_popu=3201829 if year==2004 & governorate==17 // 2004
	replace governates_popu=3260053 if year==2005 & governorate==17 // 2005
	replace governates_popu=3321499 if year==2006 & governorate==17 // 2006	
	replace governates_popu=3309482 if year==2007 & governorate==17 // 2007	
	replace governates_popu=3381399 if year==2008 & governorate==17 // 2008	
	replace governates_popu=3455434 if year==2009 & governorate==17 // 2009	
	replace governates_popu=3533702 if year==2010 & governorate==17 // 2010	
	replace governates_popu=3616765 if year==2011 & governorate==17 // 2011	
	replace governates_popu=3706194 if year==2012 & governorate==17 // 2012	
	replace governates_popu=3799149 if year==2013 & governorate==17 // 2013
	replace governates_popu=3889119 if year==2014 & governorate==17 // 2014
	
	* Behera
	replace governates_popu=4647280 if year==2004 & governorate==18 // 2004
	replace governates_popu=4732127 if year==2005 & governorate==18 // 2005
	replace governates_popu=4819797 if year==2006 & governorate==18 // 2006	
	replace governates_popu=4802272 if year==2007 & governorate==18 // 2007	
	replace governates_popu=4903300 if year==2008 & governorate==18 // 2008	
	replace governates_popu=5035067 if year==2009 & governorate==18 // 2009	
	replace governates_popu=5147722 if year==2010 & governorate==18 // 2010	
	replace governates_popu=5274349 if year==2011 & governorate==18 // 2011	
	replace governates_popu=5415375 if year==2012 & governorate==18 // 2012	
	replace governates_popu=5563465 if year==2013 & governorate==18 // 2013
	replace governates_popu=5720943 if year==2014 & governorate==18 // 2014
	
	* Ismailia
	replace governates_popu=855687 if year==2004 & governorate==19 // 2004
	replace governates_popu=874732 if year==2005 & governorate==19 // 2005
	replace governates_popu=895116 if year==2006 & governorate==19 // 2006	
	replace governates_popu=966273 if year==2007 & governorate==19 // 2007	
	replace governates_popu=990693 if year==2008 & governorate==19 // 2008	
	replace governates_popu=1015726 if year==2009 & governorate==19 // 2009	
	replace governates_popu=1040619 if year==2010 & governorate==19 // 2010	
	replace governates_popu=1066669 if year==2011 & governorate==19 // 2011	
	replace governates_popu=1096956 if year==2012 & governorate==19 // 2012	
	replace governates_popu=1128373 if year==2013 & governorate==19 // 2013
	replace governates_popu=1161490 if year==2014 & governorate==19 // 2014
	
	* Giza
	replace governates_popu=5576623 if year==2004 & governorate==21 // 2004
	replace governates_popu=5689313 if year==2005 & governorate==21 // 2005
	replace governates_popu=5800382 if year==2006 & governorate==21 // 2006	
	replace governates_popu=6364682 if year==2007 & governorate==21 // 2007	
	replace governates_popu=6501530 if year==2008 & governorate==21 // 2008	
	replace governates_popu=6616445 if year==2009 & governorate==21 // 2009	
	replace governates_popu=6756655 if year==2010 & governorate==21 // 2010	
	replace governates_popu=6926859 if year==2011 & governorate==21 // 2011	
	replace governates_popu=7104805 if year==2012 & governorate==21 // 2012	
	replace governates_popu=7291017 if year==2013 & governorate==21 // 2013
	replace governates_popu=7486361 if year==2014 & governorate==21 // 2014
	
	* Beni suef
	replace governates_popu=2222242 if year==2004 & governorate==22 // 2004
	replace governates_popu=2269373 if year==2005 & governorate==22 // 2005
	replace governates_popu=2317844 if year==2006 & governorate==22 // 2006	
	replace governates_popu=2320629 if year==2007 & governorate==22 // 2007	
	replace governates_popu=2377783 if year==2008 & governorate==22 // 2008	
	replace governates_popu=2438316 if year==2009 & governorate==22 // 2009	
	replace governates_popu=2502097 if year==2010 & governorate==22 // 2010	
	replace governates_popu=2568247 if year==2011 & governorate==22 // 2011	
	replace governates_popu=2646876 if year==2012 & governorate==22 // 2012	
	replace governates_popu=2727614 if year==2013 & governorate==22 // 2013
	replace governates_popu=2812253 if year==2014 & governorate==22 // 2014
	
	* Fayoum
	replace governates_popu=2398931 if year==2004 & governorate==23 // 2004
	replace governates_popu=2447826 if year==2005 & governorate==23 // 2005
	replace governates_popu=2501607 if year==2006 & governorate==23 // 2006	
	replace governates_popu=2546882 if year==2007 & governorate==23 // 2007	
	replace governates_popu=2612455 if year==2008 & governorate==23 // 2008	
	replace governates_popu=2683188 if year==2009 & governorate==23 // 2009	
	replace governates_popu=2759923 if year==2010 & governorate==23 // 2010	
	replace governates_popu=2843643 if year==2011 & governorate==23 // 2011	
	replace governates_popu=2930084 if year==2012 & governorate==23 // 2012	
	replace governates_popu=3021448 if year==2013 & governorate==23 // 2013
	replace governates_popu=3118078 if year==2014 & governorate==23 // 2014
	
	* Menya
	replace governates_popu=4009494 if year==2004 & governorate==24 // 2004
	replace governates_popu=4099869 if year==2005 & governorate==24 // 2005
	replace governates_popu=4190414 if year==2006 & governorate==24 // 2006	
	replace governates_popu=4212158 if year==2007 & governorate==24 // 2007	
	replace governates_popu=4318700 if year==2008 & governorate==24 // 2008	
	replace governates_popu=4426528 if year==2009 & governorate==24 // 2009	
	replace governates_popu=4536077 if year==2010 & governorate==24 // 2010	
	replace governates_popu=4658976 if year==2011 & governorate==24 // 2011	
	replace governates_popu=4792638 if year==2012 & governorate==24 // 2012	
	replace governates_popu=4930641 if year==2013 & governorate==24 // 2013
	replace governates_popu=5076879 if year==2014 & governorate==24 // 2014
	
	* Assuit
	replace governates_popu=3389991 if year==2004 & governorate==25 // 2004
	replace governates_popu=3461836 if year==2005 & governorate==25 // 2005
	replace governates_popu=3535363 if year==2006 & governorate==25 // 2006	
	replace governates_popu=3486681 if year==2007 & governorate==25 // 2007	
	replace governates_popu=3569845 if year==2008 & governorate==25 // 2008	
	replace governates_popu=3655349 if year==2009 & governorate==25 // 2009	
	replace governates_popu=3746807 if year==2010 & governorate==25 // 2010	
	replace governates_popu=3846708 if year==2011 & governorate==25 // 2011	
	replace governates_popu=3953263 if year==2012 & governorate==25 // 2012	
	replace governates_popu=4062821 if year==2013 & governorate==25 // 2013
	replace governates_popu=4181594 if year==2014 & governorate==25 // 2014
	
	* Souhag
	replace governates_popu=3736328 if year==2004 & governorate==26 // 2004
	replace governates_popu=3811721 if year==2005 & governorate==26 // 2005
	replace governates_popu=3889524 if year==2006 & governorate==26 // 2006	
	replace governates_popu=3792045 if year==2007 & governorate==26 // 2007	
	replace governates_popu=3871100 if year==2008 & governorate==26 // 2008	
	replace governates_popu=3971431 if year==2009 & governorate==26 // 2009	
	replace governates_popu=4067456 if year==2010 & governorate==26 // 2010	
	replace governates_popu=4168727 if year==2011 & governorate==26 // 2011	
	replace governates_popu=4283902 if year==2012 & governorate==26 // 2012	
	replace governates_popu=4404545 if year==2013 & governorate==26 // 2013
	replace governates_popu=4536034 if year==2014 & governorate==26 // 2014
	
	* Qena
	replace governates_popu=2905506 if year==2004 & governorate==27 // 2004
	replace governates_popu=2965402 if year==2005 & governorate==27 // 2005
	replace governates_popu=3023797 if year==2006 & governorate==27 // 2006	
	replace governates_popu=3036415 if year==2007 & governorate==27 // 2007	
	replace governates_popu=3107712 if year==2008 & governorate==27 // 2008	
	replace governates_popu=3174163 if year==2009 & governorate==27 // 2009	
	replace governates_popu=2703113 if year==2010 & governorate==27 // 2010	
	replace governates_popu=2765733 if year==2011 & governorate==27 // 2011	
	replace governates_popu=2840318 if year==2012 & governorate==27 // 2012	
	replace governates_popu=2918086 if year==2013 & governorate==27 // 2013
	replace governates_popu=3001951 if year==2014 & governorate==27 // 2014	
		
	*Aswan
	replace governates_popu=1105911 if year==2004 & governorate==28 // 2004
	replace governates_popu=1126532 if year==2005 & governorate==28 // 2005
	replace governates_popu=1146160 if year==2006 & governorate==28 // 2006	
	replace governates_popu=1196946 if year==2007 & governorate==28 // 2007	
	replace governates_popu=1221593 if year==2008 & governorate==28 // 2008	
	replace governates_popu=1251618 if year==2009 & governorate==28 // 2009	
	replace governates_popu=1278978 if year==2010 & governorate==28 // 2010	
	replace governates_popu=1308598 if year==2011 & governorate==28 // 2011	
	replace governates_popu=1340279 if year==2012 & governorate==28 // 2012	
	replace governates_popu=1374985 if year==2013 & governorate==28 // 2013
	replace governates_popu=1412300 if year==2014 & governorate==28 // 2014
	
	*Luxor
	replace governates_popu=418224 if year==2004 & governorate==29 // 2004
	replace governates_popu=425708 if year==2005 & governorate==29 // 2005
	replace governates_popu=433156 if year==2006 & governorate==29 // 2006	
	replace governates_popu=461604 if year==2007 & governorate==29 // 2007	
	replace governates_popu=470258 if year==2008 & governorate==29 // 2008	
	replace governates_popu=479623 if year==2009 & governorate==29 // 2009	
	replace governates_popu=1033310 if year==2010 & governorate==29 // 2010	
	replace governates_popu=1055576 if year==2011 & governorate==29 // 2011	
	replace governates_popu=1079337 if year==2012 & governorate==29 // 2012	
	replace governates_popu=1104858 if year==2013 & governorate==29 // 2013
	replace governates_popu=1132684 if year==2014 & governorate==29 // 2014
	
	*Red sea
	replace governates_popu=184781 if year==2004 & governorate==31 // 2004
	replace governates_popu=188871 if year==2005 & governorate==31 // 2005
	replace governates_popu=193151 if year==2006 & governorate==31 // 2006	
	replace governates_popu=291884 if year==2007 & governorate==31 // 2007	
	replace governates_popu=297377 if year==2008 & governorate==31 // 2008	
	replace governates_popu=303620 if year==2009 & governorate==31 // 2009	
	replace governates_popu=309928 if year==2010 & governorate==31 // 2010	
	replace governates_popu=316800 if year==2011 & governorate==31 // 2011	
	replace governates_popu=324553 if year==2012 & governorate==31 // 2012	
	replace governates_popu=332741 if year==2013 & governorate==31 // 2013
	replace governates_popu=341223 if year==2014 & governorate==31 // 2014	
		
	*New valley
	replace governates_popu=167801 if year==2004 & governorate==32 // 2004
	replace governates_popu=171279 if year==2005 & governorate==32 // 2005
	replace governates_popu=175122 if year==2006 & governorate==32 // 2006	
	replace governates_popu=189447 if year==2007 & governorate==32 // 2007	
	replace governates_popu=193320 if year==2008 & governorate==32 // 2008	
	replace governates_popu=197321 if year==2009 & governorate==32 // 2009	
	replace governates_popu=201584 if year==2010 & governorate==32 // 2010	
	replace governates_popu=207064 if year==2011 & governorate==32 // 2011	
	replace governates_popu=211419 if year==2012 & governorate==32 // 2012	
	replace governates_popu=216751 if year==2013 & governorate==32 // 2013
	replace governates_popu=222281 if year==2014 & governorate==32 // 2014
	
	*Matroh
	replace governates_popu=266406 if year==2004 & governorate==33 // 2004
	replace governates_popu=274482 if year==2005 & governorate==33 // 2005
	replace governates_popu=280299 if year==2006 & governorate==33 // 2006	
	replace governates_popu=326684 if year==2007 & governorate==33 // 2007	
	replace governates_popu=334730 if year==2008 & governorate==33 // 2008	
	replace governates_popu=352073 if year==2009 & governorate==33 // 2009	
	replace governates_popu=367214 if year==2010 & governorate==33 // 2010	
	replace governates_popu=382208 if year==2011 & governorate==33 // 2011	
	replace governates_popu=399107 if year==2012 & governorate==33 // 2012	
	replace governates_popu=417294 if year==2013 & governorate==33 // 2013
	replace governates_popu=437234 if year==2014 & governorate==33 // 2014
	
	* Total population in the DHS
	g tpeople1governates=.
	
	forvalues i=2007(1)2014{
	foreach k of numlist 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 {
		
		count if year==`i' & (kidage`i'==0 | kidage`i'==1) & governorate==`k'
		replace tpeople1governates=r(N) if year==`i' & governorate==`k'
	
	}
	}
	
	* Weights derived from the share of population in different governorates and years
	g sharep_governates=.
	forvalues i=2007(1)2014{
	foreach k of numlist 1 2 3 4 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 31 32 33 {
		
	replace sharep_governates=tpeople1governates/governates_popu if year==`i' & governorate==`k'
	
	}
	}
		
* Calculation of missing women
	* Referenced death ratio from developed areas
	g refer_ratio=.
	
	* Referenced death ratio				
	g muw1=.
	g muw1m=.
	g muw12040=.
	g muw1h=.
	g muw1alone=.
	
	* Missing women
	g missingwomen1=.	
	g missingwomen1m=.
	g missingwomen12040=.
	g missingwomen1h=.
	g missingwomen1alone=.
	
	* Separate shares of missing women
	g mwshare1=.

	* Starting number of women in the age1 group, denoted as pi
	g piw1=tpeople12
	* Women aged 20-40	
	g piw12040=tpeople120402
	* Whether the husband was present and listening during the survey interview	
	g piw1h=tpeople1h2
	* Interview conducted alone (without anyone present)		
	g piw1alone=tpeople1alone2
	
	forvalues i=2007(1)2014{

		* Baseline
		replace refer_ratio=(d`i'11/d`i'21) if year==`i'
		replace muw1=drate11/refer_ratio
		
		* Calculations for marriage less than 4 years group, denoted as "muw1m"	
		replace muw1m=drate1m1/refer_ratio		
		
		* Women aged 20-40
		replace muw12040=drate120401/refer_ratio

		* Whether the husband was present and listening during the survey interview	
		replace muw1h=drate1h1/refer_ratio
		
		* Interview conducted alone (without anyone present)	
		replace muw1alone=drate1alone1/refer_ratio
		
	}
	
		* Baseline		
		bysort governates_ur year: replace muw1=muw1[_n-1] if muw1==.
		* Calculations for the marriage less than 4 years group, designated as muw1		
		bysort governates_ur year: replace muw1m=muw1m[_n-1] if muw1m==.	
		* Women aged 20-40	
		bysort governates_ur year: replace muw12040=muw12040[_n-1] if muw12040==.
		* Whether the husband was present and listening during the survey interview	
		bysort governates_ur year: replace muw1h=muw1h[_n-1] if muw1h==.
		* Interview conducted alone (without anyone present)
		bysort governates_ur year: replace muw1alone=muw1alone[_n-1] if muw1alone==.		
			
	* Baseline calculation of missing women
	forvalues i=2007(1)2014{
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
		* Baseline calculation of missing women
		replace missingwomen1=(drate12-muw1)*piw1

		* Calculations for the marriage less than 4 years group, referred to as muw1
		replace missingwomen1m=(drate1m2-muw1m)*piw1
		
		* Women aged 20-40
		replace missingwomen12040=(drate120402-muw12040)*piw12040
		
		* Whether the husband was present and listening during the survey interview
		replace missingwomen1h=(drate1h2-muw1h)*piw1h
		
		* Interview conducted alone (without anyone present)	
		replace missingwomen1alone=(drate1alone2-muw1alone)*piw1alone
		
	}
	}

* Independent variables
	* Employment rate, education level, religion, wealth, and urban status for both husband and wife (respondent)
	* Husband's work rate in different governorates and years
	g urban=(region2==1)
	
	g husband1=.
	g hwork1=.
	g hwrate1=.
	
	* Education level rate for husbands in different governorates and years	
	forvalues e=0(1)3 {	
	
		g hedu1`e'=.
		g hedurate1`e'=.
	}
	
	* Work rate for female respondents in different governorates and years
	g reponsework1=.
	g reponsewrate1=.
	
	forvalues e=0(1)3 {	
	
		g reponseedu1`e'=.
		g reponseedurate1`e'=.
	}
	
	* Household religion 
	g religionhh1=.
	g religionrate1=.
	g religionhh1_christian=.
	g religionrate1_christian=.
	g religionhh1_unknown=.
	g religionrate1_unknown=.
	
	forvalues r=1(1)5 {
		
	g wealth1`r'=.
	g wealthrate1`r'=.
	
	}

	g urbanhh1=.
	g urbanrate1=.	

	foreach h of numlist 0 1 2 3 4 5 7 8 9 {
		
	g hwork1`h'=.
	g hwork_char1`h'=.
	
	}
		
	forvalues i=2007(1)2014 {
	forvalues e=0(1)3 {
	forvalues r=1(1)5 {
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
	foreach h of numlist 0 1 2 3 4 5 7 8 9 {			
					* Husband's work rate
					count if governates_ur==`k' & year==`i' 
					replace husband1=r(N) if governates_ur==`k' & year==`i' //also represent the # of obsverations in diff areas and years
					
					count if husband_work==1 & governates_ur==`k' & year==`i' 
					replace hwork1=r(N) if governates_ur==`k' & year==`i'
					replace hwrate1=hwork1/husband1 if governates_ur==`k' & year==`i'
					
					* Husband's job characteristics - Part 1
					count if hwork==`h' & governates_ur==`k' & year==`i' 
					replace hwork1`h'=r(N) if hwork==`h' & governates_ur==`k' & year==`i'
					replace hwork_char1`h'=hwork1`h'/husband1 if hwork==`h' & governates_ur==`k' & year==`i'
		
					* Rate of husband's education level					
					count if governates_ur==`k' & year==`i' & heducation==`e' 
					replace hedu1`e'=r(N) if governates_ur==`k' & year==`i' & heducation==`e' 
					replace hedurate1`e'=hedu1`e'/husband1 if governates_ur==`k' & year==`i' & heducation==`e'
					
					* Work rate of female respondents					
					count if work==1 & governates_ur==`k' & year==`i' 
					replace reponsework1=r(N) if governates_ur==`k' & year==`i'
					replace reponsewrate1=reponsework1/husband1 if governates_ur==`k' & year==`i'
					
					* Rate of education level for female respondents					
					count if governates_ur==`k' & year==`i' & education==`e' 
					replace reponseedu1`e'=r(N) if governates_ur==`k' & year==`i' & education==`e' 
					replace reponseedurate1`e'=reponseedu1`e'/husband1 if governates_ur==`k' & year==`i' & heducation==`e'
					
					* Households religion - Muslim			
					count if religion==1 & governates_ur==`k' & year==`i' 
					replace religionhh1=r(N) if governates_ur==`k' & year==`i'
					replace religionrate1=religionhh1/husband1 if governates_ur==`k' & year==`i'
	
					* Households religion - Christian
					count if religion==0 & governates_ur==`k' & year==`i' 
					replace religionhh1_christian=r(N) if governates_ur==`k' & year==`i'
					replace religionrate1_christian=religionhh1_christian/husband1 if governates_ur==`k' & year==`i'	
					
					* Households religion - Unknown religion			
					count if (religion==.| religion==96) & governates_ur==`k' & year==`i'
					replace religionhh1_unknown=r(N) if governates_ur==`k' & year==`i'
					replace religionrate1_unknown=religionhh1_unknown/husband1 if governates_ur==`k' & year==`i'
					
					* Household wealth indexes				
					count if governates_ur==`k' & year==`i' & weath_index==`r' 
					replace wealth1`r'=r(N) if governates_ur==`k' & year==`i' & weath_index==`r' 
					replace wealthrate1`r'=wealth1`r'/husband1 if governates_ur==`k' & year==`i' & weath_index==`r'				
					
					* Household residence: Urban or rural				
					count if urban==1 & governates_ur==`k' & year==`i' //urban=1 refers the urban resident places
					replace urbanhh1=r(N) if governates_ur==`k' & year==`i'
					replace urbanrate1=urbanhh1/husband1 if governates_ur==`k' & year==`i'						
	
	}
	}
	}
	}
	}
		
	* Husband's job characteristics - Part 2, continuing from Part 1
	count if hwork==98| hwork==99|hwork==.
	g hwork_char19899=r(N)/husband1	
	
	* Rate of female household heads
	count if hhgender==2
	g hhfemale_rate=r(N)/husband1	
					
	* Vaccination rates by governorates and years
	g con=1
	bysort governates_ur year b_gender: egen vac_num=sum(vaccination) if vaccination==1
	bysort governates_ur year b_gender: egen p_subgroups=sum(con)
	bysort governates_ur year b_gender: g vac_rate01=vac_num/p_subgroups
	
	g vac_rate01_f=vac_rate01 if b_gender==2 
	g vac_rate01_m=vac_rate01 if b_gender==1
			
	* Rate of domestic violence during pregnancy
	bysort governates_ur year: egen dv_num=sum(dv_preg) if dv_preg==1 & pregnecy==1
	bysort governates_ur year: egen p_subgroups1=sum(pregnecy)
	bysort governates_ur year: g dv_rate01=dv_num/p_subgroups1
	
	* Rate of domestic violence during pregnancy by different age groups
	forvalues age_start = 15(10)35 {
		local age_end `age_start' + 9

		bysort governates_ur year: egen dv_num`age_start' = sum(dv_preg) if dv_preg == 1 & pregnecy == 1 & (age >= `age_start' & age <= `age_end')
		bysort governates_ur year: egen p_subgroups`age_start' = sum(pregnecy) if (age >= `age_start' & age <= `age_end')
		bysort governates_ur year: g dv_rate`age_start' = dv_num`age_start' / p_subgroups`age_start'
	}

	* Doctor visit rate
	g drv_number=1 if (dr_visit>=5 & dr_visit<=15)
	bysort governates_ur year: egen dr_visit_num=sum(drv_number) if drv_number==1
	bysort governates_ur year: egen dr_visit_den=sum(pregnecy)
	bysort governates_ur year: g dr_visit_rate01=dr_visit_num/dr_visit_den
	
	* Birth weight
	bysort governates_ur year: egen birth_weightm=sum(birth_weight) if b_gender==1
	bysort governates_ur year: egen birth_weightf=sum(birth_weight) if b_gender==2
	
	* Aggregate-level labor participation rate for respondents
	bysort governates_ur: egen work_num=sum(work) if work==1
	bysort governates_ur: egen p_govur=sum(con)
	bysort governates_ur: g work_rate=work_num/p_govur
	
	* Labor participation rate for respondents across different age groups
	foreach i in 1524 2534 3549 {
		if `i' == 1524 {
			bysort governates_ur: egen work_num_1524 = sum(work == 1 & age >= 15 & age <= 24)
			bysort governates_ur: egen p_govur_1524 = sum(con) if age >= 15 & age <= 24
			gen work_rate_1524 = work_num_1524 / p_govur_1524
		}
		else if `i' == 2534 {
			bysort governates_ur: egen work_num_2534 = sum(work == 1 & age >= 25 & age <= 34)
			bysort governates_ur: egen p_govur_2534 = sum(con) if age >= 25 & age <= 34
			gen work_rate_2534 = work_num_2534 / p_govur_2534
		}
		else if `i' == 3549 {
			bysort governates_ur: egen work_num_3549 = sum(work == 1 & age >= 35 & age <= 49)
			bysort governates_ur: egen p_govur_3549 = sum(con) if age >= 35 & age <= 49
			gen work_rate_3549 = work_num_3549 / p_govur_3549
		}
	}
	
	* Dependent Variable: A binary variable indicating whether a child died within 12 months of birth
	g d_12m_indicator = 0
	replace d_12m_indicator = 1 if dage <= 1
	
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
	
	* Dummy variable for wealth index
	g poorest= (weath_index==1)
	g poorer= (weath_index==2)
	g middle= (weath_index==3)
	g richer= (weath_index==4)	
	g richest= (weath_index==4)	

	g Egy_population_indiweight=86813723
	
	* Share_pop weight
	g tpeople1_w=.
	
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
		count if governates_ur==`k'
		replace tpeople1_w=r(N) if governates_ur==`k'
	
	}
	
	* Weights derived from the share of population
	g share_pop_w=.
	foreach k of numlist 1 3 4 5 7 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 {
		
	replace share_pop_w=tpeople1/Egy_population_indiweight if governates_ur==`k'
	
	}

    * Dummy variables for domestic violence for influence channel check
	recode tol_vio (1=0) (0=1) (missing=99), g(tol_vio_1) 
	label var tol_vio_1 "tolerance of domestic violence"
	label define tol_viodd 0 "do not tolerance any domestic violence " 1 "tolerance domestic violence" 99 "no information"
	label values tol_vio_1 tol_viodd
			
	recode tol_vio_noinfl (1=0) (0=1) (missing=99), g(tol_vio_noinfl_1) 
	label var tol_vio_noinfl_1 "tolerance of domestic violence"
	label define tol_vio_noinfldd 0 "do not tolerance any domestic violence " 1 "tolerance domestic violence" 99 "no information"
	label values tol_vio_noinfl_1 tol_vio_noinfldd
	
	
	append using "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\lpfp_2008.dta"
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR", replace	//for individual chanel check
exit
* Create the dataset for urban and rural levels of different governorates for the analysis of missing women
 use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem_master_age1_UR", clear

    drop _merge 

	* Collapse the data by governorates_ur and year
	ds caseid governates_ur year, not
	collapse (mean) `r(varlist)', by(governates_ur year)
	
	* Remove missing values
	replace wealthrate11=0 if wealthrate11==.
	replace wealthrate12=0 if wealthrate12==.	
	replace wealthrate13=0 if wealthrate13==.
	replace wealthrate14=0 if wealthrate14==.
	
	replace reponseedurate10=0 if reponseedurate10==.
	replace reponseedurate11=0 if reponseedurate11==.	
	replace reponseedurate12=0 if reponseedurate12==.
	
	replace hedurate10=0 if hedurate10==.
	
	* It's advisable to calculate the relative death ratio after collapsing the data
	g relativeDHSDR1=drate12/drate11
	
	sort governates_ur year b_gender

	* Independent dummy variables
	g past=(year>=2011)
	
	* Treatment and control dummy variables excluding border governorates
	g tgover_ur_noborder=tgover_ur
	replace tgover_ur_noborder=. if tgover_ur==45| tgover_ur==46| tgover_ur==47| tgover_ur==48| tgover_ur==49| tgover_ur==50				
	g group=tgover_ur_noborder
	g past_group=past*group
	
	* Treatment and control group classification based on SPYE
	g group_SPYE=tgover_SPYE
	replace group_SPYE=. if tgover_SPYE==31| tgover_SPYE==32| tgover_SPYE==33
	g past_group_SYPE=past*group_SPYE
	
	* Vaccination ratio between girls and boys
	g vac_rate01_fm=vac_rate01_f/vac_rate01_m

	* Birth-weight ratio between girls and boys
	g birth_weight_fm=birth_weightf/birth_weightm
		
	* Estimate weights using propensity score matching
	logit tgover_ur past wealthrate11 wealthrate12 wealthrate13 wealthrate14 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12 	
	
	predict Lps
	replace Lps=1 if tgover_ur==1
				
	* PS weight
	g psweightL=1/(1-Lps) if tgover_ur==0
	replace psweightL=1 if tgover_ur==1
		
	* Aggregate-level dummy including border governorates
	g group_border=tgover_ur_border
	g past_group_border=past*group_border
				
	* Placebo variables
	g past_placebo=(year>=2010)
	g past_group_placebo=past_placebo*group
								
	* Estimate weights using propensity score matching
	logit tgover_ur past_placebo wealthrate11 wealthrate12 wealthrate13 wealthrate14 nb_child reponseedurate10 reponseedurate11 reponseedurate12 age age_husband hwrate1 hedurate10 hedurate11 hedurate12  	
	predict Lps_placebo
	replace Lps_placebo=1 if tgover_ur==1
				
	* Creation of weights
	g psweightL_placebo=1/(1-Lps_placebo) if tgover_ur==0
	replace psweightL_placebo=1 if tgover_ur==1			

	*For merge
	g ID=_n
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\cr_master_age1_UR2007", replace

exit
