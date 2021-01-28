#!/bin/bash

#FasterBuild. run before start - build
# echo 'tmpfs   /OUT  tmpfs size=15G,uid=root,gid=root,mode=775,noatime,noauto  0 0'  >> /etc/fstab

# Script To Compile Stock MoonBase™ Kernels.

clear
umount /OUT
rm -rf /OUT
export ARCH=arm64
export SUBARCH=arm
mkdir /OUT
mount /OUT
export PATH="/cross-tc/clang/bin:$PATH"
export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=JavaShin-X
export KBUILD_BUILD_HOST=WrongDevice
export CROSS_COMPILE="/usr/bin/aarch64-unknown-linux-gnu-"
export CROSS_COMPILE_ARM32="/usr/bin/armv7-unknown-linux-gnueabihf-"
export LD_LIBRARY_PATH="/cross-tc/clang/lib64:$LD_LIBRARY_PATH"

# Gcc-11-Optimize - Clang Optimize Hacks. Outside KBUILD System Fully Working. 
# To Be Used With Clang Compiler With Polly Support (Polyhedral Compilation)

export KCFLAGS+=" -O3 -mllvm -polly -march=armv8-a+fp+simd+crc+crypto -mcpu=kryo -mtune=kryo \
--param=inline-min-speedup=15 --param=max-inline-insns-single=200 -fno-stack-protector \
--param=max-inline-insns-auto=30 --param=early-inlining-insns=14 \
-Wno-error=misleading-indentation -Wno-error=incompatible-pointer-types-discards-qualifiers -Wno-enum-conversion \
                 -mllvm -polly-run-dce \
                 -mllvm -polly-run-inliner \
                 -mllvm -polly-opt-fusion=max \
                 -mllvm -polly-ast-use-context \
                 -mllvm -polly-detect-keep-going \
                 -mllvm -polly-vectorizer=stripmine \
                 -mllvm -polly-invariant-load-hoisting -pipe"

make O=/OUT ARCH=arm64 vendor/moonbase_stock_defconfig
make -j$(nproc --all) O=/OUT ARCH=arm64 \
CC=clang LD=/usr/bin/aarch64-unknown-linux-gnu-ld.bfd \
CLANG_TRIPLE=/usr/bin/aarch64-unknown-linux-gnu- \
CROSS_COMPILE=/usr/bin/aarch64-unknown-linux-gnu- CROSS_COMPILE_ARM32=/usr/bin/armv7-unknown-linux-gnueabihf- \
CLANG_TRIPLE_ARM32=/usr/bin/armv7-unknown-linux-gnueabihf- oldconfig prepare nconfig Image.gz-dtb dtbo.img modules V=0

# Move Compiled Files To $PWD Current Dir.
# Boot Img
cp /OUT/arch/arm64/boot/Image.gz-dtb .
ls -lash /OUT/arch/arm64/boot/Image.gz-dtb
ls -lash ./Image.gz-dtb
# Dtbo Img
cp /OUT/arch/arm64/boot/dtbo.img .
ls -lash /OUT/arch/arm64/boot/dtbo.img
ls -lash ./dtbo.img
# Prima Kernel Module
cp /OUT/drivers/staging/prima/wlan.ko ./pronto_wlan.ko
ls -lash /OUT/drivers/staging/prima/wlan.ko
ls -lash ./pronto_wlan.ko

# Ready For Verification And Manual Packing Zip
# Done By JavaShin-X 2021.






