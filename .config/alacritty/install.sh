#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$XDG_CONFIG_HOME/alacritty/current"
THEME_LINK="$THEME_DIR/theme.toml"
mkdir -p "$THEME_DIR"
if [ ! -e "$THEME_LINK" ]; then
  echo "Setting default Alacritty theme..."
  ln -s "$XDG_CONFIG_HOME/alacritty/themes/solarized_dark.toml" "$THEME_LINK"
fi

FONT_SIZE_LINK="$THEME_DIR/font_size.toml"
if [ ! -e "$FONT_SIZE_LINK" ]; then
  echo "Setting default font size..."
  ln -s "$XDG_CONFIG_HOME/alacritty/font_sizes/large.toml" "$FONT_SIZE_LINK"
fi

