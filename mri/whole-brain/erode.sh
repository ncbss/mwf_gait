 
 #!/bin/sh
subjects=subjects_list.txt
subjects=`cat $subjects`

# Timepoint
timepoint=Baseline # edit if needed

# Visit 
visit=V1 # edit if needed

echo "##########################################################################"
echo "                MWF Analysis Pipeline - Eroding Whole-brain WM            "
echo "##########################################################################"


for subj in $subjects
do
 fslmaths  ${subj}/$timepoint/grase_wm/${subj}_wm_mask_in_grase_thr1_done.nii.gz \
            -kernel sphere 1  -ero  \
            ${subj}/$timepoint/grase_wm/${subj}_wm_mask_in_grase_thr1_done_ero.nii.gz 
echo "$subj completed"
done
echo "Completed for all subjects:" $(date)