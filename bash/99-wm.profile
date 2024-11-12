# vi: ft=sh

if [ "$WM_AUTO_START" = "yes" ] && [ -z $DISPLAY ] && [ "$(tty)" = "$WM_TTY" ]; then
	systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
	dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
	exec "$WM_WM"
fi
