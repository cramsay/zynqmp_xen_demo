#!/bin/bash

export DIST_DIR=`pwd`/dist

# Create project
petalinux-create --type project --template zynqMP -s $DIST_DIR/ZCU102.bsp --name dom0
cd dom0

# Enable bridge utils and ethtool in rootfs
echo "CONFIG_ROOTFS_PACKAGES_BRIDGE_UTILS=y" >> subsystems/linux/configs/rootfs/config
echo "CONFIG_ROOTFS_PACKAGES_ETHTOOL=y" >> subsystems/linux/configs/rootfs/config

# Enable XEN network backend in kernel
echo "CONFIG_XEN_NETDEV_BACKEND=y" >> subsystems/linux/configs/kernel/config

# Edit xen device tree to give enough space for our large dom0 kernel
sed -i 's/reg = <0x0 0x80000 0x3100000>;/reg = <0x0 0x80000 0x6400000>;/g' subsystems/linux/configs/device-tree/xen-overlay.dtsi

# Add 0verkill app from dist and images from domUs
petalinux-create -t apps -n 0verkill_init --template install --enable
cd components/apps/0verkill_init
cp -r $DIST_DIR/0verkill_init/* .
cp $DIST_DIR/../domU_server/images/linux/Image data/xen/Image_server
cp $DIST_DIR/../domU_client/images/linux/Image data/xen/Image_client

# Build image
petalinux-build
petalinux-package --boot --u-boot
