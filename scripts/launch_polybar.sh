#!/bin/bash

killall polybar > /dev/null 2>&1

while read -r MON RES PRIM; do
	if [ -n "$PRIM" ]; then
		BAR=main
	else
		BAR=secondary
	fi

	MONITOR=$MON polybar --reload $BAR &
done <<< "$(polybar --list-monitors | tr -d ':')"
