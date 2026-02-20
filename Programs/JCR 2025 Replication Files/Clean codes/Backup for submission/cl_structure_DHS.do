* Second step, restructure DHS data:
* DHS 2014 is a cross-sectional dataset where each family has children with varying birth years and ages. 
* After running the cr_structure do-file, the horizontal children informationwill be transformed into column observations.
clear all
capture log close
set more off

* Modification of dataset structure:
* The variables bord_1 to bord_20 range from 1 to 20. This "_n" does not represent birth order.

* Information regarding the first child in DHS2014
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear

* Drop the variable representing birth order
	forvalues i=2(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted.
	forvalues i=0(1)13 {
		forvalues j=2(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
															  				  	
	forvalues i=15(1)16 {
		forvalues j=2(1)9{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
		
	rename (bord_01 b0_01 b1_01 b2_01 b3_01 b4_01 b5_01 b6_01 b7_01 b8_01 b9_01 ///
			b10_01 b11_01 b12_01 b13_01 b15_01 b16_01 deathyear_01 d_01 ///
			m19_1 m14_1) (b_ord b_ordtw b_mon b_yr b_cmc b_gender ///
			b_alive bdd_time bdd_month bal_age b_livewith b_inforcom b_interL ///
			b_interC b_inforck b_omitck b_line deathyear dage ///
			birth_weight dr_visit)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	g vaccination = (s605c_1==1|s605c_1==3) if !missing(s605c_1) 
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem1", replace


* Second kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_01 deathyear_01 d_01
	
	forvalues i=3(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_01			  
							}

	forvalues i=0(1)13 {
		forvalues j=3(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_01			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=3(1)9{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_02 b0_02 b1_02 b2_02 b3_02 b4_02 b5_02 b6_02 b7_02 b8_02 b9_02 ///
			b10_02 b11_02 b12_02 b13_02 b15_02 b16_02 deathyear_02 ///
			d_02 m19_2 m14_2) (b_ord b_ordtw b_mon b_yr b_cmc b_gender b_alive ///
			bdd_time bdd_month bal_age b_livewith b_inforcom b_interL ///
			b_interC b_inforck b_omitck b_line deathyear dage ///
			birth_weight dr_visit)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	g vaccination = (s605c_2==1|s605c_2==3) if !missing(s605c_2) 
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1	
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem2", replace


* Third kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_01 deathyear_01 bord_02 deathyear_02 d_01 d_02
	
	forvalues i=4(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_01 b`i'_02			  
							}

	forvalues i=0(1)13 {
		forvalues j=4(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_01 b`i'_02			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=4(1)9{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_03 b0_03 b1_03 b2_03 b3_03 b4_03 b5_03 b6_03 b7_03 b8_03 b9_03 ///
			b10_03 b11_03 b12_03 b13_03 b15_03 b16_03 deathyear_03 d_03  ///
			m19_3 m14_3) (b_ord b_ordtw b_mon b_yr b_cmc b_gender b_alive bdd_time ///
			bdd_month bal_age b_livewith b_inforcom b_interL b_interC ///
			b_inforck b_omitck b_line deathyear dage birth_weight dr_visit)
	
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	g vaccination = (s605c_3==1|s605c_3==3) if !missing(s605c_3) 
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
	
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem3",replace


*Fourth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_01 deathyear_01 bord_02 deathyear_02 bord_03 deathyear_03 d_01 d_02 d_03
	
	forvalues i=5(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_01 b`i'_02 b`i'_03		  
							}

	forvalues i=0(1)13 {
		forvalues j=5(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_01 b`i'_02 b`i'_03			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=5(1)9{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_04 b0_04 b1_04 b2_04 b3_04 b4_04 b5_04 b6_04 b7_04 b8_04 b9_04 ///
			b10_04 b11_04 b12_04 b13_04 b15_04 b16_04 deathyear_04 d_04 ///
			m19_4 m14_4) (b_ord b_ordtw b_mon b_yr b_cmc b_gender b_alive bdd_time ///
			bdd_month bal_age b_livewith b_inforcom b_interL b_interC ///
			b_inforck b_omitck b_line deathyear dage birth_weight dr_visit)
	
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	g vaccination = (s605c_4==1|s605c_4==3) if !missing(s605c_4) 
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem4", replace


*Fifth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_01 deathyear_01 bord_02 deathyear_02 bord_03 deathyear_03 ///
		 bord_04 deathyear_04 d_01 d_02 d_03 d_04
	
	forvalues i=6(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_01 b`i'_02 b`i'_03 b`i'_04	  
							}

	forvalues i=0(1)13 {
		forvalues j=6(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_01 b`i'_02 b`i'_03 b`i'_04			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=6(1)9{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_05 b0_05 b1_05 b2_05 b3_05 b4_05 b5_05 b6_05 b7_05 b8_05 b9_05 ///
			b10_05 b11_05 b12_05 b13_05 b15_05 b16_05 deathyear_05 ///
			d_05 m19_5 m14_5) (b_ord b_ordtw b_mon b_yr b_cmc b_gender b_alive ///
			bdd_time bdd_month bal_age b_livewith b_inforcom b_interL ///
			b_interC b_inforck b_omitck b_line deathyear dage birth_weight dr_visit)
	
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	g vaccination = (s605c_5==1|s605c_5==3) if !missing(s605c_5) 
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem5", replace


*Sixth kid information
	use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_07 deathyear_07 bord_08 deathyear_08 bord_09 deathyear_09 d_07 ///
	     d_08 d_09
	
	forvalues i=1(1)5	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_07 b`i'_08 b`i'_09  
							}

	forvalues i=0(1)13 {
		forvalues j=1(1)5	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_07 b`i'_08 b`i'_09			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=1(1)5{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_06 b0_06 b1_06 b2_06 b3_06 b4_06 b5_06 b6_06 b7_06 b8_06 b9_06 ///
			b10_06 b11_06 b12_06 b13_06 b15_06 b16_06 deathyear_06 d_06 ///
			m19_6 m14_6) (b_ord b_ordtw b_mon b_yr b_cmc b_gender b_alive bdd_time ///
			bdd_month bal_age b_livewith b_inforcom b_interL b_interC ///
			b_inforck b_omitck b_line deathyear dage birth_weight dr_visit)
	
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	g vaccination = (s605c_6==1|s605c_6==3) if !missing(s605c_6) 
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem6", replace
	
	
* Seventh kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_08 deathyear_08 bord_09 deathyear_09 d_08 d_09
	
	forvalues i=1(1)6	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_08 b`i'_09  
							}

	forvalues i=0(1)13 {
		forvalues j=1(1)6	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_08 b`i'_09			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=1(1)6{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_07 b0_07 b1_07 b2_07 b3_07 b4_07 b5_07 b6_07 b7_07 b8_07 b9_07 ///
			b10_07 b11_07 b12_07 b13_07 b15_07 b16_07 deathyear_07 d_07) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem7", replace	
	

*Eighth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order
	drop bord_09 deathyear_09 d_09
	
	forvalues i=1(1)7	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
				  
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {	
		drop b`i'_09  
							}

	forvalues i=0(1)13 {
		forvalues j=1(1)7	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {	
		drop b`i'_09			  
							}
					  	
	forvalues i=15(1)16 {
		forvalues j=1(1)7{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_08 b0_08 b1_08 b2_08 b3_08 b4_08 b5_08 b6_08 b7_08 b8_08 b9_08 ///
			b10_08 b11_08 b12_08 b13_08 b15_08 b16_08 deathyear_08 d_08) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem8", replace	



*Ninth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)8	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=10(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)8	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=10(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)8{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=10(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_09 b0_09 b1_09 b2_09 b3_09 b4_09 b5_09 b6_09 b7_09 b8_09 b9_09 ///
			b10_09 b11_09 b12_09 b13_09 b15_09 b16_09 deathyear_09 d_09) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem9", replace		

*Tenth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	forvalues i=11(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {
		forvalues j=11(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)9{
		drop b`i'_0`j'
						}
					  }		
					
	forvalues i=15(1)16 {
		forvalues j=11(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_10 b0_10 b1_10 b2_10 b3_10 b4_10 b5_10 b6_10 b7_10 b8_10 b9_10 ///
			b10_10 b11_10 b12_10 b13_10 b15_10 b16_10 deathyear_10 d_10) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem10", replace	

*Eleventh kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	drop bord_10 deathyear_10 d_10
	
	forvalues i=12(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {	
		drop b`i'_10  
							}
							
	forvalues i=0(1)13 {
		forvalues j=12(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)9{
		drop b`i'_0`j'
						}
					  }	
					  
	forvalues i=15(1)16 {	
		drop b`i'_10  
							}
					
	forvalues i=15(1)16 {
		forvalues j=12(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_11 b0_11 b1_11 b2_11 b3_11 b4_11 b5_11 b6_11 b7_11 b8_11 b9_11 ///
			b10_11 b11_11 b12_11 b13_11 b15_11 b16_11 deathyear_11 d_11) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem11", replace	


*Twelveth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	drop bord_10 deathyear_10 bord_11 deathyear_11 d_10 d_11
	
	forvalues i=13(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {	
		drop b`i'_10 b`i'_11 
							}
							
	forvalues i=0(1)13 {
		forvalues j=13(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)9{
		drop b`i'_0`j'
						}
					  }	
					  
	forvalues i=15(1)16 {	
		drop b`i'_10 b`i'_11
							}
					
	forvalues i=15(1)16 {
		forvalues j=13(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_12 b0_12 b1_12 b2_12 b3_12 b4_12 b5_12 b6_12 b7_12 b8_12 b9_12 ///
			b10_12 b11_12 b12_12 b13_12 b15_12 b16_12 deathyear_12 d_12) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem12", replace	


*Thirteenth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	drop bord_10 deathyear_10 bord_11 deathyear_11 bord_12 deathyear_12 d_10 d_11 d_12
	
	forvalues i=14(1)20	{
		drop bord_`i' deathyear_`i' d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {	
		drop b`i'_10 b`i'_11 b`i'_12
							}
							
	forvalues i=0(1)13 {
		forvalues j=14(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)9{
		drop b`i'_0`j'
						}
					  }	
					  
	forvalues i=15(1)16 {	
		drop b`i'_10 b`i'_11 b`i'_12
							}
					
	forvalues i=15(1)16 {
		forvalues j=14(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_13 b0_13 b1_13 b2_13 b3_13 b4_13 b5_13 b6_13 b7_13 b8_13 b9_13 ///
			b10_13 b11_13 b12_13 b13_13 b15_13 b16_13 deathyear_13 d_13) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem13", replace	
			
*Foureenth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	drop bord_10 deathyear_10 bord_11 deathyear_11 bord_12 deathyear_12 ///
	bord_13 deathyear_13 d_10 d_11 d_12 d_13
	
	forvalues i=15(1)20	{
		drop bord_`i' deathyear_`i'  d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {	
		drop b`i'_10 b`i'_11 b`i'_12 b`i'_13
							}
							
	forvalues i=0(1)13 {
		forvalues j=15(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)9{
		drop b`i'_0`j'
						}
					  }	
					  
	forvalues i=15(1)16 {	
		drop b`i'_10 b`i'_11 b`i'_12 b`i'_13
							}
					
	forvalues i=15(1)16 {
		forvalues j=15(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_14 b0_14 b1_14 b2_14 b3_14 b4_14 b5_14 b6_14 b7_14 b8_14 b9_14 ///
			b10_14 b11_14 b12_14 b13_14 b15_14 b16_14 deathyear_14 d_14) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem14", replace				
			
			
			
*Fifeenth kid information
use "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\Indicator", clear
	
* Drop the variable representing birth order 
	forvalues i=1(1)9	{
		drop bord_0`i' deathyear_0`i' d_0`i'
						}					
	
	drop bord_10 deathyear_10 bord_11 deathyear_11 bord_12 deathyear_12 ///
	bord_13 deathyear_13 bord_14 deathyear_14 d_10 d_11 d_12 d_13 d_14
	
	forvalues i=16(1)20	{
		drop bord_`i' deathyear_`i'  d_`i'
						}				
						
						
* All birth information. Note: Variable b14 is redundant and identical to b15, therefore it is omitted
	forvalues i=0(1)13 {
		forvalues j=1(1)9	{
		drop b`i'_0`j'			
					  }
							}

	forvalues i=0(1)13 {	
		drop b`i'_10 b`i'_11 b`i'_12 b`i'_13 b`i'_14
							}
							
	forvalues i=0(1)13 {
		forvalues j=16(1)20	{
		drop b`i'_`j'			
					  }
							}		
											
		
	forvalues i=15(1)16 {
		forvalues j=1(1)9{
		drop b`i'_0`j'
						}
					  }	
					  
	forvalues i=15(1)16 {	
		drop b`i'_10 b`i'_11 b`i'_12 b`i'_13 b`i'_14
							}
					
	forvalues i=15(1)16 {
		forvalues j=16(1)20{
		drop b`i'_`j'
						}
					  }			
					  
	rename (bord_15 b0_15 b1_15 b2_15 b3_15 b4_15 b5_15 b6_15 b7_15 b8_15 b9_15 ///
			b10_15 b11_15 b12_15 b13_15 b15_15 b16_15 deathyear_15 d_15) (b_ord b_ordtw b_mon b_yr b_cmc ///
			b_gender b_alive bdd_time bdd_month bal_age b_livewith b_inforcom ///
			b_interL b_interC b_inforck b_omitck b_line deathyear dage)
			
	g dv_preg =1 if d118a==1| d118b==1| d118c==1| d118d==1| d118e==1| ///
	d118f==1| d118g==1| d118h==1| d118i==1| d118j==1| d118k==1| d118l==1| ///
	d118m==1| d118n==1| d118o==1| d118p==1| d118q==1| d118r==1| d118s==1| ///
	d118t==1| d118u==1| d118v==1| d118w==1| d118x==1| d118y==1| d118xa==1| ///
	d118xb==1| d118xc==1| d118xd==1| d118xe==1| d118xf==1| d118xg==1| ///
	d118xh==1| d118xi==1| d118xj==1| d118xk==1
	
	* Pregnancy status
	g pregnecy=1 if v201!=0 | v213==1 | v228==1
		
save "C:\Users\zheng\Dropbox\Papers_with_Zhengang\arab_spring_missing_women\data\data_cleaning\Cleaned DHS\tem15", replace				
		
*Because since 16th kid, there is no information, I do not clean the rest part.

exit
