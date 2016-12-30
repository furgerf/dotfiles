""""""""""""""""""""""
" Fold configuration "
""""""""""""""""""""""

" disable folding by default - I prefer having filetypes enabling it
" regardless, this is where I configure the folding that is used, if used
set nofoldenable
" set default foldlevel when opening new file
set foldlevelstart=1
" number of columns to use for displaying folds (lefthand-side)
set foldcolumn=4
" don't create folds for less than 4 lines
set foldminlines=4

" open folds when moving into them
"set foldopen=all
" close folds when leaving them
"set foldclose=all

" vim-anyfold
let anyfold_activate=1
let anyfold_identify_comments=0
let anyfold_fold_comments=1
let anyfold_fold_toplevel=1

" these would make changing the foldlevel easier, but I prefer having
" <C-i> available for traversing the jumplist
" nnoremap <tab> zr
" nnoremap <s-tab> zm

" customize the fold text some more (anyfold already modifies that one...)
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
autocmd User anyfoldLoaded set foldtext=CustomFoldText()

