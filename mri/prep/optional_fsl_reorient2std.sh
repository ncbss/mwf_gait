#!/bin/sh

subjects=subjects_list.txt 
subjects=`cat $subjects`

echo "Reorienting images to standard space via fslreorient2std"
for subj in $subjects
do 
    for timepoint in Baseline
    do
        fslreorient2std ./$subj/$timepoint/*3D_T1.nii.gz ./$subj/$timepoint/*3D_T1.nii.gz
        fslreorient2std ./$subj/$timepoint/*GRASE_1x1.nii.gz ./$subj/$timepoint/*GRASE_1x1.nii.gz
        fslreorient2std ./$subj/$timepoint/*MWF_map.nii.gz ./$subj/$timepoint/*MWF_map.nii.gz

        echo "$subj completed"
    done
done
echo "Completed for all subjects:" $(date)