# Arab-Spring-Consequences

## Repository Structure

```
Arab-Spring-Consequences/
│
├── Data/
│   ├── source_data/                  # Raw/original data files
│   └── model_data/                   # Cleaned and processed data for analysis
│
├── Programs/
│   ├── stata/
│   │   └── Het_Analysis.do           # Heterogeneity analysis
│   ├── R/
│   └── JCR 2025 Replication Files/
│       ├── Master for all do/
│       │   └── master_all_do.do      # Master do-file to run all programs
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
│
├── Results/
│   ├── main_estimation/
│   ├── hetro_analysis/
│   ├── mechanism/
│   └── robustness_checks/
│
└── README.md
```