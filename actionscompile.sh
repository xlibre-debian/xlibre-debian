#!/usr/bin/env bash
export DEB_BUILD_OPTIONS="nocheck"
export FAILFAST="$2"
export SYSTEMD="$1"
if [ "$SYSTEMD" != "true" ]; then
	export DEB_BUILD_PROFILES="nosystemd"
fi

export CURRENTARCH=`arch`

if [ "$CURRENTARCH" == "x86_64" ]; then
	TO_BUILD="xorgproto xlibre-server xserver-xlibre-input-elographics xserver-xlibre-input-libinput xserver-xlibre-input-vmmouse xserver-xlibre-input-wacom xserver-xlibre-video-ati xserver-xlibre-video-fbdev xserver-xlibre-video-nouveau xserver-xlibre-video-sisusb xserver-xlibre-video-vmware xserver-xlibre-input-evdev xserver-xlibre-input-synaptics xserver-xlibre-input-void xserver-xlibre-video-amdgpu xserver-xlibre-video-dummy xserver-xlibre-video-intel xserver-xlibre-video-qxl xserver-xlibre-video-vesa xserver-xlibre-video-voodoo xserver-xlibre-input-keyboard xserver-xlibre-input-mouse xlibre"
else
	TO_BUILD="xorgproto xlibre-server xserver-xlibre-input-elographics xserver-xlibre-input-libinput xserver-xlibre-input-wacom xserver-xlibre-video-ati xserver-xlibre-video-fbdev xserver-xlibre-video-nouveau xserver-xlibre-video-sisusb xserver-xlibre-input-evdev xserver-xlibre-input-synaptics xserver-xlibre-input-void xserver-xlibre-video-amdgpu xserver-xlibre-video-dummy xserver-xlibre-video-qxl xserver-xlibre-video-voodoo xserver-xlibre-input-keyboard xserver-xlibre-input-mouse xlibre"
fi

ORIGINAL_DIR=`pwd`

for dir in $TO_BUILD; do
	if [ -d "$dir" ]; then
		echo -e "\e[0;32mBuilding in directory\e[0m: $dir"
		cd "$dir" || { echo "Failed to enter directory: $dir"; exit 1; }

		# not really needed
		git fetch origin pristine-tar:pristine-tar 2>/dev/null || true
		git fetch origin upstream/latest:upstream/latest 2>/dev/null || true

		mk-build-deps --install --remove --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends -y' debian/control || true

		# don't sign packages, they will be signed in a repo.
		if ! gbp buildpackage --git-builder="debuild -i -I -us -uc" --git-debian-branch="xlibre/latest" --git-upstream-branch="upstream/latest" --git-pristine-tar; then
			echo -e "\e[31mFailed to build package\e[0m: $dir"
			if [ "$FAILFAST" = "true" ]; then
				exit 1
			fi
		fi

		cd "$ORIGINAL_DIR" || { echo "Failed to return to original directory"; exit 1; }

		# install build dependencies in real time
		if [ "$dir" = "xorgproto" ]; then
			echo -e "\e[0;32mInstalling x11proto-dev\e[0m"
			dpkg -i x11proto-dev_*.deb || apt-get install -f -y
		fi
		if [ "$dir" = "xlibre-server" ]; then
			echo -e "\e[0;32mInstalling xserver-xlibre-dev\e[0m"
			dpkg -i xserver-xlibre-dev_*.deb || apt-get install -f -y
		fi

	else
		echo "Directory not found: $dir"
	fi
done
mkdir -p $ORIGINAL_DIR/build
mv *.build *.buildinfo *.changes *.deb *.xz *.gz *.dsc *.udeb $ORIGINAL_DIR/build || echo "Unable to move files to 'build' directory"
echo "If you are running on Ubuntu then you will get that error probably. I'm not sure though as I haven't really cared"
