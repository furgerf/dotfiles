"""""""""""""""""""""""""""""""""
" Various plugins configuration "
"""""""""""""""""""""""""""""""""
" Contains configuration for the following plugins:
" - NERDTree
" - CtrlP
" - UltiSnips
" - vim-test
" - CamelCaseMotion
" - expand-region
" - vim-interestingwords
" - vim-obsession
" - tagbar
" - startify

" NERDTree "{{{
" define map for opening NERDTree
nnoremap <Leader>n :NERDTreeToggle<CR>
" ignore certain file types - should be way more, though...
let NERDTreeIgnore = [ '\.bbl$', '\.blg$', '\.aux$', '\.bcf$', '\.dvi$',
      \ '\.lof$', '\.lot$', '\.out$', '\.pdf$', '\.toc$', '\.swp$' ]
"}}}

" CtrlP "{{{
" don't use normal file listing, use git instead
" NOTE: this may ignore files that shouldn't be ignored - maybe switch to
" using silver search or something else instead
if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor

    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
else
  let g:ctrlp_user_command = ['.git',
        \ 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
  let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
    \ }
endif
" ... that means there's no need for caching
let g:ctrlp_use_caching = 0
" ignore  some stuff
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v\/?gen|node_modules|vendor|.*-venv\/?'
  \ }
" define map for opening CtrlP for tags instead of files (probably quite slow!)
nnoremap <Leader>p :CtrlPTag<CR>
"}}}

" UltiSnips "{{{
" always look for snippets there (so UltiSnipsEdit can be used)
let g:UltiSnipsSnippetsDir="$VIMHOME/bundle/vim-snippets/UltiSnips/"
" insert snippet from trigger
let g:UltiSnipsExpandTrigger="<C-Space>"
" show all potential snippets with current trigger
let g:UltiSnipsListSnippets="<Localleader><Leader>"
"}}}

" vim-test "{{{
" setup mappings
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>tt :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
"}}}

" CamelCaseMotion "{{{
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
"}}}

" expand-region "{{{
" expand region by hitting `v`
vmap v <Plug>(expand_region_expand)
" reduce region by hitting `<C-v>`
vmap <C-v> <Plug>(expand_region_shrink)
"}}}

" vim-interestingwords "{{{
" use random colors
let g:interestingWordsRandomiseColors = 1
" call the actual function directly in normal mode to avoid a strange delay
nnoremap <leader>k :call InterestingWords('n')<CR>
" use the plugin command in visual mode
" NOTE: If there's no map for the plugin command at all, the plugin adds its
"       own mappings, overwriting `n` and `N` too in the process...
vmap <leader>k <Plug>InterestingWords
nmap <leader>K <Plug>InterestingWordsClear
" could also map these to cycle through interesting words but that is tricky
" to get right with the match highlighting and it doesn't work reliably anyway
" nmap n <Plug>InterestingWordsForeward
" nmap N <Plug>InterestingWordsBackward
"}}}

" vim-obsession "{{{
" start tracking session
nnoremap <Leader>o :Obsess<CR>
" stop tracking session and delete session file
nnoremap <Leader>O :Obsess!<CR>
"}}}

" tagbar "{{{
" toggle tagbar
nnoremap <Leader>t :TagbarToggle<CR>
"}}}

" startify "{{{
" don't CD when opening file
let g:startify_change_to_dir=0
"}}}

" rainbow_csv "{{{
" don't map any keys
let g:rcsv_map_keys=0
"}}}

" colorizer "{{{
" disable colorizer for large files - it makes startup reeeeally slow
let g:colorizer_maxlines=1000
"}}}

