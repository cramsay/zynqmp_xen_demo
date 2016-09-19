ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

all: build install

build:

clean:

.PHONY: install image

install:
	# Please add commands below the comments to install data to target file system.
	# Use $(TARGETINST) to copy data into the target
	# E.g. there is data/autostart in the current directory, and I want to
	# copy it into the target "/" directory:
	$(TARGETINST) -d -p 0755 data/autostart /etc/init.d/0verkill_server
	$(TARGETINST) -d -s /etc/init.d/0verkill_server /etc/rc5.d/S99_0verkill_server

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  install                install built objects to rootfs host copy"
