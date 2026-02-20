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
		local path "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\" 
		}
		if `user'==4 {
		local path "..." 
		}
	
		cd "`path'"
		
*Table 3 Appendix
*: Summary Statistics of Death Ratios in High- and Low-Protest Areas in Egypt 
	*treatment and control group indexes
	
	*treatment group	
	use "cr_master_UR", clear
	
		drop if tgover==.
		drop if governorate==31|governorate==32|governorate==33|governorate==34|governorate==35
				
		sort tgover year
			
		collapse (sum) missingwomen1 missingwomen19 missingwomen1019 missingwomen2029 tpeople_national12, by (year)
		g mwshare1=missingwomen1/tpeople_national12 
		g mwshare19=missingwomen19/tpeople_national12
		g mwshare1019=missingwomen1019/tpeople_national12 
		g mwshare2029=missingwomen2029/tpeople_national12
		
		keep year mwshare1 mwshare19 mwshare1019 mwshare2029
		
	save "Table3_treatment_appendix",replace
	export excel using "Table3_treatment_appendix", firstrow(variables) replace	
	
	