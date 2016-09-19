#!/bin/bash
export DIST=`pwd`../dist
source ~/peta/petalinux-v2016.2-final/settings.sh

bash client.sh
bash server.sh
bash dom0.sh
