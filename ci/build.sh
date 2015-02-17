#!/usr/bin/bash

set -ex


#
# Prepare syslinux
# https://git.fedorahosted.org/cgit/fedora-infrastructure.git/
#

sudo yum install -y syslinux

cp -v \
  /usr/share/syslinux/pxelinux.0 \
  /usr/share/syslinux/vesa*.c32 \
  .


#
# Create pxelinux.cfg
#
:> pxelinux.cfg
[[ -n $NODEBASEURL ]]
sed -e "s~@NODEBASEURL@~$NODEBASEURL~g" \
    -e "s~@ENGINEBASEURL@~FIXME~g" \
    pxelinux.cfg.in > pxelinux.cfg


#
# Create iPXE images
#
git submodule update --init --recursive --force

[[ -n $BOOBASEURL ]]
sed -e "s~@BOOBASEURL@~$BOOBASEURL~g" \
  script0.ipxe.in > ipxe/src/script0.ipxe

pushd ipxe/src
make -j4 EMBED=script0.ipxe
popd

rm -f ovirt-ipxe.iso ovirt-ipxe.usb
ln -v ipxe/src/bin/ipxe.iso ovirt-ipxe.iso
ln -v ipxe/src/bin/ipxe.usb ovirt-ipxe.usb

