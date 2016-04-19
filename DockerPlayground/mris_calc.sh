docker run -ti -v /home/chris/DockerPlayground/:/input -v /home/chris/DockerPlayground/:/output chrismoc/freesurfer mris_calc $1 $2
# mris_calc -o sum.nii 003.nii add 003.nii
# mris_calc 00c.nii stats
