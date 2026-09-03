# vi: ft=bash

function __hook_login() {
	for f in "${HOOK_LOGIN[@]}"; do
		"$f"
	done
}

function __hook_cd() {
	for f in "${HOOK_CD[@]}"; do
		"$f" "$@"
	done
	\cd "$@"
}
alias cd=__hook_cd

function __hook_clear() {
	\clear
	for f in "${HOOK_CLEAR[@]}"; do
		"$f" "$@"
	done
}
alias clear=__hook_clear

function __hook_entry() {
	for f in "${HOOK_ENTRY[@]}"; do
		"$f"
	done
}

function hooks() {
	for e in CD CLEAR ENTRY; do
		echo -n $e
		printf "\t| "
		eval echo "\${HOOK_${e}[@]}"
	done
}

[[ $- == *i* ]] && __hook_login
__hook_entry
