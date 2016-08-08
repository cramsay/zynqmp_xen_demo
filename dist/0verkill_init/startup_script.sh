#!/bin/bash

# Disable checksum offloading on ethernet.
# XEN would just ignore this and we'd get occasional broken UDP/TCP sessions
ethtool -K eth0 tx off

# Create a network bridge so domUs can talk over ethernet to the outside world
brctl addbr xenbr0
brctl addif xenbr0 eth0
/sbin/udhcpc -i xenbr0 -b

