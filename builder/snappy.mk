include common.mk

SNAPPY_IMAGE := $(shell i="0"; while ls roseapple-pi-`date +%Y%m%d`-$${i}.img* 1> /dev/null 2>&1; do i=$$((i+1)); done; echo "roseapple-pi-`date +%Y%m%d`-$${i}.img")
# yes for latest version; no for the specific revision of edge/stable channel
UBUNTU_CORE_CH := edge
# UBUNTU_CORE_CH := beta
GADGET_MODEL := roseapple.model
GADGET_SNAP := roseapple-pi_$(GADGET_VERSION)_armhf.snap
KERNEL_SNAP_VERSION := `grep version: $(KERNEL_SRC)/prime/meta/snap.yaml | awk '{print $$2}'`
KERNEL_SNAP := roseapple-pi-kernel_$(KERNEL_SNAP_VERSION)_armhf.snap
SNAPPY_WORKAROUND := no
UBUNTU_IMAGE=/snap/bin/ubuntu-image

all: build

clean:
	rm -f $(OUTPUT_DIR)/*.img.xz
distclean: clean

build-snappy:
	@echo "build snappy..."
	$(UBUNTU_IMAGE) \
		-c $(UBUNTU_CORE_CH) \
		--image-size 4G \
		--extra-snaps $(GADGET_SNAP) \
		--extra-snaps $(KERNEL_SNAP) \
		--extra-snaps snapweb \
		-o $(SNAPPY_IMAGE) \
		$(GADGET_MODEL)


fix-bootflag:
	dd conv=notrunc if=boot_fix.bin of=$(SNAPPY_IMAGE) seek=440 oflag=seek_bytes

workaround:
ifeq ($(SNAPPY_WORKAROUND),yes)
	@echo "workaround something..."
endif

pack:
	pxz -9 $(SNAPPY_IMAGE)

build: build-snappy fix-bootflag workaround pack 

.PHONY: build-snappy fix-bootflag workaround pack build
