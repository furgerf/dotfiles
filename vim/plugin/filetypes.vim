" <Plug> rainbow_csv {{{
" don't map any keys
let g:rcsv_map_keys=0
"}}}

" <Plug> mathematic.vim {{{
" turn on mathematic keymap and increase timeoutlen
noremap <silent> <LocalLeader>mm :call functions#TurnOnMathematicMode()<CR>
" turn off mathematic keymap and decrease timeoutlen
noremap <silent> <LocalLeader>mn :call functions#TurnOffMathematicMode()<CR>
" show keymaps
noremap <LocalLeader>ms :sp ~/git/dotfiles/vim/bundle/mathematic.vim/keymap/mathematic.vim<CR>
" run key helper (to insert single special key)
nnoremap <LocalLeader>kh :KeyHelper<CR>
inoremap <LocalLeader>kh <Esc>:KeyHelper<CR>
"}}}

" <Plug> vim-notes {{{
" by default, use parent directory
" but also use subdirectories (and their index notes)
let g:notes_directories = [
      \ '~/SynologyDrive/fabian/Misc/Notes'
      \ ]

" append .txt for windows
let g:notes_suffix = '.txt'

" prompt about renaming file/changing title (for now)
" let g:notes_title_sync = 'one of: no|change_title|rename_file'

" DON'T disable the ugly 'smart' quotes because that also disables the bullet
" points, arrows, etc.
" let g:notes_smart_quotes = 0

" change the ruler to something that makes a bit more sense
let g:notes_ruler_text = repeat("*", 80)

" don't (un-)indent with alt-left/right
let g:notes_alt_indents = 0

nnoremap <Leader>no :Note 
nnoremap <Leader>nn viw:SplitNoteFromSelectedText<CR>
nnoremap <Leader>ns :SearchNotes 
nnoremap <Leader>nr :RelatedNotes<CR>
nnoremap <Leader>nm :RecentNotes<CR>
nnoremap <Leader>ni :ShowTaggedNotes<CR> " 'notes index'
"}}}

