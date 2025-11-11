# Wofi Configuration

Native Wayland application launcher for Hyprland, replacing Rofi from i3.

## Features

- **Fast and lightweight** - Native Wayland, no X11 compatibility layer needed
- **Fuzzy matching** - Type partial words to find apps (e.g., "chro" finds Chrome)
- **Application icons** - Shows app icons at 32px size
- **Centered display** - Appears in center of screen
- **Kanagawa themed** - Matches your color scheme

## Keybindings

Your existing i3 keybindings now open wofi:

- **$mod + D** - Application launcher (drun mode)
- **$mod + Space** - Command runner (run mode)
- **$mod + Shift + Tab** - Window switcher (window mode)

### Within Wofi:

- **Type** - Search/filter applications
- **Arrow keys / j/k** - Navigate up/down
- **Enter** - Launch selected application
- **Escape** - Close wofi
- **Tab** - Expand item (if applicable)

## Modes

### 1. Application Launcher (drun)
```bash
wofi --show drun
```
Shows installed desktop applications with icons and descriptions.

### 2. Command Runner (run)
```bash
wofi --show run
```
Run any command from your PATH.

### 3. Window Switcher (window)
```bash
wofi --show window
```
Switch between open windows across all workspaces.

### 4. dmenu mode (for scripts)
```bash
echo -e "Option 1\nOption 2\nOption 3" | wofi --dmenu
```
Used in scripts like the power menu.

## Configuration Files

- **`~/.config/wofi/config`** - Main settings (size, behavior, appearance)
- **`~/.config/wofi/style.css`** - Kanagawa color theme and styling

## Customization

### Change Size

Edit `~/.config/wofi/config`:
```ini
width=800      # Default is 600
height=500     # Default is 400
```

### Change Location

```ini
location=top       # top, bottom, center, topleft, topright, etc.
```

### Change Icon Size

```ini
image_size=48      # Default is 32
```

### Disable Icons

```ini
allow_images=false
```

### Change Matching Algorithm

```ini
matching=contains  # or "fuzzy" (default), "normal"
```

### Adjust Number of Columns

```ini
columns=2          # Default is 1
```

## Color Scheme (Kanagawa)

Current theme uses:
- **Background**: Mountain Base (#1F1F28)
- **Input box**: Winter Night (#2A2A37)
- **Border**: River Gray (#717C7C)
- **Selected item**: Wave Blue (#7E9CD8)
- **Active selection**: Autumn Yellow (#E6C384)
- **Text**: Fuji White (#DCD7BA)

### Custom Colors

Edit `~/.config/wofi/style.css` to change colors. Example:
```css
#entry:selected:focus {
    border-left: 3px solid #YOUR_COLOR;
    color: #YOUR_COLOR;
}
```

## Usage Examples

### Launch specific application
```bash
wofi --show drun --term kitty
```

### Search for text
```bash
wofi --show drun --search "firefox"
```

### Custom prompt text
```bash
echo -e "Yes\nNo" | wofi --dmenu -p "Confirm?"
```

### Custom width/height for dmenu
```bash
echo -e "Option 1\nOption 2" | wofi --dmenu --width 300 --height 150
```

## Troubleshooting

### Wofi doesn't show icons
Make sure you have icon themes installed:
```bash
sudo pacman -S papirus-icon-theme
```

### Applications don't launch
Check that the application is installed and has a .desktop file:
```bash
ls /usr/share/applications/
```

### Wofi appears on wrong monitor
If you have multiple monitors, wofi appears on the currently focused one. To force a specific monitor, you might need to use Hyprland's monitor workspace assignment.

### Styling doesn't apply
After changing `style.css`, wofi doesn't auto-reload. Close and reopen it:
```bash
pkill wofi
wofi --show drun
```

### Font doesn't look right
Make sure your Nerd Font is installed and cached:
```bash
fc-cache -fv
fc-list | grep -i jetbrains
```

## Comparison with Rofi

### What's the same:
✅ Fuzzy search
✅ Application launching
✅ Window switching
✅ dmenu mode for scripts
✅ Keyboard navigation

### What's different:
- **Simpler** - Fewer features, more focused
- **Native Wayland** - Better performance, no compatibility layer
- **CSS styling** - Instead of Rasi themes
- **Fewer modes** - No ssh, file browser, etc.
- **No custom modi** - Can't add custom modes like rofi-calc

### If you miss rofi features:
You can still install `rofi-wayland` alongside wofi and use both:
```bash
sudo pacman -S rofi-wayland
```

Then use rofi for specific tasks:
```bash
# Use wofi for most things (default keybindings)
# Use rofi for advanced features
rofi -show ssh
rofi -modi calc -show calc
```

## Package Installation

```bash
sudo pacman -S wofi
```

## Additional Resources

- [Wofi Documentation](https://hg.sr.ht/~scoopta/wofi)
- [Wofi Man Page](https://man.archlinux.org/man/wofi.1)
- Custom themes: Check out [Wofi Themes Collection](https://github.com/topics/wofi-theme)

## Tips

1. **Frequent apps** - Wofi learns which apps you use most and prioritizes them
2. **Quick launch** - Just type the first few letters and hit Enter
3. **Case insensitive** - Search is case-insensitive by default
4. **No cache issues** - Wofi automatically updates when you install new apps
