#!/bin/bash

for dir in ./*/; do 
	cd $dir
	git pull
	git checkout origin/HEAD
	cd ..
done
