#!/bin/bash

# Hyprland Installation Script
# Installs all required packages and sets up dotfiles using GNU Stow
# This script backs up existing configs and excludes i3-specific files

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

log_info "Starting Hyprland installation and configuration..."

# ============================================================================
# PACKAGE INSTALLATION
# ============================================================================

log_info "Checking and installing required packages..."

# Core Hyprland packages
CORE_PACKAGES=(
    "hyprland"
    "hyprpaper"
    "waybar"
    "wofi"
    "kitty"
)

# Screenshot and clipboard tools
SCREENSHOT_PACKAGES=(
    "grim"
    "slurp"
    "wl-clipboard"
)

# Utilities
UTILITY_PACKAGES=(
    "brightnessctl"
    "networkmanager"
    "network-manager-applet"
    "pavucontrol"
    "htop"
)

# Idle and lock screen
IDLE_LOCK_PACKAGES=(
    "hypridle"
    "swaylock"
    "polkit-gnome"
)

# Development tools
DEV_PACKAGES=(
    "git"
    "stow"
)

# Terminal and shell
SHELL_PACKAGES=(
    "zsh"
    "oh-my-zsh"  # Note: oh-my-zsh is installed via script, not pacman
    "fzf"
    "fd"
    "bat"
    "eza"
    "zoxide"
    "thefuck"
)

# Combine all packages
ALL_PACKAGES=(
    "${CORE_PACKAGES[@]}"
    "${SCREENSHOT_PACKAGES[@]}"
    "${UTILITY_PACKAGES[@]}"
    "${IDLE_LOCK_PACKAGES[@]}"
    "${DEV_PACKAGES[@]}"
    "zsh"
    "fzf"
    "fd"
    "bat"
    "eza"
    "zoxide"
    "thefuck"
)

# Check which packages are missing
MISSING_PACKAGES=()
for package in "${ALL_PACKAGES[@]}"; do
    if ! pacman -Qi "$package" &> /dev/null; then
        MISSING_PACKAGES+=("$package")
    fi
done

