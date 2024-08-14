#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

# Visit
visit=V1 # edit if needed

echo "##########################################################################"
echo "                MWF Analysis Pipeline - Whole-brain WM (1)                "
echo "##########################################################################"

echo "Creating binary, whole-brain white mater mask"
for subj in $subjects
do
fslmaths $subj/$timepoint/${subj}_${visit}_3D_T1.anat/T1_fast_pve_2.nii.gz \
    -bin -thr 0.5 $subj/$timepoint/${subj}_${visit}_wm_mask_bin_thr05.nii.gz
echo "$subj completed" 
done
echo "Completed for all subjects:" $(date)