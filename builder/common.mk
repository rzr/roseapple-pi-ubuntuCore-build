CPUS := $(shell getconf _NPROCESSORS_ONLN)

include .config

OUTPUT_DIR := $(PWD)
SCRIPT_DIR := $(OUTPUT_DIR)/scripts
TOOLS_DIR := $(OUTPUT_DIR)/tools
PRELOAD_DIR := $(OUTPUT_DIR)/preloader
CONFIG_DIR := $(OUTPUT_DIR)/config/$(IC_NAME)/$(BOARD_NAME)
GADGET_DIR := $(OUTPUT_DIR)/gadget
GADGET_VERSION := `grep version $(GADGET_DIR)/meta/snap.yaml | awk '{print $$2}'`

# VENDOR: toolchain from BSP ; DEB: toolchain from deb
TOOLCHAIN := DEB

ARCH := arm
KERNEL_DTS := actduino_bubble_gum_sdboot_linux
UBOOT_DEFCONFIG := actduino_bubble_gum_v10_defconfig

KERNEL_BUILD := $(PWD)/kernel

UBOOT_REPO := https://github.com/xapp-le/u-boot.git
UBOOT_BRANCH := Ubuntu-Snappy-Core
UBOOT_SRC := $(PWD)/u-boot
UBOOT_OUT := $(PWD)/u-boot-build
UBOOT_BIN := $(UBOOT_OUT)/u-boot-dtb.img

ifeq ($(TOOLCHAIN),VENDOR)
CC :=
else
CC := arm-linux-gnueabihf-
endif
