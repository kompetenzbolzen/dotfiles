#!/bin/bash

SESSIONNAME='main'

function check_session() {
	tmux list-sessions -F '#S' | grep "^$SESSIONNAME\$" > /dev/null 2>&1
}

function attach_session() {
	tmux attach -t "$SESSIONNAME"
}

function new_session() {
	tmux new-session -s "$SESSIONNAME" -d
}

check_session || new_session
attach_session
