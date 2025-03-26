#!/bin/bash

# Default outputs can be overriden by these variables
: "${EXTERNAL_OUTPUT:=HDMI-2}"
: "${INTERNAL_OUTPUT:=eDP-1}"

sleep 1

if xrandr | grep "$EXTERNAL_OUTPUT connected"; then
    xrandr --output $EXTERNAL_OUTPUT --auto --above $INTERNAL_OUTPUT
fi

sleep 1

if xrandr | grep "$EXTERNAL_OUTPUT disconnected"; then
    xrandr --output "$EXTERNAL_OUTPUT" --off
fi

