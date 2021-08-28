#!/bin/bash

SPOTIFY_OUTPUT_REGEX="BurrBrown"

while read -r NUM NAME REST; do
	[[ "$NAME" =~ $SPOTIFY_OUTPUT_REGEX ]] && SPOTIFY_SINK=$NUM
done <<< "$(pactl list short sinks)"

export SPOTIFY_SINK
