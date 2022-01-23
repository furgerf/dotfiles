" Configuration {{{
" always show the status line
set laststatus=2
" display tabs and linebreaks
set list
" change whitespace character representation
set listchars=trail:~,tab:»·,eol:⏎
" display symbol for wrapped lines on new line
set showbreak=↪
" merge signs with numbers
set signcolumn=number
"}}}

" Mappings {{{
" unhighlight search results
nnoremap <silent> <Leader>q :nohlsearch<CR>

" flash cuc/cul
map <silent> <Leader>jj cox:sleep 100m<CR>cox
"}}}

" Highlighting {{{
" CurrentBuffer: draw darker background (more contrast)
augroup BgHighlight
  autocmd!
  " update colorcolumn depending on whether the buffer is active
  autocmd WinEnter * if functions#IsNonspecialBuffer() |
        \ execute "set colorcolumn=" . join(range(101, 335), ',') | endif
  autocmd WinLeave * if functions#IsNonspecialBuffer() |
        \ execute "set colorcolumn=" . join(range(1, 355), ',') | endif
  autocmd FileType * if functions#IsSpecialBuffer() |
        \ execute "set colorcolumn=" | endif

  " could also (un-)set cursor line/column if desired
  " autocmd VimEnter * set cul cuc
  " autocmd WinEnter * set cul cuc
  " autocmd WinLeave * set nocul nocuc
augroup END

" Overlength: text exceeding column 80 highlighted with red foreground
" Note that this technically isn't part of the colorscheme
" but, for it to fit, I'm manually taking the colors from there

" OverLength highlighting starts at column 81
highlight! OverLength ctermfg=167 guifg=#fb4934
hi clear OverLength
" because `match`-ing only affects the current window, we re-apply it each time
" we open a buffer
autocmd! FileType * if functions#IsNonspecialBuffer() |
      \ match OverLength /\%81v.\+/ | endif
"}}}

" <Plug> gruvbox {{{
" set up and load colorscheme
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_invert_selection='0'
let g:gruvbox_number_column='bg1'
let g:gruvbox_improved_warnings='1'
set background=dark
colorscheme gruvbox

" call s:HL('GruvboxWhitespace', s:bg0, s:fg4)
" hi! link Whitespace GruvboxWhitespace
"}}}

" <Plug> vim-airline {{{
" tell airline to use symbols of the powerline font
let g:airline_powerline_fonts = 1
" display buffers instead of tabs if no tabs are used
let g:airline#extensions#tabline#enabled = 1
" display 'straight' tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" also count words in 'notes' files - list appending doesn't seem to work anymore
let g:airline#extensions#wordcount#filetypes =
    \ ['help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail', 'notes']
"}}}

" <Plug> vim-gitgutter {{{
" move to next hunk
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
" I'll map my own keys
let g:gitgutter_map_keys=0
nmap <Leader>hh <Plug>(GitGutterNextHunk)
nmap <Leader>ha <Plug>(GitGutterStageHunk)
nmap <Leader>hr <Plug>(GitGutterUndoHunk)
nmap <Leader>hv <Plug>(GitGutterPreviewHunk)
"}}}

" <Plug> indentLine {{{
" use this to denote indentation
let g:indentLine_char = '┆'
" }}}

" <Plug> vim-interestingwords {{{
" use random colors
" let g:interestingWordsRandomiseColors = 1
" use gruvbox color palette
let g:interestingWordsTermColors = [
      \ 124,
      \ 106,
      \ 166,
      \ 66,
      \ 132,
      \ 72,
      \ 242,
      \ 229,
      \
      \ 167,
      \ 142,
      \ 208,
      \ 109,
      \ 175,
      \ 108,
      \ 244,
      \ 223,
      \
      \ 172,
      \ 250,
      \ ]
" call the actual function directly in normal mode to avoid a strange delay
nnoremap <silent> <leader>k :call InterestingWords('n')<CR>
" use the plugin command in visual mode
" NOTE: If there's no map for the plugin command at all, the plugin adds its
"       own mappings, overwriting `n` and `N` too in the process...
vmap <leader>k <Plug>(InterestingWords)
nmap <leader>K <Plug>(InterestingWordsClear)
" could also map these to cycle through interesting words but that is tricky
" to get right with the match highlighting and it doesn't work reliably anyway
" nmap n <Plug>(InterestingWordsForeward)
" nmap N <Plug>(InterestingWordsBackward)
"}}}

" <Plug> colorizer {{{
" disable colorizer for large files - it makes startup reeeeally slow
let g:colorizer_maxlines=200
"}}}

