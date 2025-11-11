#!/bin/bash

# Master Installation Script
# Runs all individual installation scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    log_error "Please do not run this script as root or with sudo"
    exit 1
fi

echo ""
echo "=========================================="
echo "  Required Apps Installation"
echo "=========================================="
echo ""
log_info "This script will install:"
echo "  1. CLI Tools (htop, eza, bat, fzf, etc.)"
echo "  2. Development Tools (git, python, go, java)"
echo "  3. GUI Applications (gimp, obs-studio, obsidian)"
echo "  4. NPM Global Packages (claude-code, yarn)"
echo ""

read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_warning "Installation cancelled"
    exit 0
fi

echo ""

# Track installation status
FAILED=()

# Run CLI tools installation
log_info "[1/4] Installing CLI Tools..."
if bash "$SCRIPT_DIR/install-cli-tools.sh"; then
    log_success "CLI Tools installation completed"
else
    log_error "CLI Tools installation failed"
    FAILED+=("CLI Tools")
fi

echo ""

# Run development tools installation
log_info "[2/4] Installing Development Tools..."
if bash "$SCRIPT_DIR/install-dev-tools.sh"; then
    log_success "Development Tools installation completed"
else
    log_error "Development Tools installation failed"
    FAILED+=("Development Tools")
fi

echo ""

# Run GUI applications installation
log_info "[3/4] Installing GUI Applications..."
if bash "$SCRIPT_DIR/install-gui-apps.sh"; then
    log_success "GUI Applications installation completed"
else
    log_error "GUI Applications installation failed"
    FAILED+=("GUI Applications")
fi

echo ""

# Run NPM global packages installation
log_info "[4/4] Installing NPM Global Packages..."
if bash "$SCRIPT_DIR/install-npm-globals.sh"; then
    log_success "NPM Global Packages installation completed"
else
    log_warning "NPM Global Packages installation failed (may need nvm setup first)"
    FAILED+=("NPM Global Packages")
fi

echo ""
echo "=========================================="
echo "  Installation Summary"
echo "=========================================="
echo ""

if [ ${#FAILED[@]} -eq 0 ]; then
    log_success "All installations completed successfully! 🎉"
else
    log_warning "Some installations failed:"
    for item in "${FAILED[@]}"; do
        echo "  - $item"
    done
    echo ""
    log_info "You may need to run individual scripts manually:"
    for item in "${FAILED[@]}"; do
        case "$item" in
            "CLI Tools")
                echo "  bash $SCRIPT_DIR/install-cli-tools.sh"
                ;;
            "Development Tools")
                echo "  bash $SCRIPT_DIR/install-dev-tools.sh"
                ;;
            "GUI Applications")
                echo "  bash $SCRIPT_DIR/install-gui-apps.sh"
                ;;
            "NPM Global Packages")
                echo "  bash $SCRIPT_DIR/install-npm-globals.sh"
                ;;
        esac
    done
fi

echo ""
log_info "Next steps:"
echo "  - Verify installations with: which <command>"
echo "  - Check npm globals with: npm list -g --depth=0"
echo "  - See REQUIRED_APPS.md for usage information"
echo ""
