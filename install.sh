#!/bin/bash

function fail(){
	EXCODE=$1
	shift
	echo "$@" >&2
	exit "$EXCODE"
}

WORKDIR=$(realpath "$(dirname "$0")")
cd "$WORKDIR" || fail 1 "The working directory could not be determined."

# For hooks
export WORKDIR

# === CODE BELOW HERE ===

for f in lib/*.sh; do
	source "$f" || fail 1 "Failed to load $f"
done

debug "Working in $WORKDIR"
debug "Homedir is $HOME"

if [ ! -f "config.csv" ] || [ ! -f "sets.csv" ]; then
	# TODO Create them
	fail 1 "Configuration files do not exist"
fi

#['name']='install location relative to $HOME'
declare -A CONFIGS
while IFS=";" read -r CFG DEST _; do
	CONFIGS[$CFG]="$DEST"
done < config.csv
unset CFG DEST

#['name']='list of keys of CONFIGS (or SETS; Beware of BRB)'
declare -A SETS
while IFS=";" read -r SET PKGS _; do
	SETS[$SET]="$PKGS"
done < sets.csv
unset SET PKGS

if [ $# -eq 0 ]; then
	print_help "$0"
	exit 1
fi

CMD=$1
shift

case $CMD in
	install)
		if [ $# -gt 0 ]; then
			selected=( "$@" )
		else
			selected=( $(multiselector "${!CONFIGS[@]}" "${!SETS[@]}" ) )
		fi
		for cnf in "${selected[@]}"; do
			choose_target "$cnf"
		done

		call_hook housekeeping;;
	hook)
		call_hook "$1";;
	add)
		test -e "$1" || fail 1 "Target file not found: $1"

		TARGET=$(realpath "--relative-to=$HOME" "$1")
		NAME=$(basename "$TARGET")
		RELPATH=$(dirname "$TARGET")

		# NOTE: This does not check SETS. Could be a problem
		test -n "${CONFIGS[$NAME]}" && fail 1 "An object with the same name is already managed."

		cp -r "$1" ./ || fail 1 "Failed to copy configuration"
		echo "$NAME;$RELPATH" >> config.csv

		call_hook post_add "$NAME" "$TARGET"

		echo "Config was installed successfully."
		echo "It can now be installed with $0 install $NAME"
		echo "The following files were changed: config.csv $NAME"
		;;
	*)
		echo Invalid command: "$CMD"
		exit 1
		;;
esac
