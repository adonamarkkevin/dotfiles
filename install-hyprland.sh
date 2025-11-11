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

# Optional but recommended
OPTIONAL_PACKAGES=(
    "swayidle"
    "swaylock-effects"
    "polkit-gnome"
)

# Development tools
DEV_PACKAGES=(
    "git"
    "stow"
    "nvm"
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
    "${OPTIONAL_PACKAGES[@]}"
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

    read -p "Do you want to install these packages? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Installing packages..."
        sudo pacman -S --needed "${MISSING_PACKAGES[@]}"
        log_success "Packages installed successfully"
    else
        log_warning "Skipping package installation. Some features may not work."
    fi
else
    log_success "All required packages are already installed"
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
# BACKUP EXISTING CONFIGS
# ============================================================================

log_info "Backing up existing configurations..."

BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# List of config directories to back up if they exist
CONFIG_DIRS=(
    ".config/hypr"
    ".config/waybar"
    ".config/wofi"
    ".config/kitty"
    ".config/nvim"
    ".config/tmux"
    ".config/ohmyposh"
)

# List of home directory files to back up
HOME_FILES=(
    ".zshrc"
    ".gitconfig"
    ".gitignore_global"
)

# Backup config directories
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -e "$HOME/$dir" ] && [ ! -L "$HOME/$dir" ]; then
        log_info "Backing up $dir..."
        mkdir -p "$BACKUP_DIR/$(dirname $dir)"
        cp -r "$HOME/$dir" "$BACKUP_DIR/$dir"
        rm -rf "$HOME/$dir"
        log_success "Backed up $dir to $BACKUP_DIR"
    fi
done

# Backup home files
for file in "${HOME_FILES[@]}"; do
    if [ -e "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        log_info "Backing up $file..."
        cp "$HOME/$file" "$BACKUP_DIR/$file"
        rm -f "$HOME/$file"
        log_success "Backed up $file to $BACKUP_DIR"
    fi
done

if [ "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
    log_success "Backups created in: $BACKUP_DIR"
else
    log_info "No existing configs to backup"
    rmdir "$BACKUP_DIR"
fi

# ============================================================================
# STOW CONFIGURATION
# ============================================================================

log_info "Setting up dotfiles with GNU Stow..."

# Get the script's directory (dotfiles repo root)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

log_info "Dotfiles directory: $DOTFILES_DIR"

# Create .stow-local-ignore file to exclude i3-specific files
cat > .stow-local-ignore << 'EOF'
# Ignore i3-specific configurations
\.config/i3
\.config/polybar

# Ignore alacritty (using kitty instead)
\.config/alacritty

# Ignore installation scripts
install-hyprland\.sh
install\.sh

# Ignore git files
\.git
\.gitignore
\.gitmodules

# Ignore documentation
README\.md
.*\.md$

# Ignore other files
swap_trackball_btn\.sh
EOF

log_success "Created .stow-local-ignore (excluding i3, polybar, alacritty)"

# Stow the dotfiles
log_info "Running stow to create symlinks..."

# First, unstow any existing links to avoid conflicts
stow -D . 2>/dev/null || true

# Now stow everything except what's in .stow-local-ignore
if stow -v -t "$HOME" .; then
    log_success "Dotfiles symlinked successfully!"
else
    log_error "Failed to stow dotfiles. Please check for conflicts."
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
fi

# Install oh-my-posh if not present
if ! command -v oh-my-posh &> /dev/null; then
    log_info "Installing oh-my-posh..."
    curl -s https://ohmyposh.dev/install.sh | bash -s
    log_success "oh-my-posh installed"
else
    log_success "oh-my-posh already installed"
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    log_info "Setting zsh as default shell..."
    chsh -s $(which zsh)
    log_success "Default shell changed to zsh (takes effect on next login)"
else
    log_success "Zsh is already the default shell"
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
