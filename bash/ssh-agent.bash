# vi: ft=sh

#SA_SSH_AGENT_STATIC='no'
#SA_SSH_SOCKET="/var/run/user/$UID/ssh-agent.sock"
#SA_SSH_PIDFILE="/var/run/user/$UID/ssh-agent.pid"

# For use with graphical logins when DEs don't provide an agent
# Flatpak versions of KeePassXC don't allow file access to /var/run. Allow with:
# $ flatpak override org.keepassxc.KeePassXC --user --filesystem=/run/user/$UID/ssh-agent.sock
# Caution: /var/run symlinks to /run. Flatpak for some reason does not resolve symlinks.

if [ "$SA_SSH_AGENT_STATIC"="yes" ]; then
	AGENT_PID=''
	if [ -e "$SA_SSH_PIDFILE" ]; then
		AGENT_PID=$(cat $SA_SSH_PIDFILE)
	fi

	if [ -z  "$AGENT_PID" ] || ! kill -s 0 $AGENT_PID > /dev/null 2>&1; then
		echo "Agent not running. creating one."
		eval $(ssh-agent -s -a $SA_SSH_SOCKET)

		echo "PID: $SSH_AGENT_PID"
		echo "$SSH_AGENT_PID" > "$SA_SSH_PIDFILE"
	else
		echo "Using existing Agent"
		export SSH_AUTH_SOCK="$SA_SSH_SOCKET"
	fi
fi

unset AGENT_PID
