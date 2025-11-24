#!/bin/bash

source "$XDG_CONFIG_HOME/packages/clean_list.sh"

file="$XDG_CONFIG_HOME/packages/packages_yay.txt"

echo "Packages installed but NOT in packages_yay.txt:"
pacman -Qqem | grep -vxFf <(clean_list $file)
echo

echo "Packages in packages_yay.txt but NOT installed:"
grep -vxFf <(pacman -Qqem) <(clean_list $file)
echo

