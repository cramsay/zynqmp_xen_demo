# 0verkill XEN Demo

# Run the demo

Tell u-boot that we want to load XEN first.
We put Dom0's kernel at 0x80000 so XEN can load it.
```
fatload mmc 0 7000000 xen.dtb;
fatload mmc 0 80000 Image;
fatload mmc 0 9000000 xen.ub;
bootm 9000000 - 7000000;
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
 + Add startup scripts from dist folder
 + Build image


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

## How it works

> 0verkill client doesn't run over serial! Must ssh!

## To do

 + Can I get uboot to do my command by default?
 + My start up scripts aren't working (add "S" to rc5.d script)
 + Add xen create commands to start script
