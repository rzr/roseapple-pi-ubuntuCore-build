include common.mk

SNAPPY_IMAGE := $(shell i="0"; while ls roseapple-pi-`date +%Y%m%d`-$${i}.img* 1> /dev/null 2>&1; do i=$$((i+1)); done; echo "roseapple-pi-`date +%Y%m%d`-$${i}.img")
# yes for latest version; no for the specific revision of edge/stable channel
SNAPPY_CORE_NEW := yes
SNAPPY_CORE_VER ?=
SNAPPY_CORE_CH := edge
GADGET_SNAP := roseapple-pi_$(GADGET_VERSION)_armhf.snap
KERNEL_SNAP_VERSION := `cat $(KERNEL_SRC)/prime/meta/snap.yaml | grep version: | awk '{print $$2}'`
KERNEL_SNAP := roseapple-pi-kernel_$(KERNEL_SNAP_VERSION)_armhf.snap
REVISION ?=
SNAPPY_WORKAROUND := no

all: build

clean:
	rm -f $(OUTPUT_DIR)/*.img.xz
distclean: clean

build-snappy:
ifeq ($(SNAPPY_CORE_NEW),no)
		$(eval REVISION = --revision $(SNAPPY_CORE_VER))
endif
	@echo "build snappy..."
	sudo UBUNTU_DEVICE_FLASH_IGNORE_UNSTABLE_GADGET_DEFINITION=y $(UDF) core 16 -v \
		--channel $(SNAPPY_CORE_CH) \
		--size 4 \
		--enable-ssh \
		--developer-mode \
		--gadget $(GADGET_SNAP) \
		--kernel $(KERNEL_SNAP) \
		--os ubuntu-core \
		-o $(SNAPPY_IMAGE) \
		$(REVISION)

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
