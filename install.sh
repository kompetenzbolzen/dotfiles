#!/bin/bash 

#Configs for home dir
CFGS=(.i3 .vim .xinitrc .compton.conf .bashrc .Xresources .radare2rc .bash_profile)

#Configs for .config
CFGFOLDER=(polybar powerline nvim termite twmn fish)

#Scripts
SCRIPTS=()

#1: message
yes_no()
{
	read -p "$1 (y/[n])" inp
	case $inp in
		[yY]* ) return 0;;
		* ) 	return 1;;
	esac
}

selector()
{
	local cnt=0
	for i in "$@"
	do
		echo "$cnt) $i"
		((cnt=$cnt + 1))
	done

	read -p "(default=0) >" inp
	if [[ "$inp" =~ ^-?[0-9]+\$ ]] && [ $inp -ge 0 -a $inp -le $# ]
	then
		return $inp
	elif [ -z $inp ]
	then
		return 0
	else
		return -1
	fi

}

#1: source 2: destination
link()
{
	if [ -e $2 ]
	then
		if yes_no "$(basename $2) exists. Overwrite?"
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


if [ $# -gt 0 ]
then
	for i in "$@"
	do
		echo "Install $i to"
		if [ -e $i ]
		then
			selector "~" "~/.config" "Custom location" "Abort"
			case $? in
			0)
				echo "~"
				break;;
			1)
				echo .config
				break;;
			2)
				echo custom
				break;;
			*)
				echo Abort.
				break;;
			esac
		else
			echo $i does not exist. Skipping.
		fi

	done
	exit 0
fi

WORKDIR=$(dirname $0)
cd $WORKDIR
echo Working in $WORKDIR
echo Homedir is $HOME
echo Available: ${CFGS[@]} ${CFGFOLDER[@]}

git submodule init
git submodule update

for mod in "${CFGS[@]}"; do
	if yes_no "Install $mod?"
	then
		link "$(pwd)/$mod" "$HOME/$mod"
	fi
done

for mod in "${CFGFOLDER[@]}"; do
	if yes_no "Install $mod?"
	then
		link "$(pwd)/$mod" "$HOME/.config/$mod"
	fi
done

#.files is used to tell scripts where to look for the dotfiles
if yes_no "Generate '.files'?"; then
	echo "DOTFILEBASE=\"$(pwd)\"" > $HOME/.files
fi

