clear
umount /OUT
rm -rf /OUT
export ARCH=arm64
export SUBARCH=arm
mkdir /OUT
mount /OUT
export PATH="/cross-tc/clang/bin:$PATH"
export KBUILD_BUILD_VERSION=1
export KBUILD_BUILD_USER=javashin
export KBUILD_BUILD_HOST=moonbase
export CROSS_COMPILE="/usr/bin/aarch64-unknown-linux-gnu-"
export CROSS_COMPILE_ARM32="/usr/bin/armv7-unknown-linux-gnueabihf-"
export LD_LIBRARY_PATH="/cross-tc/clang/lib64:$LD_LIBRARY_PATH"

#KCFLAGS+="-O3 -mllvm -polly -fno-stack-protector -march=armv8-a+fp+simd+crc+crypto -mcpu=kryo -mtune=kryo -Wno-error=misleading-indentation -Wno-enum-conversion"
# Gcc-11-Optimize - Clang Optimize Hacks.

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
CLANG_TRIPLE_ARM32=/usr/bin/armv7-unknown-linux-gnueabihf- oldconfig prepare nconfig Image.gz-dtb modules dtbo.img V=0
