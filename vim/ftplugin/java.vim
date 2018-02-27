""""""""""""""""""""""
" Java configuration "
""""""""""""""""""""""

" run 'main' class
nnoremap <F2> :Java<CR>
" run current file
nnoremap <F3> :Java %<CR>

" organize imports
nnoremap <localleader>i :JavaImportOrganize<CR>
" open the project settings (e.g. to set the 'main' class)
nnoremap <localleader>s :ProjectSettings<CR>

" create new project
nnoremap <localleader>c :ProjectCreate . -n java<CR>

" check if connected to an eclim instance
nnoremap <localleader>p :PingEclim<CR>

set foldmethod=syntax

