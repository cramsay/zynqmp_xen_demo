ifndef PETALINUX
$(error "Error: PETALINUX environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include apps.common.mk

all:  install

install:
	$(TARGETINST) -d -p 0755 data/autostart /etc/init.d/xen_init
	$(TARGETINST) -d -s /etc/init.d/xen_init /etc/rc5.d/S99_xen_init
	for i in $$(ls data/xen); do\
		$(TARGETINST) -d -p 644 data/xen/$$i /etc/xen/$$i;\
	done

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  clean                  clean out build objects"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  build                  build subsystem"
	@echo "  install                install built objects to rootfs host copy"
