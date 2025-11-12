# Required Applications & Tools

Essential tools and applications for system setup, organized by category.

---

## 🛠️ CLI Tools

### Modern CLI Replacements
- `htop` - Interactive process viewer (replaces top)
- `eza` - Modern ls with icons and colors
- `fd` - Fast find alternative
- `ripgrep` (rg) - Fast grep alternative
- `zoxide` (z) - Smart cd replacement
- `bat` - Cat with syntax highlighting

### Essential CLI Utilities
- `fzf` - Fuzzy finder
- `jq` - JSON processor
- `curl` - Data transfer tool
- `wget` - File downloader
- `tree` - Directory tree viewer
- `neofetch` - System information display
- `tmux` - Terminal multiplexer
- `rsync` - File synchronization
- `unzip` - ZIP archive extractor
- `tar` - Archive tool
- `7z` - 7-Zip compression
- `thefuck` - Command correction tool

---

## 💻 Development Tools

### Programming Languages & Runtimes
- `Node.js` - JavaScript runtime (v22.21.1 via nvm)
  - Multiple versions available: v16.20.2, v18.20.4, v20.17.0, v21.5.0, v22.7.0, v22.21.1
- `npm` - Node package manager
- `Python` - Python language
- `pip` - Python package manager
- `Go` - Go language
- `Java` - OpenJDK

### Build Tools & Compilers
- `make` - GNU Make
- `gcc` - GNU Compiler Collection
- `clang` - LLVM C/C++ compiler
- `yarn` - Package manager

### Version Control
- `Git` - Version control system

---

## 🔊 Audio System

### PipeWire (Modern Audio Server)
- `pipewire` - Core PipeWire multimedia framework
- `pipewire-pulse` - PulseAudio replacement/compatibility
- `pipewire-alsa` - ALSA compatibility
- `pipewire-jack` - JACK audio compatibility
- `wireplumber` - PipeWire session manager

**Installation:**
```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
```

**Enable services:**
```bash
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service
```

**Notes:**
- PipeWire provides full PulseAudio compatibility - all `pactl` commands work
- Volume controls in Hyprland and Waybar use `pactl` (works seamlessly)
- Better performance and lower latency than PulseAudio
- Required for Wayland/Hyprland setups

---

## 🎨 GUI Applications

### Media & Creative
- `gimp` - Image editor
- `obs-studio` - Streaming and recording

### Productivity
- `obsidian` - Knowledge base and note-taking

---

## 📦 NPM Global Packages

```
@anthropic-ai/claude-code@2.0.35
corepack@0.34.0
npm@10.9.4
yarn@1.22.22
```

### Installation Command
```bash
npm install -g @anthropic-ai/claude-code corepack yarn
```

---

## 📝 Installation Notes

### CLI Tools Installation
```bash
sudo pacman -S htop eza fd ripgrep zoxide bat fzf jq curl wget tree \
               neofetch tmux rsync unzip tar p7zip thefuck
```

### Development Tools Installation
```bash
# Base development
sudo pacman -S base-devel git

# Languages (Python and Go from official repos)
sudo pacman -S python python-pip go jdk-openjdk

# Node.js via NVM (already in dotfiles setup)
# nvm install 22
# nvm use 22
```

### GUI Applications Installation
```bash
sudo pacman -S gimp obs-studio obsidian
```

### NPM Global Packages Installation
```bash
npm install -g @anthropic-ai/claude-code corepack yarn
```

---

## 🔄 Quick Setup on New Machine

```bash
# 1. Install CLI tools
sudo pacman -S --needed htop eza fd ripgrep zoxide bat fzf jq curl wget \
                        tree neofetch tmux rsync unzip tar p7zip thefuck

# 2. Install development tools
sudo pacman -S --needed base-devel git python python-pip go jdk-openjdk

# 3. Install PipeWire audio system
sudo pacman -S --needed pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service

# 4. Install GUI applications
sudo pacman -S --needed gimp obs-studio obsidian

# 5. Setup Node.js (via nvm from dotfiles)
nvm install 22
nvm use 22

# 6. Install npm global packages
npm install -g @anthropic-ai/claude-code corepack yarn
```

---

**Last Updated**: 2025-11-13
