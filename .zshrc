#Load Antigen
ANTIGEN_CACHE=false
source ~/external/antigen.zsh

#Load OMZsh
antigen use oh-my-zsh
antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship

# OMZsh plugins
antigen bundle osx
antigen bundle docker

# Other Plugins
antigen bundle zsh-users/zsh-syntax-highlighting

# Apply Antigen config
antigen apply

# Spaceship stuff
SPACESHIP_KUBECONTEXT_SHOW=false
