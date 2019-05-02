#!/bin/bash 

git submodule init
git submodule update

mv ~/.config/i3/ ~/.config/i3.old
mv ~/.vim ~/.vim.old
mv ~/.xinitrc ~/.xinitrc.old
mv ~/.config/polybar ~/.config/polybar.old

ln -s $(pwd)/.vim ~/.vim
ln -s $(pwd)/.i3 ~/.i3
ln -s $(pwd)/.xinitrc ~/.xinitrc
ln -s $(pwd)/polybar ~/.config/polybar

