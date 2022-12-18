#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

# Visit 
visit=V1 # edit if needed

echo "##########################################################################"
echo "                MWF Analysis Pipeline - Eroded whole-brain WM             "
echo "##########################################################################"

echo "Creating directory for whole-brain mwf"
for subj in $subjects
do mkdir $subj/$timepoint/mwf_wm
done

echo "Step 1: Computing MWF values (mean, sd, and volume) via flstats."
for subj in $subjects
do
	# Step 1a: This first step computes MWF data for total WM
	fslstats $subj/$timepoint/${subj}_${visit}_MWF_map_in_GRASE.nii.gz -k $subj/$timepoint/grase_wm/${subj}_wm_mask_in_grase_thr1_done_ero -m -s -v > $subj/$timepoint/mwf_wm/MWF_TOT_WM_ero_map.txt

	# Step 1b: Here we convert the txt file to a .csv file, preserving subject's ID, ROI name, and MWF mean, SD, and volume (voxels) for the whole-brain WM
	awk '{OFS=", "; print $1,$2, $3, FILENAME}' $subj/$timepoint/mwf_wm/MWF_TOT_WM_ero_map.txt \
		> $subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_1_temp.csv

echo "$subj completed"
done


# Below are some additional commands to clean up the csv file and remove intermediate text files that result from Step 3.------------------------------------------------------------------------------------------------------------------------

echo "Step 2: Cleaning up csv files containing water fraction values."
for subj in $subjects
do
	# Step 2: The set of commands below do the following: 
	
	# 2(a) adding headers "MWF_mean", "MWF_sd", "Volume (voxels)" and "ID_ROI" to csv file
	awk 'BEGIN {OFS=", "; print "MWF_mean", "MWF_sd", "Volume (voxels)", "ID_ROI"} {print}' \
		$subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_1_temp.csv \
		> $subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_2_temp.csv
	
	# 2(b) shortening the path-to-file names to preserve participant study ID, timepoint and ROI name within csv file
	awk '{gsub("/'$timepoint'/mwf_wm/","_"); print}' \
		$subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_2_temp.csv \
		> $subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_3_temp.csv
	
	# 2(c) shortening the path-to-file names to preserve ROI name and remove file extension within csv file
	awk '{gsub("_map.txt",""); print}' $subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_3_temp.csv \
		> $subj/$timepoint/mwf_wm/${subj}_MWF_TOT_WM_map_results_ero.csv
done

echo "Step 3: Removing intermediate files"
for subj in $subjects
do
	# Step 3: In the final step, we remove intermediate/temporary text/csv files and keep only the a final csv file that has the MWF mean, sd and volume (voxels) data
	rm $subj/$timepoint/mwf_wm/*map.txt
	rm $subj/$timepoint/mwf_wm/*temp.csv

echo "$subj completed"
done

echo "Completed for all subjects:" $(date)