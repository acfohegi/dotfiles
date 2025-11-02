#!/bin/bash


USER=$(w | grep '/etc/X11/xinit/xserverrc :0' | awk '{print $1}' | head -1)
if [ -z "$USER" ]; then
    logger "No X user with :0 found"
    exit 1
fi

sleep 0.5

LID_STATE="/proc/acpi/button/lid/LID/state"
if [[ -f "$LID_STATE" ]]; then
    IS_OPEN=$(grep -q "open" "$LID_STATE" && echo "1" || echo "0")
    logger "Lid state file: $(cat $LID_STATE)"
    logger "Is open: $IS_OPEN"
else
    logger "Lid state file not found"
    exit 1
fi

DISPLAY=:0 runuser -u "$USER" -- /usr/bin/autorandr --change
logger "Triggered autorandr for user: $USER"

