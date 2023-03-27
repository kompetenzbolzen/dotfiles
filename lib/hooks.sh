# Functions for hooks

# 1: Name of hook
call_hook() {
	local HOOK="$1"
	shift

	if [ !  -x "hooks/$HOOK.hook" ]; then
		debug "$HOOK.hook was not found. Skipping."
		return
	fi

	debug "Running hook $HOOK"

	hooks/$HOOK.hook 2>&1 | (while read line; do echo [hook: $HOOK] $line; done)
	RET=${PIPESTATUS[0]}

	if [ $RET -ne 0 ]; then
		warning "Hook $HOOK exitet with code $RET"
	fi
}
