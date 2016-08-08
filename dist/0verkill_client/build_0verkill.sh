#!/bin/bash

cd data

# Get source code from github
git clone https://github.com/hackndev/0verkill.git
cd 0verkill

# Fix the hard coded use of gcc. That breaks our cross compilation (we're using aarch64-linux-gnu-gcc)
sed -i 's/gcc /$(CC) /g' Makefile.in

# Configure using autoconf...
aclocal
autoheader
autoconf
CC=aarch64-linux-gnu-gcc LD=aarch64-linux-gnu-ld ./configure --prefix=/usr --host=arm-linux

# Compile!
export CROSS_COMPILE=aarch64-linux-gnu-
make
