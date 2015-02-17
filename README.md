
Boot oVirt!
===========

This small collection of scripts generates an iPXE ISO
and USB image which can be used to boot some appliances
from oVirt's Jenkins instance.

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

Splash
------

The splash was taken from:

    $ curl -o syslinux-vesa-splash.jpg "http://gerrit.ovirt.org/gitweb?p=ovirt-node.git;a=blob_plain;f=images/syslinux-vesa-splash.jpg;hb=HEAD"
