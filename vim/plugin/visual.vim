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
set signcolumn=yes
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

" <Plug> gruvbox-material {{{
let g:gruvbox_material_background = 'medium'
let g:gruvbox_material_enable_bold = '1'
let g:gruvbox_material_enable_italic = '1'
let g:gruvbox_material_dim_inactive_windows = '1'
let g:gruvbox_material_diagnostic_text_highlight = '1'
let g:gruvbox_material_statusline_style = 'original'
let g:gruvbox_material_better_performance = '1'
let g:gruvbox_material_colors_override = {'bg_dim': ['#32302f', '236']} " reduce contrast for inactive panes

function! s:gruvbox_material_custom() abort
  " Link a highlight group to a predefined highlight group.
  highlight! link CopilotSuggestion Purple

  " Initialize the color palette.
  " The first parameter is a valid value for `g:gruvbox_material_background`,
  " the second parameter is a valid value for `g:gruvbox_material_foreground`,
  " and the third parameter is a valid value for `g:gruvbox_material_colors_override`.
  let l:palette = gruvbox_material#get_palette('medium', 'material', {})
  " Define a highlight group.
  " The first parameter is the name of a highlight group,
  " the second parameter is the foreground color,
  " the third parameter is the background color,
  " the fourth parameter is for UI highlighting which is optional,
  " and the last parameter is for `guisp` which is also optional.
  " See `autoload/gruvbox_material.vim` for the format of `l:palette`.
  " call gruvbox_material#highlight('', l:palette.red, l:palette.none, 'undercurl', l:palette.red)
  " TODO:
  " - make keywords not italic (Keyword?)
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END

let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  if g:airline_theme == 'gruvbox_material'
    " yellow foreground for file name of modified buffers
    let a:palette.normal_modified['airline_c'][2] = 214
    let a:palette.inactive_modified['airline_c'][2] = 214
  endif
endfunction

colorscheme gruvbox-material
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
let g:interestingWordsDefaultMappings = 0
nnoremap <silent> <leader>k :call InterestingWords('n')<CR>
vnoremap <silent> <leader>k :call InterestingWords('v')<CR>
nnoremap <silent> <leader>K :call UncolorAllWords()<CR>
" could also map these to cycle through interesting words but that is tricky
" to get right with the match highlighting and it doesn't work reliably anyway
" for that, just use the default mappings
"}}}

" <Plug> colorizer {{{
" disable colorizer for large files - it makes startup reeeeally slow
let g:colorizer_maxlines=200
"}}}

