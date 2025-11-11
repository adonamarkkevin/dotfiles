#!/bin/bash

# Install GUI Applications
# Media, creative, and productivity apps

set -e

echo "=========================================="
echo "  Installing GUI Applications"
echo "=========================================="
echo ""

# GUI applications to install
GUI_APPS=(
    "gimp"
    "obs-studio"
    "obsidian"
)

# Check which packages are missing
MISSING=()
for app in "${GUI_APPS[@]}"; do
    if ! pacman -Qi "$app" &> /dev/null; then
        MISSING+=("$app")
    fi
done

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "✓ All GUI applications already installed"
else
    echo "Installing ${#MISSING[@]} GUI applications..."
    sudo pacman -S --needed --noconfirm "${MISSING[@]}"
    echo "✓ GUI applications installed successfully"
fi

echo ""
