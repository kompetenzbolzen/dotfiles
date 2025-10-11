CHEATSHEAT_COLUMNS=3
CHEATSHEAT_PART_LEFT=0.4
CHEATSHEAT_CONF_FILE="$DOTFILEBASE/cheatsheet"

CHEATSHEAT_COLOR_PRIMARY=$purple
CHEATSHEAT_COLOR_SECONDARY=$white

#CHEATSHEAT_ENABLE defaults to no

function __cheatsheat_print() {
	echo -n "$(printf "$@")"
}

function __cheatsheet() {
	local COLS COL_L COL_R SINGLE_COLUMN CNT CP CS LOCAL_CS
	COLS=$(tput cols)
	SINGLE_COLUMN=$(bc <<< "$COLS/$CHEATSHEAT_COLUMNS")
	COL_L=$(bc <<< "$SINGLE_COLUMN * $CHEATSHEAT_PART_LEFT")
	COL_R=$(bc <<< "$SINGLE_COLUMN * (1.0-$CHEATSHEAT_PART_LEFT)")
	COL_L=${COL_L%.*}
	COL_R=${COL_R%.*}

	CP=$CHEATSHEAT_COLOR_PRIMARY
	CS=$CHEATSHEAT_COLOR_SECONDARY

	LOCAL_CS=""
	if [ -f .cheatsheet ]; then
		LOCAL_CS=".cheatsheet"
	fi

	CNT=0
	# TODO CSV nur einmal einlesen
	while IFS=";" read -r A B; do
		__cheatsheat_print "$CP%-${COL_L}s$reset_color$CS%-${COL_R}s$reset_color" \
			"$A" "$B"
		CNT=$(((CNT+1)%3))
		test $CNT -eq 0 && echo
	done <<< $(cat $LOCAL_CS $CHEATSHEAT_CONF_FILE)
}

function __clear() {
	\clear
	__cheatsheet
}

if [ "$CHEATSHEAT_ENABLE" = "yes" ]; then
	alias clear="__clear"
	__cheatsheet
	alias ?='__cheatsheet'
fi
