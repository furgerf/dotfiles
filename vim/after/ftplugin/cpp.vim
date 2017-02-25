"""""""""""""""""""""
" Cpp configuration "
"""""""""""""""""""""

" compile
noremap <F2> :!g++ -std=c++11 -pthread -o "%:p:r.out" "%:p" && "%:p:r.out"<CR>

" enable folding
setlocal foldenable

