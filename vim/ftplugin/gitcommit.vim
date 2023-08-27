""""""""""""""""""""""""""""
" Git commit configuration "
""""""""""""""""""""""""""""

" spell-check commit messages
setlocal spell

" enforce small commit message lines
setlocal textwidth=72

" no need for line numbers
setlocal nonumber
setlocal norelativenumber

" disable shared data for git commits
if has('nvim')
  setlocal shada="NONE"
else
  setlocal viminfo="NONE"
endif

" no longer highlight past column 80
hi! OverLength none

" with nonprintable characters: let @q = '/+++ b/changelog.md^M/^+- ^Mf lYggO^R0'
let @q = '/+++ b/changelog.md/^+- f lYggO0'

