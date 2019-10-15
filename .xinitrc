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

# turn off Display Power Management Service (DPMS)
xset -dpms
setterm -blank 0 -powerdown 0

# turn off black Screensaver
xset s off

#Screen background feh
>>>>>>> Stashed changes
shopt -s nullglob

pics=(~/vimconfig/pictures/b_*)
#echo $pics
len=${#pics[*]}
ran=$(($RANDOM % len))

feh --bg-fill ${pics[$ran]}

xrdb .Xresources

setxkbmap -layout de
compton &

if [ $DISPLAY -e ":0" ]; then
	lxqt-policykit-agent &
fi

exec i3
