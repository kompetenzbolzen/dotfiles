#!/bin/bash

#['name']='install location relative to $HOME'
declare -A CONFIGS
CONFIGS=( 	["sway"]=".config"
		["alacritty"]=".config"
		["polybar"]=".config"
		["powerline"]=".config"
		["nvim"]=".config"
		["termite"]=".config"
		["twmn"]=".config"
		["picom"]=".config"
		["i3"]=".config"
		["termux.properties"]=".termux"
		["bspwm"]=".config"
		["sxhkd"]=".config"
		["deadd"]=".config"
		["rofi"]=".config"
		["autoload.cfg"]=".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/csgo/cfg/"
		[".vim"]="."
		[".xinitrc"]="."
		[".bashrc"]="."
		[".Xresources"]="."
		[".radare2rc"]="."
		[".bash_profile"]="."
		[".stack"]="."
		["gpg-agent.conf"]=".gnupg"
	)

declare -A SETS
SETS=(		["base"]=".vim .bashrc .bash_profile"
		["desktop"]="base termite picom i3 deadd polybar .xinitrc .Xresources"
	)

WORKDIR=$(realpath "$(dirname "$0")")
cd "$WORKDIR" || (echo cd failed; exit 1)
echo "Working in $WORKDIR"
echo "Homedir is $HOME"

# === CODE BELOW HERE ===

source "lib/funcs.sh" || exit 1

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
