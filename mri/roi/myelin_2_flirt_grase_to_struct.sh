#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (2)                        "
echo "##########################################################################"

echo "Creating directory named 'temp' to registration outputs"

for subj in $subjects
do 
	mkdir $subj/$timepoint/temp
done

echo "Linear registration of GRASE image to subject's T1 brain via FLIRT"

for subj in $subjects
do
	flirt -ref ./$subj/$timepoint/*3D_T1_optiBET_brain.nii.gz \
		  -in ./$subj/$timepoint/*GRASE_1x1.nii.gz -dof 6 \
		  -omat ./$subj/$timepoint/temp/grase2struct.mat

	echo "$subj completed" 
done
echo "Completed for all subjects:" $(date)