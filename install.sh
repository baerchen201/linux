#!/bin/bash
set -e

clear
read -sn 1 -p "Confirm installation [y/N]" y
if ! [ "${y,,}" = "y" ]; then
	echo -e "\nInstallation cancelled"
	exit 1
fi
echo -e "\n == Starting installation =="

read -sn 1 -p "Install dependencies using \`sudo pacman\` [Y/n]" y
if ! [ "${y,,}" = "n" ]; then
	echo -e "\n == Installing dependencies, please wait... =="
	sudo pacman -Sy --needed --noconfirm < "$(dirname $0)/pacman.txt"
else
	echo -e "\nInstalling dependencies skipped, please install packages from pacman.txt manually"
fi

echo -e "\n == Copying files, please wait... =="
shopt -s dotglob extglob
cp $(dirname $0)/!(.git|.gitignore|pacman.txt|install.sh) ~ -r

echo -e "\n == Installation successful =="
read -sn 1 -p "Press any key to exit..."
echo
exit 0
