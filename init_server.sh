#!/bin/bash

export DIST_DIR=`pwd`/dist

# Create project
petalinux-create --type project --template zynqMP -s $DIST_DIR/ZCU102.bsp --name domU_server
cd domU_server

# Enable SSH
echo "CONFIG_ROOTFS_PACKAGES_DROPBEAR=y" >> subsystems/linux/configs/rootfs/config

# Add 0verkill app from dist
petalinux-create -t apps -n 0verkill_server --template install --enable
cd components/apps/0verkill_server
cp -r $DIST_DIR/0verkill_server/* .
./build_0verkill.sh

# Build image
petalinux-build
