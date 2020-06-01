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

export PATH
unset appendpath

export EDITOR=nvim

#Java Gradle hopme PATH
export GRADLE_USER_HOME=~/.gradle
