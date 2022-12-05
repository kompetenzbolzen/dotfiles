# Functions for hooks

# 1: Name of hook
call_hook() {
	if [ !  -x "hooks/$1.hook" ]; then
		debug "$1.hook was not found. Skipping."
		return
	fi

	debug "Running hook $1"

	hooks/$1.hook 2>&1 | (while read line; do echo [hook: $1] $line; done)
	RET=${PIPESTATUS[0]}

	if [ $RET -ne 0 ]; then
		warning "Hook $1 exitet with code $RET"
	fi
}
