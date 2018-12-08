""" Load Vundle plugins
runtime! vundle.vim

""" Set leader to ,
let mapleader=","

""" FileType tabbing settings
" Default tabbing
" Some languages have custom tabbing, specified in their ftplugin/<name>.vim
" files
set tabstop=2 shiftwidth=2 expandtab
set shiftround      " Don't think anyone would disagree here

""" Keep cursor somewhat centered in screen
set scrolloff=5

""" Better invisibles, should you want them
set listchars=eol:$,tab:»»,space:·

""" Highlight colors for listchars and other unknowns/invisibles
hi NonText ctermfg=8
hi SpecialKey ctermfg=8

""" Who needs vi compatibility anyways?
set nocompatible

""" Better searching
set ignorecase  " Ignore case of searches
set smartcase   " Used with above to only ignore case when you type lowercase
set incsearch   " C-r C-w to complete search term
set hlsearch    " Highlight search

""" Show where the 120 character limit is
"" Enforce it with 'textwidth'
if exists('+colorcolumn')
  set colorcolumn=120
endif
set textwidth=120

""" Unix line endings
set fileformat=unix

""" No line wrapping
set nowrap

""" Syntax Highlighting
syntax on

""" Enable the filetype plugin and indenting
filetype plugin indent on

""" Set vim to use 256 colors (Tmux/Vim Airline fix)
set t_Co=256

""" Zsh for better compatibility (I use fish shell)
if executable('/bin/zsh')
  set shell=/bin/zsh
endif

""" Folding
set foldmethod=indent                 " Fold on indent, naturally
set foldlevelstart=20                 " Start basically all unfolded

""" GUI Configs
set termguicolors
colorschem jellybeans
set guifont=Hack

""" Better color scheme for diffing
hi DiffAdd      ctermfg=254 ctermbg=22
hi DiffDelete   ctermfg=16 ctermbg=52 cterm=bold
hi DiffChange   ctermfg=15 ctermbg=90
hi DiffText     ctermfg=16 ctermbg=3 cterm=bold

""" More Git functions not provided by vim-fugitive
function! PushAndSetUpstream()
  let current_branch = system("git symbolic-ref --short HEAD")
  echo system("git push -u origin ".current_branch)
endfunction

function! ForcePush()
  let current_branch = system("git symbolic-ref --short HEAD")
  echo system("git push -f origin ".current_branch)
endfunction

""" Settings specific to non-code editing
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

""" Toggle between relative and non-relative line numbering
function! ToggleNumbers()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunction

""" Trailing whitespace

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace guibg=red
autocmd BufEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhiteSpace /\s\+$/

""" Completion

" Omnicompletion based on syntax
set omnifunc=syntaxcomplete#Complete

""" Auto-insert when entering a terminal
if has("nvim")
  autocmd BufEnter * if bufname("%") =~ "term://" | startinsert | endif
endif

""" Mouse mode, if available
if has("mouse")
  set mouse=a
endif

""" Open new split panes to right and below, which feels more natural
set splitright
set splitbelow

"" Templates
autocmd BufNewFile *.html 0r ~/.vim/templates/template.html
autocmd BufNewFile *.tex 0r ~/.vim/templates/template.tex

""" Jump to last place in file on open
autocmd BufRead * '"

""" Mappings

"" All modes
" Toggle Numbers
noremap :tn :call ToggleNumbers()<CR>

"" Normal mode
" NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
" Rails commands
nnoremap <Leader>rc :Rails console<CR>

""" Plugin configs

" NERDTree show hidden files
let NERDTreeShowHidden=1
" But not Vim swap files
let NERDTreeIgnore = ['\.swp$']

" Enable airline bar all the time
set laststatus=2

" Enable powerline font for airline
let g:airline_powerline_fonts = 1
let g:airline_section_gutter = '%= %{strftime("%R")}'

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

" Technically this is global, but here set for vim-gitgutter
set updatetime=750

" Set better super tab completion
let g:SuperTabDefaultCompletionType = "context"

" Set Vim-Test to use Dispatch (important!)
let test#strategy = "dispatch"
