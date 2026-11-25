#!/bin/bash
#
##Load Antigen
ANTIGEN_CACHE=false

source "$HOME/antigen.zsh"

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
SPACESHIP_DOCKER_COMPOSE_SHOW=false

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

# export PATH="/opt/homebrew/sbin:$PATH"

# rbenv setup
eval "$(rbenv init - zsh)"
export PATH="$HOME/.local/bin:$PATH"

# GitHub MCP server (Claude Code github plugin) — reuse the gh CLI's token
if type gh &> /dev/null; then
  export GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token 2> /dev/null)"
fi
