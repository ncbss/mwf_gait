#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                          MWF Analysis Pipeline (4)                       "
echo "##########################################################################"

echo "Non-linear registration of subject's T1 brain to Adam Dvorak's T1 template via FNIRT. The output is a warped image."

for subj in $subjects
do
	for file in $subj/$timepoint/*_3D_T1_optiBET_brain.nii.gz 
	do
	fnirt --ref=Template_3DT1.nii.gz \
			--in=${file} \
		    --aff=$subj/$timepoint/temp/struct2dvorak_affine.mat \
		    --cout=$subj/$timepoint/temp/struct2dvorak_nonlinear_warp
		echo "$subj completed"
	done
done
echo "Completed for all subjects:" $(date)