#!/bin/bash

# Install Development Tools
# Languages, compilers, and build tools

set -e

echo "=========================================="
echo "  Installing Development Tools"
echo "=========================================="
echo ""

# Development tools to install
DEV_TOOLS=(
    "base-devel"
    "git"
    "python"
    "python-pip"
    "go"
    "jdk-openjdk"
)

# Check which packages are missing
MISSING=()
for tool in "${DEV_TOOLS[@]}"; do
    if ! pacman -Qi "$tool" &> /dev/null; then
        MISSING+=("$tool")
    fi
done

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "✓ All development tools already installed"
else
    echo "Installing ${#MISSING[@]} development tools..."
    sudo pacman -S --needed --noconfirm "${MISSING[@]}"
    echo "✓ Development tools installed successfully"
fi

echo ""

# Setup Node.js via nvm
if command -v nvm &> /dev/null; then
    echo "Setting up Node.js via nvm..."
    nvm install 22
    nvm use 22
    echo "✓ Node.js v22 installed and activated"
else
    echo "⚠️  nvm not found. Install nvm first or run after dotfiles setup"
fi

echo ""
