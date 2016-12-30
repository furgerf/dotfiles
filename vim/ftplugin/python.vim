""""""""""""""""""""""""
" Python configuration "
""""""""""""""""""""""""

" configure the test runner (assuming I'm using nose2 for all python projects...
let test#python#runner = 'Nose2'
let test#python#nose2#options =
      \ '-F --with --coverage-report term --coverage-report html'

" execute current file with F2
" NOTE: Might want to change that mapping at some point...
nnoremap <F2> :!"%:p"<CR>

" enable folding - the default foldlevelstart of 1 is ok as it collapses
" functions (assuming they're inside a class)
set foldenable

