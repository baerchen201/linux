#!/usr/bin/env bash

# Setup
set -e
dir=release # Target directory (hardcoded in package.yml workflow)
if [ -d "$dir" ] && [ "$USER" != "runner" ]; then rm -rf "$dir"; fi # Delete directory if not running in GitHub Action
mkdir "$dir" # If exists, error. Intended behavior
shopt -s extglob dotglob

# Pack
files=!(.|..|.git*|"$dir"|package.sh)
echo "Packaging files [ $(echo $files) ] into directory \"$dir\""
tar -czf "$dir/release.tar.gz" $files # .tar.gz
zip -r "$dir/release.zip" $files # .zip

# Done
exit 0 # Success
