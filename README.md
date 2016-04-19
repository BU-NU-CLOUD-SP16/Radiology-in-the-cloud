# Radiology-in-the-cloud
This year's instantiation of Radiology-In-The-Cloud moves the existing ChRIS architecture to a docker-based version.

Pull Chris Portable VDI
Pull Data, Users files
Mount Data and Users
Download and install FreeSurfer (for diagnostic purposes)
Download chrismoc/freesurfer docker image
Put plugins into /src/chrisreloaded/plugins/
Ensure that the firewall allows incoming http connections
...profit!
