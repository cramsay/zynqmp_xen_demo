# 0verkill XEN Demo

# Run the demo

Tell u-boot that we want to load XEN first.
We put Dom0's kernel at 0x80000 so XEN can load it.
```
fatload mmc 0 4000000 xen.dtb;
fatload mmc 0 80000 Image;
fatload mmc 0 6000000 xen.ub;
bootm 6000000 - 4000000;
```

Now, play the game.

# How to build

Run init_server. This does a few things to set up a DomU for game server:
 + Create petalinux project
 + Enable dropbear ssh
 + Add 0verkill_server app from dist folder
 + Build image

Run init_client. This does a few things to set up a DomU for game client:
 + Create petalinux project
 + Enable dropbear ssh
 + Add 0verkill_client app from dist folder
 + Build image

Run init_dom0. This provides the Dom0 configuration which manages all of our DomU clients + server:
 + Create petalinux project
 + Enable...
   - Rootfs: bridge utils, ethtool
   - Kernel: XEN network backend
   - System: Known MAC

# OLD BUMF

## How to run it
Now we want to get our DomUs spun up.
```
mount /dev/mmcblk0p1 /mnt
/mnt/bridge.sh
for xen_cfg in $(ls /mnt/xen_demo/xen_*.cfg); do xl create $xen_cfg; done
```

## Repeatability...
### Dom0 creation

```bash
# Set your MAC to something you like
# Subsystem AUTO Hardware Settings -> Ethernet Settings -> Ethernet MAC address
petalinux-config

# Enable ssh, bridge utils, and ethtool
# Filesystem Packages -> console/network 	-> dropbear -> dropbear [*]
# Filesystem Packages -> net				-> net		-> bridge-utils [*]
# Filesystem Packages -> console/network	-> ethtool  -> ethtool [*]
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

 + Cross compile 0verkill

 ```
git clone https://github.com/hackndev/0verkill.git
cd 0verkill
sed -i 's/gcc /$(CC) /g' Makefile.in #Fix hard coded gcc reference
aclocal
autoheader
autoconf
export CROSS_COMPILE=aarch64-linux-gnu-
CC=aarch64-linux-gnu-gcc LD=aarch64-linux-gnu-ld ./configure --prefix=/usr --host=arm-linux
make

 ```

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
