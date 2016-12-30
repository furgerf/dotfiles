""""""""""""""""""""""""
" BibTeX configuration "
""""""""""""""""""""""""

" compile
noremap <F2> :!cd "%:p:h" && for i in *.aux; do bibtex $i; done<CR>

