#!/usr/bin/env bash
TO_BUILD="xlibre-server xserver-xlibre-input-elographics xserver-xlibre-input-libinput xserver-xlibre-input-vmmouse xserver-xlibre-input-wacom xserver-xlibre-video-ati xserver-xlibre-video-fbdev xserver-xlibre-video-nouveau xserver-xlibre-video-sisusb xserver-xlibre-video-vmware xlibre xorgproto xserver-xlibre-input-evdev xserver-xlibre-input-synaptics xserver-xlibre-input-void xserver-xlibre-video-amdgpu xserver-xlibre-video-dummy xserver-xlibre-video-intel xserver-xlibre-video-qxl xserver-xlibre-video-vesa xserver-xlibre-video-voodoo"

for dir in $TO_BUILD; do
	if [ -d "$dir" ]; then
		echo -e "\e[31mAlready cloned\e[0m: $dir"
	else
		echo -e "\e[0;32mCloning\e[0m: $dir"
		git clone https://github.com/xlibre-debian/$dir || { echo "Failed to enter directory: $dir"; exit 1; }
	fi
done
