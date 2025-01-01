""""""""""""""""""""""""""""
" JavaScript configuration "
""""""""""""""""""""""""""""

" enable folding
setlocal foldenable

function! DockerTransform(cmd) abort
  return ' docker compose -f docker-compose.test.yml run --rm tests ' . a:cmd
endfunction

let g:test#custom_transformations = {'docker': function('DockerTransform')}
let g:test#transformation = 'docker'

nnoremap <silent> <LocalLeader>A :CocCommand editor.action.organizeImport<CR>
nnoremap <silent> <LocalLeader>i :CocCommand eslint.executeAutofix<CR>

" " setup vim-test to work with mocha as desired
" let g:test#javascript#mocha#options = {
"   \ 'file':    '--check-leaks --full-trace --inline-diffs --no-exit',
"   \ 'nearest': '--check-leaks --full-trace --inline-diffs --no-exit',
"   \ 'suite':   '--check-leaks --full-trace --inline-diffs --no-exit --recursive'
" \}

