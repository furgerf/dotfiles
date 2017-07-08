""""""""""""""""""""""""""
" Markdown configuration "
""""""""""""""""""""""""""

" turn on spell-checking
setlocal spell

" convert to pdf and open
noremap <F2> :!cd "%:p:h" && pandoc -V geometry:margin=1in --latex-engine=xelatex
      \ "%:p" -o "%:p:r.pdf" && okular &> /dev/null "%:p:r.pdf" &<CR>

" convert to pdf (without opening)
noremap <F3> :!cd "%:p:h" && pandoc -V geometry:margin=1in --latex-engine=xelatex
      \ "%:p" -o "%:p:r.pdf" &<CR>

