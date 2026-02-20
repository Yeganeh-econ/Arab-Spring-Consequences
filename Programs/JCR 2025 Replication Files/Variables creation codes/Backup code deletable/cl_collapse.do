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
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\Codes\Publication code\cr_master_age1_UR2007", replace
