#!/bin/bash

function options() {
	cat << EOF
suspend
shutdown
reboot
Xit
EOF
}

if [ $# -gt 0 ]; then
	case "$@" in
		suspend)
			systemctl suspend;;
		shutdown)
			systemctl poweroff;;
		reboot)
			systemctl reboot;;
		Xit)
			i3-msg exit;;
		*)
			options;;
	
	esac
else
	options
fi

