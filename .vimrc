" ==============
" VIM CONFIG
" ==============

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
"  if (has("nvim"))
"  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"  endif
"  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"  if (has("termguicolors"))
"    set termguicolors
"  endif
"endif

" Load Vundle plugins
runtime! vundle.vim

let mapleader=","
set number
syntax enable

" UI Options
let g:airline_theme='one'
set background=dark
set guifont=Hack

" UI Colors
set termguicolors
" colorscheme jellybeans
colorscheme one

" =======
" MAPPINGS
" =======

" Toggle line number relative/actual
nnoremap <Leader>tn :call ToggleNumbers()<CR>

" Rspec.vim
map <Leader>sc :call RunCurrentSpecFile()<CR>
map <Leader>sa :call RunAllSpecs()<CR>

" NERDTree
map <Leader>; :NERDTreeToggle<CR>

" Move buffers shortcut
map <Leader>m <C-w>w

" Search the contents of files
map <Leader>o :Rg<CR>

" Search by file name with CtrlP plugin
let g:ctrlp_map = ',p'

" Copy into macOS keyboard
vnoremap <Leader>y "*y
vnoremap <Leader>v "*p

" Move cursor to first non-blank char
nnoremap <Leader>h ^
vnoremap <Leader>h ^

" Move cursor to last char
nnoremap <Leader>l $
vnoremap <Leader>l $

"Switch between different windows by their direction
no <C-j> <C-w>j
no <C-k> <C-w>k
no <C-l> <C-w>l
no <C-h> <C-w>h

" =======
" Text Formatting
" =======

" 100 character line length
if exists('+colorcolumn')
  set colorcolumn=100
endif

set textwidth=100

" Unix line endings
set fileformat=unix

" No line wrapping
set nowrap

" Syntax Highlighting
syntax on

" Enable the filetype plugin and indenting
filetype plugin indent on

" Fix Delay on Esc
set timeoutlen=1000 ttimeoutlen=10

" backspace should behave like backspace
:set backspace=indent,eol,start

" =======
" RANDOM
" =======

" FileType tabbing settings
" Default tabbing
" Some languages have custom tabbing, specified in their ftplugin/<name>.vim
" files
set tabstop=2 shiftwidth=2 expandtab
set shiftround      " Round to the nearest tab increment when indenting

" Keep cursor somewhat centered in screen
set scrolloff=10

" Better invisibles, should you want them
set listchars=eol:$,tab:»»

" Highlight colors for listchars and other unknowns/invisibles
hi NonText ctermfg=8
hi SpecialKey ctermfg=8

" Who needs vi compatibility anyways?
set nocompatible

" Better searching
set ignorecase  " Ignore case of searches
set smartcase   " Used with above to only ignore case when you type lowercase
set incsearch   " C-r C-w to complete search term
set hlsearch    " Highlight search

" Zsh for better compatibility
if executable('/bin/zsh')
  set shell=/bin/zsh
endif

" Disable folding
" set nofoldenable

" Better color scheme for diffing
" highlight DiffAdd      ctermfg=254 ctermbg=22
" highlight DiffDelete   ctermfg=16 ctermbg=52 cterm=bold
" highlight DiffChange   ctermfg=15 ctermbg=90
" highlight DiffText     ctermfg=16 ctermbg=3 cterm=bold

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/

" Automatically strip whitespaces from buffers before write
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Omnicompletion based on syntax
set omnifunc=syntaxcomplete#Complete

" Auto-insert when entering a terminal
if has("nvim")
  autocmd BufEnter * if bufname("%") =~ "term://" | startinsert | endif
endif

" Mouse mode, if available
if has("mouse")
  set mouse=a
endif

" Open new split panes to right and below, which feels more natural
set splitright
set splitbelow

" Templates
autocmd BufNewFile *.html 0r ~/.vim/templates/template.html
autocmd BufNewFile *.tex 0r ~/.vim/templates/template.tex

" Jump to last place in file on open
autocmd BufRead * '"

" =======
" FUNCTIONS
" =======

" More Git functions not provided by vim-fugitive
function! PushAndSetUpstream()
  let current_branch = system("git symbolic-ref --short HEAD")
  echo system("git push -u origin ".current_branch)
endfunction

function! ForcePush()
  let current_branch = system("git symbolic-ref --short HEAD")
  echo system("git push -f origin ".current_branch)
endfunction

" Settings specific to non-code editing
function! SetupForText()
  " Spell checking
  setlocal spell spelllang=en_us
  " Turn off colorcolumn
  setlocal colorcolumn=0
  " Wrap at end of screen
  setlocal wrap
  " Wrap on whitespace
  setlocal linebreak
  " Do not break lines
  setlocal textwidth=0

  "" Moving around in wrapped lines
  " Normal mode
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
  " Visual mode
  vnoremap <buffer> j gj
  vnoremap <buffer> k gk
endfunction

" Toggle between relative and non-relative line numbering
function! ToggleNumbers()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunction

" =======
" PLUGIN CONFIGS
" =======

""" Airline
" Enable airline bar all the time
set laststatus=2

" Enable powerline font for airline
let g:airline_theme='one'
let g:airline_powerline_fonts = 1

""" NerdTree
" Sshow hidden files
let NERDTreeShowHidden=1

" Ingore certain things
let NERDTreeIgnore = ['\.swp$', '\.DS_Store$']

" Fix display issue on macOS
let g:NERDTreeNodeDelimiter = "\u00a0"

" Automatically show NERDTree when launched with just `vim`, similar to launching with `vim .`
autocmd StdinReadPre * let s:std_in=120
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Technically this is global, but here set for vim-gitgutter
set updatetime=750

" Set better super tab completion
let g:SuperTabDefaultCompletionType = "context"

""" Rainbow
" Parenthesis
let g:rainbow_active = 1

let g:rainbow_conf = {
      \   'guifgs': ['royalblue3', 'seagreen3', 'darkorchid3', 'firebrick3'],
      \   'ctermfgs': ['darkcyan', 'magenta', 'green', 'darkred', 'darkmagenta', 'darkgray'],
      \   'operators': '_,_',
      \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \   'separately': {
      \       '*': {},
      \       'tex': {
      \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
      \       },
      \       'lisp': {
      \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
      \       },
      \       'vim': {
      \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
      \       },
      \       'css': 0,
      \       'html': 0,
      \   }
      \}

""" Rails
" Custom Vim Rails additions
let g:rails_projections = {
      \ "app/workers/*.rb":     {"command": "worker"},
      \ "app/jobs/*.rb":        {"command": "job"},
      \ "spec/factories/*.rb":  {"command": "factory"},
      \ "config/deploy/*.rb":   {"command": "deploy"},
      \ "config/*":             {"command": "cnf" }}

" Be passive on HTML and let me write my Angular, Meteor, etc
let g:syntastic_mode_map = { 'passive_filetypes': ['html'] }

""" CtrlP Search
" https://github.com/kien/ctrlp.vim#basic-options

" Ignore items from search
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

" Default search mode
let g:ctrlp_working_path_mode = 'ra'

""" Vim-Test
" Use Dispatch (important!)
let test#strategy = "dispatch"
