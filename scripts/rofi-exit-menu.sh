#!/bin/bash

function options() {
	cat << EOF
supspend
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
			systemctl shutdown;;
		reboot)
			systemctl reboot;;
		"exit i3")
			i3-msg exit;;
		*)
			options;;
	
	esac
else
	options
fi

