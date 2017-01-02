"""""""""""""""""""""""""
" More general mappings "
"""""""""""""""""""""""""

" Saving, closing, ... "{{{
" use common Ctrl-shortcuts
" NOTE: <C-o> isn't mapped because that's more useful for the jumplist
noremap <C-s> <esc>:w<CR>
inoremap <C-s> <esc>:w<CR>a

noremap <C-c> <esc>:q<CR>
inoremap <C-c> <esc>:q<CR>

noremap <C-q> <esc>:qa<CR>
inoremap <C-q> <esc>:qa<CR>

" Backspace deletes buffer.
nnoremap <silent> <BS> :call functions#DeleteBufferOrExit()<CR>:bd<CR>

noremap <silent> <F5> :e<CR>
"}}}

" Navigation "{{{
" easier window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" easier map to open the alternate file
nnoremap <Leader><Tab> <C-^>

" <CR> moves to the end of file or to a specific line
" nnoremap <CR> G

" make j/k move down/up one ROW rather than one LINE
nnoremap j gj
nnoremap k gk
"}}}

" Visual mode "{{{
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

" Editing "{{{
" for command mode
nnoremap <S-Tab> <<
" for insert mode - TOOD: check that this works
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

" make Y behave like D, C, ...
nnoremap Y y$
"}}}

" Abbreviations "{{{
" quitall often ends up capitalized for me
abbrev Qa qa
" I like typing `man` when looking up documentation
cabbrev man help
"}}}

" Misc "{{{
" allow saving files as sudo
cnoremap w!! w !sudo tee % > /dev/null

" rewire n and N to highlight the current match
nnoremap n n:call functions#HighlightNext(0.2)<CR>
nnoremap N N:call functions#HighlightNext(0.2)<CR>

" use F7 for pasting
set pastetoggle=<F7>

" Execute macro in q
nnoremap Q @q

" bind K to search word under cursor
" TODO: Integrate better grep plugin and change mapping key
nnoremap K :Ag "\b<C-R><C-W>\b"<CR>:cw<CR>

" use magic regex mode by default
"nnoremap / /\v

" go automatically to the end of the text after yanking/pasting
vnoremap <silent> y y']
vmap <silent> p p']
nmap <silent> p p']
vmap <silent> P P']
nmap <silent> P P']
"}}}
"
