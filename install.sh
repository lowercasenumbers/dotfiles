#!/usr/bin/env zsh

# Check to make sure oh-my-zsh is installed
if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "oh-my-zsh already installed"

fi


if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="zsh"
    STOW_FOLDERS="tmux"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES 


pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    stow -D $folder
    stow $folder
done


