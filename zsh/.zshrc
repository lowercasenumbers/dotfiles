export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="lowercasenumbers"

plugins=(git)

source $ZSH/oh-my-zsh.sh

#User Configuration
source ~/.zsh_profile


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
