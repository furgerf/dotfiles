""""""""""""""""""""""""
" Python configuration "
""""""""""""""""""""""""

" configure the test runner (assuming I'm using nose2 for all python projects...)
let test#python#runner = 'pytest'
let test#python#pytest#options = '--ignore=deps --exitfirst --failed-first --new-first -vv'
let test#python#pytest#file_pattern = '\v(test_[^/]+|[^/]+_tests)\.py$'
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
nnoremap <LocalLeader>i :CocCommand python.sortImports<CR>

" let g:syntastic_python_checkers = [ 'pylint' ]
let g:syntastic_check_on_open = 0

setlocal spell

let g:python_highlight_all = 1
let g:python_highlight_file_headers_as_comments = 1
let g:python_highlight_func_calls = 0

