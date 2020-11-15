function vim-add() {
	source ~/.files

	local NAME=$(basename "$1")
	
	[ -d "$DOTFILEBASE/.vim/bundle/$NAME" ] || return 1 # no such plugin
	[ -L "$DOTFILEBASE/.vim/bundle-active/$NAME" ] && return 2 # Already exists

	local OLD_PWD=$(pwd)
	cd "$DOTFILEBASE/.vim/bundle-active/"

	ln -s "../bundle/$NAME"

	cd "$OLD_PWD"
}

function vim-remove {
	source ~/.files

	local NAME=$(basename "$1")

	[ -L "$DOTFILEBASE/.vim/bundle-active/$NAME" ] || exit 1
	rm "$DOTFILEBASE/.vim/bundle-active/$NAME"
}

function _vim_plugins {
	source ~/.files
	local cur prev opts plugin

	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts=""

	for plugin in $DOTFILEBASE/.vim/bundle/*/; do
		opts+=" $(basename $plugin)"
	done
	
	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0
}

function _vim_plugins_active {
	source ~/.files
	local cur prev opts plugin

	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts=""

	for plugin in $DOTFILEBASE/.vim/bundle-active/*/; do
		opts+=" $(basename $plugin)"
	done
	
	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
	return 0
}

complete -F _vim_plugins vim-add
complete -F _vim_plugins_active vim-remove
