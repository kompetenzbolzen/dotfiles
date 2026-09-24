
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


debug() {
	if [ "$DEBUG" = "yes" ]; then
		echo "[DEBUG] $@"
	fi
}

warning() {
	echo "[WARNING] $@"
}

print_help() {
	cat << EOF
USAGE: $1 COMMAND [ARGS]
COMMANDS
	install [CONFIG ...]
		install configurations. if none are provided,
		a selection menu is showm.
	add	PATH
		Add PATH to managed configs
	hook	HOOK
		manually call a hook
	sysconf
		install sysconf configuration
	add_sysconf
		Add PATH to managed sysconfigs
EOF
}
