#!/usr/bin/env bash

# Power menu for rofi. Uses rofi in dmenu mode as a frontend.
# All system actions are handled by systemd / loginctl.

# Exit immediately if any command fails
set -e

# Power menu entries
MENU_ENTRIES="suspend
hybrid sleep
hibernate
shutdown
reboot
logout
cancel"

# Show confirmation menu
confirm() {
  printf "no\nyes\n" | rofi -dmenu -p "confirm $1"
}

# Ask for confirmation for destructive actions.
# First argument is the prompt, remaining arguments form the command to execute.
confrim_and_run() {
  local msg=$1; shift
  local CONFIRM
  CONFIRM=$(confirm "$msg") || return
  case "$CONFIRM" in
    yes) "$@" ;;
    no) main ;;
  esac
}

main() {
  # Show main power menu
  local CHOICE
  CHOICE=$(printf "%s\n" "$MENU_ENTRIES" | rofi -dmenu -p "power")

  # If user pressed Escape or selected nothing
  [ -z "$CHOICE" ] && exit 0

  case "$CHOICE" in
    shutdown)
      confirm_and_run shutdown systemctl poweroff
      ;;
    reboot)
      confirm_and_run reboot systemctl reboot
      ;;
    suspend)
      systemctl suspend
      ;;
    hibernate)
      systemctl hibernate
      ;;
    hybrid\ sleep)
      systemctl "hybrid sleep" hybrid-sleep
      ;;
    logout)
      # Terminates the current user session
      confirm_and_run logout loginctl terminate-user "$USER"
      ;;
    cancel)
      exit 0
      ;;
  esac
}

main

