#!/bin/sh

# turn off Display Power Management Service (DPMS)
xset -dpms
setterm -blank 0 -powerdown 0

# turn off black Screensaver
xset s off

export XSECURELOCK_PASSWORD_PROMPT=kaomoji
xss-lock -- xsecurelock &
