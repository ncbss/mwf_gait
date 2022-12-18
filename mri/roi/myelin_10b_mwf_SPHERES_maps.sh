#!/bin/sh

subjects=subjects_list.txt
spheres=spheres_labels.txt
subjects=`cat $subjects`
spheres=`cat $spheres`

# Timepoint and visit
timepoint=Baseline
visit=V1

echo "##########################################################################"
echo "                         MWF Analysis Pipeline (10b)                        "
echo "##########################################################################"

echo "Creating directory for MWF ROIs"
for subj in $subjects
do

mkdir ${subj}/${timepoint}/mwf_spheres
done

echo "Step 1: Computing MWF values (mean, sd, and volume) via flstats."
for subj in $subjects
do
	
	for ROI in $spheres	
	do
		# Step 1(a): Then we compute mask the ROIs to the MWF map via fsltats -k option, and compute the MWF mean, SD, and volume data for each ROI and print it to individual text files (this includes zeros within mask)
		fslstats ${subj}/${timepoint}/*MWF_map_in_GRASE.nii.gz \
			-k ${subj}/${timepoint}/grase_spheres/${ROI}_in_grase_thr1 \
			-m -s -v > ${subj}/${timepoint}/mwf_spheres/${ROI}_in_grase_thr1_MWF.txt

		# Step 1(b): Here we merge each text file into a single .csv file, preserving subject's ID, ROI name, and MWF mean and SD values for each ROI
		awk '{OFS=", "; print $1, $2, $3, FILENAME}' \
			${subj}/${timepoint}/mwf_spheres/${ROI}_in_grase_thr1_MWF.txt \
			>> ${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results_1_temp.csv
	done
	
echo "${subj} completed:"
done

# Below are some additional commands to clean up the csv file and remove intermediate text files that result from Step 3.------------------------------------------------------------------------------------------------------------------------

echo "Step 2: Cleaning up csv files containing water fraction values."
for subj in $subjects
do

	# Step 2: The set of commands below do the following: 
	
	# 2(a) adding headers "MWF_mean", "MWF_sd", "Volume (voxels) and "ID_ROI" to csv file
	awk 'BEGIN {OFS=", "; print "MWF_mean", "MWF_sd", "Volume (voxels)", "ID_ROI"} NR=1 {print}' \
	${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results_1_temp.csv \
	> ${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results_2_temp.csv
	
	# 2(b) shortening the path-to-file names to preserve participant study ID, timepoint and ROI name within csv file
	awk '{gsub("/'$timepoint'/mwf_spheres/","_"); print}' \
	${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results_2_temp.csv \
	> ${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results_3_temp.csv
	
	# 2(c) shortening the path-to-file names to preserve ROI name and remove file extension within csv file
	awk '{gsub("_in_grase_thr1_MWF.txt",""); print}' \
	${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results_3_temp.csv \
	> ${subj}/${timepoint}/mwf_spheres/${subj}_MWF_SPHERES_results.csv
	
	echo "${subj} completed:"
done

echo "Step 3: Removing intermediate files"
for subj in $subjects
do
	# Step 3: In the final step, we remove intermediate/temporary text/csv files and keep only the a final csv file that has the MWF mean value for each ROI

	rm ${subj}/${timepoint}/mwf_spheres/*MWF.txt
	rm ${subj}/${timepoint}/mwf_spheres/*temp.csv

	echo "${subj} completed:"
done

echo "Completed for all subjects:" $(date)