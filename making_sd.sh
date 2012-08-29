#!/bin/bash

export LOCAL_PATH=`pwd`
export MYDROID=${LOCAL_PATH}/../mydroid
export MYKERNEL=${LOCAL_PATH}/../kernel/android-3.0/arch/arm/boot
export MYUBOOT=${LOCAL_PATH}/../u-boot
export MYXLOADER=${LOCAL_PATH}/../x-loader

# Pretty colors
YELLOW="\033[01;33m"
NORMAL="\033[00m"
BLUE="\033[34m"
RED="\033[31m"

echo -e "${YELLOW}Your board type is $1 ${NORMAL}"
if [ "$1" == "blaze_tablet" ]; then
    export BOARD_TYPE=blaze_tablet
elif [ "$1" == "blaze" ]; then
    export BOARD_TYPE=blaze
else
    echo -e "${RED}Please confirm your board type${NORMAL}"
    echo -e "Usage : ./making_sd.sh [ blaze_tablet | blaze ]"
    exit 1
fi

echo -e "${YELLOW}Preparing Images for SD card....${NORMAL}"
export AFS_IMAGE_PATH=${MYDROID}/out/target/product/${BOARD_TYPE}
export IMG_PATH=${LOCAL_PATH}/omap4_sd_files_${BOARD_TYPE}

# ==================
# Check subdirectory
# ==================
if [ ! -d ${IMG_PATH} ]; then
    mkdir ${IMG_PATH}
fi

if [ ! -d ${IMG_PATH}/Boot_Images ]; then
    mkdir ${IMG_PATH}/Boot_Images
fi

if [ ! -d ${IMG_PATH}/Filesystem ]; then
    mkdir ${IMG_PATH}/Filesystem
fi

# ============================
# Preparing Images
# ============================
echo -e "${YELLOW}Copy mkmmc-anroid.sh${NORMAL}"
cp mkmmc-android.sh ${IMG_PATH}

echo -e "${YELLOW}Copy Kernel uImage${NORMAL}"
if [ ! -f ${MYKERNEL}/uImage ]; then
    echo -e "${RED}Not such kernel image !${NORMAL}"
    exit 1
else
    cp ${MYKERNEL}/uImage ${IMG_PATH}/Boot_Images
fi

echo -e "${YELLOW}Copy u-boot image${NORMAL}"
if [ ! -f ${MYUBOOT}/u-boot.bin ]; then
    echo -e "${RED}Not such u-boot image !${NORMAL}"
    exit 1
else
    cp ${MYUBOOT}/u-boot.bin ${IMG_PATH}/Boot_Images
fi

echo -e "${YELLOW}Copy x-loader image${NORMAL}"
if [ ! -f ${MYXLOADER}/MLO ]; then
    echo -e "${RED}Not such x-loader image !${NORMAL}"
    exit 1
else
    cp ${MYXLOADER}/MLO ${IMG_PATH}/Boot_Images
fi

echo -e "${YELLOW}Copy Android File System${NORMAL}"
cp -Rfp ${AFS_IMAGE_PATH}/root/* ${IMG_PATH}/Filesystem
cp -Rfp ${AFS_IMAGE_PATH}/system/ ${IMG_PATH}/Filesystem
cp -Rfp ${AFS_IMAGE_PATH}/data/ ${IMG_PATH}/Filesystem
