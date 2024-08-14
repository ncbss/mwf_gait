#!/bin/sh
subjects=subjects_list.txt
labels=spheres_labels.txt
subjects=`cat $subjects`
spheres=`cat $labels`
timepoint=Baseline # MAKE SURE that this is set up for the correct timepoint folder where the data can be found (e.g., either "Baseline" or "Final")

echo "Creating directory named 'grase_spheres' to save for ROIs in GRASE space"

for subj in $subjects
do mkdir ${subj}/${timepoint}/grase_spheres
done

echo "Registration of white matter spherical ROIs to subject's GRASE space. The output is each spherical ROI in GRASE"
for subj in $subjects
do

echo "Starting with ${subj} at:" $(date)

	for ref in ./${subj}/${timepoint}/*GRASE_1x1.nii.gz
	do
		for ROI in $spheres
		do
			applywarp --ref=${ref} --in=SPHERES_ROIs/${ROI} \
			--warp=./${subj}/${timepoint}/temp/struct2dvorak_nonlinear_warp_inv.nii.gz \
			--postmat=./${subj}/${timepoint}/temp/grase2struct_inv.mat \
			--out=./${subj}/${timepoint}/grase_spheres/${ROI}_in_grase

			echo "${ROI} done"
		done
	done
	echo "${subj} completed:" $(date) 

done
echo "Completed for all subjects:" $(date)