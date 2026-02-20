# Arab-Spring-Consequences

## Repository Structure

```
Arab-Spring-Consequences/
│
├── Data/
│   ├── source_data/                        # Raw/original data files
│   └── model_data/                         # Cleaned and processed data for analysis
│       ├── Combined_DHS_2005_2008_2014.dta
│       └── Combined_DHS_2005_2008_2014_extended.dta
│
├── Programs/
│   ├── stata/
│   │   ├── Pallab/
│   │   │   └── Pallab_Jan2025/
│   │   │       ├── Dec_2025/               # December 2025 analysis
│   │   │       │   ├── Figures/
│   │   │       │   │   ├── teen_preg_trends.png
│   │   │       │   │   └── teen_preg_trends_smooth.png
│   │   │       │   ├── Results/
│   │   │       │   │   ├── Age_of_marriage_regression_results.csv
│   │   │       │   │   ├── Education_regression_results.csv
│   │   │       │   │   ├── teen_preg_logit_mfx.csv
│   │   │       │   │   ├── teen_preg_logit_mfx_1976_2014.csv
│   │   │       │   │   └── teen_preg_regression_results.csv
│   │   │       │   ├── teen_pregnancy_regression_results.do
│   │   │       │   ├── teen_pregnancy_regression_results_Dec19.do
│   │   │       │   └── teen_pregnancy_su_figure.do
│   │   │       └── Jan_2026/               # January 2026 analysis
│   │   │           └── results/            # (organized copies in Results/)
│   │   ├── Yeganeh/
│   │   │   └── Het_Analysis.do             # Heterogeneity analysis
│   │   └── Zhengang/
│   │       ├── reg_tables_governate.do
│   │       └── reg_tables.do
│   ├── R/
│   └── JCR 2025 Replication Files/
│       ├── Master for all do/
│       │   └── master_all_do.do            # Master do-file to run all programs
│       ├── Clean codes/
│       │   ├── cl_structure_DHS.do
│       │   ├── cl_indicator_DHS.do
│       │   ├── cl_labor_participation_2008_govlevel.do
│       │   ├── cl_lp&fp_2008.do
│       │   └── cl_tem_append.do
│       ├── Variables creation codes/
│       │   ├── cl_master_DHS01 governates urban and rural.do
│       │   ├── cl_master_DHS1019 governates urban and rural.do
│       │   ├── cl_master_DHS19 governates urban and rural.do
│       │   ├── cl_master_DHS2029 governates urban and rural.do
│       │   └── cl_master_merge_all_age_groups.do
│       ├── All regression tables and graphs codes/
│       │   ├── reg_tables_governate.do
│       │   ├── reg_tables_individual_Din12month.do
│       │   ├── reg_tables_individual_appendix.do
│       │   ├── reg_tables_governate_appendix.do
│       │   ├── reg_channels_Appendix.do
│       │   ├── gra_Figure123_T&C.do
│       │   ├── gra_Figure4&6.do
│       │   ├── gra_Figures_Appendix.do
│       │   ├── sum_tables.do
│       │   ├── sum_tables_Appendix A1.do
│       │   ├── sum_channel_variables.do
│       │   └── Results for RandR1.do
│       ├── cl_developed_index.do
│       └── All Results Instruction.docx
│
├── References/
│   ├── Boyle et al SSM 2006.pdf
│   ├── cdc_13211_DS1.pdf
│   ├── EJPE 2020.pdf
│   ├── Pratley SSM 2016.pdf
│   ├── SSM 2006.pdf
│   ├── SSM 2022.pdf
│   ├── WD_2020.pdf
│   ├── Power of the Street Acemoglu 2017.pdf
│   ├── Power of the street Appendix.pdf
│   ├── Women_Empowerment_Arab_Spring_JD_2019.pdf
│   └── ...
│
├── Results/
│   ├── main_estimation/
│   │   ├── Pallab_teen_preg_reg_results_all.csv      # (Pallab)
│   │   ├── Pallab_teen_preg_reg_results_all.xlsx      # (Pallab)
│   │   ├── Pallab_Age_of_firstbirth_results_all.csv   # (Pallab)
│   │   ├── Pallab_Age_of_firstmarriage_results_all.csv# (Pallab)
│   │   ├── Pallab_Occupation_results_all.csv           # (Pallab)
│   │   ├── Pallab_Schooling_results_all.csv            # (Pallab)
│   │   ├── AllWomen_PanelA_HasEducation_detailed.csv   # (Yeganeh)
│   │   ├── AllWomen_PanelA_Working_detailed.csv        # (Yeganeh)
│   │   ├── AllWomen_PanelB_EducationLevels_detailed.csv# (Yeganeh)
│   │   ├── AllWomen_PanelB_OccupationType_detailed.csv # (Yeganeh)
│   │   ├── PanelA_HasEducation_detailed.csv            # (Yeganeh)
│   │   ├── PanelA_Working_detailed.csv                 # (Yeganeh)
│   │   ├── PanelB_EducationLevels_detailed.csv         # (Yeganeh)
│   │   ├── PanelB_OccupationType_detailed.csv          # (Yeganeh)
│   │   └── ...
│   │
│   ├── hetro_analysis/
│   │   ├── Pallab_Age_of_firstmarriage_results_teen.csv# (Pallab)
│   │   ├── Pallab_Occupation_results_teen.csv          # (Pallab)
│   │   ├── Pallab_Schooling_results_teen.csv           # (Pallab)
│   │   ├── age_group_comparison.csv                    # (Yeganeh)
│   │   ├── het_urban_rural.csv                         # (Yeganeh)
│   │   ├── urban.csv / rural.csv                       # (Yeganeh)
│   │   ├── early_pregnancy.csv / late_pregnancy.csv    # (Yeganeh)
│   │   ├── wealth_poorest.csv ... wealth_richest.csv   # (Yeganeh)
│   │   └── ...
│   │
│   ├── mechanism/
│   │   ├── Pallab_Age_of_firstmarriage_mechanism.csv   # (Pallab)
│   │   ├── Pallab_teen_preg_mechanism.csv              # (Pallab)
│   │   ├── contraceptive_categories_grouped.png        # (Yeganeh)
│   │   ├── contraceptive_trends_by_treatment.png       # (Yeganeh)
│   │   ├── modern_vs_traditional_did.png               # (Yeganeh)
│   │   └── ...
│   │
│   └── robustness_checks/
│       ├── Pallab_Miscarriage_prob_results_all.csv     # (Pallab)
│       └── Pallab_Miscarriage_prob_results_teen.csv    # (Pallab)
│
└── README.md
```