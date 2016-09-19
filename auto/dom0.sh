#!/bin/bash

# Create project
petalinux-create --type project --template zynqMP -s $DIST/ZCU102.bsp --name peta_dom0
cd peta_dom0

# Enable bridge utils and ethtool in rootfs
echo "CONFIG_ROOTFS_PACKAGES_BRIDGE_UTILS=y" >> subsystems/linux/configs/rootfs/config
echo "CONFIG_ROOTFS_PACKAGES_ETHTOOL=y" >> subsystems/linux/configs/rootfs/config

# Enable XEN network backend in kernel
echo "CONFIG_XEN_NETDEV_BACKEND=y" >> subsystems/linux/configs/kernel/config

# Edit xen device tree to give enough space for our large dom0 kernel
sed -i 's/reg = <0x0 0x80000 0x3100000>;/reg = <0x0 0x80000 0x6400000>;/g' subsystems/linux/configs/device-tree/xen-overlay.dtsi

# Add 0verkill app from dist and images from domUs
petalinux-create -t apps -n autostart --template install --enable
cp -r $DIST/dom0_files/* components/apps/autostart/
cp ../peta_server/images/linux/Image components/apps/autostart/data/xen/Image_server
cp ../peta_client/images/linux/Image components/apps/autostart/data/xen/Image_client

# Build image
petalinux-build
petalinux-package --boot --u-boot
