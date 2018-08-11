"""""""""""""""""""""
" TeX configuration "
"""""""""""""""""""""

" turn on spell-checking
setlocal spell

" assign some TeX settings
" don't jump to compilation errors
let g:Tex_GotoError=0
" produce PDFs by default compilation (\ll)
let g:Tex_DefaultTargetFormat='pdf'

" compile and open current file
nnoremap <F2> :!cd "%:p:h" && rm -f "%:p:r.pdf" && pdflatex "%:p:r.tex" &&
      \ okular &> /dev/null "%:p:r.pdf" &<CR>

" re-compile
" NOTE: <Leader>ll comes from VIM-LaTeX
imap <F3> <Esc>:w<CR><Leader>ll<CR>a
nmap <F3> :w<CR><Leader>ll<CR>

" disable ycm because it can't deal with the hidden characters and isn't very useful anyway
let g:ycm_filetype_blacklist = { 'tex': 1 }

" define the `Texcount` and `Texcountall` commands
command! Texcount execute "!perl $VIMHOME/plugin/texcount.pl %"
command! Texcountall execute "!perl $VIMHOME/plugin/tex-count-recursive %:p:h"

" enable folding
" NOTE: VIM-LaTeX' folding can be applied (reset?) with <Leader>rf
setlocal foldenable
" to fold (sub...)sections, use syntax folding
setlocal foldmethod=syntax

setlocal textwidth=100

hi! OverLength none

let g:syntastic_tex_checkers = ['lacheck']

" " insert TeX placeholder
" nnoremap <Leader>g i<++><Esc>hi
" inoremap <Leader>g <++><Esc>i

" jump to TeX next placeholder
nnoremap <silent> <C-n> /<+.*+><CR>:nohlsearch<CR><Esc>cf>
inoremap <silent> <C-n> <Esc>/<+.*+><CR>:nohlsearch<CR><Esc>cf>

" insertion helpers - use Localleader twice because backslashes are used often
inoremap <Localleader><Localleader>i \item 
inoremap <Localleader><Localleader>c \citep{}<++><Esc>F}i

