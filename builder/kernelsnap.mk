include common.mk

KERNEL_SNAP_VERSION := `cat $(KERNEL_SRC)/prime/meta/snap.yaml | grep version: | awk '{print $$2}'`
KERNEL_SNAP := roseapple-pi-kernel_$(KERNEL_SNAP_VERSION)_armhf.snap

all: build

clean:
	rm -f roseapple-pi-kernel*.snap
	if [ -d $(KERNEL_SRC) ] ; then cd $(KERNEL_SRC); snapcraft clean; fi

distclean: clean
	rm -rf $(wildcard $(KERNEL_SRC))

build:
	if [ ! -d $(KERNEL_SRC) ] ; then git clone $(KERNEL_REPO) -b $(KERNEL_BRANCH) kernel; fi
	cd $(KERNEL_SRC); snapcraft clean; snapcraft --target-arch armhf snap
	sudo rm -rf $(OUTPUT_DIR)/kernel-snap
	mkdir $(OUTPUT_DIR)/kernel-snap
	sudo unsquashfs -f -d $(OUTPUT_DIR)/kernel-snap $(KERNEL_SRC)/$(KERNEL_SNAP)
	sudo sudo ln -P $(OUTPUT_DIR)/kernel-snap/vmlinuz $(OUTPUT_DIR)/kernel-snap/kernel.img
	sudo mksquashfs $(OUTPUT_DIR)/kernel-snap/ $(OUTPUT_DIR)/$(KERNEL_SNAP)

.PHONY: build
