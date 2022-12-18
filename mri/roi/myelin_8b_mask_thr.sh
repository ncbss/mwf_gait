#!/bin/sh

# Place this file in the project folder where each subject's individual folders are stored
# Output will be saved as the ROI name with "_thr1" added
# All JHU ROI masks must be properly identified in the JHU_std_labels.txt text file
# All subjects' directories must be properly listed in the subjects_list.txt file
# To run, type in the terminal: sh myelin_8_mask_thr.sh

subjects=subjects_list.txt
labels=spheres_labels.txt
subjects=`cat $subjects`
spheres=`cat $labels`
timepoint=Baseline

echo "Thresholding (-thr 1) white matter JHU ROIs in GRASE space"

for subj in $subjects
do
	for ROI in $spheres		
	do
		fslmaths ${subj}/${timepoint}/grase_spheres/${ROI}_in_grase \
			-thr 1 ${subj}/${timepoint}/grase_spheres/${ROI}_in_grase_thr1
	done
	
echo "${subj} completed" $(date) 
done

echo "Completed for all subjects:" $(date)