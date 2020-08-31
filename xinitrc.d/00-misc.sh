#!/bin/sh

xrdb .Xresources

setxkbmap -layout de
/usr/bin/setxkbmap -option "caps:swapescape"

redshift -l 48.814:11.3431 &
