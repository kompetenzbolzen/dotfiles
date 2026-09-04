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
	tar -cf "$1" -C "$2" .
}

# 1: archive 2: pad file
function __sp_mount_pad() {
	mkdir -p "$pad_mnt" || return
	archivemount -o nobackup "$1" "$2" || return
	date +%s > "$pad_mnt"/02-ATIME
}

# 1: target
function __sp_unmount_pad() {
	fusermount -u "$1"
	rmdir "$pad_mnt"
}

# 1: pad file
function __sp_() {
	tar -xOf "$1" "00-DESCRIPTION" 2> /dev/null
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

function __sp_pad_list() {
	for f in "$SCRATCHPAD_STORAGE_DIR"/*.pad.gz; do
		local desc
		desc=$(__sp_get_description "$f" | head -n 1)
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

# NOTE we only want to be injected on prompt when we are in a pad
# shellcheck disable=2031
if [ -n "$PADHOME" ]; then
	HOOK_PROMPT+=(__sp_hook_prompt)
	HOOK_CLEAR+=(__sp_hook_clear)
fi

function sp() {
	local pad_file pad_id pad_mnt
	pad_id=$(__sp_generate_id)
	pad_file=$(__sp_genereate_file_path "$pad_id")
	pad_mnt=$(__sp_genereate_mount_path "$pad_id")

	__sp_new_pad "$pad_file" "$SCRATCHPAD_TEMPLATE"

	__sp_mount_pad "$pad_file" "$pad_mnt"

	__sp_pad_enter "$pad_mnt"

	__sp_unmount_pad "$pad_mnt"
	echo sp closed
}
