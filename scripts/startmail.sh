#!/bin/bash

SESSIONNAME='neomutt'
INTERVAL=30

function check_session() {
	tmux list-sessions -F '#S' | grep '^neomutt$' > /dev/null 2>&1
}

function attach_session() {
	tmux attach -t "$SESSIONNAME:neomutt"
}

function new_session() {
	tmux new-session -s "$SESSIONNAME" -n 'neomutt' -d "bash -c 'while true; do neomutt; done'"
	tmux new-window -n "mbsync" -t ${SESSIONNAME}: "bash -c 'while true; do mbsync -a; sleep $INTERVAL; done'"
}

check_session || new_session
attach_session
