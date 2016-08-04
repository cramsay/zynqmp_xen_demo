###########################################################
# This script sets up the networking then boots all
# DomU instances.
# 
# Dom0 then does nothing but mediate hardware access to
# the DomU instances
###########################################################

# Set up network bridge so DomUs can talk over the real network 
brctl addbr xenbr0
brctl addif xenbr0 eth0
/sbin/udhcpc -i xenbr0 -b

# Disable checksum offloading
# XEN doesn't actually do the offloaded checksums. 
# Without this, we'd get thrown out of any ssh sessions
# after a while ("message authentication code incorrect")
ethtool -K eth0 tx off

# Load all DomU configurations
# This looks scary but is really just running "xl create <my_domu.cfg>"
# for every config file in /xen_cfg
for xen_cfg in $(ls /xen_cfg/xen_*.cfg); do xl create $xen_cfg; done
