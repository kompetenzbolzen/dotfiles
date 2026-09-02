CHEATSHEET_DYNAMIC_ENTRIES=()

function cheatsheet_add() {
	CHEATSHEET_DYNAMIC_ENTRIES+=( "$1;$2" )
}

function __cheatsheet_construct_dynamic_entries() {
	for e in "${CHEATSHEET_DYNAMIC_ENTRIES[@]}"; do
		echo "$e"
	done
}
