" Mappings {{{
" easier window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" easier map to open the alternate file
nnoremap <Leader><Tab> <C-^>

" make j/k move down/up one ROW rather than one LINE
nnoremap j gj
nnoremap k gk

" use <C-\> to return after tag jump with <C-]>
" (<C-[> is something with alt/esc...)
nnoremap <C-\> :pop<CR>

" make <C-e>/<C-y> scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" go automatically to the end of the text after yanking/pasting
vnoremap <silent> y y`]
vmap <silent> p p`]
nmap <silent> p p`]
vmap <silent> P P`]
nmap <silent> P P`]
"}}}

" <Plug> fzf {{{
" layout of the popup
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" [Buffers] jup to existing window if possible
let g:fzf_buffers_jump = 1

" load marked items in quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

" change `split` to ctrl+s and load marks to quickfix with ctrl+q
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-q':function('s:build_quickfix_list'),
  \ 'ctrl-v': 'vsplit' }

" improved path completion
imap <c-x><c-f> <plug>(fzf-complete-path)

" mappings - for more see https://github.com/junegunn/fzf.vim#commands
nnoremap <silent> <Leader>fb :Buffers<CR>
nnoremap <silent> <Leader>fw :Window<CR>

nnoremap <silent> <Leader>fo :GFiles<CR>
nnoremap <silent> <Leader>fa :Files<CR>

nnoremap <silent> <Leader>fr :Rg<CR>
nnoremap <silent> <Leader>fta :Tags<CR>
nnoremap <silent> <Leader>ftb :BTags<CR>
nnoremap <silent> <Leader>fl :BLines<CR>

nnoremap <silent> <Leader>fha :Commits<CR>
nnoremap <silent> <Leader>fhb :BCommits<CR>

nnoremap <silent> <Leader>fm :Maps<CR>

" disable <Esc> to exit terminal in fzf buffers - not nice, but at least it works...
" in fzf buffers, don't remap <Esc> (technically, we're in terminal mode)
autocmd FileType fzf tunmap <Esc>
" when exiting fzf buffers, restore the <Esc> mapping (so that we can unmap it again next time)
autocmd BufLeave * if &filetype == 'fzf'| tnoremap <Esc> <C-\><C-n>
"}}}

" <Plug> CamelCaseMotion {{{
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
"}}}

" <Plug> vim-asterisk {{{
" regular */#: use smartcase
" g */#: use selection instead of word
" z */#: stay on first match
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
let g:asterisk#keeppos = 0
"}}}

