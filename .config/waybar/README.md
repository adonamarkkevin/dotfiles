# Waybar Configuration

Modern status bar for Hyprland (Wayland compositor), replacing Polybar from i3.

## Features

### Interactive Modules

#### 🎵 Audio Control (Speaker)
- **Left click**: Open PulseAudio Volume Control (pavucontrol) on output tab
- **Right click**: Mute/unmute speaker
- **Scroll up/down**: Increase/decrease volume by 5%
- **Visual**: Shows volume percentage with icon
- **Colors**: Green when active, gray when muted

#### 🎤 Microphone Control
- **Left click**: Open PulseAudio Volume Control (pavucontrol) on input tab
- **Right click**: Mute/unmute microphone
- **Scroll up/down**: Increase/decrease mic volume by 5%
- **Visual**: Shows mic volume with icon
- **Colors**: Pink when active, gray when muted

#### 📡 Network
- **Left click**: Opens `nmtui` (NetworkManager Text User Interface) in Kitty terminal
- **Display**:
  - WiFi: Shows network name (ESSID) with WiFi icon
  - Ethernet: Shows IP address with ethernet icon
  - Disconnected: Shows warning icon
- **Tooltip**: Shows signal strength, IP, bandwidth usage

#### 🔆 Brightness
- **Scroll up/down**: Increase/decrease brightness by 5%
- **Visual**: Shows brightness percentage with sun icon

#### 🔋 Battery
- **Display**: Shows battery percentage with dynamic icon
- **Colors**:
  - Green: Normal
  - Yellow: Warning (< 30%)
  - Red + Blinking: Critical (< 15%)
- **Charging**: Shows bolt icon when plugged in
- **Tooltip**: Shows time remaining and power consumption

#### 🖥️ System Resources
- **CPU**: Click to open htop
- **Memory**: Click to open htop
- **Temperature**: Shows CPU/GPU temperature

#### ⏱️ Clock
- **Format**: HH:MM:SS (24-hour)
- **Click**: Toggle between time and date format
- **Tooltip**: Shows calendar with Kanagawa colors

#### 🚫 Idle Inhibitor
- **Click**: Toggle idle inhibition (prevents screen from sleeping)
- **Icons**:
  - 󰅶 = Active (screen won't sleep)
  - 󰾪 = Inactive (normal behavior)

#### ⏻ Power Menu
- **Click**: Opens power menu with options:
  - Shutdown
  - Suspend
  - Reboot
  - Lock screen
  - Logout

## Required Packages

```bash
# Essential
sudo pacman -S waybar pavucontrol networkmanager

# Optional but recommended
sudo pacman -S htop brightnessctl
```

## Color Scheme

Uses your Kanagawa theme colors:
- **Active workspace**: Autumn Yellow (#E6C384)
- **Network/CPU**: Wave Blue (#7E9CD8)
- **Speaker/Battery**: Tea Green (#98BB6C)
- **Microphone/Memory**: Sakura Pink (#D27E99)
- **Power/Urgent**: Samurai Red (#E46876)
- **Background**: Mountain Base (#1F1F28)
- **Text**: Fuji White (#DCD7BA)

## Layout

```
┌─────────────────────────────────────────────────────────────────────┐
│ [Workspaces] [Window Title]  [Clock]  [Tray] [󰾪] [🔊] [🎤] [📡] ... │
└─────────────────────────────────────────────────────────────────────┘
```

**Left**: Workspace numbers + active window title
**Center**: Clock with seconds
**Right**: System tray, idle inhibitor, audio, network, resources, battery, power

## Customization

### Change Position
Edit `~/.config/waybar/config`:
```json
"position": "bottom",  // or "top"
```

### Change Height
```json
"height": 30,  // Default is 34
```

### Hide Modules
Remove modules you don't want from the `modules-right`, `modules-left`, or `modules-center` arrays.

### Adjust Temperature Sensor
If temperature doesn't show, find your sensor:
```bash
ls /sys/class/hwmon/
cat /sys/class/hwmon/hwmon*/name
cat /sys/class/hwmon/hwmon*/temp*_label
```

Then update in config:
```json
"temperature": {
    "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
    ...
}
```

### Adjust Backlight Device
If brightness control doesn't work:
```bash
ls /sys/class/backlight/
```

Update in config:
```json
"backlight": {
    "device": "intel_backlight",  // or "amdgpu_bl0" or "nvidia_0"
    ...
}
```

## Network Manager TUI

When you click the network icon, `nmtui` opens with three options:
1. **Activate a connection**: Switch between WiFi networks
2. **Edit a connection**: Modify network settings
3. **Set system hostname**: Change your hostname

Use arrow keys and Enter to navigate.

## PulseAudio Volume Control (pavucontrol)

Opens when you click audio icons. Tabs:
- **Playback**: Control volume for each app
- **Recording**: Control which apps can use microphone
- **Output Devices**: Select speaker/headphones
- **Input Devices**: Select microphone
- **Configuration**: Audio device profiles

## Troubleshooting

### Waybar doesn't start
```bash
# Check for errors
waybar -l debug

# Kill and restart
killall waybar && waybar &
```

### Icons don't show
Install a Nerd Font (you already have JetBrainsMonoML Nerd Font):
```bash
fc-cache -fv
```

### Network module shows disconnected
Make sure NetworkManager is running:
```bash
systemctl enable --now NetworkManager
```

### Audio controls don't work
Make sure PulseAudio is running:
```bash
systemctl --user enable --now pulseaudio
# or for PipeWire:
systemctl --user enable --now pipewire-pulse
```

### Temperature doesn't show
Check hwmon path (see Customization section above).

### Microphone module doesn't appear
Your system might not have a default source. Check:
```bash
pactl list sources short
```

## Hot Reload

Waybar automatically reloads when you save changes to:
- `~/.config/waybar/config`
- `~/.config/waybar/style.css`

If it doesn't, manually reload:
```bash
killall waybar && waybar &
```

## Additional Resources

- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Module Configuration](https://github.com/Alexays/Waybar/wiki/Module:-Custom)
- [Font Awesome Icons](https://fontawesome.com/icons) - For custom icons
