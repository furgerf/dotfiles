"""""""""""""""""""
" C configuration "
"""""""""""""""""""

" compile
noremap <F2> :!gcc -o "%:p:r.out" "%:p" && "%:p:r.out"<CR>

