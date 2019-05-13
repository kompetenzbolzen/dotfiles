#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If running in xterm set transparency
#[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null
#MOVED TO COMPTON CONF

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
