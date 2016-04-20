# Radiology-in-the-cloud
This year's instantiation of Radiology-In-The-Cloud moves the existing ChRIS architecture to a docker-based version.

Fundamentally, ChRIS (Children's Research Integration System) is a combination of web-based data storage front-end and a workflow manager that allows multiple possible configurations (such as cluster, remote, or local) for image processing back-ends (utilizing industry standard programs such as [Freesurfer](http://freesurfer.net/)).  More information on the details of ChRIS are available at the site for Boston Children's Hospital's Fetal-Neonatal Neuroimaging and Developmental Science Center, which has its own [Git Repository](https://github.com/FNNDSC/). 

Last year's Cloud Computing class integrated the existing ChRIS front and back-ends with a [python-based utility] (https://github.com/BU-EC500-SP15/rad-cloud) for scheduling ChRIS jobs on a cluster (in their case, the [Mass Open Cloud](https://github.com/CCI-MOC/moc-public)).

This year's Radiology-In-The-Cloud group takes things in a slightly different direction - we are using [Docker](www.docker.com) containers to create a more flexible means of hosting the ChRIS back end. Dockers use lightweight containers running in a command line environment according to the open containers standard. This implementation has many potential advantages including good isolation and scalability. In particular, they provide a quick means of controlling and updating dependencies without tinkering with a host's file system, and there is a [unified system](www.dockerhub.com) for pulling and pushing images and updates.

There are two ways in which you can build an instantiation of the system we have established on the [Mass Open Cloud](https://github.com/CCI-MOC/moc-public), but it depends on whether you are going to build from the (established version of ChRIS)[https://github.com/FNNDSC/chrisreloaded] or the [new portable version](https://github.com/FNNDSC/ChRIS-portable). If you are going to build from the portable version, you will need to obtain the virtual disk image and additional files from them.

What follows is a precis of the the ChRIS portable installation instructions.  We assume that you won't be running this off of a USB stick (although if you do, we suggest that you use a much larger one than the 8GB they suggest!)

## Initial setup

## Start by uploading the ChRIS_portable.vdi to your cloud computing platform of choice

### Unpack the <tt>extra.tgz</tt> file to the host

The <tt>extra.tgz</tt> archive contains the ChRIS <tt>data</tt> and <tt>users</tt> directories. Unpack these directories where ever convenient on the host file system, e.g.

```bash
cd ~/
mkdir chris
cd chris
tar xvfz ~/Downloads/extra.tgz
```

where we assume the <tt>extra.tgz</tt> is in the <tt>~/Downloads</tt> directory.

### Create a Virtual Box "container"

#### Basic VM settings

ChRIS portable is intended to run a standard VirtualBox <tt>vdi</tt> file configured with 2GB RAM and 2 CPUs.
More detailed settings include: 

* Type: Linux Ubuntu 64-bit
* 2048 MB RAM
* 2 CPUs
* 128 MB Video Memory
* HiDPI Support: Enabled
* Storage SATA Controller: ChRIS_portable.vdi file

**The most important setting is the storage SATA Controller. Add the ChRIS-portable.vdi file as the setting to the controller.**

However, a Dockerized instantiation of ChRIS is going to require significantly more space. This is due to the fact that the main utility that the plugins use, Freesurfer, is a fairly large package (8GB), and sadly this is a non-negotiable investment.

#### Network Port Forwarding:

Set the following Port Forwards:

| Host Port | Guest Port |
|-----------|------------|
|   2222    |    22      |
|   8001    |    80      |
|   8042    |   8042     |
|   4242    |   4242     |
|   8888    |   8888     |

## Start the VM

Once configured, start the Virtual Box Machine. Once Ubuntu boots, you will see a standard lightdm login screen. Select the "Chris System" login and use <tt>chris321</tt> as the password.

## Mount the relevant dirs from the host

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

Note that these directories (<tt>data</tt> and <tt>users</tt>) are linked to corresponding directories on the host, located at <tt>/mnt/kyon/Users/rudolph.pienaar/chris/</tt> which reflects the file tree in my specific case.

In the VM, I link to these directories using:

```bash
sudo sshfs -o uid=6244,gid=1102,allow_other rudolph.pienaar@10.0.2.2:/ /mnt/kyon
```

The <tt>10.0.2.2</tt> address is invariant. However, update the login <tt>rudolph.pienaar</tt> and paths according to your particular setup. Note that my paths reflect a Mac OS X naming convention (the users' home directory on my host is <tt>/Users</tt> while on a Linux host this would be <tt>/home</tt>.

### Caveats

If you get an error:

```bash
sshfs Read: Connection reset by peer
```

This typically means that the ssh keys currently in the VM don't match up to the host. In that case, first do:

```bash
ssh 10.0.2.2
```

you should get an error, and in the error text a line about removing the key. Copy/paste that line into the terminal. You also need to the above as **root**, so do

```bash
sudo bash
ssh 10.0.2.2
```

and similarly copy/paste the key remove command.


## Use ChRIS on the VM

To connect to ChRIS on the VM, from the **host** in a browser (preferably Chrome), connect to

```
http://localhost:8001
```

You can login with <tt>chris</tt> and <tt>chris321</tt>.

To connect to the Orthanc server from the host, do

```
http://localhost:8042
```



Pull Chris Portable VDI
Pull Data, Users files
Mount Data and Users
Download and install FreeSurfer (for diagnostic purposes)
Download chrismoc/freesurfer docker image
Put plugins into /src/chrisreloaded/plugins/
Ensure that the firewall allows incoming http connections
...profit!
