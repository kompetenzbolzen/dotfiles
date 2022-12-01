# vi: ft=sh

if [ "$WM_AUTO_START" = "yes" ] && [ -z $DISPLAY ] && [ "$(tty)" = "$WM_TTY" ]; then
  exec "$WM_WM"
fi
