# vi:syntax=sh

function cdtmp() {
	local TMPDIR=$(mktemp -d)
	if [ $# -gt 0 ]; then
		local ARR=( "$@" )
		cp "${ARR[@]}" $TMPDIR
	fi
	builtin cd "$TMPDIR"
}

function mkvenv() {
	local TMPDIR=$(mktemp -d)
	python -m virtualenv --system-site-packages "$TMPDIR"
	source "$TMPDIR/bin/activate" || return 1

	if [ $# -gt 0 ]; then
		pip install "$@"
	fi
}

function cdpython() {
	local TMPDIR=$(mktemp -d)
	cp -r "$DOTFILEBASE"/templates/python/* "$TMPDIR"
	builtin cd "$TMPDIR" || return 1

	if [ -f requirements.txt ]; then
		mkvenv -r requirements.txt
	fi
}

cheatsheet_add cdtmp "mktmp && cd"
cheatsheet_add mkvenv "temp venv"
cheatsheet_add cdpython "mktmp py-template"
