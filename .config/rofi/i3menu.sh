#!/usr/bin/env bash

# i3 menu for rofi. Uses rofi in dmenu mode as a frontend.
# If the expected behavior is meaningful even with Rofi open, display info and offer execution.
# Otherwise, just display a short description.

set -e

show_info() {
    local lines=("$@")
    local msg=""
    for line in "${lines[@]}"; do
        msg+="$line\n\n"
    done
    rofi -e "$(printf "%b" "$msg")"
}

show_info_execute() {
    local command="$1"
    shift
    local lines=("$@")

    local msg=""
    for line in "${lines[@]}"; do
        msg+="$line\n"
    done

    # Show info in rofi
    rofi -e "$(printf "%b" "$msg")"

    # Prompt to confirm execution
    local choice
    choice=$(printf "yes\nno" | rofi -dmenu -p "execute?")
    if [ "$choice" = "yes" ]; then
        eval "$command"
    fi
}

MENU_ENTRIES=$(cat <<EOF
focus parent [MOD+A]
focus child [MOD+D]
split h [MOD+Z]
split v [MOD+V]
layout stacking [MOD+S]
layout tabbed [MOD+W]
layout toggle split [MOD+E]
floating toggle [MOD+SHIFT+SPACE]
focus mode_toggle [ALT+TAB]
bar mode toggle [MOD+N]
workspace next [MOD+TAB]
workspace prev [MOD+SHIFT+TAB]
workspace back_and_forth [MOD+B]
move container to workspace back_and_forth [MOD+SHIFT+B]
move workspace to output prev [MOD+ALT+CTRL+H]
move workspace to output next [MOD+ALT+CTRL+L]
EOF
)

while true; do
    CHOICE=$(printf "%s\n" "$MENU_ENTRIES" | rofi -dmenu -p "desktop controls")
    [ -z "$CHOICE" ] && break  # exit on Escape or empty

    case "$CHOICE" in
        "focus parent [MOD+A]")
            show_info "$CHOICE" "Moves focus to the parent container of the currently focused window"
            ;;
        "focus child [MOD+D]")
            show_info "$CHOICE" "Moves focus to the first child container of the currently focused window"
            ;;
        "split h [MOD+Z]")
            show_info "$CHOICE" "Splits the currently focused container horizontally"
            ;;
        "split v [MOD+V]")
            show_info "$CHOICE" "Splits the currently focused container vertically"
            ;;
        "layout stacking [MOD+S]")
            show_info "$CHOICE" "Changes the layout of the current container to stacking"
            ;;
        "layout tabbed [MOD+W]")
            show_info "$CHOICE" "Changes the layout of the current container to tabbed"
            ;;
        "layout toggle split [MOD+E]")
            show_info "$CHOICE" "Toggles the orientation (horizontal/vertical) of the current container"
            ;;
        "floating toggle [MOD+SHIFT+SPACE]")
            show_info "$CHOICE" "Toggles floating mode for the currently focused window"
            ;;
        "focus mode_toggle [ALT+TAB]")
            show_info "$CHOICE" "Toggles i3's focus mode, which determines whether focus navigation moves through tiling or floating windows. Does not change the active window."
            ;;
        "bar mode toggle [MOD+N]")
            show_info "$CHOICE" "Toggles the visibility mode of the i3 bar"
            ;;
        "workspace next [MOD+TAB]")
            show_info_execute "i3-msg workspace next" "$CHOICE" "Moves focus to the next workspace"
            ;;
        "workspace prev [MOD+SHIFT+TAB]")
            show_info_execute "i3-msg workspace prev" "$CHOICE" "Moves focus to the previous workspace"
            ;;
        "workspace back_and_forth [MOD+B]")
            show_info_execute "i3-msg workspace back_and_forth" "$CHOICE" "Switches to the previously focused workspace"
            ;;
        "move workspace to output prev [MOD+ALT+CTRL+H]")
            show_info_execute "i3-msg move workspace to output prev" "$CHOICE" "Moves the current workspace to the previous output"
            ;;
        "move workspace to output next [MOD+ALT+CTRL+L]")
            show_info_execute "i3-msg move workspace to output next" "$CHOICE" "Moves the current workspace to the next output"
            ;;
        "move container to workspace back_and_forth [MOD+SHIFT+B]")
            show_info "$CHOICE" "Moves the currently focused container to the previously focused workspace"
            ;;
        *)
            # Esc or empty
            ;;
    esac
done

