#!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

echo "##########################################################################"
echo "                          MWF Analysis Pipeline (5)                       "
echo "##########################################################################"

echo "Computing inverse matrix for subjects via covert_xfm"

for subj in $subjects
do
	convert_xfm -omat ./$subj/$timepoint/temp/grase2struct_inv.mat \
				-inverse ./$subj/$timepoint/temp/grase2struct.mat

	echo "$subj completed"
done
echo "Completed for all subjects:" $(date)