# vi:filetype=sh

function appendpath() {
	local regex="[:^]${1//'/'/'\/'}[:$]"
	if [[ ! ${PATH} =~ $regex ]]; then
		PATH=$PATH:$1
	fi
}

appendpath "$HOME/bin"
appendpath "$DOTFILEBASE/scripts"
appendpath "$HOME/.local/bin"
appendpath "$HOME/go/bin"
appendpath "$HOME/.cabal/bin"
appendpath "$HOME/.ghcup/bin"

export PATH
unset appendpath

if which nvim > /dev/null 2>&1 && [ ! "$FORCE_VANILLA_VIM" = "yes" ] ; then
	export EDITOR=nvim
else
	export EDITOR=vim
fi

#Java Gradle hopme PATH
export GRADLE_USER_HOME=~/.gradle

export HISTTIMEFORMAT="%y-%m-%d %T "
export HISTSIZE=1000
