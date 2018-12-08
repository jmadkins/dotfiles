#Load Antigen
ANTIGEN_CACHE=false
source ~/external/antigen.zsh

#Load OMZsh
antigen use oh-my-zsh

# OMZsh plugins
antigen bundle osx
antigen bundle docker

# Other Plugins
antigen bundle zsh-users/zsh-syntax-highlighting

# Apply Antigen config
antigen apply

# Spaceship theme
antigen theme denysdovhan/spaceship-prompt
SPACESHIP_KUBECONTEXT_SHOW=false
