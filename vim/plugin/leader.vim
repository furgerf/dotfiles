"""""""""""""""""""""""""""
" General leader mappings "
"""""""""""""""""""""""""""
" This file contains some generic leader mappings. Note that most (if not all of
" the mappings shouldn't apply to insert mode to avoid accidental execution
" while typing.

" edit/source vimrc
nnoremap <Leader>vim :e $MYVIMRC<CR>
nnoremap <Leader>ss :so $MYVIMRC<CR>

" edit bashrc
nnoremap <Leader>b :e ~/.bashrc<CR>

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

" rename file (prompts for new filename)
nnoremap <Leader>rn :call functions#RenameFile()<CR>

" yank entire file
nnoremap <Leader>y ggVGy

" remove trailing whitelines
nnoremap <Leader>rw :%s/\s\+$//<cr>:nohlsearch<cr>

" convert tabs to spaces
nnoremap <Leader>rt :retab<CR>
vnoremap <Leader>rt :retab<CR>

" unhighlight search results
nnoremap <Leader>q :nohlsearch<CR>

" cycle through buffers
" nnoremap <Leader>w <C-w>w

" close preview, quickfix, location list
" NOTE: Since the location list is local to the window, only the one in the current window is closed
" The function `functions#ToggleErrors` could be adapted to close all location lists
nnoremap <silent> <Leader><Space> :pclose<CR>:cclose<CR>:lclose<CR>

" start opening help (manual)
nnoremap <Leader>m :help 

" simple get/put for diff
nnoremap <Leader>dg do
vnoremap <Leader>dg :diffget<CR>
nnoremap <Leader>dp dp
vnoremap <Leader>dp :diffput<CR>

