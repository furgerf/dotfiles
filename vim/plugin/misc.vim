" Open, save, close, ... {{{
" use common Ctrl-shortcuts
" NOTE: <C-o> isn't mapped because that's more useful for the jumplist
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <C-c> :q<CR>
nnoremap <C-q> :qa<CR>

" save (and/or) close
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>x :x<CR>
nnoremap <Leader>w :w<CR>

" edit another file in the same directory as the current file
nnoremap <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
nnoremap <Leader>sh :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <Leader>sv :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>

" open alternate file in split
nnoremap <Leader>shl :split #<CR>
nnoremap <Leader>svl :vnew #<CR>

" allow saving files as sudo
cnoremap w!! w !sudo tee % > /dev/null

" Backspace deletes buffer.
nnoremap <silent> <BS> :call functions#DeleteBufferOrExit()<CR>
nnoremap <silent> <Leader><BS> :call functions#DeleteInactiveBuffers()<CR>
nnoremap <silent> <Localleader><BS> :%bd \| e#<CR>

noremap <silent> <F5> :e<CR>
noremap <silent> <Leader><F5> :windo :e<CR>
"}}}

" Split undo sequence while typing {{{
inoremap . .<C-g>u
inoremap ? ?<C-g>u
inoremap ! !<C-g>u
inoremap , ,<C-g>u
"}}}

" Misc {{{
" edit/source vimrc
nnoremap <Leader>vim :e $MYVIMRC<CR>
nnoremap <Leader>ss :so $MYVIMRC<CR>

" rename file (prompts for new filename)
nnoremap <Leader>frn :call functions#RenameFile()<CR>

" close preview, quickfix, location list
" NOTE: Since the location list is local to the window, only the one in the current window is closed
" The function `functions#ToggleErrors` could be adapted to close all location lists
nnoremap <silent> <Leader><Localleader> :call functions#CloseExtraBuffers()<CR>

" simple get/put for diff
nnoremap <Leader>dg do
vnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp dp
vnoremap <Leader>dp :diffput<CR>

" restore equal layout
nnoremap <Leader>Z <C-w>=

" remove trailing whitelines
nnoremap <Leader>rw :%s/\s\+$//<cr>:nohlsearch<cr>
" convert tabs to whitespace
nnoremap <Leader>cw :%s/\t/  /g<cr>:nohlsearch<cr>

" convert tabs to spaces
nnoremap <Leader>rt :retab<CR>
vnoremap <Leader>rt :retab<CR>

" indent file - TODO replace with autoformat
nnoremap <Leader>ri mzgg=G`z

" rewire n and N to highlight the current match - TODO fix?
nnoremap <silent> n nzv:call functions#HighlightNext(0.2)<CR>
nnoremap <silent> N Nzv:call functions#HighlightNext(0.2)<CR>

" start opening help (manual)
nnoremap <Leader>h<Space> :tab help 

" use F6 to toggle local spellchecking
nnoremap <F6> :setlocal spell!<CR>

" execute macro in q
nnoremap Q @q

" use magic regex mode by default
"nnoremap / /\v

" calculate stats on numbers like sum, avg, ...
vnoremap <expr> ++ VMATH_YankAndAnalyse()
nmap ++ vip++
"}}}

" <Plug> vim-fugitive {{{
" delete all fugitive buffers as soon as the're no longer displayed
autocmd! BufReadPost fugitive://* set bufhidden=delete
" use vertical diff by default - note that this is a vim option
set diffopt+=vertical
" add a bunch of mappings
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gs :Git<CR>
nnoremap <Leader>gl :Gclog<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gc :Git commit<CR>
" nnoremap <Leader>gm :Gmove<CR>
" nnoremap <Leader>grm :Gremove<CR>
nnoremap <Leader>gg :G 
"}}}

" <Plug> vim-obsession {{{
" start tracking session
" nnoremap <Leader>o :Obsess<CR>
" start/stop tracking session (and delete session file)
nnoremap <Leader>O :Obsess!<CR>
" store less often for better performance
" let g:obsession_no_bufenter = 1
"}}}

" <Plug> syntastic {{{
" keep updating the location list
let g:syntastic_always_populate_loc_list = 1

" open location list when there are errors and close when there are none
" let g:syntastic_auto_loc_list = 1

" check for errors when opening file and don't check when writing AND closing
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" aggregate errors from different checkers
let g:syntastic_aggregate_errors = 1

" allow shellcheck to follow external source files
let g:syntastic_sh_shellcheck_args = "-x"

" configure python checking
let g:syntastic_python_checkers = []

" TODO statusline
" TODO priority of messages greater than gitgutter?

" syntastic mappings
nnoremap <Leader>se :Errors<CR>
nnoremap <Leader>sm :SyntasticToggleMode<CR>
nnoremap <Leader>sc :SyntasticCheck<CR>
nnoremap <Leader>si :SyntasticInfo<CR>
"}}}

" <Plug> startify {{{
" don't CD when opening file
let g:startify_change_to_dir=0
"}}}

" <Plug> tagbar {{{
" toggle tagbar
nnoremap <Leader>tt :TagbarToggle<CR>
nnoremap <Leader>tp :TagbarTogglePause<CR>
nnoremap <Leader>tj :TagbarOpenAutoClose<CR>
"}}}

" <Plug> expand-region {{{
" expand region by hitting `v`
vmap v <Plug>(expand_region_expand)
" reduce region by hitting `<C-v>`
vmap <C-v> <Plug>(expand_region_shrink)
"}}}

" <Plug> vim-test {{{
" setup mappings
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>tt :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
"}}}

" <Plug> vim-maximizer {{{
" set custom mappings to avoid mapping <Space> in insert-mode
let g:maximizer_set_default_mapping = 0
nnoremap <silent><Leader>z :MaximizerToggle<CR>
vnoremap <silent><Leader>z :MaximizerToggle<CR>gv
"}}}

