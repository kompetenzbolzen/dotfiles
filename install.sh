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


#1: message
yes_no() {
	read -p "$1 (y/[n])" inp
	case $inp in
		[yY]* ) return 0;;
		* ) 	return 1;;
	esac
}

#interface on sterr
multiselector() {
	local argc=$#
	local argv=( "$@" )
	local cnt=0
	local ret=""

	for entry in "$@"; do
		>&2 echo "$cnt) $entry"
		((cnt=cnt + 1))
	done

	>&2 echo "Select entry(s)"
	>&2 echo "eg. '1 3' '1-4' 'a'"
	>&2 read -p " > " inp

	for sel in $inp; do
		local reg_range="^[0-9]+\-[0-9]+$"
		local reg_single="^[0-9]+$"
		local reg_all="^[aA]+"

		if [[ $sel =~ $reg_range ]]; then
			range=($(echo $sel | tr "-" " "))
			for (( i=${range[0]}; i<=${range[1]}; i++ )); do
				ret="$ret ${argv[$i]}"
			done
		elif [[ $sel =~ $reg_single ]]; then
			ret="$ret ${argv[$sel]}"
		elif [[ $sel =~ $reg_all ]]; then
			ret=$@
			break;
		else
			>&2 echo "Wrong input at \"$sel\""
			ret=""
			break
		fi
	done
	echo $ret
}

selector() {
	local regex="^-?[0-9]+\$"
	local cnt=0
	for selection in "$@"
	do
		echo "$cnt) $selection"
		((cnt=$cnt + 1))
	done

	read -p "(default=0) >" inp
	if [[ "$inp" =~ $regex ]] && [ $inp -ge 0 -a $inp -le $# ]
	then
		echo $inp
		return $inp
	elif [ -z $inp ]
	then
		return 0
	else
		return 2
	fi
}

#1: source 2: destination
link() {
	if [ -e "$2" ]; then
		if yes_no "$(basename $2) exists. Overwrite?"; then
			if [ -d "$2" ]; then
				rm -R "$2"
			else
				rm "$2"
			fi
		else
			return
		fi
	fi

	ln -s "$1" "$2"
}

choose_target() {
	if [ ! -z "${CONFIGS[$1]}" ]; then
		echo "Install $(pwd)/$1 to $HOME/${CONFIGS[$1]}/$1"
		link "$(pwd)/$1" "$HOME/${CONFIGS[$1]}/$1"
	elif [ ! -z "${SETS[$1]}" ]; then
		for f in ${SETS[$1]}; do
			choose_target $f
		done
	else
		echo Target $1 not found. skipping.
	fi
}

housekeeping() {
	git submodule init
	git submodule update

	#.files is used to tell scripts where to look for the dotfiles
	[ -f "$HOME/.files" ] && source "$HOME/.files"
	if [ "$DOTFILEBASE" != "$(pwd)" ] && yes_no "'.files' out of date. Regenerate?"; then
		echo "DOTFILEBASE=\"$(pwd)\"" > $HOME/.files
	fi

	if [ ! -f "$HOME/.files.config" ] && yes_no ".files.config does not exist. Populate with defaults?"; then
		cp "config.default" "$HOME/.files.config"
	fi
}

if [ $# -gt 0 ]
then
	for i in "$@"; do
		choose_target "$i"
	done
	housekeeping
	exit 0
fi

WORKDIR=$(realpath $(dirname $0))
cd "$WORKDIR" || (echo cd failed; exit 1)
echo "Working in $WORKDIR"
echo "Homedir is $HOME"

selected=( $(multiselector "${!CONFIGS[@]}" "${!SETS[@]}" ) )

for cnf in "${selected[@]}"; do
	choose_target "$cnf"
done

housekeeping
