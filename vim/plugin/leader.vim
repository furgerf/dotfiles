"""""""""""""""""""""""""""
" General leader mappings "
"""""""""""""""""""""""""""

" map leader
" unhighlight search results
noremap <Leader>q :nohlsearch<CR>
noremap <Leader>yy ggVG"*y
noremap <Leader>dr :E ~/dropbox<CR>
noremap <Leader>vim :e $MYVIMRC<CR>
noremap <Leader>ss :so $MYVIMRC<CR>
noremap <Leader>b :e ~/.bashrc<CR>
noremap <Leader>rw :%s/\s\+$//<cr>:nohlsearch<cr>
noremap <Leader>w <C-w>w

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
noremap <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
noremap <Leader>sh :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
noremap <Leader>shl :split #<CR>
noremap <Leader>sv :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
noremap <Leader>svl :vnew #<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE (thanks Gary Bernhardt)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
noremap <Leader>rn :call RenameFile()<cr>

" Quickfix management
noremap <Space><Space> :ccl<CR>:pclose<CR>

