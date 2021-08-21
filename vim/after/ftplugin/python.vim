""""""""""""""""""""""""""""""""
" Delayed python configuration "
""""""""""""""""""""""""""""""""

" the installed plugin/python.vim assigns these locally so I have to overwrite
" them to match my vimrc
" however, I want 4-space indents in sedimentum (python) files
if stridx(expand("%:h"), "git/sedimentum") == -1 && stridx(getcwd(), "git/sedimentum") == -1
  setlocal softtabstop=2 tabstop=2 shiftwidth=2
else
  unmap <Leader>f
  nmap <Leader>f :Black<CR>
endif

