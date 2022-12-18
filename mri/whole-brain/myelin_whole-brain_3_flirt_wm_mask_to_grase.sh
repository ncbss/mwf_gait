#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                MWF Analysis Pipeline - Whole-brain WM (3)                "
echo "##########################################################################"

# Step 1: Total WM mask registration to GRASE space using t1_optiBET_brain_to_grase.mat to improve spatial registration

echo "Step 1: Linear registration of whole-brain white matter mask to subject's GRASE image via FLIRT"

for subj in $subjects
do
    for ref in ./$subj/$timepoint/*GRASE_1x1.nii.gz
	do

    flirt -in $subj/$timepoint/grase_wm/${subj}_wm_mask_ready \
        -ref ${ref} \
        -out $subj/$timepoint/grase_wm/${subj}_wm_mask_in_grase \
        -omat $subj/$timepoint/grase_wm/wm_mask_in_grase.mat \
        -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6

    done

echo "$subj completed [Step 1]"
done
echo "Completed for all subjects:" $(date)

# Step 2: Finally, we threshold the WM mask in GRASE at 1, eliminating any  voxels with values that are less than 1, and may include non-myelin tissue

echo "Step 2: Thresholding whole white matter mask in GRASE (-thr 1) via fslmaths"
for subj in $subjects
do
	
    fslmaths $subj/$timepoint/grase_wm/${subj}_wm_mask_in_grase \
        -thr 1 $subj/$timepoint/grase_wm/${subj}_wm_mask_in_grase_thr1

echo "$subj completed [Step 2]"
done

echo "Completed for all subjects:" $(date) 