#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (3)                        "
echo "##########################################################################"

echo "Linear registration of subject's T1 brain to Adam Dvorak's T1 template via FLIRT. The output is an affine matrix"

for subj in $subjects
do
	flirt -ref Template_3DT1.nii.gz \
		  -in ./$subj/$timepoint/*3D_T1_optiBET_brain.nii.gz \
		  -omat ./$subj/$timepoint/temp/struct2dvorak_affine.mat

	echo "$subj completed" 
done
echo "Completed for all subjects:" $(date)