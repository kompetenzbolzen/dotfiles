# Primarily Plugin file (.d) manager

# NOTE: 1: SOURCE 2: DEST
function install_all_in_folder() {
	for f in "$1"/*; do
		echo Installing $(basename $f) to $2
		sudo install -m 644 -C --target-directory "$2" "$f"
	done
}

# NOTE: 1: sysconf entry name 2: Destination
function install_sysconf() {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo No destination provided
		return
	fi

	local SOURCE="$(pwd)/sysconf/$1"
	local DEST="/$2"

	# BUG O NO! We rely on executon order based on alphabet here!
	if ! yes_no "Install $SOURCE to $DEST?"; then
		echo Ok, won\'t then
		return
	fi

	echo "Unlock Sudo"
	# WARNING sudo -v does not work when user is NOPASSWD
	while ! sudo true; do
		echo sudo failed. trying again.
		sleep 1
	done

	if [ -d "$SOURCE" ] && [ -d "$DEST" ]; then
		install_all_in_folder $SOURCE $DEST
	elif [ -d "$SOURCE" ] && [ ! -e "$DEST" ]; then
		sudo mkdir -p "$DEST"
		install_all_in_folder $SOURCE $DEST
	elif [ -f "$SOURCE" ] && [ -f "$DEST" ]; then
		# TODO maybe create leading path?
		sudo install -C "$SOURCE" "$DEST"
	elif [ -f "$SOURCE" ] && [ ! -e "$DEST" ]; then
		sudo install -C "$SOURCE" "$DEST"
	else
		echo  +++++++++++
		echo "|Conflict!|"
		echo  +++++++++++
		return
	fi

	echo OK.
}
