#!/bin/bash

set -e
set -x

TOOLCHAIN=riscv64-linux-gnu-

GENIMAGE_CFG=$(pwd)/genimage-star64-uboot.cfg

OPENSBI=$(pwd)/opensbi
OPENSBI_BUILD_DIR=$(pwd)/build/opensbi
OPENSBI_PAYLOAD_FINAL=$(pwd)/build/opensbi_uboot_payload.img

UBOOT=$(pwd)/u-boot
UBOOT_FDT=$UBOOT/arch/riscv/dts/pine64_star64.dtb
UBOOT_BIN=$UBOOT/u-boot.bin
UBOOT_SPL_BIN=$UBOOT/spl/u-boot-spl.bin
UBOOT_ITS=$(pwd)/star64-uboot-fit-image.its

SPL_TOOL_SRC=$(pwd)/soft_3rdpart/spl_tool

# Compile U-Boot
CROSS_COMPILE=$TOOLCHAIN make -C $UBOOT pine64_star64_defconfig
CROSS_COMPILE=$TOOLCHAIN make -C $UBOOT

# Compile OpenSBI payload with U-Boot
mkdir -p $OPENSBI_BUILD_DIR
make -C $OPENSBI PLATFORM=generic \
                    CROSS_COMPILE=$TOOLCHAIN \
                    FW_FDT_PATH=$UBOOT_FDT \
                    FW_PAYLOAD_PATH=$UBOOT_BIN \
                    PLATFORM_RISCV_XLEN=64 \
                    PLATFORM_RISCV_ISA=rv64gcb \
                    PLATFORM_RISCV_ABI=lp64d \
                    O=$OPENSBI_BUILD_DIR \
                    FW_TEXT_START=0x40000000 \
# mkimage U-Boot
mkimage -f $UBOOT_ITS -A riscv -O u-boot -T firmware $OPENSBI_PAYLOAD_FINAL
# Compile spl_tool
make -C $SPL_TOOL_SRC
# Add SPL header to U-Boot SPL
$SPL_TOOL_SRC/spl_tool -c -f $UBOOT_SPL_BIN 
# Finally compile all of it into one image
mkdir -p temp
mkdir -p root
genimage --config $GENIMAGE_CFG --inputpath . --tmppath temp

