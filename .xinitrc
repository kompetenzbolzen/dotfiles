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

#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_LOCK

#Screen background feh
shopt -s nullglob

pics=(~/vimconfig/pictures/b_*)
#echo $pics
len=${#pics[*]}
ran=$(($RANDOM % len))

feh --bg-fill ${pics[$ran]}

# exec gnome-session
#exec startkde
exec i3
# exec startxfce4
# ...or the Window Manager of your choice
