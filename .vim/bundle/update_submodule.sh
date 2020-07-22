#!/bin/bash

for dir in ./*/; do 
	cd $dir
	git pull
	git checkout master
	cd ..
done
