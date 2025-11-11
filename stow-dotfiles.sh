#!/bin/bash

# Stow Dotfiles Script
# Backs up existing configs and creates symlinks using GNU Stow

set -e

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

echo ""
echo "=========================================="
echo "  Dotfiles Stow Setup"
echo "=========================================="
echo ""

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    log_error "GNU Stow is not installed. Please install it first:"
    echo "  sudo pacman -S stow"
    exit 1
fi

# Get the script's directory (dotfiles repo root)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

log_info "Dotfiles directory: $DOTFILES_DIR"
echo ""

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

# Backup and remove config directories
for dir in "${CONFIG_DIRS[@]}"; do
    if [ -e "$HOME/$dir" ]; then
        if [ -L "$HOME/$dir" ]; then
            # It's a symlink, just remove it
            log_info "Removing symlink: $dir"
            rm -f "$HOME/$dir"
        else
            # It's a real directory/file, back it up and remove
            log_info "Backing up and removing $dir..."
            mkdir -p "$BACKUP_DIR/$(dirname $dir)"
            cp -r "$HOME/$dir" "$BACKUP_DIR/$dir"
            rm -rf "$HOME/$dir"
            log_success "Backed up $dir to $BACKUP_DIR"
        fi
    fi
done

# Backup and remove home files
for file in "${HOME_FILES[@]}"; do
    if [ -e "$HOME/$file" ]; then
        if [ -L "$HOME/$file" ]; then
            # It's a symlink, just remove it
            log_info "Removing symlink: $file"
            rm -f "$HOME/$file"
        else
            # It's a real file, back it up and remove
            log_info "Backing up and removing $file..."
            cp "$HOME/$file" "$BACKUP_DIR/$file"
            rm -f "$HOME/$file"
            log_success "Backed up $file to $BACKUP_DIR"
        fi
    fi
done

if [ "$(ls -A $BACKUP_DIR 2>/dev/null)" ]; then
    log_success "Backups created in: $BACKUP_DIR"
else
    log_info "No existing configs to backup"
    rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

log_success "All existing configs removed - ready for stow"
echo ""

# ============================================================================
# CREATE STOW IGNORE FILE
# ============================================================================

log_info "Creating .stow-local-ignore file..."

cat > .stow-local-ignore << 'EOF'
# Ignore i3-specific configurations
\.config/i3
\.config/polybar

# Ignore alacritty (using kitty instead)
\.config/alacritty

# Ignore installation scripts
install-hyprland\.sh
install\.sh
stow-dotfiles\.sh

# Ignore scripts directory
scripts

# Ignore git files
\.git
\.gitignore
\.gitmodules

# Ignore documentation
README\.md
.*\.md$
CLAUDE\.md
REQUIRED_APPS\.md

# Ignore tmp directory
tmp

# Ignore other files
swap_trackball_btn\.sh
EOF

log_success "Created .stow-local-ignore (excluding i3, polybar, alacritty, scripts)"
echo ""

# ============================================================================
# STOW DOTFILES
# ============================================================================

log_info "Running GNU Stow to create symlinks..."

# First, unstow any existing links to avoid conflicts
log_info "Removing any existing stow symlinks..."
stow -D . 2>/dev/null || true

# Try to stow with verbose output
log_info "Creating symlinks with stow..."
if stow -v -t "$HOME" . 2>&1 | tee /tmp/stow-output.log; then
    log_success "Dotfiles symlinked successfully!"
else
    log_error "Failed to stow dotfiles. Checking for conflicts..."

    # Show the conflicts
    if grep -q "existing target is" /tmp/stow-output.log; then
        log_warning "Found existing files/directories that conflict:"
        grep "existing target is" /tmp/stow-output.log | head -10
        echo ""
        log_info "These files need to be removed or backed up manually."
        echo ""
        read -p "Do you want to force remove conflicting files and try again? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Extract conflicting paths and remove them
            grep "existing target is" /tmp/stow-output.log | sed 's/.*existing target is \(.*\) but.*/\1/' | while read file; do
                if [ -e "$HOME/$file" ]; then
                    log_warning "Removing: $HOME/$file"
                    rm -rf "$HOME/$file"
                fi
            done

            # Try stow again
            log_info "Retrying stow..."
            if stow -v -t "$HOME" .; then
                log_success "Dotfiles symlinked successfully!"
            else
                log_error "Stow still failed. Please check /tmp/stow-output.log for details"
                exit 1
            fi
        else
            log_error "Cannot continue without resolving conflicts"
            exit 1
        fi
    else
        log_error "Stow failed for unknown reason. Check /tmp/stow-output.log"
        exit 1
    fi
fi

echo ""

# ============================================================================
# VERIFY SYMLINKS
# ============================================================================

log_info "Verifying symlinks..."

VERIFY_PATHS=(
    ".config/hypr/hyprland.conf"
    ".config/waybar/config"
    ".config/wofi/config"
    ".config/kitty/kitty.conf"
    ".zshrc"
    ".gitconfig"
)

ALL_GOOD=true
for path in "${VERIFY_PATHS[@]}"; do
    if [ -L "$HOME/$path" ]; then
        log_success "✓ $path → $(readlink $HOME/$path)"
    elif [ -e "$HOME/$path" ]; then
        log_warning "⚠ $path exists but is not a symlink"
        ALL_GOOD=false
    else
        log_warning "✗ $path does not exist"
        ALL_GOOD=false
    fi
done

echo ""

if [ "$ALL_GOOD" = true ]; then
    log_success "All dotfiles symlinked correctly!"
else
    log_warning "Some symlinks may not be set up correctly. Check above for details."
fi

echo ""
log_info "Stow complete!"
echo ""
log_info "Note: Changes will take effect:"
echo "  - Hyprland: After restarting Hyprland"
echo "  - Zsh: After restarting your shell or running: source ~/.zshrc"
echo "  - Git: Immediately"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    log_info "Your old configs are backed up in: $BACKUP_DIR"
fi

echo ""
