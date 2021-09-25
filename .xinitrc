#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -f ~/.files ]; then
	. "$HOME/.files"
	for f in $DOTFILEBASE/xinitrc.d/*; do
		# Some scripts require bash, but .xinitrc is sourced from sh.
		# If a script is marked executable, it is executed instead of sourced.
		[ -x "$f" ] && exec "$f" || . "$f"
	done
	unset f
fi

