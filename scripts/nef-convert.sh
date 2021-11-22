#!/bin/bash

mkdir jpg_converted
for i in *.NEF ; do
	echo "Converting $i"
	exiftool -b -JpgFromRaw "$i" > "jpg_converted/${i/%.NEF/.jpg}"
done
