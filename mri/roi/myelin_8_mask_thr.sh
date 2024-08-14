#!/bin/sh
subjects=subjects_list.txt
labels=JHU_std_labels.txt
subjects=`cat $subjects`
labels=`cat $labels`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (8)                        "
echo "##########################################################################"

for subj in $subjects
do
	for ROI in $labels		
	do
	fslmaths $subj/$timepoint/grase_roi/${ROI}_in_grase \
		-thr 1 $subj/$timepoint/grase_roi/${ROI}_in_grase_thr1
	done
	
echo "${subj} completed"
done
echo "Completed for all subjects:" $(date)