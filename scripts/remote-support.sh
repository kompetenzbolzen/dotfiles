#!/bin/bash

# Remote access

DEPENDENCIES=("sshd" "systemctl" "ssh" "ssh-keygen" "sudo")
SSH_ACCESS_PUBKEY=""
REMOTE_ADDRESS=""

for dep in ${DEPENDENCIES[@]}; do
	which $dep > /dev/null || exit 1
done

PORT=$(( ($RANDOM % 64000) + 1024 ))

trap 'kill -s SIGKILL $SSH_PID' 1 2 9

if [ ! -f $HOME/.ssh/id_rsa_remote ]; then
	echo No SSH Key found. Creating one.

	ssh-keygen -t rsa -N "" -C "remote key $USER@$HOSTNAME" \
		-f "$HOME/.ssh/id_rsa_remote"

	echo ---
	cat $HOME/.ssh/id_rsa_remote.pub
	echo ---
	
	read -p "Press ENTER to continue."
fi

grep -q "^$SSH_ACCESS_PUBKEY$" "$HOME/.ssh/authorized_keys" && \
	KEEP_KEY="YES" || \
	echo "$SSH_ACCESS_PUBKEY" >> "$HOME/.ssh/authorized_keys"

sudo systemctl start sshd || echo "Failed to start sshd"

ssh -R -N 22:$REMOTE_ADDRESS:$PORT &
SSH_PID=$!

echo Connected to $REMOTE_ADDRESS
echo "=> U: $USER P: $PORT"
echo CTRL+C to disconnect

while kill -s 0 $PID; do sleep 1; done

echo Connection closed.

[ -z "$KEEP_KEY" ] && sed -i "\|^$SSH_ACCESS_PUBKEY$|d" \
	"$HOME/.ssh/authorized_keys"
