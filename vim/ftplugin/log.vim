" no longer highlight past column 80
hi! OverLength none

" stop highlighting current buffer
" TODO: Figure out how to only disable that in log buffer
" currently, if a logfile is opened directly, the highlighting is disabled in
" entire vim session, otherwise it's enabled regardless of current filetype
autocmd! BgHighlight * <buffer>

" don't autodetect csv - I'm doing my custom coloring
let g:disable_rainbow_csv_autodetect=1

" color the first 4 space-delimited columns
autocmd! VimEnter * call functions#HighlightColumns(' ', [
      \ ['darkblue', 'darkblue'],
      \ ['blue', 'blue'],
      \ ['red', 'red'],
      \ ['green', 'green'],
      \ ['NONE', 'NONE']
      \ ])

