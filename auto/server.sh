#!/bin/bash

# Copy client project
cp -r peta_client peta_server
cd peta_server

# Create new app for autostart scripts
petalinux-create -t apps -n autostart --template install --enable
cp $DIST/server_files/autostart components/apps/autostart/data/autostart
cp $DIST/server_files/Makefile components/apps/autostart/Makefile

# Bulid
petalinux-build
