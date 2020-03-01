#!/bin/bash

# Backup GPG keys as DMTX for offline backup

# Generates key-aa, key-ab, ...
gpg --export-secret-key --armor $1 | split -b 1500 - key-

# Convert each of them to a PNG image
for K in key-*; do
    dmtxwrite -e 8 $K > $K.png
done
