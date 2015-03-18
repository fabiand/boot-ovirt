# Guides:
# https://fedoraproject.org/wiki/Anaconda/ProductImage#Product_image
# https://git.fedorahosted.org/cgit/fedora-logos.git/tree/anaconda

set -x

DSTDIR=$PWD
TOPDIR=$(dirname $0)
PRDDIR=$TOPDIR/product/usr/share/anaconda/pixmaps

mkdir -p $PRDDIR
cp -v $TOPDIR/sidebar-logo.png $PRDDIR/

pushd $TOPDIR/product/
find . | cpio -c -o | pigz -9cv > $DSTDIR/product.img
popd

unpigz < $DSTDIR/product.img | cpio -t
