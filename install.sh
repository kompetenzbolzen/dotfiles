#!/bin/bash

function fail(){
	EXCODE=$1
	shift
	echo "$@" >&2
	exit "$EXCODE"
}

WORKDIR=$(realpath "$(dirname "$0")")
cd "$WORKDIR" || fail 1 "The working directory could not be determined."
echo "Working in $WORKDIR"
echo "Homedir is $HOME"

# === CODE BELOW HERE ===

source "lib/funcs.sh" || fail 1 "Failed to load components"

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
	cat << EOF
USAGE: $0 COMMAND [ARGS]
COMMANDS
	install [CONFIG ...]
		install configurations. if none are provided,
		a selection menu is showm.
	hk
		perform housekeeping functions
EOF
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
		housekeeping;;
	hk)
		housekeeping;;
	*)
		echo Invalid command: "$CMD"
		exit 1
		;;
esac
