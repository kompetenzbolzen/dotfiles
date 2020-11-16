# vi:syntax=sh

function prompt_command () {
	local EXIT="$?"
	local REMOTE=""
	local VENV=""

	[ $EXIT -eq 0 ] && EXIT=""
	[ ! -z "$SSH_CONNECTION" ] && REMOTE="${orange}[R] "
	[ -z "$VIRTUAL_ENV" ] || VENV="$(basename "$VIRTUAL_ENV")"
	
	#PS1="\n${REMOTE}${cyan}\h:$(virtualenv_prompt) ${reset_color} ${yellow}\w ${green}$(scm_prompt_info)\n${red}${EXIT} ${reset_color}→ "
	PS1="\n${REMOTE}${cyan}\h: ${reset_color} ${yellow}\w ${green}${VENV}\n${red}${EXIT} ${reset_color}→ "
}

PROMPT_COMMAND=prompt_command
