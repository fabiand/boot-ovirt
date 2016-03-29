#!/usr/bin/bash

set -ex

[[ -n $BOOBASEURL ]]

#
# Prepare kickstarts
#
for BRANCH in ovirt-3.6 ovirt-4.0 master;
do
  curl -L "https://gerrit.ovirt.org/gitweb?p=ovirt-node-ng.git;a=blob_plain;f=docs/kickstart/minimal-kickstart.ks;hb=${BRANCH}" \
  | sed "s%URL_TO_SQUASHFS%http://jenkins.ovirt.org/job/ovirt-node-ng_${BRANCH}_build-artifacts-fc22-x86_64/lastSuccessfulBuild/artifact/exported-artifacts/ovirt-node-ng-image.squashfs.img%" \
  | tee "${BRANCH}.ks"

  # Build the product image
  BRANCH=${BRANCH} ISFINAL=False bash -xe product-img/create-product-img.sh
  mv -v product.img "${BRANCH}-product.img"
done

#
# Create pxelinux.cfg
#
:> pxelinux.cfg
sed \
  -e "s~@BOOBASEURL@~$BOOBASEURL~g" \
  pxelinux.cfg.in > pxelinux.cfg


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
# Create iPXE images
#
git submodule update --init --recursive --force

sed \
  -e "s~@BOOBASEURL@~$BOOBASEURL~g" \
  script0.ipxe.in > ipxe/src/script0.ipxe

pushd ipxe/src
make -j4 EMBED=script0.ipxe
popd

rm -f ovirt-ipxe.iso ovirt-ipxe.usb
ln -v ipxe/src/bin/ipxe.iso ovirt-ipxe.iso
ln -v ipxe/src/bin/ipxe.usb ovirt-ipxe.usb
