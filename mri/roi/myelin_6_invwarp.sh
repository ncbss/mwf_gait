#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                          MWF Analysis Pipeline (6)                       "
echo "##########################################################################"

echo "Computing inverse of warped image via invwarp"

for subj in $subjects
do
	for timepoint in Baseline
	do	
		for file in $subj/$timepoint/*3D_T1_optiBET_brain.nii.gz 
		do
			invwarp --ref=$file \
					--warp=$subj/$timepoint/temp/struct2dvorak_nonlinear_warp \
					--out=$subj/$timepoint/temp/struct2dvorak_nonlinear_warp_inv 

		echo "$subj completed"
		done
	done
done
echo "Completed for all subjects:" $(date)