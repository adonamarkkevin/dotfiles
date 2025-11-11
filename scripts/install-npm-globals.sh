#!/bin/bash

# Install NPM Global Packages

set -e

echo "=========================================="
echo "  Installing NPM Global Packages"
echo "=========================================="
echo ""

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "✗ npm not found. Please install Node.js first."
    exit 1
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
