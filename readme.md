# 0verkill XEN Demo

## Setup Description

Petalinux Dom0 and DomUs.
Default config but with ssh and both with 0verkill "app".

 + Dom0 0verkill app copies over 0verkill-server
 + DomU 0verkill app copies over 0verkill (client)


## How to run it

Tell u-boot to load xen first and put the Dom0 kernel at 0x80000 so xen can find it when it's ready.

```
fatload mmc 0 4000000 xen.dtb;
fatload mmc 0 80000 Image;
fatload mmc 0 6000000 xen.ub;
bootm 6000000 - 4000000;
```

Now we want to get our DomUs spun up.
```
mount /dev/mmcblk0p1 /mnt
/mnt/bridge.sh
for xen_cfg in $(ls /mnt/xen_demo/xen_*.cfg); do xl create $xen_cfg; done
```


## Repeatability...
### Dom0 creation

```bash
source /opt/Xilinx/petalinux-v2016.2-final/settings.sh
export DIST_DIR=<dist-dir>

# Create project
petalinux-create --type project --template zynqMP -s $DIST_DIR/ZCU102.bsp --name dom0_peta
cd dom0_peta

# Set your MAC to something you like
# Subsystem AUTO Hardware Settings -> Ethernet Settings -> Ethernet MAC address
petalinux-config

# Enable ssh, bridge utils, and ethtool
# Filesystem Packages -> console/network 	-> dropbear -> dropbear [*]
# Filesystem Packages -> net				-> net		-> bridge-utils [*] and bridge-utils-lic [*]
# Filesystem Packages -> console/network	-> ethtool  -> ethtool [*] and ethtool-lic[*]
petalinux-config -c rootfs

# Enable XEN networking backend
# Device Drivers	-> Network device support	-> XEN_NETDEV_BACKEND [*]
petalinux-config -c kernel

# Make 0verkill app
# TODO: Could directly use --source flag here
petalinux-create --type apps --template c --name 0verkill --enable
cp -r $DIST_DIR/dom0_app/* components/apps/0verkill/
petalinux-build
petalinux-package --boot --u-boot
```

Then copy over BOOT.BIN and image.ub from images/linux to the SD card.

#### To clean up

 + Set mac address via device tree?
 + Make xen config with networking
 + Mount SD card on boot (so we can get to the kernel of Dom0)

### Dist folder notes
This is the set of files intended for distribution. The user doesn't need to recreate these, but it's useful for me to write down how I did it!

First, for the 0verkill_bin folder:
 + Got source from https://github.com/hackndev/0verkill
 + Fooled about with cross compilation, then gave up.
 + Built it on ubuntu on the MPSoC board, then copied binaries
 	* Install build-essential
	* Edit "rebuild" to not include --with-x flag
	* run rebuild

Petalinux Makefile just uses find, xargs and TARGETINST to copy over all the files in the 0verkill_bin folder to the root filesystem.

> 0verkill client doesn't run over serial! Must ssh!
