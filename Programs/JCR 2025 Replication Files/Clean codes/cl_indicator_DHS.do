* Organize original rough DHS data set
clear all
capture log close
set more off

cd "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\source\DHS raw\DHS 2014\EGIR61DT" 
use EGIR61FL,clear
		
	* Death age in years
	forvalues i=1(1)9 {
		gen d_0`i'=0 if b7_0`i'==0
					  }

	forvalues i=10(1)20 {
		gen d_`i'=0 if b7_`i'==0
						}
	
	forvalues i=1(1)9 {
		replace d_0`i'=1 if b7_0`i'>=1 & b7_0`i'<=12
		replace d_0`i'=2 if b7_0`i'>=13 & b7_0`i'<=24
		replace d_0`i'=b7_0`i'/12 if b7_0`i'>=25
					  }
							
	forvalues i=10(1)20 {
		replace d_`i'=1 if b7_`i'>=1 & b7_`i'<=12
		replace d_`i'=2 if b7_`i'>=13 & b7_`i'<=24
		replace d_`i'=b7_`i'/12 if b7_`i'>=25
						}
	* b7_03==88 can not be divided by 12 into an integer
	replace d_03=8 if b7_03==88
	
	* Death years
	forvalues i=1(1)9 {
		gen deathyear_0`i'=b2_0`i'+d_0`i'
					  }
	
	forvalues i=10(1)20 {
		gen deathyear_`i'=b2_`i'+d_`i'
					    }
						
* Respondents' marital condition
	g marriagedur = v512
					  
	* In variable "deathyear_01", death age is approxmate to 1 -> deathyear=2015.
	replace deathyear_01=2014 if deathyear_01==2015
		
* Female empower dummies
	
	* Visit family or relative   
		* Respondent alone or Respondent and husband decide together=1
		g visit_both=1 if v743d==1| v743d==2
		replace visit_both=0 if v743d==4
		replace visit_both=5 if v743d==5
		replace visit_both=6 if v743d==6
		replace visit_both=99 if v743d==.
		
		label var visit_both "visiting family or relative"
		label define visit_bothd 1 "response or with husband decide" 0 "husband decides alone" 5 "other" 6 "other" 99 "no information"
		label values visit_both visit_bothd

		* Response decide alone=1
		g visit_alone=1 if v743d==1
		replace visit_alone=0 if v743d==2| v743d==4
		replace visit_alone=5 if v743d==5
		replace visit_alone=6 if v743d==6
		replace visit_alone=99 if v743d==.
		
		label var visit_alone "visiting family or relative"
		label define visit_aloned 1 "response decide alone" 0 "response does not decide alone" 5 "other" 6 "other" 99 "no information"
		label values visit_alone visit_aloned
				
	* Main purchase
		* Respondent alone or Respondent and husband decide together=1, only husband decide=0
		recode v743b (1 2=1) (4=0), gen (pur_both)	
		replace pur_both=5 if v743b==5
		replace pur_both=6 if v743b==6
		replace pur_both=99 if v743b==.
		
		label var pur_both "household purchase decision"
		label define pur_bothd 1 "response alone or with husband" 0 "husband alone" 5 "other" 6 "other" 99 "no information"
		label values pur_both pur_bothd
		
		* Respondent alone=1, only both decide=0
		recode v743b (1=1) (2 4=0), gen (pur_alone)	
		replace pur_alone=5 if v743b==5
		replace pur_alone=6 if v743b==6
		replace pur_alone=99 if v743b==.
		
		label var pur_alone "household purchase decision"
		label define pur_aloned 1 "response alone " 0 "husband alone or with husband" 5 "other" 6 "other" 99 "no information"
		label values pur_alone pur_aloned
				
	* Respondent's health condition
		* Respondent alone or Respondent and husband decide together=1, only husband decide=0
		recode v743a (1 2=1) (4=0), gen (health_both)	
		replace health_both=5 if v743a==5
		replace health_both=6 if v743a==6
		replace health_both=99 if v743a==.
		
		label var health_both "response health decision"
		label define health_bothd 1 "response alone or with husband" 0 "husband alone" 5 "other" 6 "other" 99 "no information"
		label values health_both health_bothd
		
		* Respondent alone=1, only both decide=0
		recode v743a (1=1) (2 4=0), gen (health_alone)	
		replace health_alone=5 if v743a==5
		replace health_alone=6 if v743a==6
		replace health_alone=99 if v743a==.
		
		label var health_alone "response health decision"
		label define health_aloned 1 "response alone" 0 "husband or both alone" 5 "other" 6 "other" 99 "no information"
		label values health_alone health_aloned
		
	* Agree with female excision
		* Aisgree with female excision=1
		recode g116 (0=1) (1=0), gen (excision)
		replace excision=8 if g116==8
		replace excision=99 if g116==.
		
		label var excision "attitude on female excision"
		label define excisiond 1 "disagree female excision" 0 "agree female excision" 8 "do not know" 99 "no information"
		label values excision excisiond		

		* Aisgree with female excision=1 and no men during interview
		g excision_noinfl=1 if g116==0 & (v811==0 & v812==0 & v813==0 & v814==0)
		replace excision_noinfl=0 if g116==1 & (v811==0 & v812==0 & v813==0 & v814==0)
		replace excision_noinfl=8 if g116==8
		replace excision_noinfl=99 if g116==.
		
		label var excision_noinfl "attitude on female excision no men influence"
		label define excision_noinfld 1 "disagree female excision no men influence" 0 "agree female excision no men influence" 8 "do not know" 99 "no information"
		label values excision_noinfl excision_noinfld
	
	* Domestic violence tolerance
		* Disagree with any kind of domestic violence=1
		g tol_vio=1 if v744a==0| v744b==0| v744c==0| v744d==0| v744e==0
		replace tol_vio=0 if v744a==1 & v744b==1 & v744c==1 & v744d==1 & v744e==1
		replace tol_vio=99 if tol_vio==.
		
		label var tol_vio "tolerance of domestic violence"
		label define tol_viod 1 "do not tolerance any domestic violence " 0 "tolerance domestic violence" 99 "no information"
		label values tol_vio tol_viod
		
		* Disagree with any kind of domestic violence=1 - no men during interview
		g tol_vio_noinfl=1 if (v744a==0| v744b==0| v744c==0| v744d==0| v744e==0) & (v811==0 & v812==0 & v813==0 & v814==0)
		replace tol_vio_noinfl=0 if (v744a==1 & v744b==1 & v744c==1 & v744d==1 & v744e==1) & (v811==0 & v812==0 & v813==0 & v814==0)
		replace tol_vio_noinfl=99 if tol_vio_noinfl==.
		
		label var tol_vio_noinfl "tolerance of domestic violence no men finluence"
		label define tol_vio_noinfld 1 "do not tolerance any domestic violence no men finluence" 0 "tolerance domestic violence no men finluence" 99 "no information"
		label values tol_vio_noinfl tol_vio_noinfld
		
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
	
	save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", replace	
	    
	      
exit
	
