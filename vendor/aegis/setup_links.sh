#!/bin/bash
# setup_links.sh - Create symlinks for vendor overlays in AOSP tree
# Usage: source build/envsetup.sh && lunch aosp_<device>-userdebug && ./vendor/aegis/setup_links.sh

set -e

AOSP_ROOT="$ANDROID_BUILD_TOP"
VENDOR_AEGIS="$AOSP_ROOT/vendor/aegis"

if [ -z "$ANDROID_BUILD_TOP" ]; then
    echo "Error: Run 'source build/envsetup.sh' first."
    exit 1
fi

echo "Setting up AegisOS overlay symlinks..."

# Link device tree (if not already linked)
DEVICE_LINK="$AOSP_ROOT/device/google/pixel-secure"
if [ ! -e "$DEVICE_LINK" ]; then
    ln -sf "$VENDOR_AEGIS/device/google/pixel-secure" "$DEVICE_LINK"
    echo "Linked device tree -> $DEVICE_LINK"
fi

# Link Settings overlay (override existing packages/apps/Settings)
SETTINGS_SRC="$VENDOR_AEGIS/packages/apps/Settings"
SETTINGS_DST="$AOSP_ROOT/packages/apps/Settings"
if [ -d "$SETTINGS_DST" ]; then
    # Backup original if not already
    if [ ! -L "$SETTINGS_DST" ]; then
        mv "$SETTINGS_DST" "$SETTINGS_DST.bak"
        echo "Moved original Settings to $SETTINGS_DST.bak"
    else
        rm "$SETTINGS_DST"
    fi
fi
ln -sf "$SETTINGS_SRC" "$SETTINGS_DST"
echo "Linked Settings -> $SETTINGS_DST"

# Link frameworks/base overlay (replace/add files)
FRAMEWORKS_SRC="$VENDOR_AEGIS/frameworks/base"
FRAMEWORKS_DST="$AOSP_ROOT/frameworks/base"
if [ -d "$FRAMEWORKS_DST" ]; then
    # Use overlay directory: create symlinks for each file/dir
    # We'll symlink specific files and directories
    for item in "$FRAMEWORKS_SRC"/*; do
        name=$(basename "$item")
        target="$FRAMEWORKS_DST/$name"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            mv "$target" "$target.bak"
            echo "Moved original $target to $target.bak"
        fi
        if [ -e "$target" ]; then
            rm -f "$target"
        fi
        ln -sf "$item" "$target"
        echo "Linked $name -> $target"
    done
else
    echo "Error: frameworks/base not found in AOSP root"
    exit 1
fi

echo "AegisOS overlay setup complete."
