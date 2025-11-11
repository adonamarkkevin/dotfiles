#!/bin/bash

# Verification Script for Dotfiles Setup
# Checks if all required tools and configurations are properly installed

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "=========================================="
echo "  Dotfiles Setup Verification"
echo "=========================================="
echo ""

MISSING=()
INSTALLED=()

# Function to check command
check_command() {
    local cmd=$1
    local name=${2:-$1}
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name"
        INSTALLED+=("$name")
        return 0
    else
        echo -e "${RED}✗${NC} $name ${YELLOW}(missing)${NC}"
        MISSING+=("$name")
        return 1
    fi
}

# Function to check file
check_file() {
    local file=$1
    local name=$2
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $name"
        INSTALLED+=("$name")
        return 0
    else
        echo -e "${RED}✗${NC} $name ${YELLOW}(missing)${NC}"
        MISSING+=("$name")
        return 1
    fi
}

# Function to check symlink
check_symlink() {
    local file=$1
    local name=$2
    if [ -L "$file" ]; then
        echo -e "${GREEN}✓${NC} $name ${BLUE}→ $(readlink $file)${NC}"
        INSTALLED+=("$name")
        return 0
    elif [ -e "$file" ]; then
        echo -e "${YELLOW}⚠${NC} $name ${YELLOW}(exists but not a symlink)${NC}"
        return 1
    else
        echo -e "${RED}✗${NC} $name ${YELLOW}(missing)${NC}"
        MISSING+=("$name")
        return 1
    fi
}

echo -e "${BLUE}[Core Tools]${NC}"
check_command zsh "zsh"
check_command git "git"
check_command stow "GNU Stow"
check_command nvim "Neovim"
check_command tmux "tmux"
echo ""

echo -e "${BLUE}[Shell Tools]${NC}"
check_command fzf "fzf"
check_command fd "fd"
check_command bat "bat"
check_command eza "eza"
check_command zoxide "zoxide"
check_command thefuck "thefuck"
check_command oh-my-posh "oh-my-posh"
echo ""

echo -e "${BLUE}[Development Tools]${NC}"
check_command node "Node.js"
check_command npm "npm"
check_command nvm "nvm"
check_command go "Go"
echo ""

echo -e "${BLUE}[Hyprland Components]${NC}"
check_command hyprland "Hyprland"
check_command waybar "Waybar"
check_command wofi "Wofi"
check_command kitty "Kitty"
check_command grim "grim (screenshots)"
check_command slurp "slurp (screenshots)"
check_command wl-copy "wl-clipboard"
check_command swaylock "swaylock"
check_command hypridle "hypridle"
echo ""

echo -e "${BLUE}[Configuration Files]${NC}"
check_file "$HOME/.oh-my-zsh/oh-my-zsh.sh" "Oh My Zsh"
check_file "$HOME/dotfiles/fzf-git/fzf-git.sh" "fzf-git.sh"
check_file "$HOME/.config/ohmyposh/zen.toml" "oh-my-posh theme"
check_file "$HOME/.nvm/nvm.sh" "NVM script"
echo ""

echo -e "${BLUE}[Symlinks (Stow)]${NC}"
check_symlink "$HOME/.zshrc" ".zshrc"
check_symlink "$HOME/.gitconfig" ".gitconfig"
check_symlink "$HOME/.config/hypr/hyprland.conf" "hyprland.conf"
check_symlink "$HOME/.config/kitty/kitty.conf" "kitty.conf"
check_symlink "$HOME/.config/nvim" "nvim config"
check_symlink "$HOME/.config/tmux/tmux.conf" "tmux.conf"
echo ""

echo -e "${BLUE}[Shell Configuration]${NC}"
if [ "$SHELL" = "$(which zsh)" ] || [ "$SHELL" = "/usr/bin/zsh" ] || [ "$SHELL" = "/bin/zsh" ]; then
    echo -e "${GREEN}✓${NC} Default shell is zsh"
else
    echo -e "${YELLOW}⚠${NC} Default shell is $SHELL (not zsh)"
    echo -e "  ${YELLOW}Run:${NC} chsh -s /usr/bin/zsh"
fi
echo ""

# Summary
echo "=========================================="
echo "  Summary"
echo "=========================================="
echo -e "${GREEN}Installed:${NC} ${#INSTALLED[@]} items"
echo -e "${RED}Missing:${NC} ${#MISSING[@]} items"
echo ""

if [ ${#MISSING[@]} -gt 0 ]; then
    echo -e "${YELLOW}Missing items:${NC}"
    printf '  - %s\n' "${MISSING[@]}"
    echo ""
    echo -e "${BLUE}To fix missing items:${NC}"
    echo "  1. Run the installation script: ./install-hyprland.sh"
    echo "  2. Or install manually:"
    echo "     - Packages: sudo pacman -S <package>"
    echo "     - oh-my-posh: curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin"
    echo "     - fzf-git: cd ~/dotfiles && git submodule update --init --recursive"
    echo ""
else
    echo -e "${GREEN}✓ Everything looks good!${NC}"
    echo ""
fi

# Check if running in zsh
if [ -n "$ZSH_VERSION" ]; then
    echo -e "${GREEN}✓${NC} Currently running in zsh"
elif [ -n "$BASH_VERSION" ]; then
    echo -e "${YELLOW}⚠${NC} Currently running in bash. Start zsh with: ${BLUE}zsh${NC}"
fi

echo ""
