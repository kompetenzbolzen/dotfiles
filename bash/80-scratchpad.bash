# vi: ft=bash

if [ ! "$SCRATCHPAD_ENABLE" = "yes" ]; then
	return
fi

SCRATCHPAD_MOUNT_PREFIX="$XDG_RUNTIME_DIR/scratchpad"
[ ! -d "$SCRATCHPAD_MOUNT_PREFIX" ] && mkdir -p "$SCRATCHPAD_MOUNT_PREFIX"
[ ! -d "$SCRATCHPAD_STORAGE_DIR" ] && mkdir -p "$SCRATCHPAD_STORAGE_DIR"

SCRATCHPAD_TEMPLATE="$DOTFILEBASE"/templates/scratchpad/

function __sp_generate_id() {
	date +%Y-%m-%d_%H-%M-%S
}

# 1: pad id
function __sp_genereate_file_path() {
	echo "$SCRATCHPAD_STORAGE_DIR/$1.pad.gz"
}

# 1: pad id
function __sp_genereate_mount_path() {
	echo "$SCRATCHPAD_MOUNT_PREFIX/$1"
}

# 1: output 2: template dir
function __sp_new_pad() {
	(
	cd "$2" || return
	tar -cf "$1" -- *
	)
}

# 1: archive 2: pad file
function __sp_mount_pad() {
	mkdir -p "$pad_mnt" || return
	archivemount -o nobackup "$1" "$2" || return
	__sp_update_atime "$pad_mnt"
}

# 1: target
function __sp_unmount_pad() {
	fusermount -u "$1"
	rmdir "$pad_mnt"
}

# 1: pad file
function __sp_read_description() {
	tar -xOf "$1" "00-DESCRIPTION" #2> /dev/null
	return 0
}

# 1: mounted pad dir
function __sp_update_atime() {
	date +%s > "$1"/02-ATIME
}

# 1: mounted pad dir
function __sp_pad_enter() {
	(
	cd "$1" || return
	# shellcheck disable=2030 # subshell var scope is intended
	export PADHOME="$1"
	# TODO set history file in pad
	# TODO save env
	# TODO lockfiles
	bash
	)
}

function __sp_pad_list_metadata() {
	for f in "$SCRATCHPAD_STORAGE_DIR"/*.pad.gz; do
		local desc
		desc=$(__sp_read_description "$f" | head -n 1)
		echo "$f;$desc"
	done
}

function __sp_hook_prompt() {
	## shellcheck disable=2031 # this is only run in subshell env.
	#PS1="[PAD $(basename "$PADHOME")] $PS1"
	true
}

function __sp_hook_clear() {
	# shellcheck disable=2031 # this is only run in subshell env.
	local np="$PADHOME/notepad.md"
	test -f "$np" && head -n 5 "$np"
}

__sp_pad_choose() {
	local cnt=0
	local choices=()

	while IFS=';' read -r FILE DESC _; do
		echo "$cnt | $(basename "$FILE") | $DESC" >&2
		choices+=( "$FILE" )
		cnt=$((cnt+1))
		
	done <<< "$(__sp_pad_list_metadata | tail -n 10 | tac)"

	read -rp "?> " CHOICE _

	if [ -z "$CHOICE" ]; then
		CHOICE=0
	fi
	
	echo "${choices[$CHOICE]}"
}

# NOTE.
# user facing commands

function spls() {
	while IFS=';' read -r FILE DESC _; do
		echo "$(basename "$FILE") | $DESC"
	done <<< "$(__sp_pad_list_metadata)"
}

function spenter() {
	local pad_file pad_mnt
	pad_file=$(__sp_pad_choose)
	pad_mnt=$(__sp_genereate_mount_path "$(basename "$pad_file")" )

	__sp_mount_pad "$pad_file" "$pad_mnt"
	__sp_pad_enter "$pad_mnt"
	__sp_unmount_pad "$pad_mnt"
}

function sp() {
	# shellcheck disable=2031
	test -n "$PADHOME" && return 1

	local pad_file pad_id pad_mnt
	pad_id=$(__sp_generate_id)
	pad_file=$(__sp_genereate_file_path "$pad_id")
	pad_mnt=$(__sp_genereate_mount_path "$(basename "$pad_file")" )

	__sp_new_pad "$pad_file" "$SCRATCHPAD_TEMPLATE"

	__sp_mount_pad "$pad_file" "$pad_mnt"
	__sp_pad_enter "$pad_mnt"
	__sp_unmount_pad "$pad_mnt"
}

# NOTE we only want to be injected on prompt when we are in a pad
# shellcheck disable=2031
if [ -n "$PADHOME" ]; then
	HOOK_PROMPT+=(__sp_hook_prompt)
	HOOK_CLEAR+=(__sp_hook_clear)
	HOOK_ENTRY+=(__sp_hook_clear)
fi
