#!/bin/bash

# Install NPM Global Packages

set -e

echo "=========================================="
echo "  Installing NPM Global Packages"
echo "=========================================="
echo ""

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "✗ npm not found. Installing Node.js via NVM first..."
    echo ""

    # Install NVM if not present
    if [ ! -d "$HOME/.nvm" ]; then
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    fi

    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install Node.js
    if command -v nvm &> /dev/null; then
        echo "Installing Node.js v22..."
        nvm install 22
        nvm use 22
        nvm alias default 22
        echo "✓ Node.js installed"
    else
        echo "✗ Failed to load NVM. Please restart your shell and run this script again."
        exit 1
    fi
fi

echo "Current npm version: $(npm --version)"
echo "Current node version: $(node --version)"
echo ""

# NPM global packages to install
NPM_PACKAGES=(
    "@anthropic-ai/claude-code"
    "corepack"
    "yarn"
)

echo "Installing npm global packages..."
for package in "${NPM_PACKAGES[@]}"; do
    echo "  Installing $package..."
    npm install -g "$package"
done

echo ""
echo "✓ NPM global packages installed successfully"
echo ""

# List installed global packages
echo "Installed global packages:"
npm list -g --depth=0

echo ""
