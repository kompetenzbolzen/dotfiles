#!/bin/bash

# Automatically lock/unlock system with bluetooth based presence detection
# using monitor on raspi and mosquitto MQTT client
#
# ./mqtt_monitor_systemlock.sh [BROKER] [TOPIC]


readonly THRESHHOLD=50
LAST_CONFIDENCE=100

readonly DEPENDS=( mosquitto_sub jq xset xsecurelock )
for prog in "${DEPENDS[@]}"; do 
	if ! which $prog > /dev/null 2>&1; then
		echo $prog not found
		exit 1
	fi
done

while read msg; do
	if ! CONFIDENCE=$(jq -r ".confidence" <<< "$msg"; exit $?); then
		echo JQ parse error.
		exit 1
	fi

	if [ $CONFIDENCE -lt $THRESHHOLD -a $LAST_CONFIDENCE -ge $THRESHHOLD ]; then
		echo [$(date +%d.%m.%Y\ %H:%M)] OFF

		XSECURELOCK_PASSWORD_PROMPT=kaomoji xsecurelock 2> /dev/null &
		LOCK_PID=$!

		xset dpms force standby
	elif [ $CONFIDENCE -gt $THRESHHOLD -a $LAST_CONFIDENCE -le $THRESHHOLD ]; then
		echo [$(date +%d.%m.%Y\ %H:%M)] ON

		kill $LOCK_PID

		xset dpms force on
	fi

	LAST_CONFIDENCE=$CONFIDENCE
done < <( mosquitto_sub -h "$1" -t "$2" )
