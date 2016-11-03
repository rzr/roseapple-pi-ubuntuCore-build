include common.mk

OEM_UBOOT_BIN := $(GADGET_DIR)/boot-assets/u-boot.bin
OEM_SNAP := $(OUTPUT_DIR)/*.snap

# for preloader packaging
ifneq "$(findstring ARM, $(shell grep -m 1 'model name.*: ARM' /proc/cpuinfo))" ""
BOOTLOADER_PACK=bootloader_pack.arm
else
BOOTLOADER_PACK=bootloader_pack
endif

all: build

clean:
	rm -rf $(GADGET_DIR)/boot-assets
	rm -f $(GADGET_DIR)/uboot.conf
	rm -f $(GADGET_DIR)/uboot.env
	rm -f $(OEM_SNAP)
distclean: clean

u-boot:
	@if [ ! -f $(UBOOT_BIN) ] ; then echo "Build u-boot first."; exit 1; fi
		cp -f $(UBOOT_BIN) $(OEM_UBOOT_BIN)

preload:
	cd $(TOOLS_DIR)/utils && ./$(BOOTLOADER_PACK) $(PRELOAD_DIR)/bootloader.bin $(PRELOAD_DIR)/bootloader.ini $(GADGET_DIR)/bootloader.bin
	mkenvimage -r -s 131072  -o $(GADGET_DIR)/uboot.env $(GADGET_DIR)/uboot.env.in
	@if [ ! -f $(GADGET_DIR)/uboot.conf ]; then ln -s uboot.env $(GADGET_DIR)/uboot.conf; fi

snappy:
	snapcraft snap gadget

gadget: preload u-boot snappy

build: gadget

.PHONY: u-boot snappy gadget build
