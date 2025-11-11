# Hyprpaper - Wallpaper Manager

Official wallpaper utility for Hyprland, replaces `feh` from your i3 setup.

## Installation

```bash
sudo pacman -S hyprpaper
```

## How It Works

Hyprpaper is automatically started by `autostart.sh` and reads its configuration from `~/.config/hypr/hyprpaper.conf`.

## Configuration File

Located at: `~/.config/hypr/hyprpaper.conf`

### Basic Structure

```conf
# 1. Preload wallpapers into memory (faster switching)
preload = /path/to/wallpaper.png

# 2. Assign wallpapers to monitors
wallpaper = MONITOR_NAME,/path/to/wallpaper.png
```

## Finding Your Monitor Names

Run this command while in Hyprland:
```bash
hyprctl monitors
```

Output example:
```
Monitor DP-1 (ID 0):
    1920x1080@144Hz at 0x0
    ...

Monitor eDP-1 (ID 1):
    1920x1080@60Hz at 1920x0
    ...
```

The monitor names are: `DP-1` and `eDP-1`

## Your Current Setup

You have two wallpapers based on hostname:
- **Desktop (archlinux)**: 1440p cyberpunk city
- **Laptop (archbtw)**: 1080p cyberpunk city

### Option 1: Configure Per Monitor (Recommended)

Edit `hyprpaper.conf` after finding your monitor names:

```conf
preload = ~/backgrounds/1440p-cyberpunk-city.png
preload = ~/backgrounds/1080p-cyberpunk-city.png

# Desktop monitors (usually DP-x or HDMI-A-x)
wallpaper = DP-1,~/backgrounds/1440p-cyberpunk-city.png
wallpaper = DP-2,~/backgrounds/1440p-cyberpunk-city.png

# Laptop monitor (usually eDP-1)
wallpaper = eDP-1,~/backgrounds/1080p-cyberpunk-city.png
```

### Option 2: Same Wallpaper on All Monitors

```conf
preload = ~/backgrounds/1440p-cyberpunk-city.png
wallpaper = ,~/backgrounds/1440p-cyberpunk-city.png  # Note the comma before path
```

## Changing Wallpapers

### Method 1: Edit Config and Reload

1. Edit `~/.config/hypr/hyprpaper.conf`
2. Kill and restart hyprpaper:
   ```bash
   killall hyprpaper && hyprpaper &
   ```

### Method 2: Using IPC (Dynamic Changes)

Enable IPC in config:
```conf
ipc = on
```

Then use hyprctl:
```bash
# Preload new wallpaper
hyprctl hyprpaper preload ~/backgrounds/new-wallpaper.png

# Set it on a monitor
hyprctl hyprpaper wallpaper "DP-1,~/backgrounds/new-wallpaper.png"

# Unload old wallpaper from memory
hyprctl hyprpaper unload ~/backgrounds/old-wallpaper.png
```

## Supported Formats

- PNG
- JPEG
- WebP
- BMP

## Troubleshooting

### Wallpaper doesn't show

1. **Check monitor names**:
   ```bash
   hyprctl monitors
   ```

2. **Check file paths are correct**:
   ```bash
   ls ~/backgrounds/
   ```

3. **Check hyprpaper is running**:
   ```bash
   ps aux | grep hyprpaper
   ```

4. **Check logs**:
   ```bash
   killall hyprpaper
   hyprpaper  # Run in foreground to see errors
   ```

### Wrong wallpaper on monitor

Update the monitor name in `hyprpaper.conf` to match output from `hyprctl monitors`.

### Wallpaper looks blurry/stretched

Make sure you're using the correct resolution wallpaper for each monitor. Check monitor resolution:
```bash
hyprctl monitors | grep -A 1 "Monitor"
```

### Performance issues

- Only preload wallpapers you're actually using
- Use compressed formats (JPEG/WebP instead of PNG for photos)
- Reduce wallpaper resolution if needed

## Performance Notes

- **Preloading**: Loads images into RAM for instant switching
- **Memory usage**: ~10-50MB depending on image count/size
- **CPU usage**: Minimal after initial load
- **Better than feh**: Native Wayland, no X11 overhead

## Alternative: swww

If you want animated wallpapers or transitions:

```bash
sudo pacman -S swww

# Start daemon
swww init

# Set wallpaper
swww img ~/backgrounds/wallpaper.png

# With transition
swww img ~/backgrounds/wallpaper.png --transition-type wipe --transition-angle 30
```

But for static wallpapers like yours, hyprpaper is simpler and more efficient.

## Your Migration Checklist

On new laptop:

1. ✅ Install hyprpaper: `sudo pacman -S hyprpaper`
2. ✅ Configuration already created in `~/.config/hypr/hyprpaper.conf`
3. ✅ Autostart already configured in `autostart.sh`
4. ⚠️ Find your monitor names: `hyprctl monitors`
5. ⚠️ Update `hyprpaper.conf` with your actual monitor names
6. ✅ Your wallpapers in `~/backgrounds/` will work automatically

## Quick Reference

```bash
# Find monitor names
hyprctl monitors

# Reload hyprpaper
killall hyprpaper && hyprpaper &

# Test in foreground (see errors)
killall hyprpaper && hyprpaper

# Check if running
pgrep hyprpaper
```
