""""""""""""""""""""""""
" Python configuration "
""""""""""""""""""""""""

" configure the test runner (assuming I'm using nose2 for all python projects...)
let test#python#runner = 'Nose2'
let test#python#nose2#options = '-F'

" execute current file with F2
" NOTE: Might want to change that mapping at some point...
nnoremap <F2> :!python "%:p"<CR>

" enable folding - the default foldlevelstart of 1 is ok as it collapses
" functions (assuming they're inside a class)
setlocal foldenable
setlocal foldlevel=999
" also enable anyfold
let anyfold_activate=1

" add mappings to sort imports
nnoremap <LocalLeader>i :Isort<CR>

" let g:syntastic_python_checkers = [ 'pylint' ]
let g:syntastic_check_on_open = 0

" don't indent python files...
unmap <Leader>f
nmap <Leader>f :echoerr "Don't format!!"<CR>

