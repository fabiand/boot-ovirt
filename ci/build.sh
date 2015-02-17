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
sed -e "s~@NODEBASEURL@~$NODEBASEURL~" \
    -e "s~@ENGINEBASEURL@~FIXME~" \
    pxelinux.cfg.in > pxelinux.cfg


#
# Create iPXE images
#
git submodule update --init --recursive --force

[[ -n $BOOBASEURL ]]
pushd ipxe/src
cat <<EOF > script0.ipxe
#!ipxe
set 209:string pxelinux.cfg
set 210:string $BOOBASEURL
dhcp || goto manualnet
chain $BOOBASEURL/pxelinux.0
:manualnet
echo Please provide, IP address, Netmask, Gateway and Router
ifopen net0
config net0
chain $BOOBASEURL/pxelinux.0
EOF

make -j4 EMBED=script0.ipxe

popd

ln -v ipxe/src/bin/ipxe.iso ovirt-ipxe.iso
ln -v ipxe/src/bin/ipxe.usb ovirt-ipxe.usb

