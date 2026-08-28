#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
THEME_DIR="$CONFIG_DIR/current"
THEME_LINK="$THEME_DIR/theme.toml"
mkdir -p "$THEME_DIR"
if [ ! -e "$THEME_LINK" ]; then
  echo "Setting default Alacritty theme..."
  ln -s "$CONFIG_DIR/themes/solarized_dark.toml" "$THEME_LINK"
fi

FONT_SIZE_LINK="$THEME_DIR/font_size.toml"
if [ ! -e "$FONT_SIZE_LINK" ]; then
  echo "Setting default font size..."
  ln -s "$CONFIG_DIR/font_sizes/large.toml" "$FONT_SIZE_LINK"
fi

LOCAL_BIN="${XDG_BIN_HOME:-$HOME/.local/bin}"
mkdir -p "$LOCAL_BIN"
if [ ! -e "$LOCAL_BIN/alacritty-set" ]; then
  echo "Installing alacritty-set command..."
  ln -s "$CONFIG_DIR/alacritty-set.sh" "$LOCAL_BIN/alacritty-set"
fi
