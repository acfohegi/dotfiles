#!/bin/bash

source "$XDG_CONFIG_HOME/packages/clean_list.sh"

file="$XDG_CONFIG_HOME/packages/packages_pacman.txt"

echo "Packages installed but NOT in packages_pacman.txt:"
pacman -Qqen | grep -vxFf <(clean_list $file)
echo

echo "Packages in packages_pacman.txt but NOT installed:"
grep -vxFf <(pacman -Qqen) <(clean_list $file)
echo

