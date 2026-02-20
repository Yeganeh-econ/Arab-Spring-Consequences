clear all
capture log close
set more off

* do all dofiles
* cr
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Clean codes"
do "cr_indicator_DHS"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Clean codes"
do "cr_structure_DHS"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Clean codes"
do "cr_tem_append"


* variables creations
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Variables creation codes"
do "cr_master_DHS01 governates urban and rural"
  
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Variables creation codes"
do "cr_master_DHS19 governates urban and rural" 
  
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Variables creation codes"
do "cr_master_DHS1019 governates urban and rural" 
  
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Variables creation codes"
do "cr_master_DHS2029 governates urban and rural"   

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\Variables creation codes"
do "cr_master_merge_all_age_groups"  


* all tables and graphs creations
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Publication code\Submission\All tables and graphs codes"
do "cr_master_merge_all_age_groups"  
  
  
  
cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS59 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS19 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS1014 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS1519 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS1019 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS2024 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS2529 governates urban and rural 2007"

cd "C:\Users\AmericanCaptain\Dropbox\Papers_with_Zhengang\Codes\Try"
do "cr_master_DHS2029 governates urban and rural 2007"


exit