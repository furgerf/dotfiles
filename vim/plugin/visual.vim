""""""""""""""""""""""""
" Visual configuration "
""""""""""""""""""""""""
" Contains configuration for:
" - colorscheme
" - vim-airline
" - general visual stuff

" Colorscheme "{{{
" set up and load colorscheme
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_invert_selection='0'
let g:gruvbox_number_column='bg1'
let g:gruvbox_improved_warnings='1'
colorscheme gruvbox
"}}}

" vim-airline "{{{
" tell airline to use symbols of the powerline font
let g:airline_powerline_fonts = 1
" display buffers instead of tabs if no tabs are used
let g:airline#extensions#tabline#enabled = 1
" display 'straight' tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
"}}}

" General "{{{
" always show the status line
set laststatus=2
" display tabs and linebreaks
set list
" change whitespace character representation
set listchars=trail:~,tab:»·,eol:⏎
" display symbol for wrapped lines on new line
set showbreak=↪
" use this to denote indentation
let g:indentLine_char = '┆'
"}}}

" Highlighting "{{{
" CurrentBuffer: draw darker background (more contrast)
augroup BgHighlight
  autocmd!
  " update colorcolumn depending on whether the buffer is active
  autocmd VimEnter * execute "set colorcolumn=" . join(range(101, 335), ',')
  autocmd WinEnter * execute "set colorcolumn=" . join(range(101, 355), ',')
  autocmd WinLeave * execute "set colorcolumn=" . join(range(1, 355), ',')

  " could also (un-)set cursor line/column if desired
  " autocmd VimEnter * set cul cuc
  " autocmd WinEnter * set cul cuc
  " autocmd WinLeave * set nocul nocuc
augroup END

" Overlength: text exceeding column 80 highlighted with red foreground
" Note that this technically isn't part of the colorscheme
" but, for it to fit, I'm manually taking the colors from there

" OverLength highlighting starts at column 81
highlight OverLength ctermfg=167 guifg=#fb4934
" because `match`-ing only affects the current window, we re-apply it each time
" we open a buffer
autocmd! BufWinEnter * match OverLength /\%81v.\+/
"}}}

