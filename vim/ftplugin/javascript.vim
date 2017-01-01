""""""""""""""""""""""""""""
" JavaScript configuration "
""""""""""""""""""""""""""""

" add maps to easily insert commas/semicolons
nnoremap <leader>, :CommaOrSemiColon<CR>
inoremap <leader>, <c-o>:CommaOrSemiColon<CR>

" enable folding
setlocal foldenable

" setup vim-test to work with mocha as desired
let g:test#javascript#mocha#options = {
  \ 'file':    '--check-leaks --full-trace --inline-diffs --no-exit',
  \ 'nearest': '--check-leaks --full-trace --inline-diffs --no-exit',
  \ 'suite':   '--check-leaks --full-trace --inline-diffs --no-exit --recursive'
\}

