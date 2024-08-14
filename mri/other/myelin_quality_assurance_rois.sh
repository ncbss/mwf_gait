#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "Creating non-binary ROI mask for quality assurance"

for subj in $subjects
do
	for ref in ./${subj}/${timepoint}/*GRASE_1x1.nii.gz
	do
		for ROI in ROI_JLF_ALL_masked_edited # Edited non-binary ROI mask that matches mask from Dvorak's paper.
		do
			# Registration of non-binary mask		
			applywarp --ref=${ref} --in=${ROI} \
			--warp=./${subj}/${timepoint}/temp/struct2dvorak_nonlinear_warp_inv.nii.gz \
			--postmat=./${subj}/${timepoint}/temp/grase2struct_inv.mat \
			--out=./${subj}/${timepoint}/ROI_JLF_ALL_masked_in_grase_temp
			
			# Masking to tresholded binary ROI
			fslmaths ${subj}/${timepoint}/ROI_JLF_ALL_masked_in_grase_temp.nii.gz \
			-mas ${subj}/${timepoint}/grase_roi/ROI_JLF_ALL_in_grase_thr1.nii.gz \
			${subj}/${timepoint}/${subj}_ROI_JLF_ALL_qa_mask.nii.gz

			# Removing intermediate files
			rm ${subj}/${timepoint}/*temp.nii.gz

			echo "${subj} completed"
		done
	done
done
echo "Completed for all ${subj}:" $(date)