#!/bin/bash
shopt -s extglob

readonly TMUX_FORMAT='#{session_id};#{session_attached};#{session_name}'

OPTIONS=$(
echo new
while IFS=';' read -r ID ATTACHED NAME; do
	printf "%s\t|" "$ID"
	printf " %s" "$NAME"
	test $ATTACHED -ge 1 && printf " (attached)"

	printf "\n"
done <<< "$(tmux ls -F "$TMUX_FORMAT")"
)

CHOICE=$(fzf <<< "$OPTIONS" | awk -F'|' '{ print $1 }')
test -z "$CHOICE" && exit 1

echo $CHOICE

case $CHOICE in
	$+([0-9])* )
		tmux attach -t $CHOICE ;;
	new) tmux ;;
	*)
		exit 1;;
esac
