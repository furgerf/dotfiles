"""""""""""""""""""""
" Cpp configuration "
"""""""""""""""""""""

" compile
noremap <F2> :!g++ -std=c++11 -pthread -o "%:p:r.out" "%:p" && "%:p:r.out"<CR>
noremap <Localleader>mm :!make<CR>
noremap <Localleader>mc :!make clean<CR>
noremap <Localleader>ma :!make && make clean<CR>

" enable folding
setlocal foldenable

