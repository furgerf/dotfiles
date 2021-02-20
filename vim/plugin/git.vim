"""""""""""""""""""""
" Git configuration "
"""""""""""""""""""""
" Contains configuration for:
" - GitGutter
" - Fugitive
" - general git-related configuration

" GitGutter "{{{
" move to next hunk
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" I'll map my own keys
let g:gitgutter_map_keys=0
nmap <Leader>hh <Plug>(GitGutterNextHunk)
nmap <Leader>ha <Plug>(GitGutterStageHunk)
nmap <Leader>hr <Plug>(GitGutterUndoHunk)
nmap <Leader>hv <Plug>(GitGutterPreviewHunk)
"}}}

" Fugitive "{{{
" delete all fugitive buffers as soon as the're no longer displayed
autocmd! BufReadPost fugitive://* set bufhidden=delete
" use vertical diff by default - note that this is a vim option
set diffopt+=vertical
" add a bunch of mappings
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gl :Glog<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gc :Gcommit<CR>
" nnoremap <Leader>gm :Gmove<CR>
" nnoremap <Leader>grm :Gremove<CR>
"}}}

" General "{{{
" tell vim to also check for tags in .git
set tags+=.git/tags
"}}}

