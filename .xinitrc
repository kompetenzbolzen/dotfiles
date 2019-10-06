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

#Select random background image
shopt -s nullglob

pics=(~/vimconfig/pictures/b_*)
#echo $pics
len=${#pics[*]}
ran=$(($RANDOM % len))

feh --bg-fill ${pics[$ran]}

xrdb .Xresources

setxkbmap -layout de
compton &
lxqt-policykit-agent &

exec i3
