" no longer highlight past column 80
hi! OverLength none

" stop highlighting current buffer
" TODO: Figure out how to only disable that in log buffer
" currently, if a logfile is opened directly, the highlighting is disabled in
" entire vim session, otherwise it's enabled regardless of current filetype
autocmd! BgHighlight *

" don't autodetect csv - I'm doing my custom coloring
let g:disable_rainbow_csv_autodetect=1

" color the first 4 space-delimited columns
autocmd! BufEnter * call functions#HighlightColumns(' ', [
      \ [109, '#83a598'],
      \ [108, '#8ec07c'],
      \ [208, '#fe8019'],
      \ [214, '#fabd2f'],
      \ ['NONE', 'NONE']
      \ ])

