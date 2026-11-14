if [ ! "$TMUX_VIM_ENABLE" = "yes" ]; then
	return
fi

if [ -z "$TMUX" ]; then
	return
fi

_TMUX_VIM_TITLE="tmux-vim"

function __tmux_vim_pane_exists() {
	tmux list-panes -F '#{pane_title}' | grep -Fqx -- "$_TMUX_VIM_TITLE" > /dev/null 2>&1
}

function __tmux_vim_create_split_pane() {
	tmux split-window -h -T "$_TMUX_VIM_TITLE" nvim "$@"
}

function __tmux_vim_create_float_pane() {
	tmux new-pane -h -T "$_TMUX_VIM_TITLE" nvim "$@"
}

function __tmux_vim_focus() {
	local id=$(tmux list-panes -F $'#{pane_id}\t#{pane_title}' | \
		awk -F '\t' -v title="$_TMUX_VIM_TITLE" '$2 == title { print $1 }')
	tmux select-pane -t "$id"
}


function vimm() {
	__tmux_vim_pane_exists || __tmux_vim_create_split_pane "$@"
	__tmux_vim_focus
}

function vimf() {
	__tmux_vim_pane_exists || __tmux_vim_create_float_pane "$@"
	__tmux_vim_focus
}

unalias notes
function notes() {
	tmux new-pane -y50% -h nvim "+VimwikiIndex"
}

cheatsheet_add vimm "tmux split vim"
