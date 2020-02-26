# vi:filetype=sh

function appendpath() {
	local regex="[:^]${1//'/'/'\/'}[:$]"
	echo $regex
	if [[ ! ${PATH} =~ $regex ]]; then
		PATH=$PATH:$1
	fi
}

appendpath "$HOME/bin"
appendpath "$DOTFILEBASE/scripts"

export PATH
unset appendpath

export EDITOR=vim
