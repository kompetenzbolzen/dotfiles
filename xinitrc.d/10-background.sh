#!/bin/bash

#Screen background feh
if [ -f ~/.files ]; then
	source ~/.files
	shopt -s nullglob

	pics=($DOTFILEBASE/pictures/b_*)
	len=${#pics[*]}
	ran=$(($RANDOM % len))

	feh --bg-fill ${pics[$ran]}

	unset pics len ran
fi
