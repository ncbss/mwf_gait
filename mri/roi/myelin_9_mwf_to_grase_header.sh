#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline  # edit if needed
# Visit
visit=V1  # edit if needed

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (9)                        "
echo "##########################################################################"

echo "Aligning MWF maps to the same spatial dimension as the GRASE image via using fslswapdim and fslcpgeom"

for subj in $subjects
do

    fslswapdim $subj/$timepoint/${subj}_${visit}_MWF_map.nii.gz -x y z $subj/$timepoint/${subj}_${visit}_MWF_map_in_GRASE.nii.gz
    fslcpgeom $subj/$timepoint/*GRASE_1x1.nii.gz $subj/$timepoint/${subj}_${visit}_MWF_map_in_GRASE.nii.gz

    echo "$subj completed"

done
echo "Completed for all subjects:" $(date)