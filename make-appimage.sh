#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q yt-dlp | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://github.com/yt-dlp.png
export DESKTOP=DUMMY
export MAIN_BIN=yt-dlp
export DEPLOY_PYTHON=1

# Deploy dependencies
quick-sharun /usr/bin/yt-dlp /usr/bin/deno

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
