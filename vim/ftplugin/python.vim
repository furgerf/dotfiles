""""""""""""""""""""""""
" Python configuration "
""""""""""""""""""""""""

" configure the test runner (assuming I'm using nose2 for all python projects...)
let test#python#runner = 'pytest'
let test#python#pytest#options = '--ignore=deps --exitfirst --failed-first --new-first'
function! DockerTransform(cmd) abort
  return ' docker-compose -f docker-compose.test.yml run --rm tests ' . a:cmd
endfunction

let g:test#custom_transformations = {'docker': function('DockerTransform')}
let g:test#transformation = 'docker'


" execute current file with F2
" NOTE: Might want to change that mapping at some point...
nnoremap <F2> :!python "%:p"<CR>

" enable folding - the default foldlevelstart of 1 is ok as it collapses
" functions (assuming they're inside a class)
setlocal foldenable
setlocal foldlevel=999
" also enable anyfold
AnyFoldActivate

" add mappings to sort imports
nnoremap <LocalLeader>i :Isort<CR>

" let g:syntastic_python_checkers = [ 'pylint' ]
let g:syntastic_check_on_open = 0

" don't indent python files...
unmap <Leader>f
nmap <Leader>f :echoerr "Don't format!!"<CR>

let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1
let g:python_highlight_func_calls = 0

let g:black_quiet = 1
let g:black_linelength = 120
let g:black_virtualenv = '~/.cache/black/virtualenv'

autocmd BufWritePre ~/git/sedimentum/*.py execute ':Black'

