#!/bin/sh

#Screen background feh
shopt -s nullglob

pics=(~/vimconfig/pictures/b_*)
len=${#pics[*]}
ran=$(($RANDOM % len))

feh --bg-fill ${pics[$ran]}

unset pics len ran
