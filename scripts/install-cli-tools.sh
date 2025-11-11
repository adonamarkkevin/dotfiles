#!/bin/bash

# Install CLI Tools
# Modern CLI replacements and essential utilities

set -e

echo "=========================================="
echo "  Installing CLI Tools"
echo "=========================================="
echo ""

# CLI tools to install
CLI_TOOLS=(
    "htop"
    "eza"
    "fd"
    "ripgrep"
    "zoxide"
    "bat"
    "fzf"
    "jq"
    "curl"
    "wget"
    "tree"
    "neofetch"
    "tmux"
    "rsync"
    "unzip"
    "tar"
    "p7zip"
    "thefuck"
)

# Check which packages are missing
MISSING=()
for tool in "${CLI_TOOLS[@]}"; do
    if ! pacman -Qi "$tool" &> /dev/null; then
        MISSING+=("$tool")
    fi
done

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "✓ All CLI tools already installed"
else
    echo "Installing ${#MISSING[@]} CLI tools..."
    sudo pacman -S --needed --noconfirm "${MISSING[@]}"
    echo "✓ CLI tools installed successfully"
fi

echo ""
