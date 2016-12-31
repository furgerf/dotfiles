"""""""""""""""""""""""""
" More general mappings "
"""""""""""""""""""""""""

" allow saving files as sudo
cnoremap w!! w !sudo tee % > /dev/null

" This rewires n and N to do the highlighing...
" TODO: fix - maybe that was introduced with vim 8..?
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

" add blinkhighlight when browsing trough matches
function! HLNext (blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#\%('.@/.'\)'
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 500) . 'm'
  call matchdelete(ring)
  redraw
endfunction

" map save, close all
noremap <C-s> <esc>:w<CR>
inoremap <C-s> <esc>:w<CR>a
noremap <C-c> <esc>:q<CR>
inoremap <C-c> <esc>:q<CR>
noremap <C-q> <esc>:qa<CR>
inoremap <C-q> <esc>:qa<CR>
abbrev Qa qa

" easier window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" visual mode: < and > indent block and re-select previous indentation too
vnoremap < <gv
vnoremap > >gv

" go automatically to the end of the text after yanking/pasting
vnoremap <silent> y y']
vmap <silent> p p']
nmap <silent> p p']
vmap <silent> P P']
nmap <silent> P P']

" <CR> moves to the end of file or to a specific line
nnoremap <CR> G

noremap <silent> <F5> :e<CR>

" select just-pasted text
noremap gV `[v`]

" for command mode
nnoremap <S-Tab> <<
" for insert mode
inoremap <S-Tab> <C-d>

" Q autoformats the current selection or paragraph
vnoremap Q gq
" nnoremap Q gqap

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

"Jump back to last edited buffer
nnoremap <C-b> :e#<CR>
inoremap <C-b> <esc>:e#<CR>

" Backspace deletes buffer.
nnoremap <BS> :bd<CR>

" search for what's visually selected by pressing `//`
vnoremap // y/<C-R>"<CR>

map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e

" duplicate visual mode selection
vnoremap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vnoremap P p:call setreg('+', getreg('0'))<CR>

" bind K to search word under cursor
nnoremap K :Ag "\b<C-R><C-W>\b"<CR>:cw<CR>

" make j/k move down/up one ROW rather than one LINE
nnoremap j gj
nnoremap k gk

" Execute macro in q
nnoremap Q @q

" use F7 for pasting
set pastetoggle=<F7>

