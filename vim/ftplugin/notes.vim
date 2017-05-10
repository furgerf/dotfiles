"""""""""""""""""""""""
" Notes configuration "
"""""""""""""""""""""""

" turn on spell-check
setlocal spell

" wrap text
" setlocal textwidth=100

" enabling folding
" setlocal foldenable
" use syntax folding
" setlocal foldmethod=syntax

" no longer highlight past column 80
hi! OverLength none

" 'compile' current note
nnoremap <Localleader>nh :NoteToHtml<CR>
nnoremap <Localleader>nm :NoteToMarkdown<CR>

:call functions#TurnOnMathematicMode()

