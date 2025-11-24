#!/bin/bash

source "$XDG_CONFIG_HOME/packages/clean_list.sh"

file="$XDG_CONFIG_HOME/packages/packages_yay.txt"

yay -Syu --needed --removemake --cleanafter - <  <(clean_list $file)

