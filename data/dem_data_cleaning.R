#----------------------------#
# Loading packages        ####
#----------------------------#
library(tidyverse)
library(openxlsx)

#------------------------------#
# Demographic Data          ####
#------------------------------#

# Loading data
cogmob_dem <- read.xlsx("cogmob_demographics_30April2021.xlsx")
rvci_dem <- read.xlsx("rvci_demographics_30April2021.xlsx")
subjects <- read_table("subjects_list.txt", col_names = "id")

# Cleaning datasets
## RVCI
rvci_dem_clean <- rvci_dem %>% 
  rename(age = "Age.at.Enrollment", height = "Height.(cm)", weight = "Weight.(kg)", moca = Total.MoCA, mmse = Total.MMSE) %>% 
  rename_all(tolower) %>%
  rename_with(~(gsub(".", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub(",", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub("/", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub("(", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub(">", "", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub(")", "", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub("__", "_", .x, fixed = TRUE))) %>% 
  mutate(sex = str_replace_all(sex, c("M" = "male", "F" = "female")))

rvci_dem_clean <- rvci_dem_clean %>% 
  select(id, age, sex, education, moca, mmse, height, weight, bmi, meters_walked, 
         overall_fall_risk_score, best_quadriceps_strength, mean_quadriceps_strength,
         fci_1_arthritis,
         fci_2_osteoporosis,
         fci_3_asthma,
         fci_4_copd_ards_or_emphysema,
         fci_5_angina, 
         fci_6_congestive_heart_failure_or_heart_disease,
         fci_7_heart_attack_myocardial_infarct,
         fci_8_neurological_disease,
         fci_9_stroke_or_tia,
         fci_10_peripheral_vascular_disease,
         fci_11_diabetes_type_i_and_ii,
         fci_12_upper_gastrointestinal_disease,
         fci_13_depression,                                
        fci_14_anxiety_or_panic_disorders,
        fci_15_visual_impairment,
        fci_16_hearing_impairment,
        fci_17_degenerative_disc_disease,
        fci_18_obesity_and_or_body_mass_index_30,
        fci_19_thyroid_disease,
        fci_20_cancer,
        fci_21_hypertension,
        fci_total)

## CogMob
cogmob_dem_clean <- cogmob_dem %>%
  rename(height = "Final.Height", weight = "Final.Weight", moca = Total.MoCA, mmse = Total.MMSE) %>% 
  mutate(bmi = weight/((height/100)^2)) %>% 
  rename_all(tolower) %>% 
  rename_with(~(gsub(".", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub(",", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub("/", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub("(", "_", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub(">", "", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub(")", "", .x, fixed = TRUE))) %>% 
  rename_with(~(gsub("__", "_", .x, fixed = TRUE))) %>% 
  mutate(id = str_replace_all(id, c("MCI" = "FALLERS2_")))

cogmob_dem_clean <- cogmob_dem_clean %>% 
  select(id, age, sex, education, moca, mmse, height, weight, bmi, meters_walked, overall_fall_risk_score, 
         best_quadriceps_strength, mean_quadriceps_strength,
         fci_1_arthritis,
         fci_2_osteoporosis,
         fci_3_asthma,
         fci_4_copd_ards_or_emphysema,
         fci_5_angina, 
         fci_6_congestive_heart_failure_or_heart_disease,
         fci_7_heart_attack_myocardial_infarct,
         fci_8_neurological_disease,
         fci_9_stroke_or_tia,
         fci_10_peripheral_vascular_disease,
         fci_11_diabetes_type_i_and_ii,
         fci_12_upper_gastrointestinal_disease,
         fci_13_depression,                                
         fci_14_anxiety_or_panic_disorders,
         fci_15_visual_impairment,
         fci_16_hearing_impairment,
         fci_17_degenerative_disc_disease,
         fci_18_obesity_and_or_body_mass_index_30,
         fci_19_thyroid_disease,
         fci_20_cancer,
         fci_21_hypertension,
         fci_total)
  

# Merging all
all_data_demographics <- rbind(cogmob_dem_clean, rvci_dem_clean)
all_data_demographics <- left_join(subjects, all_data_demographics, by = "id")

## Recoding education and mutating FCI variables to character
all_data_demographics <- all_data_demographics %>% 
  mutate(education_r = str_replace_all(education, c("trades or professional certificate or diploma \\(CEGEP in Quebec\\)" = "trades or professional certificate",
                                                    "Less than grade 9" = "high school or less",
                                                    "high school certificate or diploma" = "high school or less",
                                                    "grades 9-13, without certificate or diploma" = "high school or less",
                                                    "some university certificate or diploma" = "some university")))

# Saving dataset  
write.xlsx(all_data_demographics, "all_data_demographics.xlsx")
