#!/bin/sh
subjects=subjects_list.txt
labels=JHU_std_labels.txt
subjects=`cat $subjects`
labels=`cat $labels`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (7)                        "
echo "##########################################################################"

echo "Creating directory named 'grase_roi' to save ROIs in GRASE space"

for subj in $subjects
do 
	mkdir $subj/$timepoint/grase_roi
done

echo "Registration of white matter JHU ROIs to subject's GRASE space. The output is each ROI in GRASE"
for subj in $subjects
do
	echo "Starting with $subj at:" $(date)

	for ref in ./$subj/$timepoint/*GRASE_1x1.nii.gz
	do	
		for ROI in $labels
		do
			applywarp --ref=$ref --in=./JHU_ROIs/$ROI \
					  --warp=./$subj/$timepoint/temp/struct2dvorak_nonlinear_warp_inv.nii.gz \
					  --postmat=./$subj/$timepoint/temp/grase2struct_inv.mat \
			          --out=./$subj/$timepoint/grase_roi/${ROI}_in_grase

			echo "$ROI done"
		done
	done
	echo "$subj completed" 

done
echo "Completed for all subjects:" $(date)