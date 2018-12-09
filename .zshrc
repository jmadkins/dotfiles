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

