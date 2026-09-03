# vi:syntax=sh
#PROMPT_EXECTIME="no"

function _prompt_command () {
	local EXIT="$?"
	local MOD_PREFIX=""
	local VENV=""
	local EXECTIME=""

	local NOW
	if [ "$PROMPT_EXECTIME" = "yes" ]; then
		NOW=$(date +%s)
	fi

	[ $EXIT -eq 0 ] && EXIT=""
	[ ! -z "$SSH_CONNECTION" ] && MOD_PREFIX+="${orange}[R] "
	[ ! -z "$PADHOME" ] && MOD_PREFIX+="${orange}[PAD $(basename "$PADHOME")] "
	[ -z "$VIRTUAL_ENV" ] || VENV="$(basename "$VIRTUAL_ENV")"

	if [ -n "$__LAST_PROMPT" ]; then
		EXECTIME=" ($(( NOW - __LAST_PROMPT ))s)"
	fi
	
	PS1="\n${yellow}\t${EXECTIME}${reset_color}\n${MOD_PREFIX}${white}\u@${cyan}\h: ${reset_color} ${yellow}\w ${green}${VENV}\n\[${red}\]${EXIT} \[${reset_color}\]→ "

	__LAST_PROMPT="$NOW"
}

function _preexec() {
	__LAST_PROMPT="$(date +%s)"
}

_preexec_invoke_exec () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    _preexec "$this_command"
}

if [ "$PROMPT_EXECTIME" = "yes" ]; then
	trap '_preexec_invoke_exec' DEBUG
fi

HOOK_PROMPT+=(_prompt_command)
