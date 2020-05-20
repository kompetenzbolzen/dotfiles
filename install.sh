#!/bin/bash

#['name']='install location'
declare -A CONFIGS
CONFIGS=( UU	["nvim"]=".config"
		[".vim"]="."
		[".xinitrc"]="."
		[".compton.conf"]="."
		[".bashrc"]="."
		[".bash_profile"]="." )

#1: message
yes_no()
{
	read -p "$1 (y/[n])" inp
	case $inp in
		[yY]* ) return 0;;
		* ) 	return 1;;
	esac
}

#interface on sterr
multiselector() {
	local argc=$#
	local argv=($@)
	local cnt=0
	local ret=""

	for entry in "$@"; do
		>&2 echo "$cnt) $entry"
		((cnt=$cnt + 1))
	done

	>&2 echo "Select entry(s)"
	>&2 echo "eg. '1 3' '1-4' 'a'"
	>&2 read -p " > " inp

	for sel in $inp; do
		local reg_range="^[0-9]+\-[0-9]+$"
		local reg_single="^[0-9]+$"
		local reg_all="^[aA]*"

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

selector()
{
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
link()
{
	if [ -e $2 ]; then
		if yes_no "$(basename $2) exists. Overwrite?"; then
			if [ -d $2 ]; then
				rm -R $2
			else
				rm $2
			fi
		else
			return
		fi
	fi

	ln -s "$1" "$2"
}

if [ $# -gt 0 ]
then
	for i in "$@"
	do
		if [ ! -z ${CONFIGS[$i]} ]; then
			echo "Install $(pwd)/$i to $HOME/${CONFIGS[$i]}/$i"
			link "$(pwd)/$i" "$HOME/${CONFIGS[$i]}/$i"
		else
			echo $i Not found. Skipping.
		fi
	done
	exit 0
fi

WORKDIR=$(dirname $0)
cd $WORKDIR
echo Working in $WORKDIR
echo Homedir is $HOME

git submodule init
git submodule update

selected=( $(multiselector ${!CONFIGS[@]}) )

for cnf in "${selected[@]}"; do
	echo "Install $(pwd)/$cnf to $HOME/${CONFIGS[$cnf]}/$cnf"
	link "$(pwd)/$cnf" "$HOME/${CONFIGS[$cnf]}/$cnf"
done

#.files is used to tell scripts where to look for the dotfiles
if yes_no "Generate '.files'?"; then
	echo "DOTFILEBASE=\"$(pwd)\"" > $HOME/.files
fi

