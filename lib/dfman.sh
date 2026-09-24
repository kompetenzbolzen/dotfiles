# shellcheck shell=bash
# NOTE.
# Functions for installing and managing dotfiles

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

	if [ ! -d "$(dirname $2)" ]; then
		debug "$(dirname $2) does not exit. Creating it."
		mkdir -p "$(dirname $2)"
	fi

	ln -s "$1" "$2"

	call_hook "installed.$(basename "$2")" "$2"
	call_hook "installed" "$2"
}

install_target() {
	if [ ! -z "${CONFIGS[$1]}" ]; then
		echo "Install $(pwd)/$1 to $HOME/${CONFIGS[$1]}/$1"
		link "$(pwd)/$1" "$HOME/${CONFIGS[$1]}/$1"
	elif [ ! -z "${SETS[$1]}" ]; then
		for f in ${SETS[$1]}; do
			install_target $f
		done
	else
		echo Target $1 not found. skipping.
	fi
}

list_installed() {
	local f
	for c in "${!CONFIGS[@]}"; do
		f="$HOME/${CONFIGS[$c]}/$c"
		if [ ! -L "$f" ]; then
			continue
		elif [ ! "$(dirname "$(readlink "$f")")" \
			= "$WORKDIR" ]; then
			# NOTE check if symlink points to df dir
			continue
		fi
		echo "$c"
	done
}
