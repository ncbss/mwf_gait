#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline

# Visit
visit=V1

echo "##########################################################################"
echo "                MWF Analysis Pipeline - Whole-brain WM (2)                "
echo "##########################################################################"

# Step 1: Creating output directory for all total WM MWF analysis

echo "Creating directory for whole-brain white matter"
for subj in $subjects
do mkdir $subj/$timepoint/grase_wm
done

# Step 2: Remove the subcortical structures from the total WM matter image

echo "Removing subcortical structures from whole-brain white matter mask via fslmaths."	
for subj in $subjects
do
	
	# Step 2a: First, we binarize the subcortical structures (FIRST output within fsl_anat folder). The output will be in the directory created above

	fslmaths $subj/$timepoint/*3D_T1.anat/first_results/T1_first_all_fast_firstseg.nii.gz \
		-bin $subj/$timepoint/grase_wm/${subj}_all_firstseg_bin.nii.gz

	# Step 2b: Add mask created from subcortical GM structures (in the step above), then binarize the output image from this step. The output is a temporary image containing the total WM and the subcortical structure
	
	fslmaths $subj/$timepoint/${subj}_${visit}_wm_mask_bin_thr05_edited.nii.gz \
		-add $subj/$timepoint/grase_wm/${subj}_all_firstseg_bin.nii.gz \
		-bin $subj/$timepoint/grase_wm/${subj}_wm_mask_temp.nii.gz

	# Step 2c: Subtract subcortical GM structures from Step 2b, and the result will be a binarized total WM mask without any traces of subcortical structures. This mask can then be registered to GRASE space and used to estimate myelin total WM fraction

	fslmaths $subj/$timepoint/grase_wm/${subj}_wm_mask_temp.nii.gz \
		-sub $subj/$timepoint/grase_wm/${subj}_all_firstseg_bin.nii.gz \
		$subj/$timepoint/grase_wm/${subj}_wm_mask_ready.nii.gz

echo "$subj completed" 
done


# Step 3: Remove temporary files

echo "Removing intermediate files"
for subj in $subjects
do rm $subj/$timepoint/grase_wm/*temp.nii.gz
done

echo "Completed for all subjects:" $(date)