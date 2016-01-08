#!/usr/bin/bash

set -ex

[[ -n $NODE_MANUAL_KS_URL ]]
[[ -n $BOOBASEURL ]]

#
# Prepare syslinux
# https://git.fedorahosted.org/cgit/fedora-infrastructure.git/
#

sudo yum install -y syslinux

cp -v \
  /usr/share/syslinux/lpxelinux.0 \
  /usr/share/syslinux/*.c32 \
  .

#
# Create pxelinux.cfg
#
:> pxelinux.cfg
sed -e "s~@NODE_MANUAL_KS_URL@~$NODE_MANUAL_KS_URL~g" \
    pxelinux.cfg.in > pxelinux.cfg


#
# Create iPXE images
#
git submodule update --init --recursive --force

sed -e "s~@BOOBASEURL@~$BOOBASEURL~g" \
  script0.ipxe.in > ipxe/src/script0.ipxe

pushd ipxe/src
make -j4 EMBED=script0.ipxe
popd

rm -f ovirt-ipxe.iso ovirt-ipxe.usb
ln -v ipxe/src/bin/ipxe.iso ovirt-ipxe.iso
ln -v ipxe/src/bin/ipxe.usb ovirt-ipxe.usb


# Build the product image
bash -xe product-img/create-product-img.sh
