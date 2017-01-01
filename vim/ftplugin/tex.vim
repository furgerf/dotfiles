"""""""""""""""""""""
" TeX configuration "
"""""""""""""""""""""

" turn on spell-checking
setlocal spell

" assign some TeX settings
" interpret all .tex files as latex files
let g:tex_flavor = "latex"
" don't jump to compilation errors
let g:Tex_GotoError=0
" produce PDFs by default compilation (\ll)
let g:Tex_DefaultTargetFormat='pdf'

" compile and open current file
noremap <F2> :!cd "%:p:h" && rm -f "%:p:r.pdf" && pdflatex "%:p:r.tex" &&
      \ okular &> /dev/null "%:p:r.pdf" &<CR>

" re-compile
" NOTE: <Leader>ll comes from VIM-LaTeX
imap <F3> <Esc>:w<CR><Leader>ll<CR>a
nmap <F3> :w<CR><Leader>ll<CR>

" disable ycm - that is a big mess, IIRC...
" let g:ycm_filetype_specific_completion_to_disable = { 'tex': 1 }

" define the `Texcount` and `Texcountall` commands
command! Texcount execute "!perl $VIMHOME/plugin/texcount.pl %"
command! Texcountall execute "!perl $VIMHOME/plugin/tex-count-recursive %:p:h"

" enable folding
" NOTE: VIM-LaTeX' folding can be applied (reset?) with <Leader>rf
setlocal foldenable
" to fold (sub...)sections, use syntax folding
setlocal foldmethod=syntax

" " insert TeX placeholder
" nnoremap <Leader>g i<++><Esc>hi
" inoremap <Leader>g <++><Esc>i

" " jump to TeX next placeholder
" nnoremap <C-n> /<+.*+><CR>:nohlsearch<CR><Esc>cf>
" inoremap <C-n> <Esc>/<+.*+><CR>:nohlsearch<CR><Esc>cf>

