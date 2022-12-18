#!/bin/sh
subjects=subjects_list.txt
subjects=`cat ${subjects}`
timepoint=Baseline
visit=V1

echo "##########################################################################"
echo "                              Preprocessing                               "
echo "##########################################################################"

echo "Converting .PAR/.REC files to NIfTI"
echo "Subject ids:" $subjects
echo "##########################################################################"

echo ""
echo ""

# Converting to NIfTI via dcm2niix
for subj in $subjects
do
    /Applications/dcm2niix -z y -b n -f ${subj}_${visit}_3D_T1 $subj/$timepoint/*3D_T1.REC
    /Applications/dcm2niix -z y -b n -f ${subj}_${visit}_GRASE_1x%e $subj/$timepoint/*GRASE.REC
done

# Removing other GRASE volumes (2 to 48)
for subj in $subjects
do
    for i in $(seq 2 48)
    do
    rm $subj/$timepoint/${subj}_${visit}_GRASE_1x${i}.nii.gz
    done
done

# Moving raw data to new folder
echo "Creating directory and moving raw data"
for subj in $subjects
do
    mkdir $subj/$timepoint/raw
    mv $subj/$timepoint/*.REC $subj/$timepoint/raw/
    mv $subj/$timepoint/*.PAR $subj/$timepoint/raw/
done