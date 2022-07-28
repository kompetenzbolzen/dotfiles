# vi:syntax=sh
#
# .bash_profile
#

if [[ -f ~/.files ]]; then
	source ~/.files
else
	DOTFILEBASE="/home/jonas/dotfiles"
fi

source "$DOTFILEBASE/config.default"
if [ -f "$HOME/.files.config" ]; then
	source "$HOME/.files.config"
fi

for f in $DOTFILEBASE/bash/*.profile ; do
	source $f
done

if [[ -f ~/.bashrc ]]; then
	source ~/.bashrc
fi
