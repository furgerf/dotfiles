""""""""""""""""""""""""
" Visual configuration "
""""""""""""""""""""""""

" set up and load colorscheme
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_invert_selection='0'
let g:gruvbox_number_column='bg1'
let g:gruvbox_improved_warnings='1'
colorscheme gruvbox

" display tabs and linebreaks
set list
" change whitespace character representation
set listchars=trail:~,tab:»·,eol:⏎
" display symbol for wrapped lines on new line
set showbreak=↪

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
" display buffers instead of tabs if no tabs are used
let g:airline#extensions#tabline#enabled = 1
" display 'straight' tabs
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'

" highlight the current buffer with normal background
augroup BgHighlight
  autocmd!
  autocmd VimEnter * execute "set colorcolumn=" . join(range(101, 335), ',')
  autocmd WinEnter * execute "set colorcolumn=" . join(range(101, 335), ',')
  autocmd WinLeave * execute "set colorcolumn=" . join(range(1, 335), ',')
  " autocmd VimEnter * set cul cuc
  " autocmd WinEnter * set cul cuc
  " autocmd WinLeave * set nocul nocuc
augroup END

" additional highlighting
" NOTE that this technically isn't part of the colorscheme
" but, for it to fit, I'm manually taking the colors from there
" overlength starts at column 81
highlight OverLength ctermfg=167 guifg=#fb4934
match OverLength /\%81v.\+/

