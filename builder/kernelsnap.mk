include common.mk

KERNEL_SNAP_VERSION := `cat $(KERNEL_BUILD)/prime/meta/snap.yaml | grep version: | awk '{print $$2}'`
KERNEL_SNAP := roseapple-pi-kernel_$(KERNEL_SNAP_VERSION)_armhf.snap

all: build

clean:
	rm -f roseapple-pi-kernel*.snap
	cd $(KERNEL_BUILD); snapcraft clean

distclean: clean
	cd $(KERNEL_BUILD); snapcraft clean

build:
	cd $(KERNEL_BUILD); snapcraft --target-arch armhf snap
	cp $(KERNEL_BUILD)/$(KERNEL_SNAP) $(OUTPUT_DIR)

.PHONY: build
