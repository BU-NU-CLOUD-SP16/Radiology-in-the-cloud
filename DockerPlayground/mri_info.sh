#!/bin/sh
docker run -i -v $1:/input -v $2:/output chrismoc/freesurfer mri_info $3
