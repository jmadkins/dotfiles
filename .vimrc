" ==============
" VIM CONFIG
" ==============

" Load Vundle plugins
runtime! vundle.vim

let mapleader=","
set number

" UI Colors
set termguicolors
colorscheme jellybeans
set guifont=Hack

" =======
" MAPPINGS
" =======

" Toggle line number relative/actual
nnoremap <Leader>tn :call ToggleNumbers()<CR>

" Rspec.vim
map <Leader>sc :call RunCurrentSpecFile()<CR>
map <Leader>sa :call RunAllSpecs()<CR>

" NERDTree
map <F5> :NERDTreeToggle<CR>

" Move buffers shortcut
map <F6> <C-w>w

" Search the contents of files
map <F7> :Rg<CR>

" Copy into macOS keyboard
vnoremap <Leader>y "*y

" Move cursor to first non-blank char
nnoremap <Leader>h ^
vnoremap <Leader>h ^

" Move cursor to last char
nnoremap <Leader>l $
vnoremap <Leader>l $

" F2 => Save
nnoremap <F2> :w<CR>
inoremap <F2> <ESC>:w<CR>
vnoremap <F2> <ESC>:w<CR>

" F3 => Save and Exit
nnoremap <F3> :wq<CR>
inoremap <F3> <ESC>:wq<CR>
vnoremap <F3> <ESC>:wq<CR>

" F4 => Exit
nnoremap <F4> :q!<CR>
inoremap <F4> <ESC>:q!<CR>
vnoremap <F4> <ESC>:q!<CR>

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
set nofoldenable

" Better color scheme for diffing
hi DiffAdd      ctermfg=254 ctermbg=22
hi DiffDelete   ctermfg=16 ctermbg=52 cterm=bold
hi DiffChange   ctermfg=15 ctermbg=90
hi DiffText     ctermfg=16 ctermbg=3 cterm=bold

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

" Automatically show NERDTree when launched with just `vim`, similar to launching with `vim .`
autocmd StdinReadPre * let s:std_in=120
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

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

" Enable airline bar all the time
set laststatus=2

" NERDTree show hidden files
let NERDTreeShowHidden=1
" But not these things...
let NERDTreeIgnore = ['\.swp$', '\.DS_Store$']
let g:NERDTreeNodeDelimiter = "\u00a0"

" Enable powerline font for airline
let g:airline_powerline_fonts = 1

" Rainbow parenthesis
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

" Custom Vim Rails additions
let g:rails_projections = {
      \ "app/workers/*.rb":     {"command": "worker"},
      \ "app/jobs/*.rb":        {"command": "job"},
      \ "spec/factories/*.rb":  {"command": "factory"},
      \ "config/deploy/*.rb":   {"command": "deploy"},
      \ "config/*":             {"command": "cnf" }}

" Be passive on HTML and let me write my Angular, Meteor, etc
let g:syntastic_mode_map = { 'passive_filetypes': ['html'] }

" Remap CtrlP search -- <Leader>, doesn't work
let g:ctrlp_map = ',p'

" Ignore some things with ctrlp search
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_working_path_mode = 'ra' " https://github.com/kien/ctrlp.vim#basic-options

" Technically this is global, but here set for vim-gitgutter
set updatetime=750

" Set better super tab completion
let g:SuperTabDefaultCompletionType = "context"

" Set Vim-Test to use Dispatch (important!)
let test#strategy = "dispatch"
