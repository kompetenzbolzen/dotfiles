# vi:filetype=sh

function is_not_in_path() {
	local regex="(:|^)${1//'/'/'\/*'}(:|$)"
	[[ ! ${PATH} =~ $regex ]]
}

function appendpath() {
	if is_not_in_path "$1"; then
		PATH="$PATH:$1"
	fi
}

function prependpath() {
	if is_not_in_path "$1"; then
		PATH="$1:$PATH"
	fi
}

appendpath "$HOME/bin"
appendpath "$DOTFILEBASE/scripts"
appendpath "$HOME/.local/bin"
appendpath "$HOME/go/bin"
appendpath "$HOME/.cabal/bin"
prependpath "$HOME/.ghcup/bin"

export PATH

if which nvim > /dev/null 2>&1 && [ ! "$FORCE_VANILLA_VIM" = "yes" ] ; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi

#Java Gradle hopme PATH
export GRADLE_USER_HOME=~/.gradle

export HISTTIMEFORMAT="%y-%m-%d %T "
export HISTSIZE=1000

export QT_QPA_PLATFORMTHEME=qt6ct
