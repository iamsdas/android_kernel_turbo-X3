#!/bin/sh

#
 # Custom build script by SuryashsnkarDas
 #
 #This program is free software: you can redistribute it and/or modify
 #it under the terms of the GNU General Public License as published by
 #the Free Software Foundation, either version 3 of the License, or
 #(at your option) any later version.
 #
 #This program is distributed in the hope that it will be useful,
 #but WITHOUT ANY WARRANTY; without even the implied warranty of
 #MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #GNU General Public License for more details.
 #
#

# This build script checks if the build completed successfully or not and also creats a flashable zip file of the kernel if conditions are met.

# User variables
export KBUILD_BUILD_USER="sdas"
export KBUILD_BUILD_HOST="ubuntu"
export ARCH=arm64
export LD_LIBRARY_PATH="/home/sdas/kernel/aarch64-linux-gnu/lib"
export CROSS_COMPILE="/home/sdas/kernel/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
export SUBARCH=arm64
export STRIP="/home/sdas/kernel/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
mkdir $PWD/out

# Make commands
echo "#########################"
echo "###  CLEANING SOURCE  ###"
echo "#########################"
make -C $PWD O=$PWD/out clean && make mrproper

echo "#########################"
echo "###  PREPARING BUILD  ###"
echo "#########################"
make -C $PWD O=$PWD/out x500_defconfig

echo "#########################"
echo "###  BUILDING KERNEL  ###"
echo "#########################"
time make -j16 -C $PWD O=$PWD/out

# Check if build was successfull
if [ -e "$PWD/out/arch/arm64/boot/Image.gz-dtb" ]; then
echo "build complete !!!"

# Anykernel2
if [ -d "$PWD/release/AnyKernel2" ]; then
echo "#############################"
echo "### MAKING FLASHABLE FILE ###"
echo "#############################"
export ZIP_VER="Turbo-X3"
KERNEL_DIR=$PWD
KERNEL="Image.gz-dtb"
ANYKERNEL_DIR="$KERNEL_DIR/release/AnyKernel2"
REPACK_DIR="$ANYKERNEL_DIR"
KERN_IMG=$KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb
cp -vr $KERN_IMG $REPACK_DIR/Image.gz-dtb

############
## DEPLOY ##
############

    BUILDER=$KBUILD_BUILD_USER
    echo "Builder detected: $BUILDER"
    cd release/AnyKernel2
    zip -r9 $ZIP_VER-$BUILDER.zip * -x README.md $ZIP_VER-$BUILDER.zip
    echo "done!"
    echo 'Zipped succesfully'

## END

cd ..
cd ..
rm -rf $PWD/release/AnyKernel2/Image.gz-dtb
fi
else
echo "....build failed!!!"
fi
rm -rf $PWD/out
