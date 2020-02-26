# vi:syntax=sh

function prompt_command () {
	local EXIT="$?"
	if [ $EXIT -eq 0 ]; then
		EXIT=""
	fi
	#PS1="\n${cyan}\h:$(virtualenv_prompt) ${reset_color} ${yellow}\w ${green}$(scm_prompt_info)\n${red}${EXIT} ${reset_color}→ "
	PS1="\n${cyan}\h: ${reset_color} ${yellow}\w \n${red}${EXIT} ${reset_color}→ "
}

PROMPT_COMMAND=prompt_command
