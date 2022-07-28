# vi: ft=sh

#SA_SSH_AGENT_STATIC='no'
#SA_SSH_SOCKET="/var/run/user/$UID/ssh-agent.sock"
#SA_SSH_PIDFILE="/var/run/user/$UID/ssh-agent.pid"

if [ ! "$SA_SSH_AGENT_STATIC" = "yes" ]; then
	[ -z $SSH_AUTH_SOCK ] && eval `ssh-agent`
fi
