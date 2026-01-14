#!/usr/bin/env bash

# Installer for i3menu.
# Creates symlink in ~/.local/bin.
# Installs .desktop entry into XDG applications directory.

set -e

# Set XDG_DATA_HOME fallback if not set
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

SOURCE_SCRIPT="$XDG_CONFIG_HOME/rofi/i3menu.sh"

BIN_DIR="$HOME/.local/bin"
BIN_PATH="$BIN_DIR/i3menu"

DESKTOP_DIR="$XDG_DATA_HOME/applications"
DESKTOP_FILE="$DESKTOP_DIR/i3menu.desktop"

# Ensure source script exists
if [ ! -f "$SOURCE_SCRIPT" ]; then
  echo "i3menu.sh not found"
  exit 1
fi

# Create ~/.local/bin if needed
mkdir -vp "$BIN_DIR"

# Ensure ~/.local/bin is in PATH
ZPROFILE="$HOME/.zprofile"
if ! grep -q 'local/bin' "$ZPROFILE" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZPROFILE"
    echo "Added ~/.local/bin to PATH in $ZPROFILE. You need to log out and back in for GUI to pick it up."
fi

# Create or update symlink
ln -sf "$SOURCE_SCRIPT" "$BIN_PATH"
chmod +x "$SOURCE_SCRIPT"

# Create applications directory if needed
mkdir -vp "$DESKTOP_DIR"

# Install desktop entry
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=i3 Menu
GenericName=Desktop controls
Exec=i3menu
EOF

echo "i3menu installed successfully."
echo "Binary: $BIN_PATH"
echo "Desktop entry: $DESKTOP_FILE"

