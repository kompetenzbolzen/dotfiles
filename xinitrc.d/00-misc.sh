#!/bin/sh

xrdb .Xresources

setxkbmap -layout de
#/usr/bin/setxkbmap -option "caps:swapescape"

redshift -l 48.814:11.3431 &

/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets &

nextcloud &
