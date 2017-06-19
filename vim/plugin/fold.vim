""""""""""""""""""""""
" Fold configuration "
""""""""""""""""""""""
" Contains configuration for:
" - general folding options
" - vim-anyfold
" - custom fold text

" General "{{{
" disable folding by default - I prefer having filetypes enabling it
" regardless, this is where I configure the folding that is used, if used
set nofoldenable
" set default foldlevel when opening new file
set foldlevelstart=1
" number of columns to use for displaying folds (lefthand-side)
set foldcolumn=1
" don't create folds for less than 4 lines
set foldminlines=0

" open folds when moving into them
"set foldopen=all
" close folds when leaving them
"set foldclose=all

" automatically save/load view
" http://vim.wikia.com/wiki/Make_views_automatic
augroup AutoView
  autocmd!

  " autocmd BufWinLeave ?* if functions#IsNonspecialBuffer() | mkview | endif
  " autocmd BufWinEnter ?* if functions#IsNonspecialBuffer() | silent loadview | endif
augroup END

" move to next/previous level-1-fold
" http://superuser.com/questions/816005/move-to-next-fold-of-level-1-in-vim/816085#816085
nnoremap <silent> zj :let max = &fdn<bar>let &fdn = 1<CR>zj:let &fdn=max<CR>
nnoremap <silent> zk :let max = &fdn<bar>let &fdn = 1<CR>zk:let &fdn=max<CR>

" make zO open recursively even when the cursor is on an open fold
nnoremap <silent> zO :call functions#RecursivelyOpenFold()<CR>
"}}}

" vim-anyfold "{{{
" Note: must be enabled specifically (let anyfold_activate=1) if desired
let anyfold_identify_comments=0
let anyfold_fold_comments=1
let anyfold_fold_toplevel=1
"}}}

" Fold text "{{{
" Note that anyfold already uses a custom fold text (that gets overwritten)
function! CustomFoldText()
  "get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = repeat("➕•••", v:foldlevel)
  let lineCount = line("$")
  let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
  let expansionString = " " . repeat("•", 3 + w - strwidth(foldSizeStr.line.foldPercentage.foldLevelStr))
  return substitute(line, " ", "•", "g") . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endf
autocmd! User anyfoldLoaded set foldtext=CustomFoldText()
"}}}

