#!/bin/bash

source "$XDG_CONFIG_HOME/packages/clean_list.sh"

file="$XDG_CONFIG_HOME/packages/packages_pacman.txt"

sudo pacman -S --needed - <  <(clean_list $file)

