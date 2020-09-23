#!/bin/bash

# Remote access
#
# Forward local SSH server to remote host to make it accessible
# remotely without NAT/Firewall mapping

DEPENDENCIES=("sshd" "systemctl" "ssh" "ssh-keygen" "sudo")
SSH_ACCESS_PUBKEY=""
REMOTE_ADDRESS=""

for dep in ${DEPENDENCIES[@]}; do
	which $dep > /dev/null || exit 1
done

read -p "Connecting to $REMOTE_ADDRESS. Proceed? (y/[n]) > " proceed
case $proceed in
	[yY]* )
		;;
	* )
		echo Aborting.
		exit 1
esac

PORT=$(( ($RANDOM % 64000) + 1024 ))

trap 'kill -s SIGKILL $SSH_PID' 1 2 9

if [ ! -f $HOME/.ssh/id_rsa_remote ]; then
	echo No SSH Key found. Creating one.

	ssh-keygen -t rsa -N "" -C "remote key $USER@$HOSTNAME" \
		-f "$HOME/.ssh/id_rsa_remote"

	echo --- $HOME/.ssh/id_rsa_remote.pub ---
	cat $HOME/.ssh/id_rsa_remote.pub
	echo --- END ---
	
	read -p "Press ENTER to continue."
fi

# Check if key is already allowed to connect, add if not
grep -q "^$SSH_ACCESS_PUBKEY$" "$HOME/.ssh/authorized_keys" && \
	KEEP_KEY="YES" || \
	echo "$SSH_ACCESS_PUBKEY" >> "$HOME/.ssh/authorized_keys"

sudo systemctl start sshd || echo "Failed to start sshd."

ssh -R -N 22:$REMOTE_ADDRESS:$PORT &
SSH_PID=$!

echo Connected to $REMOTE_ADDRESS
echo "=> U: $USER P: $PORT"
echo CTRL+C to disconnect

while kill -s 0 $PID; do sleep 1; done

echo Connection closed.

# Remove Key from authorized_keys if it wasn't originally there
[ -z "$KEEP_KEY" ] && sed -i "\|^$SSH_ACCESS_PUBKEY$|d" \
	"$HOME/.ssh/authorized_keys"
