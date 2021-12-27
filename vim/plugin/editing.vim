" Yanking/pasting {{{
" yank entire file
nnoremap <Leader>y ggVGy

" make Y behave like D, C, ...
nnoremap Y y$

" paste from system clipboard
nnoremap <silent> <Leader>pp :set paste<CR>:r! xclip -o<CR>:set nopaste<CR>

" use F7 for pasting
set pastetoggle=<F7>

"}}}

" Mappings {{{
" shift-tab to reduce indent
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-d>

" Bubble single lines
nnoremap <silent> <C-Up>   :move-2<CR>==
nnoremap <silent> <C-Down> :move+<CR>==
" Bubble multiple lines
xnoremap <silent> <C-Up>   :move-2<CR>gv=gv
xnoremap <silent> <C-Down> :move'>+<CR>gv=gv

"Duplicate lines above and below
inoremap <C-A-down> <esc>Ypk
nnoremap <C-A-down> Ypk
xnoremap <C-A-down> y`>pgv
inoremap <C-A-up> <esc>YPj
nnoremap <C-A-up> YPj
xnoremap <C-A-up> y`<Pgv

" delete paranthesis under cursor and matching
nnoremap <Leader>X %x<C-o>x

"}}}

" Visual mode mappings {{{
" visual mode: < and > indent block and re-select previous indentation too
vnoremap < <gv
vnoremap > >gv

" select just-pasted text
noremap gV `[v`]

" search for what's visually selected by pressing `//`
vnoremap // y/<C-R>"<CR>

" duplicate visual mode selection
vnoremap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vnoremap P p:call setreg('+', getreg('0'))<CR>
"}}}

" <Plug> vim-mundo {{{
" if has('python3')
"   let g:gundo_prefer_python3 = 1
" endif
noremap <Leader>u :MundoToggle<CR>
"}}}

