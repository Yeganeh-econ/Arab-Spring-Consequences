clear all
capture log off

set more off

cd "C:\Users\Americancaptain\Dropbox\Papers_with_Zhengang\Data\Cleaned\Cleaned Developed"

	use "Developed countries dying_cleaned_WRages", clear
	
	local varlist1 Austrilia19 Austrilia1019 Austrilia2029 Austria19 Austria1019 Austria2029 ///
	Belgium19 Belgium1019 Belgium2029 Canada19 Canada1019 Canada2029 France19 France1019 ///
	France2029 German19 German1019 German2029 Japan19 Japan1019 Japan2029 Luxembourg19 ///
	Luxembourg1019 Luxembourg2029 Netherlands19 Netherlands1019 Netherlands2029 NewZealand19 ///
	NewZealand1019 NewZealand2029 Switzerland19 Switzerland1019 Switzerland2029 US19 US1019 US2029

	*Percentage transfer
	foreach var of local varlist1 {
		
		replace `var'=`var'/200000
		
											 }
									 
	local varlist2 Austrilia14 Austrilia59 Austrilia1014 Austrilia1519 Austrilia2024 Austrilia2529 ///
	Austrilia3034 Austria14 Austria59 Austria1014 Austria1519 Austria2024 Austria2529 ///
	Austria3034 Belgium14 Belgium59 Belgium1014 Belgium1519 Belgium2024 Belgium2529 ///
	Belgium3034 Canada14 Canada59 Canada1014 Canada1519 Canada2024 Canada2529 Canada3034 ///
	France14 France59 France1014 France1519 France2024 France2529 France3034 ///
	German14 German59 German1014 German1519 German2024 German2529 German3034 Japan14 ///
	Japan59 Japan1014 Japan1519 Japan2024 Japan2529 Japan3034 Luxembourg14 Luxembourg59 ///
	Luxembourg1014 Luxembourg1519 Luxembourg2024 Luxembourg2529 Luxembourg3034 ///
	Netherlands14 Netherlands59 Netherlands1014 Netherlands1519 Netherlands2024 Netherlands2529 ///
	Netherlands3034 NewZealand14 NewZealand59 NewZealand1014 NewZealand1519 NewZealand2024 ///
	NewZealand2529 NewZealand3034 Switzerland14 Switzerland59 Switzerland1014 Switzerland1519 ///
	Switzerland2024 Switzerland2529 Switzerland3034 US14 US59 US1014 US1519 US2024 US2529 US3034 ///
	Austrilia1 Austria1 Belgium1 Canada1 France1 German1 Japan1 Luxembourg1 Netherlands1 NewZealand1 Switzerland1 US1 	 

	*Percentage transfer
	foreach var of local varlist2 {
		
		replace `var'=`var'/100000
		
											 }			 
	
	*Calculated developed country index
	foreach i of numlist 1 14 59 19 1014 1519 1019 2024 2529 2029 {
			
		g developed1`i'=.
					
		g developed2`i'=.
																							
																				}
																																				
	forvalues j=2000(1)2014 {
		foreach i of numlist 1 14 59 19 1014 1519 1019 2024 2529 2029 {
		
			replace developed1`i'=(Austrilia`i'+Austria`i'+Belgium`i'+Canada`i'+France`i'+German`i'+Japan`i'+ ///
			Luxembourg`i'+Netherlands`i'+NewZealand`i'+Switzerland`i'+US`i')/12 if CountryAgeGroup=="M`j'"
			
			replace developed2`i'=(Austrilia`i'+Austria`i'+Belgium`i'+Canada`i'+France`i'+German`i'+Japan`i'+ ///
			Luxembourg`i'+Netherlands`i'+NewZealand`i'+Switzerland`i'+US`i')/12 if CountryAgeGroup=="F`j'"
																							
																							}
												}
									
*index organized
	forvalues j=2000(1)2014 {
		forvalues s=1(1)2 {
			foreach i of numlist 1 14 59 19 1014 1519 1019 2024 2529 2029 {
			

				g d`j'`s'`i'=. if CountryAgeGroup=="M`j'"

										
																						}
									}
										}



	forvalues j=2000(1)2014 {
			foreach i of numlist 1 14 59 19 1014 1519 1019 2024 2529 2029 {
			

				replace d`j'1`i'=developed1`i' if CountryAgeGroup=="M`j'"
				replace d`j'2`i'=developed2`i' if CountryAgeGroup=="F`j'"

										
																						}
									
										}

	*gsort -genderage
	sort CountryAgeGroup
	forvalues j=2000(1)2014 {
	forvalues s=1(1)2 {
		foreach i of numlist 1 14 59 19 1014 1519 1019 2024 2529 2029 {
			
			replace d`j'`s'`i'=d`j'`s'`i'[_n-1] if d`j'`s'`i'== . 

										
																					}
									}
										}
	
	*sort genderage
	forvalues j=2000(1)2014 {
	forvalues s=1(1)2 {
		foreach i of numlist 1 14 59 19 1014 1519 1019 2024 2529 2029 {
			
			replace d`j'`s'`i'=d`j'`s'`i'[_n+1] if d`j'`s'`i'== . 

										
																					}
									}
										}
	

	keep if _n==_N
	
	gen id=_n
	move id CountryAgeGroup
	drop CountryAgeGroup
	
	
save "C:\Users\Americancaptain\Dropbox\Papers_with_Zhengang\Data\Cleaned\Cleaned Developed\agg_developedindex_WRages", replace



