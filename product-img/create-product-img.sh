# Guides:
# https://fedoraproject.org/wiki/Anaconda/ProductImage#Product_image
# https://git.fedorahosted.org/cgit/fedora-logos.git/tree/anaconda

set -x

DSTDIR=$PWD
TOPDIR=$(dirname $0)
PRDDIR=$TOPDIR/product/
PIXMAPDIR=$PRDDIR/usr/share/anaconda/pixmaps

mkdir -p "$PRDDIR" "$PIXMAPDIR"
cp -v $TOPDIR/sidebar-logo.png "$PIXMAPDIR/"
cp -v .buildstamp "$PRDDIR/"

pushd $TOPDIR/product/
find . | cpio -c -o | pigz -9cv > $DSTDIR/product.img
popd

unpigz < $DSTDIR/product.img | cpio -t
