# vi:syntax=sh

function prompt_command () {
	local EXIT="$?"
	local REMOTE=""

	[ $EXIT -eq 0 ] && EXIT=""
	[ ! -z "$SSH_CONNECTION" ] && REMOTE="${orange}[R] "
	
	#PS1="\n${REMOTE}${cyan}\h:$(virtualenv_prompt) ${reset_color} ${yellow}\w ${green}$(scm_prompt_info)\n${red}${EXIT} ${reset_color}→ "
	PS1="\n${REMOTE}${cyan}\h: ${reset_color} ${yellow}\w \n${red}${EXIT} ${reset_color}→ "
}

PROMPT_COMMAND=prompt_command
