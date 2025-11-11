# Hyprland Migration Notes

## Required Packages

Install these packages on your new laptop with Arch Linux:

```bash
# Core Hyprland packages
sudo pacman -S hyprland hyprpaper waybar wofi

# Screenshot tools (Wayland replacements for maim)
sudo pacman -S grim slurp wl-clipboard

# Idle management and screen locking
sudo pacman -S hypridle swaylock

# Optional: Enhanced lock screen (AUR)
yay -S swaylock-effects

# Additional utilities
sudo pacman -S brightnessctl networkmanager network-manager-applet polkit-gnome
```

## Key Differences from i3

### What Changed:

1. **Screenshots**
   - **Old (X11)**: `maim` + `xclip`
   - **New (Wayland)**: `grim` + `slurp` + `wl-clipboard`
   - All screenshot keybindings already updated in the config

2. **Status Bar**
   - **Old**: Polybar
   - **New**: Waybar
   - You'll need to create a waybar config (see below)

3. **Compositor**
   - **Old**: Picom (separate process)
   - **New**: Built into Hyprland (no need for picom)

4. **Wallpaper**
   - **Old**: `feh` (X11)
   - **New**: `hyprpaper` (configured and ready to use)
   - Config at `~/.config/hypr/hyprpaper.conf`
   - See `HYPRPAPER_README.md` for details

5. **Screen Locking & Idle Management**
   - **Old**: `i3lock` + `xss-lock` (X11)
   - **New**: `swaylock` + `hypridle` (Wayland)
   - Config at `~/.config/hypr/hypridle.conf` and `~/.config/hypr/swaylock.conf`
   - Auto-locks after 10 minutes, dims at 5 minutes, screen off at 15 minutes

### What Stays the Same:

✅ All your keybindings (hjkl navigation, workspaces, etc.)
✅ Your terminal (Kitty works perfectly on Wayland)
✅ Rofi (just install `rofi-wayland` instead)
✅ Neovim, Tmux, Zsh configurations (100% compatible)
✅ Git, password-store, all CLI tools
✅ Gaps configuration (10 inner, 30 outer)
✅ Your Kanagawa color scheme

## Setup Steps on New Laptop

1. **Install packages** (see above)

2. **Clone your dotfiles**
   ```bash
   git clone --recurse-submodules https://github.com/adonamarkkevin/dotfiles.git
   cd dotfiles
   ```

3. **Use GNU Stow to symlink configs**
   ```bash
   stow .
   ```

4. **Make autostart script executable**
   ```bash
   chmod +x ~/.config/hypr/autostart.sh
   ```

5. **Create Waybar config** (see waybar section below)

6. **Configure hyprpaper for your monitors**
   - Run `hyprctl monitors` to see your monitor names
   - Edit `~/.config/hypr/hyprpaper.conf` to match your monitor names
   - See `HYPRPAPER_README.md` for detailed instructions

7. **Update lock screen script**
   - Edit `~/.config/i3/lock_screen.sh`
   - Replace `i3lock` with `swaylock`

## Waybar Configuration

Create a basic waybar config at `~/.config/waybar/config`:

```json
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": [],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "clock"],

    "hyprland/workspaces": {
        "format": "{id}",
        "on-click": "activate"
    },

    "clock": {
        "format": "{:%H:%M | %y.%m.%d}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
    },

    "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""]
    },

    "network": {
        "format-wifi": "{essid} ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "format-disconnected": "Disconnected ⚠"
    },

    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-muted": "🔇",
        "format-icons": {
            "default": ["🔈", "🔉", "🔊"]
        },
        "on-click": "pavucontrol"
    }
}
```

And style at `~/.config/waybar/style.css`:

```css
* {
    font-family: "JetBrainsMonoML Nerd Font";
    font-size: 14px;
}

window#waybar {
    background-color: rgba(26, 26, 37, 0.95);
    color: #DCD7BA;
}

#workspaces button {
    padding: 0 10px;
    color: #717C7C;
}

#workspaces button.active {
    color: #E6C384;
}

#clock, #battery, #cpu, #memory, #network, #pulseaudio {
    padding: 0 10px;
    color: #DCD7BA;
}
```

## Monitor Configuration

In `hyprland.conf`, update the monitor line based on your setup:

```bash
# For single monitor
monitor=,preferred,auto,1

# For dual monitors (example - adjust based on your monitors)
monitor=DP-1,1920x1080@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1

# To find your monitor names, run:
hyprctl monitors
```

## Workspace to Monitor Binding

If you want specific workspaces on specific monitors (like your current 1-9 on monitor 1, 11-19 on monitor 2):

```bash
# Add to hyprland.conf
workspace = 1, monitor:DP-1
workspace = 2, monitor:DP-1
workspace = 3, monitor:DP-1
# ... (4-9)

workspace = 11, monitor:HDMI-A-1
workspace = 12, monitor:HDMI-A-1
# ... (13-19)
```

## Testing Before Full Migration

You can test Hyprland on your current system:
```bash
# Install Hyprland
sudo pacman -S hyprland

# Log out of i3
# Select Hyprland from your display manager
```

Your i3 config will remain untouched, and you can switch back anytime.

## Troubleshooting

### If applications don't start on the right workspace:
- Check window class with: `hyprctl clients`
- Update the `windowrulev2` lines in `hyprland.conf`

### If keybindings don't work:
- Check for conflicts with: `hyprctl binds`
- Test individual binds from terminal: `hyprctl dispatch exec kitty`

### If monitors aren't detected:
- Run `hyprctl monitors` to see detected monitors
- Update the `monitor=` lines accordingly

## Additional Resources

- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Awesome Hyprland](https://github.com/hyprland-community/awesome-hyprland) - Collection of themes and configs
