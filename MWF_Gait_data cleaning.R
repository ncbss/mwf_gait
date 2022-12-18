#------------------------------------------------------------------#
# Loading packages                                              ####
#------------------------------------------------------------------#
library(tidyverse)
library(openxlsx)

#------------------------------------------------------------------#
# Loading data                                                  ####
#------------------------------------------------------------------#

# Demographics data
all_data_demographics <- read.xlsx("./data/all_data_demographics.xlsx")

# GAITRite data
all_gait_data_raw <- rbind(read.xlsx("./data/cogmob_GAITRite_merged_clean_long.xlsx"), # Merging at import
                     read.xlsx("./data/rvci_GAITRite_merged_clean_long.xlsx"))
# MWF data
cogmob_mwf <- read.xlsx("./data/cogmob_mwf_all_wm.xlsx") # Needs to be separate from rvci due to IDs having different lenghts
rvci_mwf <- read.xlsx("./data/rvci_mwf_all_wm.xlsx")

# WMH and Fazekas score data
rvci_wmh <- read.xlsx("./data/rvci_wmh_volume.xlsx" )
cogmob_wmh <- read.xlsx("./data/cogmob_wmh_volume.xlsx")

#------------------------------------------------------------------#
# Data management                                               ####
#------------------------------------------------------------------#

# Gait data ####
## Cleaning up study IDs for merging
all_gait_data_clean <- all_gait_data_raw %>% 
  mutate(ID = str_replace(ID, "MCI", "FALLERS2")) %>% 
  rename_all(tolower) %>% 
  select(-c(gender, height))

## Computing new variables / averaging L and R data
all_gait_data_clean <- all_gait_data_clean %>% 
  mutate(step_time_avg = (step_time_sec_l + step_time_sec_r)/2,                                # Avg step time
         step_time_sd_avg = (step_time_std_dev_left + step_time_std_dev_right)/2,              # Avg step time SD
         step_length_avg = (step_length_cm_l + step_length_cm_r)/2,                            # Avg step length
         step_len_sd_avg = (step_len_std_dev_left + step_len_std_dev_right)/2,                 # Avg step length SD
         double_supp_time_avg = (double_supp_time_sec_l + double_supp_time_sec_r)/2,           # Double supp time avg
         cycle_time_avg = (cycle_time_sec_l + cycle_time_sec_r)/2,                             # Avg cycle time
         stride_time_sd_avg = (stride_time_std_dev_left + stride_time_std_dev_right)/2,        # Avg stride time SD
         stride_length_sd_avg = (stride_length_std_dev_left + stride_length_std_dev_right)/2,  # Avg stride length SD
         cycle_time_cov = (stride_time_sd_avg/cycle_time_avg)*100)                             # Cycle time coeff of variation


## Averaging trials of Single (ST) and Dual task (DT) data
all_gait_data_clean <- all_gait_data_clean %>% 
  mutate(task = str_replace_all(task, c("DT.." = "DT", "ST.." = "ST"))) %>% 
  filter(task == "ST") %>% 
  group_by(id, task) %>% 
  summarise_all(mean) %>% 
  ungroup()

## Pivoting gait data to create individual variables per each task
values_list <- colnames(all_gait_data_clean)[4:ncol(all_gait_data_clean)] # Variables to be pivoted

all_gait_data_clean <- all_gait_data_clean %>%
  pivot_wider(id_cols = c(id, leg_length), 
              names_from = task, 
              values_from = all_of(values_list), 
              names_sort = FALSE)

# Myelin data ####
## Cleaning up
### MWF
cogmob_mwf <- cogmob_mwf %>% 
  separate(ID_ROI, c("id","roi"), sep = 12) # Cleaning up ROI and study id

rvci_mwf <- rvci_mwf %>%
  separate(ID_ROI, c("id","roi"), sep = 8) # Cleaning up ROI and study id

## Merging datasets
all_mwf_data_raw <- rbind(cogmob_mwf, rvci_mwf) %>% 
  mutate(roi = str_replace_all(roi, c("_ROI_" = "", "_M" = "M","_wm" = "_WM"))) %>% 
  mutate(roi = str_replace_all(roi, c("JLF_" = "", "_F" = "F","_O" = "O", "_P" = "P"))) %>% 
  rename("volume" = "Volume.(voxels)") %>% 
  rename_all(tolower)

## Transposing roi mwf data from long to wide
mwf_wide_mean <- all_mwf_data_raw %>% 
  pivot_wider(id_cols = id, names_from = roi, values_from = mwf_mean)
colnames(mwf_wide_mean)[2:ncol(mwf_wide_mean)] <- paste(colnames(mwf_wide_mean)[2:ncol(mwf_wide_mean)], "mean", sep = "_")

mwf_wide_sd <- all_mwf_data_raw %>% 
  pivot_wider(id_cols = id, names_from = roi, values_from = mwf_sd)
colnames(mwf_wide_sd)[2:ncol(mwf_wide_sd)]  <- paste(colnames(mwf_wide_sd) [2:ncol(mwf_wide_sd)] , "sd", sep = "_")

mwf_wide_vol <- all_mwf_data_raw %>% 
  pivot_wider(id_cols = id, names_from = roi, values_from = volume)
colnames(mwf_wide_vol)[2:ncol(mwf_wide_vol)]  <- paste(colnames(mwf_wide_vol) [2:ncol(mwf_wide_vol)] , "vol", sep = "_")

# Merging clean datasets
all_mwf_data_clean <- left_join(mwf_wide_mean, mwf_wide_sd, by = "id") %>% 
  left_join(., mwf_wide_vol, by = "id")

#------------------------------------------------------------------#
# Merging final gait, MWF data, and wmh                          ####
#------------------------------------------------------------------#

# Merging gait,  myelin and structural final datasets ####
# eicv data — computed separately to increase N
rvci_eicv <- read.xlsx("./data/rvci_eicv.xlsx") %>% 
  rename(id = ID) 

cogmob_eicv <- read.xlsx("./data/cogmob_eicv.xlsx") %>% 
  rename(id = ID)

all_eicv <- rbind(cogmob_eicv, rvci_eicv) %>% 
  mutate(eicv_cm3 = eicv/1000)

# Fazekas score
cogmob_wmh <- cogmob_wmh %>% 
  rename(id = ID, wmh = Total.Vol, fazekas_score = Fazekas.Score) %>% 
  mutate(id = str_replace(id, "Cogmob2_", "FALLERS2_"))

rvci_wmh <- rvci_wmh %>% 
  rename(id = ID, wmh = Total.Vol, fazekas_score = Fazekas.from.Baseline.MRI)

all_wmh <- rbind(cogmob_wmh, rvci_wmh) %>% 
  rename_all(tolower) %>% 
  mutate(wmh_cm3 = wmh/1000) %>% 
  select(id, wmh, wmh_cm3, fazekas_score)

# Merging
all_data_clean <- left_join(all_data_demographics, all_wmh, by="id") %>% 
  left_join(., all_mwf_data_clean, by = "id") %>% 
  left_join(., all_gait_data_clean, by = "id") %>%
  left_join(., all_eicv, by = "id") %>% 
  filter(is.na(velocity_ST) == FALSE) # Subjects with gait data available only

# Checking observations for duplicates
tableone::CreateTableOne(data = all_data_clean, "id")

# Saving 
write.xlsx(all_data_clean, "all_data_clean.xlsx")

