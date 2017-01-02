"""""""""""""""""""""""""""
" General leader mappings "
"""""""""""""""""""""""""""
" This file contains some generic leader mappings. Note that most (if not all of
" the mappings shouldn't apply to insert mode to avoid accidental execution
" while typing.

" edit/source vimrc
noremap <Leader>vim :e $MYVIMRC<CR>
noremap <Leader>ss :so $MYVIMRC<CR>

" edit bashrc
noremap <Leader>b :e ~/.bashrc<CR>

" edit another file in the same directory as the current file
noremap <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
noremap <Leader>sh :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
noremap <Leader>sv :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>

" open alternate file in split
noremap <Leader>shl :split #<CR>
noremap <Leader>svl :vnew #<CR>

" rename file (prompts for new filename)
noremap <Leader>rn :call functions#RenameFile()<CR>

" yank entire file
noremap <Leader>y ggVGy

" remove trailing whitelines
noremap <Leader>rw :%s/\s\+$//<cr>:nohlsearch<cr>

" unhighlight search results
noremap <Leader>q :nohlsearch<CR>

" cycle through buffers
noremap <Leader>w <C-w>w

" close preview and quickfix window
noremap <Leader><Space> :ccl<CR>:pclose<CR>

