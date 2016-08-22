# 0verkill XEN Demo

# Run the demo

Tell u-boot that we want to load XEN first.
We put Dom0's kernel at 0x80000 so XEN can load it.

## From SD card
```
fatload mmc 0 7000000 xen.dtb;
fatload mmc 0 9000000 xen.ub;
fatload mmc 0 80000 Image;
bootm 9000000 - 7000000;
```

## From JTAG + TFTP
```
setenv serverip 10.42.0.1
tftpb 7000000 xen.dtb;
tftpb 9000000 xen.ub;
tftpb 80000 Image;
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


## How it works

> 0verkill client doesn't run over serial! Must ssh!

## Gotchas

 + Network checksum offloading
 + Default kernel size in device tree
 + Can't support virtual framebuffers in petalinux Dom0
