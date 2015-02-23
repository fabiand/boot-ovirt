
Boot oVirt!
===========

This small collection of scripts generates an iPXE ISO and USB image which
can be used to boot and install some appliances from oVirt's Jenkins
instance.


Try!
----

It is easy to try:

    yum install -y qemu-system-x86_64
    qemu-img create -f qcow2 dst.img 20G
    qemu-system-x86_64 \
      -enable-kvm \
      -m 2048 \
      -cdrom http://jenkins.ovirt.org/job/fabiand_boo_build_testing/lastSuccessfulBuild/artifact/src/bin/ovirt-ipxe.iso \
      -hda dst.img \
      -serial stdio


What do I install?
------------------

The default configuration is pointing to the nightly built images of oVirt
Engine and oVirt Node.
Both images are built in the [upstream Jenkins infrastructure](http://jenkins.ovirt.org).

The installer images are taken from the relevant upstream repositories.

For details take a look at the `syslinux.cfg.in` file and the upstream
Jenkins jobs.


What platform and installer is used?
------------------------------------

Currently the appliance images which are installed, are build on top of
Fedora or CentOS.
anaconda - the default installer of both - is also used for installing
our appliance images.


How does it work?
-----------------

The whole booting works like this:

1. Node and Engine appliances are built in Jenkins
2. squashfs images for both jobs are exported, including the installer
   kernel, initrd and squashfs
3. The syslinux configuration file is pointing to the installers and
   squashfs images of both projects
4. An iPXE image (iso) is created, pointing to the syslinux configuration,
   hosted in Jenkins

The iPXE iso is the iso image used for booting.


Splash
------

The splash was taken from:

    $ curl -o syslinux-vesa-splash.jpg "http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob_plain;f=images/syslinux-vesa-splash.jpg;hb=HEAD"


