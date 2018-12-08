" 4-space tabs
setlocal shiftwidth=4 tabstop=4

" Set color column to be at 120
" Enforce it as well
if exists("+colorcolumn")
  setlocal colorcolumn=120
  setlocal textwidth=120
end
