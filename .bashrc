#!/usr/bin/env bash

#Light and fancy bash

if [[ -f "$HOME/.files" ]]; then
	source "$HOME/.files"
else
	DOTFILEBASE="/home/jonas/dotfiles"
fi

for f in $DOTFILEBASE/bash/*.bash; do
	source $f
done

