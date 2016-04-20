# Radiology-in-the-cloud
This year's instantiation of Radiology-In-The-Cloud moves the existing ChRIS architecture to a docker-based version.

Fundamentally, ChRIS (Children's Research Integration System) is a combination of web-based data storage front-end and a workflow manager that allows multiple possible configurations (such as cluster, remote, or local) for image processing back-ends (utilizing industry standard programs such as [Freesurfer](http://freesurfer.net/)).  More information on the details of ChRIS are available at the site for Boston Children's Hospital's Fetal-Neonatal Neuroimaging and Developmental Science Center, which has its own [Git Repository](https://github.com/FNNDSC/). 

Last year's Cloud Computing class integrated the existing ChRIS front and back-ends with a [python-based utility] (https://github.com/BU-EC500-SP15/rad-cloud) for scheduling ChRIS jobs on a cluster (in their case, the [Mass Open Cloud](https://github.com/CCI-MOC/moc-public)).

This year's Radiology-In-The-Cloud group takes things in a slightly different direction - we are using [Docker](www.docker.com) containers to create a more flexible means of hosting the ChRIS back end. Dockers use lightweight containers running in a command line environment according to the open containers standard. This implementation has many potential advantages including good isolation and scalability. In particular, they provide a quick means of controlling and updating dependencies without tinkering with a host's file system, and there is a [unified system](www.dockerhub.com) for pulling and pushing images and updates.

There are two ways in which you can build an instantiation of the system we have established on the [Mass Open Cloud](https://github.com/CCI-MOC/moc-public), but it depends on whether you are going to build from the (established version of ChRIS)[https://github.com/FNNDSC/chrisreloaded] or the [new portable version](https://github.com/FNNDSC/ChRIS-portable). If you are going to build from the portable version, you will need to obtain the virtual disk image and additional files from them.

Pull Chris Portable VDI
Pull Data, Users files
Mount Data and Users
Download and install FreeSurfer (for diagnostic purposes)
Download chrismoc/freesurfer docker image
Put plugins into /src/chrisreloaded/plugins/
Ensure that the firewall allows incoming http connections
...profit!
