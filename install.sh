#!/bin/bash

set -e

# Step 1: Install base packages
sudo apt update
sudo apt install -y \
  sway xwayland foot \
  xdg-desktop-portal-wlr \
  waybar wofi mako-notifier fcitx5 fcitx5-hangul \
  blueman network-manager-gnome brightnessctl \
  grim slurp wl-clipboard playerctl pavucontrol \
  fonts-noto-cjk fonts-nanum fonts-noto-color-emoji

sudo apt remove xdg-desktop-portal-gtk

# Step 3: Set up portals preference
mkdir -p ~/.config/xdg-desktop-portal
echo -e "[preferred]\ndefault=wlr" > ~/.config/xdg-desktop-portal/portals.conf

# Step 4: Set up Sway config
mkdir -p ~/.config/sway
cat > ~/.config/sway/config <<EOF
### Sway config (customized + default behavior)

# Modifier key
set $mod Mod4

# Applications
set $term foot
set $menu \"wofi --show drun\"

### Startup applications
exec nm-applet
exec blueman-applet
exec mako
exec swaybg -c '#000000'
exec fcitx5
exec waybar


### Key bindings

# Launch apps
bindsym $mod+Return exec $term
bindsym $mod+d exec $menu

# Volume control
bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Brightness control
bindsym XF86MonBrightnessUp exec brightnessctl set +10%
bindsym XF86MonBrightnessDown exec brightnessctl set 10%-

# Kill focused window
bindsym $mod+Shift+q kill

# Fullscreen toggle
bindsym $mod+f fullscreen

# Focus movement (vim-style)
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Move windows
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# Workspace switching
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9

# Move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9

# Toggle floating
bindsym $mod+Shift+space floating toggle

# Reload/Restart/Exit sway
bindsym $mod+Shift+c reload
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exit

# Change layout mode
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

### Input (keyboard, touchpad, etc.)
input type:keyboard {
  xkb_layout us,kr
}

input "type:touchpad" {
  natural_scroll enabled
  tap enabled
}

EOF

# Step 5: Waybar config
mkdir -p ~/.config/waybar
cat > ~/.config/waybar/config <<EOF
{
  "layer": "top",
  "position": "top",
  "height": 30,
  "modules-left": ["sway/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["cpu", "memory", "battery", "tray"],

  "clock": {
    "format": "{:%A, %Y-%m-%d %H:%M}",
    "tooltip-format": "%A, %d %B %Y\n%I:%M:%S %p"
  },

  "cpu": {
    "format": "CPU: {usage}%",
    "interval":1,
    "tooltip": true
  },

  "memory": {
    "format": "MEM: {used:0.1f}G / {total:0.1f}G",
    "interval":1,
    "tooltip": true
  },

  "battery": {
    "format": "BAT: {capacity}%",
    "format-charging": "BAT: {capacity}% ⚡",
    "format-discharging": "BAT: {capacity}% ↓",
    "format-full": "BAT: {capacity}% ✔",
    "interval":1,
    "tooltip": true
  },

  "sway/workspaces": {
    "disable-scroll": false,
    "all-outputs": false,
    "format": "{name}"
  }
}
EOF

cat > ~/.config/waybar/style.css <<EOF
* {
  font-family: "JetBrainsMono Nerd Font", monospace;
  font-size: 14px;
  color: #ffffff;
  background: #1e1e2e;
}
#cpu, #memory, #battery, #clock, #tray {
  padding: 0 10px;
}
EOF

# Step 6: Mako notification config
mkdir -p ~/.config/mako
cat > ~/.config/mako/config <<EOF
font=JetBrains Mono 12
background-color=#222222
text-color=#ffffff
border-color=#888888
padding=10
EOF

# Step 7: Input method env vars
if ! grep -q 'fcitx' ~/.profile; then
  echo "export GTK_IM_MODULE=fcitx" >> ~/.profile
  echo "export QT_IM_MODULE=fcitx" >> ~/.profile
  echo "export XMODIFIERS=@im=fcitx" >> ~/.profile
fi


echo "✅ All done! Reboot"
