# Sway

Packages:
`ttf-font-awesome otf-font-awesome ttf-dejavu sway waybar alacritty wofi swaybg xorg-xwayland j4-dmenu-desktop bemenu bemenu-wayland swayidle`

For screencast:
`xdg-desktop-portal-wlr`

and
```sh
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
```

Notification: `swaync` (AUR0

## Pipewire

`pipewire wireplumber pipewire-pulse pipewire-alsa`

## Screenshot

`/usr/share/sway/scripts/grimshot copy area`

Packages:

`slurp` `grim` `wl-clipboard` `sway-contrib`
