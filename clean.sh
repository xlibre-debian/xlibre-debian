#!/usr/bin/env bash
TO_BUILD="xlibre-server xserver-xlibre-input-elographics xserver-xlibre-input-libinput xserver-xlibre-input-vmmouse xserver-xlibre-input-wacom xserver-xlibre-video-ati xserver-xlibre-video-fbdev xserver-xlibre-video-nouveau xserver-xlibre-video-sisusb xserver-xlibre-video-vmware xlibre xorgproto xserver-xlibre-input-evdev xserver-xlibre-input-synaptics xserver-xlibre-input-void xserver-xlibre-video-amdgpu xserver-xlibre-video-dummy xserver-xlibre-video-intel xserver-xlibre-video-qxl xserver-xlibre-video-vesa xserver-xlibre-video-voodoo"
ORIGINAL_DIR="$(pwd)"

for dir in $TO_BUILD; do
	if [ -d "$dir" ]; then
		echo -e "\e[0;32mCleaning in directory\e[0m: $dir"
		cd "$dir" || { echo "Failed to enter directory: $dir"; exit 1; }

		debian/rules clean

		cd "$ORIGINAL_DIR" || { echo "Failed to return to original directory"; exit 1; }
	else
		echo "Directory not found: $dir"
	fi
done
