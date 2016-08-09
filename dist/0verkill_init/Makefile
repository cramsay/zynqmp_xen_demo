ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

all:  install

install:
	cat filelist.txt | tr '\n' '\0' | xargs -0 -I {} $(TARGETINST) -d "data/{}" "/{}"
	$(TARGETINST) -d -p 0755 startup_script.sh /etc/init.d/xen_init
	$(TARGETINST) -s /etc/init.d/xen_init /etc/rc5.d/S99xen_init

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  clean                  clean out build objects"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  build                  build subsystem"
	@echo "  install                install built objects to rootfs host copy"
