#!/bin/bash
# Rename multiple files at once using a text editor
# File list can be given as args
# if no args, all files in pwd are used

EDITOR=${EDITOR=:vi}

TMPFILE="$(mktemp)"
touch "$TMPFILE"

FILES=( )
if [ $# -eq 0 ]; then
	FILES=( * )
else
	FILES=( $@ )
fi

# List current dir
for f in "${FILES[@]}"; do
	echo $f >> "$TMPFILE"
done

eval "$EDITOR $TMPFILE"

i=0
while read line; do
	if [ "$line" != "${FILES[$i]}" -a -e "${FILES[$i]}" -a ! -e "$line" ]; then
		echo "${FILES[$i]} -> $line"
		if [ -e "${FILES[$i]}" -a ! -e "$line" ]; then
			mv "${FILES[$i]}" "$line"
		else
			echo "Skipping ${FILES[$i]} -> $line . Target already exists."
		fi
	fi

	i=$(( i + 1 ))
done < "$TMPFILE"

rm "$TMPFILE"
