#!/usr/bin/env bash
set -euo pipefail

SELF="$0"
while [ -L "$SELF" ]; do
    SELF_DIR="$(cd "$(dirname "$SELF")" && pwd)"
    SELF="$(readlink "$SELF")"
    case "$SELF" in
        /*) ;;
        *) SELF="$SELF_DIR/$SELF" ;;
    esac
done
SCRIPT_DIR="$(cd "$(dirname "$SELF")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
FONTS_DIR="$SCRIPT_DIR/font_sizes"
CURRENT_DIR="$SCRIPT_DIR/current"
ALACRITTY_TOML="$SCRIPT_DIR/alacritty.toml"
BIN_NAME="alacritty-set"

usage() {
    cat <<EOF
Usage: $BIN_NAME [SCOPE] [OPTIONS]

Change Alacritty theme and font size. Without a scope, changes are applied
to the current window only (runtime-only, not saved). Use --config to save
the change for the user (all windows pick it up via live reload).

Scopes (mutually exclusive):
  (default)                current window, runtime-only
  -w, --window <ID>        specific window, runtime-only
  --all-windows            all running windows, runtime-only
  --config                 save for the user via symlink + config reload

Options:
  -t, --theme [PATTERN]    theme; without PATTERN pick interactively
  -f, --font [NAME]        font size; without NAME pick interactively
  -l, --list               show current and available themes/font sizes
  -r, --revert             revert runtime changes within the scope
  -h, --help               show this help

Examples:
  $BIN_NAME                              pick setting and value interactively
  $BIN_NAME --theme light                theme for the current window
  $BIN_NAME --config --theme light       save theme for the user
  $BIN_NAME --all-windows --font large   font size in all running windows
  $BIN_NAME --revert --all-windows       revert runtime changes everywhere
EOF
}

die() {
    echo "$BIN_NAME: $*" >&2
    exit 1
}

find_alacritty() {
    local candidate
    if command -v alacritty >/dev/null 2>&1; then
        command -v alacritty
        return 0
    fi
    for candidate in \
        "/Applications/Alacritty.app/Contents/MacOS/alacritty" \
        "$HOME/Applications/Alacritty.app/Contents/MacOS/alacritty" \
        "$HOME/.cargo/bin/alacritty"; do
        if [ -x "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done
    return 1
}

list_files() {
    local dir="$1" name
    for name in "$dir"/*.toml; do
        [ -e "$name" ] || continue
        basename "$name" .toml
    done
}

match_file() {
    local dir="$1" pattern="$2" name lower_pattern match
    [ -n "$pattern" ] || die "empty pattern"
    lower_pattern="$(printf '%s' "$pattern" | tr '[:upper:]' '[:lower:]')"
    match=""
    for name in $(list_files "$dir"); do
        case "$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]')" in
            *"$lower_pattern"*)
                if [ -n "$match" ]; then
                    echo "Ambiguous pattern '$pattern', candidates:" >&2
                    echo "  $match" >&2
                    echo "  $name" >&2
                    exit 1
                fi
                match="$name"
                ;;
        esac
    done
    [ -n "$match" ] || {
        echo "No match for '$pattern'. Available:" >&2
        list_files "$dir" >&2
        exit 1
    }
    echo "$match"
}

pick_file() {
    local dir="$1" setting="$2" choice files count i=1
    files="$(list_files "$dir")"
    [ -n "$files" ] || die "no .toml files in $dir"
    if command -v fzf >/dev/null 2>&1; then
        choice="$(printf '%s\n' "$files" | fzf --prompt="$setting> " --height=40% --preview="cat $dir/{}.toml")" || exit 0
    else
        echo "Select $setting:" >&2
        for choice in $files; do
            echo "  $i) $choice" >&2
            i=$((i + 1))
        done
        printf "Enter number: " >&2
        read -r choice
        [ "$choice" -ge 1 ] 2>/dev/null || die "invalid selection"
        count=$(printf '%s\n' "$files" | wc -l | tr -d ' ')
        [ "$choice" -le "$count" ] || die "invalid selection"
        choice=$(printf '%s\n' "$files" | sed -n "${choice}p")
    fi
    echo "$choice"
}

pick_setting() {
    local choice
    if command -v fzf >/dev/null 2>&1; then
        choice="$(printf 'theme\nfont size\n' | fzf --prompt="setting> " --height=40%)" || exit 0
    else
        echo "Select setting:" >&2
        echo "  1) theme" >&2
        echo "  2) font size" >&2
        printf "Enter number: " >&2
        read -r choice
        case "$choice" in
            1) choice="theme" ;;
            2) choice="font size" ;;
            *) die "invalid selection" ;;
        esac
    fi
    case "$choice" in
        theme) echo "theme" ;;
        "font size") echo "font" ;;
        *) exit 0 ;;
    esac
}

current_value() {
    local link="$1"
    [ -L "$link" ] && basename "$(readlink "$link")" .toml || echo "(none)"
}

show_list() {
    echo "Theme:  $(current_value "$CURRENT_DIR/theme.toml")"
    echo "Font:   $(current_value "$CURRENT_DIR/font_size.toml")"
    echo
    echo "Themes:"
    list_files "$THEMES_DIR" | sed 's/^/  /'
    echo "Font sizes:"
    list_files "$FONTS_DIR" | sed 's/^/  /'
}

msg_config() {
    local window_id="$1" binary
    shift
    binary="$(find_alacritty)" || die "alacritty binary not found"
    "$binary" msg config -w "$window_id" "$@"
}

apply_runtime() {
    local window_id="$1" file="$2"
    local result
    if ! result="$(msg_config "$window_id" "$(cat "$file")" 2>&1)"; then
        echo "$BIN_NAME: failed to apply runtime config: $result" >&2
        case "$result" in
            *"no socket found"*)
                echo "Is Alacritty running? To save the change for the user, use --config." >&2
                ;;
        esac
        exit 1
    fi
}

apply_config() {
    local file="$1" link="$2" old
    old="$(current_value "$link")"
    mkdir -p "$CURRENT_DIR"
    ln -sf "$file" "$link"
    [ -f "$ALACRITTY_TOML" ] && touch "$ALACRITTY_TOML"
    echo "Saved: $(basename "$file" .toml) (was: $old)"
}

apply_theme() {
    local scope="$1" name="$2"
    if [ "$scope" = "config" ]; then
        apply_config "$THEMES_DIR/$name.toml" "$CURRENT_DIR/theme.toml"
    elif [ "$scope" = "-1" ]; then
        apply_runtime "$scope" "$THEMES_DIR/$name.toml"
        echo "Theme '$name' applied to all windows (runtime-only)."
    else
        apply_runtime "$scope" "$THEMES_DIR/$name.toml"
        echo "Theme '$name' applied to window (runtime-only)."
    fi
}

apply_font() {
    local scope="$1" name="$2"
    if [ "$scope" = "config" ]; then
        apply_config "$FONTS_DIR/$name.toml" "$CURRENT_DIR/font_size.toml"
    elif [ "$scope" = "-1" ]; then
        apply_runtime "$scope" "$FONTS_DIR/$name.toml"
        echo "Font size '$name' applied to all windows (runtime-only)."
    else
        apply_runtime "$scope" "$FONTS_DIR/$name.toml"
        echo "Font size '$name' applied to window (runtime-only)."
    fi
}

SCOPE=""
WINDOW_ID=""
THEME_FLAG=0
FONT_FLAG=0
THEME_ARG=""
FONT_ARG=""
DO_LIST=0
DO_REVERT=0

while [ $# -gt 0 ]; do
    case "$1" in
        -w|--window)
            [ -n "${2-}" ] || die "--window requires an ID"
            case "$2" in *[!0-9]*) die "--window requires a numeric ID" ;; esac
            [ "$SCOPE" = "all" ] && die "scopes are mutually exclusive"
            [ "$SCOPE" = "config" ] && die "scopes are mutually exclusive"
            SCOPE="window"
            WINDOW_ID="$2"
            shift 2
            ;;
        --window=*)
            [ "$SCOPE" = "all" ] && die "scopes are mutually exclusive"
            [ "$SCOPE" = "config" ] && die "scopes are mutually exclusive"
            SCOPE="window"
            WINDOW_ID="${1#*=}"
            [ -n "$WINDOW_ID" ] || die "--window requires an ID"
            case "$WINDOW_ID" in *[!0-9]*) die "--window requires a numeric ID" ;; esac
            shift
            ;;
        --all-windows)
            [ "$SCOPE" = "window" ] && die "scopes are mutually exclusive"
            [ "$SCOPE" = "config" ] && die "scopes are mutually exclusive"
            SCOPE="all"
            shift
            ;;
        --config)
            [ "$SCOPE" = "window" ] && die "scopes are mutually exclusive"
            [ "$SCOPE" = "all" ] && die "scopes are mutually exclusive"
            SCOPE="config"
            shift
            ;;
        -t|--theme)
            THEME_FLAG=1
            shift
            [ $# -gt 0 ] && case "$1" in
                -*) ;;
                *) THEME_ARG="$1"; shift ;;
            esac
            ;;
        --theme=*)
            THEME_FLAG=1
            THEME_ARG="${1#*=}"
            shift
            ;;
        -f|--font)
            FONT_FLAG=1
            shift
            [ $# -gt 0 ] && case "$1" in
                -*) ;;
                *) FONT_ARG="$1"; shift ;;
            esac
            ;;
        --font=*)
            FONT_FLAG=1
            FONT_ARG="${1#*=}"
            shift
            ;;
        -l|--list)
            DO_LIST=1
            shift
            ;;
        -r|--revert)
            DO_REVERT=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            die "unknown option: $1 (see --help)"
            ;;
    esac
done

if [ "$DO_LIST" -eq 1 ]; then
    show_list
    exit 0
fi

if [ "$DO_REVERT" -eq 1 ]; then
    case "$SCOPE" in
        window) REVERT_ID="$WINDOW_ID" ;;
        all) REVERT_ID="-1" ;;
        config) die "--revert is not available with --config" ;;
        *)
            [ -n "${ALACRITTY_WINDOW_ID-}" ] || die "not running inside Alacritty (no ALACRITTY_WINDOW_ID); use --window <ID> or --all-windows"
            REVERT_ID="$ALACRITTY_WINDOW_ID"
            ;;
    esac
    if ! result="$(msg_config "$REVERT_ID" -r 2>&1)"; then
        echo "$BIN_NAME: failed to revert: $result" >&2
        case "$result" in
            *"no socket found"*) echo "Is Alacritty running?" >&2 ;;
        esac
        exit 1
    fi
    echo "Runtime changes reverted."
    exit 0
fi

if [ "$THEME_FLAG" -eq 0 ] && [ "$FONT_FLAG" -eq 0 ]; then
    setting="$(pick_setting)"
    case "$setting" in
        theme) THEME_FLAG=1 ;;
        font) FONT_FLAG=1 ;;
    esac
fi

SCOPE_RESOLVED=""
resolve_scope() {
    if [ -n "$SCOPE_RESOLVED" ]; then
        echo "$SCOPE_RESOLVED"
        return 0
    fi
    if [ "$SCOPE" = "config" ]; then
        SCOPE_RESOLVED="config"
    elif [ "$SCOPE" = "all" ]; then
        SCOPE_RESOLVED="-1"
    elif [ "$SCOPE" = "window" ]; then
        SCOPE_RESOLVED="$WINDOW_ID"
    elif [ -n "${ALACRITTY_WINDOW_ID-}" ]; then
        SCOPE_RESOLVED="$ALACRITTY_WINDOW_ID"
    else
        die "not running inside Alacritty (no ALACRITTY_WINDOW_ID); use --window <ID>, --all-windows or --config"
    fi
    echo "$SCOPE_RESOLVED"
}

if [ "$THEME_FLAG" -eq 1 ] || [ "$FONT_FLAG" -eq 1 ]; then
    resolve_scope >/dev/null
fi

if [ "$THEME_FLAG" -eq 1 ]; then
    if [ -z "$THEME_ARG" ]; then
        THEME_ARG="$(pick_file "$THEMES_DIR" "theme")"
    else
        THEME_ARG="$(match_file "$THEMES_DIR" "$THEME_ARG")"
    fi
    apply_theme "$SCOPE_RESOLVED" "$THEME_ARG"
fi

if [ "$FONT_FLAG" -eq 1 ]; then
    if [ -z "$FONT_ARG" ]; then
        FONT_ARG="$(pick_file "$FONTS_DIR" "font size")"
    else
        FONT_ARG="$(match_file "$FONTS_DIR" "$FONT_ARG")"
    fi
    apply_font "$SCOPE_RESOLVED" "$FONT_ARG"
fi
