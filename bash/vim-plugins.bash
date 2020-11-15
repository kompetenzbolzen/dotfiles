function vim-add() {
	source ~/.files

	local NAME=$(basename "$1")
	
	[ -d "$DOTFILEBASE/.vim/bundle/$NAME" ] || return 1 # no such plugin

	local OLD_PWD=$(pwd)
	cd "$DOTFILEBASE/.vim/bundle-active/"
	[ -L $NAME ] && cd "$OLD_PWD" && return 2 # Already exists

	ln -s "../bundle/$NAME"

	cd "$OLD_PWD"
}

function vim-remove {
	source ~/.files

	local NAME=$(basename "$1")
}
