#!/bin/sh

picom --experimental-backends &
twmnd &

keepassxc &

exec i3
