#------------------------------------------------------------------#
# Loading packages                                              ####
#------------------------------------------------------------------#
library(tidyverse)
library(openxlsx)

#------------------------------------------------------------------#
# Loading data                                                  ####
#------------------------------------------------------------------#

# MWF data
cogmob_mwf_ero <- read.xlsx("./data/cogmob_mwf_all_wm_eroded.xlsx") # Needs to be separate from rvci due to IDs having different lenghts
rvci_mwf_ero <- read.xlsx("./data/rvci_mwf_all_wm_eroded.xlsx")

# Myelin data ####
## Cleaning up
### MWF
cogmob_mwf_ero <- cogmob_mwf_ero %>% 
  separate(ID_ROI, c("id","roi"), sep = 12) # Cleaning up ROI and study id

rvci_mwf_ero <- rvci_mwf_ero %>%
  separate(ID_ROI, c("id","roi"), sep = 8) # Cleaning up ROI and study id

## Merging datasets
all_mwf_data_raw <- rbind(cogmob_mwf_ero, rvci_mwf_ero) %>% 
  rename("volume" = "Volume.(voxels)") %>% 
  rename_all(tolower) %>% 
  mutate(roi = str_replace_all(roi, c("_ROI_" = "", "_M" = "M","_wm" = "_WM"))) %>% 
  mutate(roi = str_replace(roi, "WM", "WM_eroded"))

## Transposing roi mwf data from long to wide
mwf_wide_mean <- all_mwf_data_raw %>% 
  pivot_wider(id_cols = id, names_from = roi, values_from = mwf_mean_eroded)
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


# Saving 
write.xlsx(all_mwf_data_clean, "mwf_merged_eroded.xlsx")

