# Creating spherical WM ROIs using Dvorak's template

# Frontal WM, right hemisphere
input_image=Template_3DT1.nii.gz
x=88
y=219
z=188
mm=5
for roi in Frontal_wm_R
do
fslmaths ${input_image} -roi $x 1 $y 1 $z 1 0 1 ${roi}_point_mask
fslmaths ${roi}_point_mask.nii.gz -kernel sphere ${mm} -fmean -bin -thr 0 ${roi}_sphere_roi -odt float
done

# Frontal WM, left hemisphere
input_image=Template_3DT1.nii.gz
x=135
y=219
z=188
mm=5
for roi in Frontal_wm_L
do
fslmaths ${input_image} -roi $x 1 $y 1 $z 1 0 1 ${roi}_point_mask
fslmaths ${roi}_point_mask.nii.gz -kernel sphere ${mm} -fmean -bin -thr 0 ${roi}_sphere_roi -odt float
done

# Parietal WM, right hemisphere
input_image=Template_3DT1.nii.gz
x=90
y=150
z=226
mm=5
for roi in Parietal_wm_R
do
fslmaths ${input_image} -roi $x 1 $y 1 $z 1 0 1 ${roi}_point_mask
fslmaths ${roi}_point_mask.nii.gz -kernel sphere ${mm} -fmean -bin -thr 0 ${roi}_sphere_roi -odt float
done

# Parietal WM, left hemisphere
input_image=Template_3DT1.nii.gz
x=130
y=150
z=226
mm=5
for roi in Parietal_wm_L
do
fslmaths ${input_image} -roi $x 1 $y 1 $z 1 0 1 ${roi}_point_mask
fslmaths ${roi}_point_mask.nii.gz -kernel sphere ${mm} -fmean -bin -thr 0 ${roi}_sphere_roi -odt float
done

# Creating bilateral ROIs
for roi in Frontal_wm
do
fslmaths ${roi}_R_sphere_roi.nii.gz -add ${roi}_L_sphere_roi.nii.gz ${roi}_all
done

for roi in Parietal_wm
do
fslmaths ${roi}_R_sphere_roi.nii.gz -add ${roi}_L_sphere_roi.nii.gz ${roi}_all
done

# Removing point masks
rm *point_mask*
