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
	python -m virtualenv --system-site-packages $TMPDIR
	source $TMPDIR/bin/activate

	if [ $# -gt 0 ]; then
		pip install "$@"
	fi
}

function cdpython() {
	local TMPDIR=$(mktemp -d)
	cp -r $DOTFILEBASE/templates/python/* "$TMPDIR"
	cd "$TMPDIR"

	if [ -f requirements.txt ]; then
		mkvenv -r requirements.txt
	fi
}
