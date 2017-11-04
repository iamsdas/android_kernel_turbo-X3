#!/bin/sh

#
 # Custom build script by SuryashsnkarDas
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
#

export KBUILD_BUILD_USER="sdas"
export KBUILD_BUILD_HOST="ubuntu"
export ARCH=arm64
export LD_LIBRARY_PATH="/home/sdas/aarch64-linux-android-4.9/lib"
export CROSS_COMPILE="/home/sdas/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export SUBARCH=arm64
export STRIP="/home/sdas/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
mkdir $PWD/out

echo "###  CLEANING SOURCE  ###"
make clean && make mrproper
echo "###  PREPARING BUILD  ###"
make -C $PWD O=$PWD/out x500_defconfig
echo "###  BUILDING KERNEL  ###"
time make -j12 -C $PWD O=$PWD/out KCFLAGS=-mno-android
echo "build complete !!"

if [ -d "$PWD/release/AnyKernel2" ]; then
echo "     Making flashable zip file...."
KERNEL_DIR=$PWD
KERNEL="Image.gz-dtb"
ANYKERNEL_DIR="$KERNEL_DIR/release/AnyKernel2"
REPACK_DIR="$ANYKERNEL_DIR"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
VER="_$(date +"%Y-%m-%d"-%H%M)"
export ZIP_VER="Turbo-X3"
BUILD_START=$(date +"%s")
cp -vr $KERN_IMG $REPACK_DIR/Image.gz-dtb
MODULES_DIR=$KERNEL_DIR/arch/arm/boot/AnyKernel2/modules
rm -rf out

############
## DEPLOY ##
############
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
#

    BUILDER=$KBUILD_BUILD_USER
    echo "Builder detected: $BUILDER"
    cd release/AnyKernel2
    zip -r9 $ZIP_VER-$BUILDER.zip * -x README.md $ZIP_VER-$BUILDER.zip
    echo "done!"
    echo 'Zipped succesfully'

## END
else
rm -rf out
fi
