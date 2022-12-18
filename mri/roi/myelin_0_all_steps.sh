#!/bin/sh
echo "##########################################################################"
echo "                       MWF Analysis Pipeline (All)                        "
echo "##########################################################################"

echo "Running MWF analysis pipeline (1-10)"
echo "Starting:" $(date)
for mwf_all in 	myelin_1_optiBET.sh \
				myelin_2_flirt_grase_to_struct.sh \
				myelin_3_flirt_struct_to_template.sh \
				myelin_4_fnirt_struct_to_template.sh \
				myelin_5_convert_xfm.sh \
				myelin_6_invwarp.sh \
				myelin_7_applywarp_mask.sh \
				myelin_8_mask_thr.sh \
				myelin_9_mwf_to_grase_header.sh \
				myelin_10_mwf_roi_data.sh
do
sh $mwf_all
done
echo "Completed all_steps" $(date)
exit