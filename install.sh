#!/bin/bash 

mv ~/.config/i3/ ~/.config/i3.old
mv ~/.vim ~/.vim.old
mv ~/.xinitrc ~/.xinitrc.old

ln -s $(pwd)/.vim ~/.vim
ln -s $(pwd)/.i3 ~/.i3
ln -s $(pwd)/.xinitrc ~/.xinitrc
