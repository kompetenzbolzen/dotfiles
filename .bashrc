#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If running in xterm set transparency
#[ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null
#MOVED TO COMPTON CONF

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. /usr/share/powerline/bindings/bash/powerline.sh

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
