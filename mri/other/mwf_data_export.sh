#!/bin/sh

subjects=subjects_list.txt
subjects=`cat $subjects`
timepoint=Baseline

# Creating destination folder
mkdir mwf_data

echo "Exporting csv files containing MWF data for ROIs and whole-brain WM to a the new directory 'mwf_dir'"
for subj in $subjects
do
cp $subj/$timepoint/mwf_roi/*csv mwf_data
cp $subj/$timepoint/mwf_spheres/*csv mwf_data
cp $subj/$timepoint/mwf_wm/*csv mwf_data
echo "Completed for ${subj} "
done

echo "Completed for all subjects" $(date)