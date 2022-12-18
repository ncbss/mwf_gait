#!/bin/sh
subjects=subjects_list.txt 
subjects=`cat $subjects`

echo "Segmentation of whole-brain white matter and subcortical structures via fsl_anat"
for subj in $subjects
do
    for timepoint in Baseline
    do
    fsl_anat -i ./${subj}/${timepoint}/*3D_T1.nii.gz
    
    echo "$sub completed"
    done
done
echo "Completed for all subjects:" $(date)