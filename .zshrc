## Load Oh My ZSH
if [ -e $HOME/.oh-my-zsh ]; then
    ZSH=$HOME/.oh-my-zsh
    ZSH_THEME="agnoster"
    COMPLETION_WAITING_DOTS="true"
    plugins=(git rails bundler history-substring-search zsh-syntax-highlighting)
    source $ZSH/oh-my-zsh.sh
fi
