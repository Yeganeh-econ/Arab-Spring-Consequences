# Revolution and Reproduction: How the Arab Spring Reshaped Marriage and Fertility in Egypt

**Authors:** Yeganeh Karbalaei, Firat Demir, and Pallab Ghosh

Department of Economics, University of Oklahoma

---

## Repository Structure

```
Arab-Spring-Consequences/
│
├── Draft/
│   └── Draft1/
│       └── Feb_2026/                         # Current working draft
│           ├── Results_Summary.tex           # LaTeX source
│           └── Results_Summary.pdf           # Compiled PDF (13 pages)
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
│   ├── summary/                               # Formatted Excel summaries
│   │   ├── 00_Master_File_Index.xlsx          # Complete file index with descriptions
│   │   ├── 01_Main_Estimation_Summary.xlsx    # Key treatment effects & full specifications
│   │   ├── 02_Heterogeneity_Analysis_Summary.xlsx  # All Women vs Teen comparison
│   │   ├── 03_Mechanism_Analysis_Summary.xlsx # Marriage age mediation analysis
│   │   └── 04_Robustness_Checks_Summary.xlsx  # Miscarriage probability (placebo test)
│   │
│   ├── main_estimation/
│   │   ├── Pallab/                            # 6 files
│   │   │   ├── Pallab_teen_preg_reg_results_all.csv / .xlsx
│   │   │   ├── Pallab_Age_of_firstbirth_results_all.csv
│   │   │   ├── Pallab_Age_of_firstmarriage_results_all.csv
│   │   │   ├── Pallab_Occupation_results_all.csv
│   │   │   └── Pallab_Schooling_results_all.csv
│   │   └── Yeganeh/                           # 17 files
│   │       ├── AllWomen_Panel{A-D}_*.csv      # All women panel results (8 files)
│   │       └── Panel{A-E}_*.csv               # Teen pregnancy panel results (9 files)
│   │
│   ├── hetro_analysis/
│   │   ├── Pallab/                            # 3 files
│   │   │   ├── Pallab_Age_of_firstmarriage_results_teen.csv
│   │   │   ├── Pallab_Occupation_results_teen.csv
│   │   │   └── Pallab_Schooling_results_teen.csv
│   │   └── Yeganeh/                           # 21 files
│   │       ├── age_group_comparison.csv       # Age group heterogeneity
│   │       ├── urban.csv / rural.csv + related  # Urban/rural (7 files)
│   │       ├── early/late/very_early_pregnancy.csv  # Pregnancy timing (3 files)
│   │       └── wealth_poorest...richest.csv   # Wealth quintiles (5 files)
│   │
│   ├── mechanism/
│   │   ├── Pallab/                            # 2 files
│   │   │   ├── Pallab_teen_preg_mechanism.csv
│   │   │   └── Pallab_Age_of_firstmarriage_mechanism.csv
│   │   └── Yeganeh/                           # 6 files
│   │       ├── contraceptive_*.png            # Contraceptive analysis figures (5)
│   │       └── modern_vs_traditional_did.png  # Modern vs traditional DiD
│   │
│   └── robustness_checks/
│       └── Pallab/                            # 2 files
│           ├── Pallab_Miscarriage_prob_results_all.csv
│           └── Pallab_Miscarriage_prob_results_teen.csv
│
└── README.md
```