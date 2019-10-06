#!/bin/bash 

# Programs:
# compton: Compositor
# xterm fo default terminal

#Configs for home dir
MODULES=(.i3 .vim .xinitrc .compton.conf .bashrc .Xresources .radare2rc .bash_profile)

#Configs for .config
CFGFOLDER=(polybar powerline nvim termite twmn)

#Scripts
SCRIPTS=()

#1: message
yes_no()
{
	read -p "$1 (y/[n])" inp
	case $inp in
		[yY]* ) return 1;;
		* ) 	return 0;;
	esac
}

#1: source 2: destination
link()
{
	if [ -e $2 ]
	then
		yes_no "$(basename $2) exists. Overwrite?"
		if [ $? -eq 0 ]
		then
			return
		fi

		if [ -d $2 ]
		then
			rm -R $2
		else
			rm $2
		fi
	fi

	ln -s "$1" "$2"
}

echo Configs to install: ${MODULES[@]} ${CFGFOLDER[@]}

git submodule init
git submodule update

for mod in ${MODULES[@]}; do
	yes_no "Install $mod?"
	#ln -s --backup $(pwd)/$mod/ ~/$mod/
	if [ $? -eq 1 ]
	then
		link "$(pwd)/$(dirname $0)/$mod" "$HOME/$mod"
	fi
done

for mod in ${CFGFOLDER[@]}; do
	#ln -s --backup $(pwd)/$mod/ ~/.config/$mod/
	yes_no "Install $mod?"
	if [ $? -eq 1 ]
	then
		link "$(pwd)/$(dirname $0)/$mod" "$HOME/.config/$mod"
	fi
done

