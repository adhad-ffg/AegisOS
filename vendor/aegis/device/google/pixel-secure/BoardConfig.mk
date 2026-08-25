# BoardConfig.mk for Pixel Secure with GKI prebuilts

# Use prebuilt GKI kernel
TARGET_NO_KERNEL := false
BOARD_PREBUILT_KERNEL := device/google/pixel-secure/kernel/prebuilts/Image
BOARD_PREBUILT_DTBOIMAGE := device/google/pixel-secure/kernel/prebuilts/dtbo.img
TARGET_KERNEL_DIR := device/google/pixel-secure/kernel/prebuilts
TARGET_KERNEL_CONFIG := gki_defconfig

# Kernel modules (out-of-tree, built against prebuilt headers)
BOARD_VENDOR_KERNEL_MODULES += \
    device/google/pixel-secure/kernel/modules/spoof/spoof.ko \
    device/google/pixel-secure/kernel/modules/ebpf/detector.ko
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    device/google/pixel-secure/kernel/modules/spoof/spoof.ko \
    device/google/pixel-secure/kernel/modules/ebpf/detector.ko

# Kernel module signing (optional, for GKI compliance)
BOARD_SIGN_KERNEL_MODULES := true
BOARD_KERNEL_MODULE_SIGN_KEY := device/google/pixel-secure/avb/keys/verity.pem

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_ALGORITHM := SHA256_RSA2048
BOARD_AVB_KEY_PATH := device/google/pixel-secure/avb/keys/verity.pem
BOARD_AVB_ROLLBACK_INDEX := 0
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --set_hashtree_disabled_flag

# SELinux
BOARD_SEPOLICY_DIRS += device/google/pixel-secure/sepolicy
BOARD_SEPOLICY_M4DEFS += \
    qapp_service_domain=qapp_service \
    ebpf_detector_domain=ebpf_detector

# eBPF (for detector)
BOARD_BPF_MODULES := device/google/pixel-secure/runtime/ebpf_detector/detector.bpf.o
