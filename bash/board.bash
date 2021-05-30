#!/bin/bash

BB_HIST_DIR="$HOME/.cache/bashboard/"
BB_SHORTCUT=()

[ ! -d "$BB_HIST_DIR" ] && mkdir -p "$BB_HIST_DIR"

# format
# NUM YYYY-MM-DD PATH

function cd {
	local BB_PWD
	local BB_GREP_RET
	local BB_NUM BB_DATE BB_DIR

	builtin cd "$@" || return $?
	[ -f "$BB_DIR/history" ] || touch "$BB_HIST_DIR/history"
	BB_PWD="$(pwd)"

	[ "$BB_PWD" = "$HOME" ] && return

	BB_GREP_RET=$(grep -P "^\d+ \d+ \Q$BB_PWD\E$" "$BB_HIST_DIR/history")
	read -r BB_NUM BB_DATE BB_DIR <<< "$BB_GREP_RET"
	if [ -n "$BB_NUM" ]; then
		BB_NUM=$((BB_NUM+1))
		perl -p -i -e "s|^\d+ \d+ \Q$BB_PWD\E$|$BB_NUM $(date +%s) $BB_PWD|g" \
			"$BB_HIST_DIR/history"
	else
		echo "1 $(date +%s) $BB_PWD" >> "$BB_HIST_DIR/history"
	fi
}

function bashboard {
	local BB_NUM BB_DATE BB_DIR
	local line
	local cnt

	BB_SHORTCUT=()

	cnt=0
	while read -r line; do
		read -r BB_NUM BB_DATE BB_DIR <<< "$line"
		echo "[$cnt] ${BB_DIR##$HOME/}"

		BB_SHORTCUT+=("$BB_DIR")

		cnt=$((cnt+1))
	done <<< "$(sort -nr "$BB_HIST_DIR/history" | head -n 5)"

	# TODO recently used
}

function bb {
	if [ $# -eq 0 ]; then
		bashboard
		return
	fi

	cd "${BB_SHORTCUT[$1]}" || return
}

bashboard
