#!/usr/bin/env bash
export DEB_BUILD_OPTIONS="nocheck"
export FAILFAST="$2"
export SYSTEMD="$1"
if [ "$SYSTEMD" != "true" ]; then
	export DEB_BUILD_PROFILES="nosystemd"
fi

export CURRENTARCH=`arch`

if [ "$CURRENTARCH" == "x86_64" ]; then
	TO_BUILD="xlibre-server xserver-xlibre-input-elographics xserver-xlibre-input-libinput xserver-xlibre-input-vmmouse xserver-xlibre-input-wacom xserver-xlibre-video-ati xserver-xlibre-video-fbdev xserver-xlibre-video-nouveau xserver-xlibre-video-sisusb xserver-xlibre-video-vmware xlibre xorgproto xserver-xlibre-input-evdev xserver-xlibre-input-synaptics xserver-xlibre-input-void xserver-xlibre-video-amdgpu xserver-xlibre-video-dummy xserver-xlibre-video-intel xserver-xlibre-video-qxl xserver-xlibre-video-vesa xserver-xlibre-video-voodoo xserver-xlibre-input-keyboard xserver-xlibre-input-mouse"
else
	TO_BUILD="xlibre-server xserver-xlibre-input-elographics xserver-xlibre-input-libinput xserver-xlibre-input-wacom xserver-xlibre-video-ati xserver-xlibre-video-fbdev xserver-xlibre-video-nouveau xserver-xlibre-video-sisusb xlibre xorgproto xserver-xlibre-input-evdev xserver-xlibre-input-synaptics xserver-xlibre-input-void xserver-xlibre-video-amdgpu xserver-xlibre-video-dummy xserver-xlibre-video-intel xserver-xlibre-video-qxl xserver-xlibre-video-voodoo xserver-xlibre-input-keyboard xserver-xlibre-input-mouse"
fi

ORIGINAL_DIR="$(pwd)"

for dir in $TO_BUILD; do
	if [ -d "$dir" ]; then
		echo -e "\e[0;32mBuilding in directory\e[0m: $dir"
		cd "$dir" || { echo "Failed to enter directory: $dir"; exit 1; }

		# don't sign packages, they will be signed in a repo.
		if ! gbp buildpackage --git-builder="debuild -i -I -us -uc" --git-debian-branch="xlibre/latest"; then
			echo -e "\e[31mFailed to build package\e[0m: $dir"
			if [ "$FAILFAST" = "true" ]; then
				exit 1
			fi
		fi

		cd "$ORIGINAL_DIR" || { echo "Failed to return to original directory"; exit 1; }

	else
		echo "Directory not found: $dir"
	fi
done
mkdir -p $ORIGINAL_DIR/build
mv *.build *.buildinfo *.changes *.deb *.xz *.gz *.dsc *.udeb $ORIGINAL_DIR/build || { echo "Unable to move files to 'build' directory"; exit 1; }
