#!/bin/bash

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

copy_to_home() {
  move_if_exists $1
  cp "$(pwd)/$1" "$HOME/$1"
}

move_if_exists() {
  if [ -e $HOME/$1 ]; then
    echo "Moving ~/$1 to ~/$1.old"
    mv -f $HOME/$1 $HOME/$1.old
  fi
}

# Link ZSH files
if type zsh &> /dev/null; then
  if [ ! -e "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    curl -L "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" | sh
  fi

  link_to_home .zshrc
  link_to_home .zshenv
  link_to_home .aliases
  copy_to_home antigen.zsh # I'd like to just create a symlink but zsh complains of too many symbolic links :(
fi

# Homebrew on Mac
if [[ $( uname ) == 'Darwin' ]]; then
  # Apple Silicon installs to /opt/homebrew, Intel to /usr/local
  if ! type brew &> /dev/null; then
    for prefix in /opt/homebrew /usr/local; do
      [[ -x "$prefix/bin/brew" ]] && eval "$("$prefix/bin/brew" shellenv)" && break
    done
  fi

  if ! type brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    for prefix in /opt/homebrew /usr/local; do
      [[ -x "$prefix/bin/brew" ]] && eval "$("$prefix/bin/brew" shellenv)" && break
    done
  fi

  brew bundle --file="$pwd/brewfile"
  link_to_home brewfile
fi

# Link Git files
if type git &> /dev/null; then
  link_to_home .gitconfig
  link_to_home .gitignore_global
fi

# Link vim files
if type vim &> /dev/null; then
  link_to_home .vim
  link_to_home .vimrc
fi

# Link Claude Code personal instructions
mkdir -p "$HOME/.claude"
echo "Linking claude/CLAUDE.md to $HOME/.claude/CLAUDE.md"
ln -sf "$(pwd)/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
echo "Linking claude/rails.md to $HOME/.claude/rails.md"
ln -sf "$(pwd)/claude/rails.md" "$HOME/.claude/rails.md"

# Link Emacs files (individually, so packages and history stay out of the repo)
if type emacs &> /dev/null; then
  mkdir -p "$HOME/.emacs.d"
  link_to_home .emacs.d/early-init.el
  link_to_home .emacs.d/init.el
  link_to_home .emacs.d/learn-emacs.org

  echo "Installing Emacs packages and tree-sitter grammars..."
  emacs --batch \
    -l "$HOME/.emacs.d/early-init.el" -l "$HOME/.emacs.d/init.el" \
    --eval "(let ((treesit-auto-langs '(ruby yaml json javascript typescript tsx css html bash))) (cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest _) t))) (treesit-auto-install-all)))" \
    > /dev/null 2>&1 \
    && echo "Emacs is ready." \
    || echo "Emacs bootstrap failed; packages will install on first launch."
fi

# Install Vundle
echo "Installing Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing vim plugins..."
vim +PluginInstall +qall

if ! xcode-select -p &> /dev/null; then
  echo "Installing x-code tools..."
  xcode-select --install
fi

# Link Helix config
if type hx &> /dev/null; then
  mkdir -p "$HOME/.config"
  if [ -d "$HOME/.config/helix" ] && [ ! -L "$HOME/.config/helix" ]; then
    move_if_exists .config/helix
  fi
  echo "Linking helix to $HOME/.config/helix"
  ln -sfn "$(pwd)/helix" "$HOME/.config/helix"
fi
