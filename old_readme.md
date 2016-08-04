# XEN demo

## How it's setup

### Dom0
Petalinux kernel.
Buildroot FS + XZD xen tools punched in.
Buildroot is upstream, with some configs and overlays stolen from XZD

### DomU
Petalinux kernel.
Ubuntu-core but could easily be buildroot...

## Running it

Tell u-boot to load xen first and put the Dom0 kernel at 0x80000 so xen can find it when it's ready.

```
fatload mmc 0 4000000 xen.dtb;
fatload mmc 0 80000 Image;
fatload mmc 0 6000000 xen.ub;
bootm 6000000 - 4000000;
```

Wait for Dom0 login prompt (user=root, password=root).

When Dom0 boots, I've made it mount the first partition on the sd card (the one we just booted from) to `/mnt`. The DomU init script `/mnt/ubuntu-core/init.sh` is called from the end of the existing `/xenboot.sh` script. There should be evidence of DomU using the xl command.

```
xl list
```
> |Name               |ID  |Mem     |VCPUs |State    |Time(s)|
> |-------------------|----|--------|------|---------|-------|
> |dom0               |0   |512     |4     |r-----   |    6.3|
> |domu               |1   |1024    |4     |-b----   |    7.0|

Switch to DomU's console with `xl console domu`. You can return to Dom0's console with `ctrl`+`]` at any time. Log in with the same credentials.

I haven't got the automatic networking setup yet. Start dhcp on eth0 now.

```
ip link set eth0 up
dhclient eth0
```

Note the ip address, then start the graphical session with `./start_display.sh`.
From your host PC, we can now use VNC to access the graphical session running on the board.

```
vncviewer -encoding "hextile copy raw" 10.42.1.XXX
```
