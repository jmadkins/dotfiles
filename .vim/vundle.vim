""" Vundle
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle your vundle
Plugin 'VundleVim/Vundle.vim'

" Aesthetics
Plugin 'bling/vim-airline'                " Vim Airline

" Parenthesis
Plugin 'luochen1990/rainbow'              " New rainbow parenthesis
Plugin 'jiangmiao/auto-pairs'             " Auto pairing
Plugin 'tpope/vim-surround'               " Vim-surround

" Git-related stuff
Plugin 'tpope/vim-git'                    " Vim-git
Plugin 'tpope/vim-fugitive'               " Git tools in Vim
Plugin 'airblade/vim-gitgutter'           " Git gutter. It's cool!

" Other excellent things
Plugin 'sheerun/vim-polyglot'             " Laguage-Specific improvments (syntax highlighting, etc)
Plugin 'scrooloose/nerdtree'              " Nerdtree
Plugin 'scrooloose/syntastic'             " Syntastic
Plugin 'tpope/vim-bundler'                " Bundler
Plugin 'tpope/vim-haml'                   " HAML
Plugin 'martinda/Jenkinsfile-vim-syntax'  " Jenkinsfile
Plugin 'tpope/vim-dotenv'                 " Dotenv
Plugin 'tpope/vim-endwise'                " Endwise
Plugin 'tpope/vim-rails'                  " Rails
Plugin 'vim-ruby/vim-ruby'                " Ruby
Plugin 'tpope/vim-commentary'             " Easy commenting
Plugin 'kien/ctrlp.vim'                   " Quick file finding
Plugin 'mileszs/ack.vim'                  " Silver searcher in Vim
Plugin 'rizzatti/dash.vim'                " Launch Dash from Vim
Plugin 'janko-m/vim-test'                 " Support for various testing frameworks
Plugin 'ervandew/supertab'                " Better tab-completion
Plugin 'tpope/vim-dispatch'               " Run tests async
Plugin 'vimwiki/vimwiki'                  " Markdown Wiki
Plugin 'junegunn/fzf'                     " Fuzzy finder
Plugin 'junegunn/fzf.vim'
Plugin 'stephpy/vim-yaml'                 " Yaml
Plugin 'easymotion/vim-easymotion'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'thoughtbot/vim-rspec'
Plugin 'bpolly/vim-ttr'
Plugin 'godlygeek/tabular'

" Color schemes
Plugin 'nanotech/jellybeans.vim'         " Darker theme
Plugin 'KeitaNakamura/neodark.vim'
Plugin 'rakr/vim-one'

" End Vundle
call vundle#end()
