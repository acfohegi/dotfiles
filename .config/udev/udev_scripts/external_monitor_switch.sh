#!/bin/bash

# Default outputs can be overriden by these variables
: "${EXTERNAL_OUTPUT:=HDMI-2}"
: "${INTERNAL_OUTPUT:=eDP-1}"

LOGFILE="/tmp/external_monitor_switch.log"

log() {
    local timestamp
    timestamp="[$(date --iso-8601=seconds)]"
    echo "$timestamp $1" >> $LOGFILE 2>&1
}

log "START FOR EXTERNAL_OUTPUT: $EXTERNAL_OUTPUT"
log "XAUTHORITY:$XAUTHORITY DISPLAY:$DISPLAY INTERNAL_OUTPUT:$INTERNAL_OUTPUT"
log "XRANDR STATE FOR EXTERNAL OUTPUT: $(xrandr | grep $EXTERNAL_OUTPUT)"

if xrandr | grep "$EXTERNAL_OUTPUT connected"; then
    log "EXTERNAL_OUTPUT CONNECTED: $EXTERNAL_OUTPUT"
    xrandr --output $EXTERNAL_OUTPUT --auto --above $INTERNAL_OUTPUT
fi

sleep 1

if xrandr | grep "$EXTERNAL_OUTPUT disconnected"; then
    log "EXTERNAL_OUTPUT DISCONNECTED: $EXTERNAL_OUTPUT"
    xrandr --output "$EXTERNAL_OUTPUT" --off
fi

