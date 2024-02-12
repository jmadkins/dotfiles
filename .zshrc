# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
#!/bin/bash
#
##Load Antigen
ANTIGEN_CACHE=false

source "$HOME/antigen.zsh"
#source <(kubectl completion zsh)

#Load OMZsh
antigen use oh-my-zsh

# OMZsh plugins
antigen bundle docker

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
  antigen bundle brew
  antigen bundle brew-cask
  antigen bundle gem
  antigen bundle osx
elif [[ $CURRENT_OS == 'Linux' ]]; then
  # None so far...
  if [[ $DISTRO == 'CentOS' ]]; then
    antigen bundle centos
  fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
  antigen bundle cygwin
fi

# GitHub Hub
if [[ -a $(which hub) ]]
then
    eval $( hub alias -s)
    alias gpr="hub pull-request"
    alias gpl="hub sync"
    alias gci="hub ci-status"
fi

# Other Plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

# Apply Antigen config
antigen apply

# Spaceship theme
antigen theme denysdovhan/spaceship-prompt
SPACESHIP_KUBECONTEXT_SHOW=false

## Inclusions
# Source aliases, if they exist
if [ -f $HOME/.aliases ]; then
  source $HOME/.aliases
fi

# Use vim as default editor
export EDITOR="vim"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

# export PATH="/opt/homebrew/sbin:$PATH"

# rbenv setup
eval "$(rbenv init - zsh)"

