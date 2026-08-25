$(call inherit-product, device/google/redbull/device.mk)

PRODUCT_NAME := secure_pixel
PRODUCT_DEVICE := pixel
PRODUCT_BRAND := Google
PRODUCT_MODEL := Pixel Secure
PRODUCT_MANUFACTURER := Google

# Include AegisOS custom packages
PRODUCT_PACKAGES += \
    SecureSettings \
    QappService \
    QappRuntime \
    eBPFDetector \
    KernelSpoofModule \
    qapp_runtime \
    avb_pkmd

# SELinux policy
BOARD_SEPOLICY_DIRS += device/google/pixel-secure/sepolicy

# Kernel hardening config
BOARD_KERNEL_CMDLINE += kaslr nokaslr=0 slub_debug=FZP

# Init scripts
PRODUCT_COPY_FILES += \
    device/google/pixel-secure/init/init.qapp.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.qapp.rc \
    device/google/pixel-secure/init/init.secure.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.secure.rc

# AVB custom keys
PRODUCT_COPY_FILES += \
    device/google/pixel-secure/avb/keys/verity.avbpubkey:$(TARGET_COPY_OUT_VENDOR)/etc/security/avb/verity.avbpubkey \
    device/google/pixel-secure/avb/avb_pkmd.bin:$(TARGET_COPY_OUT_VENDOR)/etc/security/avb/avb_pkmd.bin

# eBPF detector startup
PRODUCT_PACKAGES += ebpf_detector
