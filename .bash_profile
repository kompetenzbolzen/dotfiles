# vi:syntax=sh
#
# .bash_profile
#

if [[ -f ~/.files ]]; then
	source ~/.files
else
	DOTFILEBASE="/home/jonas/dotfiles"
fi

for f in $DOTFILEBASE/bash/*.profile ; do
	source $f
done

if [[ -f ~/.bashrc ]]; then
	source ~/.bashrc
fi
