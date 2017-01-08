"""""""""""""""""""""""
" Notes configuration "
"""""""""""""""""""""""

" turn on spell-check
setlocal spell

" wrap text
setlocal textwidth=80

" enabling folding
" setlocal foldenable
" use syntax folding
" setlocal foldmethod=syntax

" 'compile' current note
nnoremap <Localleader>nh :NoteToHtml<CR>
nnoremap <Localleader>nm :NoteToMarkdown<CR>

