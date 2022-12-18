#!/bin/sh
subjects=subjects_list.txt 
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (1)                        "
echo "##########################################################################"

echo "Brain extraction via optiBET"
for subj in $subjects
do
	sh optiBET.sh -i ./$subj/$timepoint/*3D_T1.nii.gz
	echo "$sub completed"
done
echo "Completed for all subjects:" $(date)