# vi:syntax=sh

function cdtmp() {
	local TMPDIR=$(mktemp -d)
	if [ $# -gt 0 ]; then
		local ARR=( "$@" )
		cp "${ARR[@]}" $TMPDIR
	fi
	builtin cd "$TMPDIR"
}
