#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm yt-dlp bun

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ! mesa ! vulkan

make-aur-package --archlinux-pkg bun

# build yt-dlp and its dependencies since archlinuxarm is insanely out of date
# remove deno dependency since we are going to use bun
export PRE_BUILD_CMDS="sed -i -e 's|deno||g' ./PKGBUILD"
make-aur-package --archlinux-pkg yt-dlp-ejs
make-aur-package --archlinux-pkg yt-dlp
unset PRE_BUILD_CMDS

# yt-dlp gives a warning that only deno is supported by default
sed -i -e "s|default=\['deno'\]|default=['bun']|" /usr/lib/python*/site-packages/yt_dlp/options.py

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
