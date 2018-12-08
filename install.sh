#1 /bin/bash

pwd=$(pwd)

yes_or_ask() {
  if [[ $yes == true ]]; then
    return 0
  fi

  echo $1
  read input
  if [[ $input == y* ]]; then
    return 0
  elif [[ $input == n* ]]; then
    echo $2
  else
    echo "Answer not recognized, skipping..."
  fi

  return 1
}

link_to_home() {
  echo "Linking $1 to $HOME/$1"
  if [[ $yes == true ]]; then
    ln -sf "$(pwd)/$1" "$HOME/$1"
  else
    ln -si "$(pwd)/$1" "$HOME/$1"
  fi
}

function move_if_exists() {
  if [ -e $HOME/$1 ]; then
    echo "Moving ~/$1 to ~/$1.old"
    mv -f $HOME/$1 $HOME/$1.old
  fi
}

# Link ZSH files
if type zsh &> /dev/null; then
  if [ ! -e "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh"
    curl -L "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" | sh
  fi

  link_to_home .zshrc
  link_to_home .zshenv
  link_to_home .aliases
fi

# Homebrew on Mac
if [[ $( uname ) == 'Darwin' ]]; then
  echo "Installing Homebrew..."
  if [[ ! -e /usr/local/bin/brew ]]; then
	  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  /usr/local/bin/brew tap Homebrew/bundle
  /usr/local/bin/brew bundle --file=$pwd/brewfile
  link_to_home brewfile
fi

# Link Git files
if type git &> /dev/null; then
  if yes_or_ask "You should update the name and email in '.gitconfig'. Have you done this? " "Please do so and run this again"; then
    link_to_home .gitconfig
  fi

  link_to_home .gitignore_global
fi

# Install Vundle
echo "Installing Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Link vim files
if type vim &> /dev/null; then
  link_to_home .vim
  link_to_home .vimrc
fi

echo "Installing vim plugins..."
vim +PluginInstall +qall

if [[ -e rvm ]]; then
  echo "Installing rvm..."
  \curl -sSL https://get.rvm.io | bash -s stable --ruby
fi

echo "Installing x-code tools..."
xcode-select --instal

