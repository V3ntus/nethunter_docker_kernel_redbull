#!/bin/bash
make clean && rm -rf out
export ARCH=arm64
export SUBARCH=arm64
export PATH="/root/proton-clang/bin:$PATH"

# Setup KernelSU to a specific commit which still implements UAPI 5.
# As of 10/20/2026, the UAPI implementation is 6, but the manager is behind on UAPI 5.
curl -LSs "https://raw.githubusercontent.com/KernelSU-Next/KernelSU-Next/next/kernel/setup.sh" | bash -s 465490a26667ba4cf00b3be975a7e28e53978829

mkdir out
args="-j$(nproc --all) \
ARCH=arm64 \
SUBARCH=arm64 \
O=out \
CC=clang \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
CLANG_TRIPLE=aarch64-linux-gnu- \
AR=llvm-ar \
NM=llvm-nm \
OBJCOPY=llvm-objcopy \
OBJDUMP=llvm-objdump \
STRIP=llvm-strip "
make ${args} mrproper
make ${args} nethunter-docker-support_redbull_defconfig
make ${args} menuconfig
