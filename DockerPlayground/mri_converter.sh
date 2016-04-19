#!/bin/sh
docker run -i -v $1:/input -v $2:/opt/freesurfer/subjects chrismoc/freesurfer mri_convert $5 /input/$3 /opt/freesurfer/subjects/$4
