#!/bin/bash

petalinux-create --type project --template zynqMP -s $DIST\ZCU102.bsp --name peta_client
cd peta_client

# Enable SSH
echo "CONFIG_ROOTFS_PACKAGES_DROPBEAR=y" >> subsystems/linux/configs/rootfs/config

# Add 0verkill app from dist
petalinux-create -t apps -n 0verkill --template install --enable
cp -r $DIST/0verkill/* components/apps/0verkill/data
cp $DIST/client_files/Makefile components/apps/0verkill/Makefile

# Build image
petalinux-build
