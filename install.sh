#!/bin/bash 

# Programs:
# compton: Compositor
# xterm fo default terminal

#Configs for home dir
MODULES=(.i3 .vim .xinitrc .compton.conf .bashrc .Xresources)

#Configs for .config
CFGFOLDER=(polybar powerline nvim)

echo Configs to install: ${MODULES[@]} ${CFGFOLDER[@]}

git submodule init
git submodule update

for mod in ${MODULES[@]}; do
	echo Linking $mod
	mv ~/$mod ~/$mod.old
	ln -s $(pwd)/$mod ~/$mod
done

for mod in ${CFGFOLDER[@]}; do
	mv ~/.config/$mod ~/.config/$mod.old
	ln -s $(pwd)/$mod ~/.config/$mod
done