# Install missing packages
if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    log_info "The following packages need to be installed:"
    printf '%s\n' "${MISSING_PACKAGES[@]}" | sed 's/^/  - /'
    echo ""

    read -p "Do you want to install these packages? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installing packages..."
        if sudo pacman -S --needed --noconfirm "${MISSING_PACKAGES[@]}"; then
            log_success "Packages installed successfully"

            # Verify critical packages are installed
            log_info "Verifying critical packages..."
            CRITICAL_PACKAGES=("hyprland" "waybar" "wofi" "kitty" "zsh" "git" "stow")
            MISSING_CRITICAL=()

            for pkg in "${CRITICAL_PACKAGES[@]}"; do
                if ! pacman -Qi "$pkg" &> /dev/null; then
                    MISSING_CRITICAL+=("$pkg")
                fi
            done

            if [ ${#MISSING_CRITICAL[@]} -gt 0 ]; then
                log_error "Critical packages failed to install: ${MISSING_CRITICAL[*]}"
                log_error "Please try installing them manually: sudo pacman -S ${MISSING_CRITICAL[*]}"
                exit 1
            else
                log_success "All critical packages verified"
            fi
        else
            log_error "Package installation failed. Please check the errors above."
            exit 1
        fi
    else
        log_warning "Skipping package installation. Some features may not work."
        log_warning "The script will likely fail. Press Ctrl+C to cancel or Enter to continue anyway."
        read
    fi
else
    log_success "All required packages are already installed"
fi

# ============================================================================
# ZSH INSTALLATION (Must be before Oh My Zsh)
# ============================================================================

if ! command -v zsh &> /dev/null; then
    log_info "Installing zsh..."
    sudo pacman -S --needed --noconfirm zsh
    log_success "Zsh installed"
else
    log_success "Zsh already installed"
fi

# ============================================================================
# OH-MY-ZSH INSTALLATION
# ============================================================================

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log_success "Oh My Zsh installed"
else
    log_success "Oh My Zsh already installed"
fi

# ============================================================================
# NVM INSTALLATION
# ============================================================================

if [ ! -d "$HOME/.nvm" ]; then
    log_info "Installing NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # Source nvm for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    log_success "NVM installed"
else
    log_success "NVM already installed"
    # Source nvm for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install Node.js via NVM
if command -v nvm &> /dev/null; then
    log_info "Installing Node.js v22 via NVM..."
    nvm install 22
    nvm use 22
    nvm alias default 22
    log_success "Node.js v22 installed and set as default"
else
    log_warning "NVM not available in current session. Please restart shell and run: nvm install 22"
fi

# ============================================================================
# AUR PACKAGES (OPTIONAL)
# ============================================================================

log_info "Checking for AUR helper (yay)..."

if command -v yay &> /dev/null; then
    log_info "AUR helper found. Do you want to install swaylock-effects (enhanced lock screen)?"
    read -p "Install swaylock-effects from AUR? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installing swaylock-effects from AUR..."
        yay -S --needed --noconfirm swaylock-effects
        log_success "swaylock-effects installed"
    else
        log_info "Skipping swaylock-effects (using regular swaylock)"
    fi
else
    log_warning "AUR helper (yay) not found. Using regular swaylock instead of swaylock-effects"
    log_info "To install swaylock-effects later, run: yay -S swaylock-effects"
fi

# ============================================================================
# STOW CONFIGURATION
# ============================================================================

log_info "Setting up dotfiles with GNU Stow..."

# Get the script's directory (dotfiles repo root)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run the separate stow script
if bash "$DOTFILES_DIR/stow-dotfiles.sh"; then
    log_success "Dotfiles setup complete!"
else
    log_error "Stow script failed. You can run it separately:"
    echo "  cd $DOTFILES_DIR"
    echo "  ./stow-dotfiles.sh"
    exit 1
fi

# ============================================================================
# POST-INSTALLATION SETUP
# ============================================================================

log_info "Running post-installation setup..."

# Make scripts executable
log_info "Making scripts executable..."
chmod +x "$HOME/.config/hypr/autostart.sh" 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/power-menu.sh" 2>/dev/null || true
chmod +x "$HOME/swap_trackball_btn.sh" 2>/dev/null || true
log_success "Scripts made executable"

# Initialize git submodules if needed
if [ -d "$DOTFILES_DIR/.git" ]; then
    log_info "Updating git submodules..."
    cd "$DOTFILES_DIR"
    git submodule update --init --recursive
    log_success "Git submodules updated"

    # Verify critical submodules
    if [ ! -f "$DOTFILES_DIR/fzf-git/fzf-git.sh" ]; then
        log_warning "fzf-git.sh not found, attempting to fix..."
        git submodule update --init --recursive --force
        if [ -f "$DOTFILES_DIR/fzf-git/fzf-git.sh" ]; then
            log_success "fzf-git.sh submodule initialized"
        else
            log_error "Failed to initialize fzf-git submodule"
            log_info "You may need to clone it manually:"
            echo "  cd ~/dotfiles && git submodule update --init --recursive"
        fi
    else
        log_success "fzf-git.sh submodule verified"
    fi
else
    log_warning "Not a git repository. Submodules not initialized."
    log_info "If you cloned without --recurse-submodules, run:"
    echo "  cd ~/dotfiles && git submodule update --init --recursive"
fi

# Install oh-my-posh if not present
if ! command -v oh-my-posh &> /dev/null; then
    log_info "Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin

    # Add to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"

    if command -v oh-my-posh &> /dev/null; then
        log_success "oh-my-posh installed to ~/.local/bin"
    else
        log_error "oh-my-posh installation failed"
        log_info "You can install it manually later: curl -s https://ohmyposh.dev/install.sh | bash -s"
    fi
else
    log_success "oh-my-posh already installed"
fi

# Set zsh as default shell if not already
if command -v zsh &> /dev/null; then
    ZSH_PATH=$(which zsh)
    if [ "$SHELL" != "$ZSH_PATH" ]; then
        log_info "Setting zsh as default shell..."
        chsh -s "$ZSH_PATH"
        log_success "Default shell changed to zsh (takes effect on next login)"
    else
        log_success "Zsh is already the default shell"
    fi
else
    log_warning "Zsh not found. Please install zsh first: sudo pacman -S zsh"
fi

# ============================================================================
# MONITOR CONFIGURATION REMINDER
# ============================================================================

log_warning "IMPORTANT: Monitor configuration needed!"
echo ""
log_info "After first login to Hyprland, run these commands:"
echo "  1. Find your monitor names:"
echo "     hyprctl monitors"
echo ""
echo "  2. Edit hyprpaper config to match your monitors:"
echo "     nvim ~/.config/hypr/hyprpaper.conf"
echo ""
echo "  3. Reload hyprpaper:"
echo "     killall hyprpaper && hyprpaper &"
echo ""
log_info "See ~/.config/hypr/HYPRPAPER_README.md for detailed instructions"

# ============================================================================
# FINAL SUMMARY
# ============================================================================

echo ""
log_success "============================================"
log_success "  Hyprland Installation Complete!"
log_success "============================================"
echo ""
log_info "Next steps:"
echo "  1. Log out of your current session"
echo "  2. Select 'Hyprland' from your display manager"
echo "  3. Log in"
echo "  4. Configure monitors (see warning above)"
echo ""
log_info "Key shortcuts (same as i3):"
echo "  - Super + T           : Open terminal"
echo "  - Super + D           : Application launcher"
echo "  - Super + Space       : Command runner"
echo "  - Super + Shift + Q   : Close window"
echo "  - Super + H/J/K/L     : Navigate windows"
echo "  - Super + 1-9         : Switch workspaces"
echo "  - Super + Escape      : Lock screen"
echo "  - Print               : Screenshot"
echo ""
log_info "Configuration files:"
echo "  - Hyprland  : ~/.config/hypr/hyprland.conf"
echo "  - Waybar    : ~/.config/waybar/config"
echo "  - Wofi      : ~/.config/wofi/config"
echo "  - Hyprpaper : ~/.config/hypr/hyprpaper.conf"
echo "  - Kitty     : ~/.config/kitty/kitty.conf"
echo ""
log_info "Documentation:"
echo "  - Migration guide     : ~/.config/hypr/MIGRATION_NOTES.md"
echo "  - Waybar guide        : ~/.config/waybar/README.md"
echo "  - Wofi guide          : ~/.config/wofi/README.md"
echo "  - Hyprpaper guide     : ~/.config/hypr/HYPRPAPER_README.md"
echo ""
if [ -d "$BACKUP_DIR" ]; then
    log_info "Your old configs are backed up in: $BACKUP_DIR"
fi
echo ""
log_success "Enjoy your new Hyprland setup! 🚀"
