#!/bin/sh

# Try pbcopy (macOS), then xclip (X11), then xsel (X11)

if command -v pbcopy >/dev/null 2>&1; then
    pbcopy
elif command -v xclip >/dev/null 2>&1; then
    # redirecting stdout due to a bug in xclip
    # https://github.com/tmux/tmux/wiki/Clipboard#common-issues---xclip1
    xclip -selection clipboard >/dev/null
elif command -v xsel >/dev/null 2>&1; then
    xsel --clipboard --input
fi

