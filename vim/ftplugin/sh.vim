"""""""""""""""""""""""
" Shell configuration "
"""""""""""""""""""""""

" run script
noremap <F2> :!"%:p"<CR>

" NOT enabling folding - because there seems to be a problem with the `expr`
" foldmethod used by vim-anyfold
" `syntax` seems to work but that seems to get overwritten each time
" however, so far I didn't really need it so whatever I guess...

