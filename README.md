# Radiology-in-the-cloud
This year's instantiation of Radiology-In-The-Cloud moves the existing ChRIS architecture to a docker-based version.

Fundamentally, ChRIS (Children's Research Integration System) is a combination of web-based data storage front-end and a workflow manager that allows multiple possible configurations (such as cluster, remote, or local) for image processing back-ends (utilizing industry standard programs such as [Freesurfer](http://freesurfer.net/)).  More information on the details of ChRIS are available at the site for Boston Children's Hospital's Fetal-Neonatal Neuroimaging and Developmental Science Center, which has its own [Git Repository](https://github.com/FNNDSC/). 

Last year's Cloud Computing class integrated the existing ChRIS front and back-ends with a [python-based utility] (https://github.com/BU-EC500-SP15/rad-cloud) for scheduling ChRIS jobs on a cluster (in their case, the [Mass Open Cloud](https://github.com/CCI-MOC/moc-public)).

This year's Radiology-In-The-Cloud group takes things in a slightly different direction - we are using [Docker](www.docker.com) containers to create a more flexible means of hosting the ChRIS back end. Dockers use lightweight containers running in a command line environment according to the open containers standard. This implementation has many potential advantages including good isolation and scalability. In particular, they provide a quick means of controlling and updating dependencies without tinkering with a host's file system, and there is a [unified system](www.dockerhub.com) for pulling and pushing images and updates.

There are two ways in which you can build an instantiation of the system we have established on the [Mass Open Cloud](https://github.com/CCI-MOC/moc-public), but it depends on whether you are going to build from the (established version of ChRIS)[https://github.com/FNNDSC/chrisreloaded] or the [new portable version](https://github.com/FNNDSC/ChRIS-portable). If you are going to build from the portable version, you will need to obtain the virtual disk image and additional files from them.

What follows is a precis of the the ChRIS portable installation instructions.  We assume that you won't be running this off of a USB stick (although if you do, we suggest that you use a much larger one than the 8GB they suggest!)

#### Initial setup - Adapted from the [ChRIS Portable](https://github.com/FNNDSC/ChRIS-portable) spec

#### Start by uploading the ChRIS_portable.vdi to your cloud computing platform of choice

##### Unpack the <tt>extra.tgz</tt> file to the host

The <tt>extra.tgz</tt> archive contains the ChRIS <tt>data</tt> and <tt>users</tt> directories. Unpack these directories where ever convenient on the host file system, e.g.

```bash
cd ~/
mkdir chris
cd chris
tar xvfz ~/Downloads/extra.tgz
```

where we assume the <tt>extra.tgz</tt> is in the <tt>~/Downloads</tt> directory.

##### Basic VM settings

The cannonical version of ChRIS portable is intended to run a standard VirtualBox <tt>vdi</tt> file configured with 2GB RAM and 2 CPUs.

However, a Dockerized instantiation of ChRIS is going to require significantly more space. This is due to the fact that the main utility that the plugins use, Freesurfer, is a fairly large package (8GB), and sadly this is a non-negotiable investment.

##### Network Port Forwarding:

Set the following Port Forwards:

| Host Port | Guest Port |
|-----------|------------|
|   2222    |    22      |
|   8001    |    80      |
|   8042    |   8042     |
|   4242    |   4242     |
|   8888    |   8888     |

#### Start the VM

Select the "Chris System" login and use <tt>chris321</tt> as the password.

#### Mount the relevant dirs from the host

In the ChRIS VM, you will note that the <tt>data</tt> and <tt>users</tt> directories are dead symbolic links:

```bash
# In the ChRIS VM!
cd ~/
ls -ld data users
```

will result in

```bash
[chris@chris-portable:x86_64-Linux]~$>ls -ld data users
lrwxrwxrwx 1 chris chris 42 Dec 11 17:32 data -> /mnt/kyon/Users/rudolph.pienaar/chris/data
lrwxrwxrwx 1 chris chris 43 Dec 11 17:32 users -> /mnt/kyon/Users/rudolph.pienaar/chris/users
[chris@chris-portable:x86_64-Linux]~$>
```

Note that these directories (<tt>data</tt> and <tt>users</tt>) are linked to corresponding directories on the host, located at <tt>/mnt/kyon/Users/rudolph.pienaar/chris/</tt> which you won't have access to ;).

There are two quick ways to amend this. 

• create virtual drives from the data and users archives and mount them at these folders 

![alt_tag](https://raw.githubusercontent.com/BU-NU-CLOUD-SP16/Radiology-in-the-cloud/master/docs/OpenStack%20Volumes.png)
![alt_tag](https://raw.githubusercontent.com/BU-NU-CLOUD-SP16/Radiology-in-the-cloud/master/docs/ChRIS%20Volumes.png)

or 

• just increase the main disk drive and just plug in the data instead of the links (recommended)


Please note that if you are loading the existing ChRIS portable VDI into the MOC, even if you use a virtual machine with a large main drive, or resize the drive, you will need to increase the main disk partition manually after doing so (this was not available when we did this on the MOC, but is supposed to be coming soon in an update). 
You can use [Gparted](http://gparted.org/) to do this fairly quickly (even while the VM is up and running)



#### Use ChRIS on the Open Cloud

To connect to ChRIS, from the **host** in a browser (preferably Chrome), connect to

```
http://localhost:8001
```
And the ChRIS front-end will be mounted at
```
http://your-external-ip-here/
```

Similarly, you can login as user chris with <tt>chris321</tt> as the password.

This will bring up the ChRIS front-end. 

![alt_tag](https://raw.githubusercontent.com/BU-NU-CLOUD-SP16/Radiology-in-the-cloud/master/docs/ChRIS%20frontend%201.png)

Unfortunately, as ChRIS portable is configured to send jobs to a remote cluster, attempting to start jobs will just send them into the ether.

![alt_tag](https://raw.githubusercontent.com/BU-NU-CLOUD-SP16/Radiology-in-the-cloud/master/docs/ChRIS%20frontend%202.png)

####Download and install FreeSurfer (for diagnostic purposes)

![alt_tag](https://raw.githubusercontent.com/BU-NU-CLOUD-SP16/Radiology-in-the-cloud/master/docs/freesurfer1.png)

You're going to want to get the Linux-CentOS 64bit version. Beware that this is a 4Gb download, and will expand to up to 8Gb. If you're working with the ChRIS portable image distributed by Children's Hospital, you will need to either expand the partition table manually, or you'll need to mount Freesurfer on a separate disk and link it into your filesystem.


![alt_tag](https://raw.githubusercontent.com/BU-NU-CLOUD-SP16/Radiology-in-the-cloud/master/docs/freesurfer2.png)


####Download chrismoc/freesurfer docker image
Go ahead and [install Docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/).
In order to make the symbolic links play nicely, we suggest that you install it into 
```
/home/chris/DockerPlayground
```
as you can download the shell scripts directly from the repository here and the plugins won't require any tweaking.

Once you have docker installed (again, if using the portable version, beware of filesystem issues), you can get the image we used for the MOC by simply issuing:

```docker pull chrismoc/freesurfer```

As above, beware that this is a sizeable (8GB) download.

You will need to [UPDATE the license by registering](https://surfer.nmr.mgh.harvard.edu/registration.html) for FreeSurfer, as the license contained within is only intended for use within the MOC.

The simplest way to do this is to enter the image itself:
```
docker run -i -t --entrypoint /bin/bash chrismoc/freesurfer
cd /opt/freesurfer
```
Then replace the ```.license``` file with the one which you were sent by MGH.


####Get the updated plugins.
The plugins from our repository on GitHub can be put directly into the ChRIS directory ```/src/chrisreloaded/plugins/```
These plugins reference scripts located at ```/home/chris/DockerPlayground``` - if you move them, you will need to change the file references in the plugins and in the scripts to the directory that you wish to use.
