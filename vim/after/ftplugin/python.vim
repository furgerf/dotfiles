""""""""""""""""""""""""
" Python configuration "
""""""""""""""""""""""""

" the installed plugin/python.vim assigns these locally so I have to overwrite
" them to match my vimrc
setlocal softtabstop=2 tabstop=2 shiftwidth=2

" configure the test runner (assuming I'm using nose2 for all python projects...
let test#python#runner = 'Nose2'
let test#python#nose2#options =
      \ '-F --with --coverage-report term --coverage-report html'

" execute current file with F2
" NOTE: Might want to change that mapping at some point...
nnoremap <F2> :!"%:p"<CR>
