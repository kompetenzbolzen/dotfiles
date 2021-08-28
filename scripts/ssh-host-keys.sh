#!/bin/bash

for host in "$@"; do
	ssh-keyscan -t rsa "$host" 2> /dev/null | ssh-keygen -lf -
done
